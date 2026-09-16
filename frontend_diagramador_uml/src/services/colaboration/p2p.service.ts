import { Injectable } from '@angular/core';
import { SignalingService } from './signaling.service';

type Peer = {
  pc: RTCPeerConnection;
  dc?: RTCDataChannel;
};

@Injectable({ providedIn: 'root' })
export class P2PService {
  private peers = new Map<string, Peer>();
  private localId = ''; // mi channel_name asignado por el servidor
  private lastProcessedOps = new Set<string>();
  public onData?: (from: string, data: any) => void;

  constructor(private signaling: SignalingService) {}

  init(roomId: string) {
    this.signaling.onMessage = (msg) => this.handleSignaling(msg);
    this.signaling.connect(roomId);
  }

  private iceServers: RTCIceServer[] = [
    { urls: ['stun:stun.l.google.com:19302'] },
  ];

  private newPeer(remoteId: string, isInitiator: boolean) {
    const pc = new RTCPeerConnection({ iceServers: this.iceServers });
    const peer: Peer = { pc };
    this.peers.set(remoteId, peer);

    pc.onicecandidate = (e) => {
      if (e.candidate) {
        this.signaling.sendSignal(remoteId, { type: 'ice', candidate: e.candidate });
      }
    };

    if (isInitiator) {
      const dc = pc.createDataChannel('canvas');
      this.attachDataChannel(remoteId, dc);
      pc.createOffer().then(offer => {
        pc.setLocalDescription(offer);
        this.signaling.sendSignal(remoteId, { type: 'offer', sdp: offer });
      }).catch(err => console.warn('[P2P] Error creando oferta:', err));
    } else {
      pc.ondatachannel = (ev) => this.attachDataChannel(remoteId, ev.channel);
    }

    return peer;
  }

  private attachDataChannel(remoteId: string, dc: RTCDataChannel) {
    const p = this.peers.get(remoteId);
    if (!p) {
      console.error(`[P2P] Peer no encontrado para ${remoteId}`);
      return;
    }
    p.dc = dc;
    dc.onopen = () => {
      console.log('[P2P] DataChannel abierto con', remoteId);
    };
    dc.onmessage = (ev) => {
      try {
        const data = JSON.parse(ev.data);
        this.dispatchOp(remoteId, data);
      } catch (e) {
        console.error('[P2P] Error parsing mensaje DataChannel:', e);
      }
    };
  }

  private dispatchOp(from: string, payload: any) {
    if (!payload || !this.onData) return;

    // Deduplicación inteligente para evitar dobles ejecuciones si llega por WebRTC y WebSocket
    const opKey = `${payload.t}_${payload.id || payload.linkId || ''}_${payload.x ?? ''}_${payload.y ?? ''}_${payload.field ?? ''}_${payload.value ?? ''}_${payload.w ?? ''}_${payload.h ?? ''}`;
    if (this.lastProcessedOps.has(opKey)) return;
    this.lastProcessedOps.add(opKey);
    if (this.lastProcessedOps.size > 200) {
      const first = this.lastProcessedOps.values().next().value;
      if (first) this.lastProcessedOps.delete(first);
    }

    this.onData(from, payload);
  }

  private async handleSignaling(msg: any) {
    // 1. Mensaje de bienvenida del servidor con el channel_name asignado
    if (msg.type === 'welcome') {
      this.localId = msg.peer;
      console.log('[P2P] Local peer ID confirmado:', this.localId);
      return;
    }

    // 2. Presencia en la sala
    if (msg.type === 'presence') {
      if (msg.peer && !this.localId) {
        this.localId = msg.peer;
      }
      if (msg.action === 'join' && msg.peer !== this.localId) {
        // Nuevo compañero en la sala: anunciar mi presencia
        this.signaling.broadcast({ type: 'announce' });
      }
      if (msg.action === 'leave' && msg.peer) {
        const p = this.peers.get(msg.peer);
        if (p) {
          try { p.dc?.close(); } catch {}
          try { p.pc?.close(); } catch {}
          this.peers.delete(msg.peer);
        }
      }
      return;
    }

    // 3. Broadcast distribuido (vía WebSocket)
    if (msg.type === 'broadcast') {
      // Handshake de presencia
      if (msg.payload?.type === 'announce') {
        const remoteId = msg.from;
        if (!remoteId || remoteId === this.localId || this.peers.has(remoteId)) return;

        const isInitiator = this.localId < remoteId;
        this.newPeer(remoteId, isInitiator);
        return;
      }

      // Operación de sincronización colaborativa
      if (msg.from !== this.localId && msg.payload) {
        this.dispatchOp(msg.from, msg.payload);
      }
      return;
    }

    // 4. Negociación WebRTC (señalización pura)
    if (msg.type === 'signal') {
      const remoteId = msg.from;
      let peer = this.peers.get(remoteId);
      if (!peer) peer = this.newPeer(remoteId, false);
      const pc = peer.pc;
      const payload = msg.payload;

      if (payload.type === 'offer') {
        try {
          await pc.setRemoteDescription(new RTCSessionDescription(payload.sdp));
          const answer = await pc.createAnswer();
          await pc.setLocalDescription(answer);
          this.signaling.sendSignal(remoteId, { type: 'answer', sdp: answer });
        } catch (err) {
          console.warn('[P2P] Error procesando oferta SDP:', err);
        }
      } else if (payload.type === 'answer') {
        if (pc.signalingState !== 'stable') {
          try {
            await pc.setRemoteDescription(new RTCSessionDescription(payload.sdp));
          } catch (err) {
            console.warn('[P2P] Error procesando respuesta SDP:', err);
          }
        }
      } else if (payload.type === 'ice' && payload.candidate) {
        try {
          await pc.addIceCandidate(payload.candidate);
        } catch (e) {
          console.warn('[P2P] Error aplicando ICE candidate:', e);
        }
      }
    }
  }

  sendToAll(data: any) {
    const json = JSON.stringify(data);

    // Intentar enviar por DataChannels WebRTC abiertos
    for (const [id, p] of this.peers) {
      if (p.dc?.readyState === 'open') {
        try {
          p.dc.send(json);
        } catch (e) {
          console.warn('[P2P] Error en envío DataChannel:', e);
        }
      }
    }

    // Siempre difundir por WebSocket signaling para asegurar sincronización 100% garantizada
    this.signaling.broadcast(data);
  }

  closeSocketRTC() {
    for (const [id, peer] of this.peers) {
      try { peer.dc?.close(); } catch {}
      try { peer.pc?.close(); } catch {}
    }
    this.peers.clear();
    this.localId = '';
    this.lastProcessedOps.clear();
    this.signaling.close();
  }
}

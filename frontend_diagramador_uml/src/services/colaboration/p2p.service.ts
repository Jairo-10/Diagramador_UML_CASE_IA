import { Injectable } from '@angular/core';
import { SignalingService } from './signaling.service';

type Peer = {
  pc: RTCPeerConnection;
  dc?: RTCDataChannel;
};

@Injectable({ providedIn: 'root' })
export class P2PService {
  private peers = new Map<string, Peer>();
  private localId = ''; // mi channel_name (lo asigna el servidor en presence)
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
      });
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
      if (this.onData) {
        this.onData(remoteId, { t: 'request_full_state' } as any);
      }
    };
    dc.onmessage = (ev) => {
      try {
        this.onData && this.onData(remoteId, JSON.parse(ev.data));
      } catch (e) {
        console.error('[P2P] Error parsing mensaje remoto:', e);
      }
    };
  }

  private async handleSignaling(msg: any) {
    if (msg.type === 'presence') {
      if (msg.peer && !this.localId) {
        this.localId = msg.peer;
      }
      if (msg.action === 'join') {
        // Aviso a la sala que estoy disponible
        this.signaling.broadcast({ type: 'announce' });
      }
      return;
    }

    if (msg.type === 'broadcast') {
      // 1. Handshake de presencia P2P
      if (msg.payload?.type === 'announce') {
        const remoteId = msg.from;
        if (this.peers.has(remoteId)) return;

        // regla: el que tiene ID menor inicia WebRTC
        const isInitiator = this.localId < remoteId;
        this.newPeer(remoteId, isInitiator);
        return;
      }

      // 2. Sincronización híbrida: Si el broadcast contiene una operación enviada por WebSocket
      if (msg.from !== this.localId && this.onData) {
        const peer = this.peers.get(msg.from);
        const hasOpenDc = peer?.dc?.readyState === 'open';
        // Si aún no tenemos canal WebRTC abierto con este peer, procesar de inmediato por WebSocket
        if (!hasOpenDc) {
          this.onData(msg.from, msg.payload);
        }
      }
      return;
    }

    if (msg.type === 'signal') {
      const remoteId = msg.from;
      let peer = this.peers.get(remoteId);
      if (!peer) peer = this.newPeer(remoteId, false);
      const pc = peer.pc;
      const payload = msg.payload;

      if (payload.type === 'offer') {
        await pc.setRemoteDescription(new RTCSessionDescription(payload.sdp));
        const answer = await pc.createAnswer();
        await pc.setLocalDescription(answer);
        this.signaling.sendSignal(remoteId, { type: 'answer', sdp: answer });
      } else if (payload.type === 'answer') {
        if (pc.signalingState !== 'stable') {
          await pc.setRemoteDescription(new RTCSessionDescription(payload.sdp));
        }
      } else if (payload.type === 'ice' && payload.candidate) {
        try {
          await pc.addIceCandidate(payload.candidate);
        } catch (e) {
          console.warn('[P2P] Error aplicando ICE:', e);
        }
      }
    }
  }

  sendToAll(data: any) {
    const json = JSON.stringify(data);
    let openPeersCount = 0;
    for (const [id, p] of this.peers) {
      if (p.dc?.readyState === 'open') {
        p.dc.send(json);
        openPeersCount++;
      }
    }

    // Fallback híbrido: Si aún no hay DataChannels WebRTC abiertos o mientras se establece la conexión,
    // propagar a través del WebSocket del servidor (Django Channels) para entrega 100% garantizada.
    if (openPeersCount === 0) {
      this.signaling.broadcast(data);
    }
  }

  closeSocketRTC() {
    // Cerrar WebRTC peers
    for (const [id, peer] of this.peers) {
      try {
        peer.dc?.close();
      } catch {}
      try {
        peer.pc.close();
      } catch {}
    }
    this.peers.clear();
    this.localId = '';

    // Cerrar signaling
    this.signaling.close();
  }
}

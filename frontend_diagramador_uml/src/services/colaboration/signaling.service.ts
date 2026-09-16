import { Injectable } from '@angular/core';
import { environment } from '../../environments/environment';

type Msg =
  | { type: 'welcome'; peer: string; room: string }
  | { type: 'presence'; action: 'join' | 'leave'; peer: string }
  | { type: 'signal'; from: string; payload: any }
  | { type: 'broadcast'; from: string; payload: any };

@Injectable({ providedIn: 'root' })
export class SignalingService {
  private socket?: WebSocket;
  private _roomId!: string;
  private messageQueue: string[] = [];
  public onMessage?: (msg: Msg) => void;

  connect(roomId: string) {
    this._roomId = roomId;

    if (this.socket && (this.socket.readyState === WebSocket.OPEN || this.socket.readyState === WebSocket.CONNECTING)) {
      return;
    }

    const scheme = window.location.protocol === 'https:' ? 'wss' : 'ws';
    const host = window.location.protocol === 'https:'
      ? environment.WebSocket_python
      : window.location.hostname;

    const port = window.location.protocol === 'https:'
      ? ''
      : environment.wsPort
        ? `:${environment.wsPort}`
        : '';
    const wsUrl = `${scheme}://${host}${port}${environment.wsPath}${roomId}/`;

    console.log('[Signaling] Conectando a:', wsUrl);
    this.socket = new WebSocket(wsUrl);

    this.socket.onopen = () => {
      console.log('[Signaling] WebSocket conectado a:', wsUrl);
      while (this.messageQueue.length > 0) {
        const item = this.messageQueue.shift();
        if (item && this.socket && this.socket.readyState === WebSocket.OPEN) {
          this.socket.send(item);
        }
      }
    };

    this.socket.onmessage = (ev) => {
      try {
        const msg: Msg = JSON.parse(ev.data);
        if (this.onMessage) this.onMessage(msg);
      } catch (e) {
        console.error('[Signaling] Error parsing message', e);
      }
    };

    this.socket.onclose = () => console.log('[Signaling] WebSocket desconectado');
    this.socket.onerror = (err) => console.warn('[Signaling] Error WebSocket:', err);
  }

  sendSignal(to: string, payload: any) {
    const data = JSON.stringify({ type: 'signal', to, payload });
    if (this.socket && this.socket.readyState === WebSocket.OPEN) {
      this.socket.send(data);
    } else if (this.socket && this.socket.readyState === WebSocket.CONNECTING) {
      this.messageQueue.push(data);
    }
  }

  broadcast(payload: any) {
    const data = JSON.stringify({ type: 'broadcast', payload });
    if (this.socket && this.socket.readyState === WebSocket.OPEN) {
      this.socket.send(data);
    } else if (this.socket && this.socket.readyState === WebSocket.CONNECTING) {
      this.messageQueue.push(data);
    }
  }

  close() {
    this.messageQueue = [];
    if (this.socket) {
      try { this.socket.close(); } catch {}
      this.socket = undefined;
    }
  }
}

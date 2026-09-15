import { Component, OnInit, PLATFORM_ID, Inject } from '@angular/core';
import { Router } from '@angular/router';
import { v4 as uuid } from 'uuid';
import { CommonModule, isPlatformBrowser } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { BackupService } from '../../services/exports/backup.service';

@Component({
  selector: 'app-landin-page',
  imports: [CommonModule, FormsModule],
  templateUrl: './landin-page.html',
  styleUrls: ['./landin-page.css']
})
export class LandinPage implements OnInit {
  joinCode: string = '';
  recentRooms: string[] = [];
  errorMessage: string = '';
  isVerifying: boolean = false;

  constructor(
    private router: Router,
    private backupService: BackupService,
    @Inject(PLATFORM_ID) private platformId: Object
  ) {}

  ngOnInit(): void {
    if (isPlatformBrowser(this.platformId)) {
      this.loadRecentRooms();
    }
  }

  loadRecentRooms(): void {
    try {
      const keys = Object.keys(localStorage).filter(k => k.startsWith('diagram-'));
      this.recentRooms = keys.map(k => k.replace('diagram-', '')).slice(-4).reverse();
    } catch (e) {
      console.warn('No se pudieron cargar salas recientes', e);
    }
  }

  private isValidUUID(code: string): boolean {
    const uuidPattern = /^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$/;
    return uuidPattern.test(code.trim());
  }

  crearNuevoLienzo(): void {
    const roomId = uuid();
    this.router.navigate(['/diagram', roomId]);
  }

  unirseAlLienzo(): void {
    this.errorMessage = '';
    const code = this.joinCode.trim();

    if (!code) return;

    // 1. Validar que el código tenga formato UUID válido
    if (!this.isValidUUID(code)) {
      this.errorMessage = 'Código inválido (formato UUID incorrecto).';
      return;
    }

    // 2. Verificar en el servidor si la sala existe realmente
    this.isVerifying = true;
    this.backupService.getBackup(code).subscribe({
      next: () => {
        this.isVerifying = false;
        this.router.navigate(['/diagram', code]);
      },
      error: () => {
        this.isVerifying = false;
        this.errorMessage = 'La sala no existe. Verifica el código.';
      }
    });
  }

  abrirSala(roomId: string): void {
    this.router.navigate(['/diagram', roomId]);
  }

  cerrarAlerta(): void {
    this.errorMessage = '';
  }
}

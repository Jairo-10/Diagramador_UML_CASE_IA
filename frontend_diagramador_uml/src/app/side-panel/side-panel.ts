import { Component, Output, EventEmitter, PLATFORM_ID, Inject, signal, inject } from '@angular/core';
import { CommonModule, isPlatformBrowser } from '@angular/common';
import { DragDropModule, CdkDragEnd } from '@angular/cdk/drag-drop';
import { FormsModule } from '@angular/forms';
import { DiagramService } from '../../services/diagram/diagram.service';
import { UmlValidationService } from '../../services/colaboration/uml-validation.service';
import { ActivatedRoute, Router } from '@angular/router';
import { SqlExportService } from '../../services/exports/sql-export.service';
import { UmlImageServiceTs } from '../../services/imports/uml-image.service';
import { FrontendGeneratorService } from '../../services/exports/frontend-generator.service';
import { Spinner } from "../components/diagram/spinner/spinner";
import { ChatbotService } from '../../services/IA/chatbot.service';
import { BackendGeneratorService } from '../../services/exports/backend-generator.service';

@Component({
  selector: 'app-side-panel',
  imports: [CommonModule, DragDropModule, FormsModule, Spinner],
  templateUrl: './side-panel.html',
  styleUrl: './side-panel.css'
})
export class SidePanel {
  private frontendGeneratorService = inject(FrontendGeneratorService);
  private chatboxService = inject(ChatbotService);
  private backendGeneratorService = inject(BackendGeneratorService);

  @Output() elementDragged = new EventEmitter<CdkDragEnd>();
  @Output() saveClicked = new EventEmitter<void>();
  @Output() generateClicked = new EventEmitter<string>();
  @Output() relationSelected = new EventEmitter<string>();

  // Control de visibilidad del Panel Derecho
  public showRightDrawer = signal<boolean>(false);

  // Modo de relación activo
  public activeRelation = signal<string | null>(null);

  prompt: string = '';
  validationCollapsed = signal<boolean>(false);
  validationResult = signal<any>(null);
  analyzingModel = signal<boolean>(false);
  roomId: string | null = null;
  copied = signal<boolean>(false);
  recognizing = signal<boolean>(false);
  recognition: any;
  isBrowser: boolean;

  constructor(
    private diagramService: DiagramService,
    private umlValidation: UmlValidationService,
    private router: Router,
    private route: ActivatedRoute,
    private sqlExportService: SqlExportService,
    private umlImageService: UmlImageServiceTs,
    @Inject(PLATFORM_ID) platformId: Object
  ) {
    this.isBrowser = isPlatformBrowser(platformId);
    this.roomId = this.route.snapshot.paramMap.get('roomId');

    if (this.isBrowser) {
      this.configVoiceRecognition();
    }
  }

  toggleRightDrawer(): void {
    this.showRightDrawer.set(!this.showRightDrawer());
  }

  closeRightDrawer(): void {
    this.showRightDrawer.set(false);
  }

  selectRelation(type: string): void {
    if (this.activeRelation() === type) {
      this.activeRelation.set(null);
      this.relationSelected.emit('cancel');
    } else {
      this.activeRelation.set(type);
      this.relationSelected.emit(type);
    }
  }

  clearActiveRelation(): void {
    this.activeRelation.set(null);
  }

  onDragEnded(event: CdkDragEnd): void {
    this.elementDragged.emit(event);
    event.source.reset();
  }

  onSaveClicked(): void {
    this.saveClicked.emit();
  }

  onGenerate(): void {
    if (this.prompt.trim()) {
      this.generateClicked.emit(this.prompt.trim());
      this.prompt = '';
    }
  }

  toggleValidationPanel(): void {
    this.validationCollapsed.set(!this.validationCollapsed());
  }

  analyzeNow(): void {
    this.analyzingModel.set(true);
    const umlJson = this.diagramService.exportToJson();
    this.umlValidation.validateModel(umlJson);
  }

  updateValidationResult(result: any): void {
    this.validationResult.set(result);
    this.analyzingModel.set(false);
    this.validationCollapsed.set(false);
  }

  goHome(): void {
    // Guardar estado actual antes de salir para que persista en PostgreSQL y localStorage
    this.diagramService.persist(true);
    this.diagramService.closeDiagram(this.roomId!);
    this.router.navigate(['/']);
  }

  copyRoomCode(): void {
    const roomId = this.route.snapshot.paramMap.get('roomId');
    if (!roomId) return;

    const isSecure = window.location.protocol === 'https:' || window.location.hostname === 'localhost';

    if (isSecure && navigator.clipboard && navigator.clipboard.writeText) {
      navigator.clipboard.writeText(roomId).then(() => {
        this.copied.set(true);
        setTimeout(() => this.copied.set(false), 2000);
      }).catch(() => this.fallbackCopy(roomId));
    } else {
      this.fallbackCopy(roomId);
    }
  }

  private fallbackCopy(text: string): void {
    const textarea = document.createElement('textarea');
    textarea.value = text;
    textarea.style.position = 'fixed';
    textarea.style.left = '-9999px';
    document.body.appendChild(textarea);
    textarea.focus();
    textarea.select();
    try {
      document.execCommand('copy');
      this.copied.set(true);
      setTimeout(() => this.copied.set(false), 2000);
    } catch (err) {
      console.error('Fallback copy failed', err);
    }
    document.body.removeChild(textarea);
  }

  configVoiceRecognition(): void {
    if (!this.isBrowser) return;
    this.recognition = null;
    const SpeechRecognition =
      (window as any).webkitSpeechRecognition || (window as any).SpeechRecognition;

    if (SpeechRecognition) {
      this.recognition = new SpeechRecognition();
      this.recognition.lang = 'es-ES';
      this.recognition.interimResults = true;
      this.recognition.continuous = false;

      this.recognition.onresult = (event: any) => {
        const transcript = Array.from(event.results)
          .map((result: any) => result[0].transcript)
          .join('');
        this.prompt = transcript;
      };

      this.recognition.onend = () => {
        this.recognizing.set(false);
      };
    }
  }

  toggleVoiceInput(): void {
    if (!this.recognition) {
      alert('Tu navegador no soporta reconocimiento de voz.');
      return;
    }

    if (this.recognizing()) {
      this.recognition.stop();
      this.recognizing.set(false);
    } else {
      this.recognition.start();
      this.recognizing.set(true);
    }
  }

  exportImage(): void {
    this.diagramService.exportToImage('diagrama.png');
  }

  exportSql(): void {
    const umlJson = this.diagramService.exportToJson();
    this.sqlExportService.downloadSql(umlJson, 'diagrama.sql');
  }

  onImportImage(event: Event): void {
    this.umlImageService.loading.set(true);
    const input = event.target as HTMLInputElement;
    if (!input.files || input.files.length === 0) return;

    const file = input.files[0];
    this.analyzingModel.set(true);

    this.umlImageService.analyzeImage(file).subscribe({
      next: (res) => {
        const umlJson = res.uml_json || res;
        this.diagramService.loadFromJson(umlJson);
        this.analyzingModel.set(false);
        this.umlImageService.loading.set(false);
      },
      error: (err) => {
        console.error('[Vision] Error al procesar imagen UML:', err);
        this.analyzingModel.set(false);
        this.umlImageService.loading.set(false);
      }
    });
  }

  onGenerateFrontend(): void {
    const umlJson = this.diagramService.exportToJson();
    this.frontendGeneratorService.generateFrontend(umlJson);
  }

  isLoadingImage(): boolean {
    return this.umlImageService.loading();
  }
  isLoadingChatbox(): boolean {
    return this.chatboxService.isLoading();
  }
  isLoadingGeneratefrontend(): boolean {
    return this.frontendGeneratorService.loading();
  }
  isLoadingGenerateBackend(): boolean {
    return this.backendGeneratorService.loading();
  }
}

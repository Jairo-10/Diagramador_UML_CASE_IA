import { Injectable } from '@angular/core';
import { v4 as uuid } from 'uuid';
import { CollaborationService } from '../colaboration/collaboration.service';
import { DiagramExportService } from '../exports/diagram-export.service';
import { UmlValidationService } from '../colaboration/uml-validation.service';



@Injectable({ providedIn: 'root' })
export class EditionService {
  readonly MIN_W = 180;
  readonly NAME_H = 30;
  readonly MIN_ATTRS_H = 40;
  readonly MIN_METHS_H = 40;
  readonly PAD_V = 10;
  constructor(
    private exportService: DiagramExportService,
		private umlValidationService: UmlValidationService
  ){}
  // ========= Edición de campos =========
  startEditing(
    model: any,
    paper: any,
    field: 'name' | 'attributes' | 'methods',
    x: number,
    y: number,
    collab?: { broadcast: (msg: any) => void }
  ) {
    const MAP: Record<typeof field, string> = {
      name: '.uml-class-name-text',
      attributes: '.uml-class-attrs-text',
      methods: '.uml-class-methods-text'
    };
    const selector = MAP[field];
    const currentValue = model.attr(`${selector}/text`) || '';

    // Obtener escala actual del papel y rectángulo de pantalla exacto del elemento
    const currentScale = (typeof paper.scale === 'function' ? paper.scale().sx : 1) || 1;
    const cellView = typeof paper.findViewByModel === 'function' ? paper.findViewByModel(model) : null;
    const viewEl = cellView?.el as SVGElement | undefined;

    let absX = 0;
    let absY = 0;
    let editorWidth = 180;
    let editorHeight = 32;

    if (viewEl && typeof viewEl.getBoundingClientRect === 'function') {
      const nodeRect = viewEl.getBoundingClientRect();
      absX = nodeRect.left;
      editorWidth = Math.max(140, Math.round(nodeRect.width));

      const nameH = (this.NAME_H || 30) * currentScale;
      const sep1Y = parseFloat(model.attr('.sep-name/y1')) || (this.NAME_H || 30);
      const sep2Y = parseFloat(model.attr('.sep-attrs/y1')) || ((this.NAME_H || 30) + 40);

      if (field === 'name') {
        absY = nodeRect.top;
        editorHeight = Math.max(28, Math.round(nameH));
      } else if (field === 'attributes') {
        absY = nodeRect.top + sep1Y * currentScale;
        editorHeight = Math.max(55, Math.round((sep2Y - sep1Y) * currentScale));
      } else {
        absY = nodeRect.top + sep2Y * currentScale;
        editorHeight = Math.max(55, Math.round(nodeRect.bottom - absY));
      }
    } else {
      const paperRect = paper.el.getBoundingClientRect();
      absX = paperRect.left + x;
      absY = paperRect.top + y;
    }

    const editor = field === 'name'
      ? document.createElement('input')
      : document.createElement('textarea');

    editor.value = currentValue;
    const fontSz = Math.max(10, Math.min(14, Math.round(12.5 * currentScale)));
    Object.assign(editor.style, {
      position: 'fixed',
      left: `${absX}px`,
      top: `${absY}px`,
      width: `${editorWidth}px`,
      height: field === 'name' ? `${editorHeight}px` : 'auto',
      border: '2px solid #2563eb',
      borderRadius: '2px',
      padding: '2px 6px',
      zIndex: '99999',
      fontSize: `${fontSz}px`,
      fontWeight: field === 'name' ? 'bold' : 'normal',
      fontFamily: field === 'name' ? 'sans-serif' : 'monospace',
      color: '#0f172a',
      backgroundColor: '#ffffff',
      boxShadow: '0 4px 14px rgba(0,0,0,0.25)',
      boxSizing: 'border-box',
      outline: 'none',
      resize: 'none'
    } as CSSStyleDeclaration);

    if (field !== 'name') (editor as HTMLTextAreaElement).rows = 4;

    document.body.appendChild(editor);
    editor.focus();
    editor.select();

    let closed = false;
    const finish = (save: boolean) => {
      if (closed) return;
      closed = true;

      if (save) {
        const raw = (editor as HTMLInputElement | HTMLTextAreaElement).value;
        const newValue = field === 'name' ? raw.trim() : raw.replace(/\r?\n/g, '\n');
        model.attr(`${selector}/text`, newValue);
        model.set(field, newValue);
        collab?.broadcast({ t: 'edit_text', id: model.id, field, value: newValue });
        this.scheduleAutoResize(model, paper);
      }
      editor.parentNode && editor.parentNode.removeChild(editor);
    };

    editor.addEventListener('blur', () => finish(true));
    editor.addEventListener('keydown', (evt: Event) => {
      const e = evt as KeyboardEvent;
      if (field === 'name') {
        if (e.key === 'Enter') { e.preventDefault(); finish(true); }
        if (e.key === 'Escape') { e.preventDefault(); finish(false); }
      } else {
        if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); finish(true); }
        if (e.key === 'Escape') { e.preventDefault(); finish(false); }
      }
    });
  }
  
  // ========= Edición de etiquetas de enlaces =========
  startEditingLabel(
    model: any,
    paper: any,
    labelIndex: number,
    currentValue: string,
    x: number,
    y: number,
    collab?: { broadcast: (msg: any) => void },
    graph?: any
  ) {
    const linkView = paper.findViewByModel(model) as any;
    const labelNode = linkView?.findLabelNode?.(labelIndex) as SVGElement | undefined;

    let absX = x;
    let absY = y;
    if (labelNode && typeof labelNode.getBoundingClientRect === 'function') {
      const nodeRect = labelNode.getBoundingClientRect();
      absX = nodeRect.left;
      absY = nodeRect.top;
    } else {
      const paperRect = paper.el.getBoundingClientRect();
      absX = paperRect.left + x;
      absY = paperRect.top + y;
    }

    const input = document.createElement('input');
    input.type = 'text';
    input.value = currentValue;
    Object.assign(input.style, {
      position: 'fixed',
      left: `${absX}px`,
      top: `${absY}px`,
      border: '2px solid #2563eb',
      borderRadius: '4px',
      padding: '2px 6px',
      zIndex: '10000',
      fontSize: '13px',
      fontWeight: 'bold',
      background: '#ffffff',
      boxShadow: '0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06)',
      outline: 'none',
      width: '60px',
      textAlign: 'center'
    } as CSSStyleDeclaration);

    document.body.appendChild(input);
    input.focus();
    input.select();

    if (labelNode) {
      labelNode.setAttribute('stroke', '#2563eb');
      labelNode.setAttribute('stroke-width', '2');
    }

    let closed = false;
    const cleanupHighlight = () => {
      if (labelNode) {
        labelNode.removeAttribute('stroke');
        labelNode.removeAttribute('stroke-width');
      }
    };
    const finish = (save: boolean) => {
      if (closed) return;
      closed = true;

      if (save) {
        const text = input.value.trim();
        model.label(labelIndex, { ...model.label(labelIndex), attrs: { text: { text } } });
        collab?.broadcast({ t: 'edit_label', linkId: model.id, index: labelIndex, text });
        model.set('label', text);
        const umlJson = this.exportService.export(graph);
        this.umlValidationService.validateModel(umlJson);
      }
      if (labelNode) { labelNode.removeAttribute('stroke'); labelNode.removeAttribute('stroke-width'); }
      input.parentNode && input.parentNode.removeChild(input);
      cleanupHighlight();
    };

    input.addEventListener('blur', () => finish(true));
    input.addEventListener('keydown', (e: KeyboardEvent) => {
      if (e.key === 'Enter' || e.key === 'Escape' || e.key === ' ') {
        e.preventDefault();
        finish(e.key !== 'Escape'); // Enter/Espacio = guardar, Escape = cancelar
      }
    });
  }
  // ========= Actualiza la posición de los puertos o puntos de enlace =========
  updatePorts(model: any) {
    if (!model?.isElement?.()) return;
    const { width, height } = model.size();
    model.portProp('top',    'args', { x: width / 2, y: 0 });
    model.portProp('bottom', 'args', { x: width / 2, y: height });
    model.portProp('left',   'args', { x: 0,        y: height / 2 });
    model.portProp('right',  'args', { x: width,    y: height / 2 });
  }

  scheduleAutoResize(model: any, paper: any) {
    requestAnimationFrame(() => {
      requestAnimationFrame(() => this.autoResizeUmlClass(model, paper));
    });
  }

  /**************************************************************************************************
  *                  FUNCIONES PRIVADAS
  ***************************************************************************************************/ 

  // ========= Auto-resize + puertos =========
  private getTextBBox(model: any, paper: any, selector: string): number {
    const view = paper.findViewByModel(model);
    const node = view?.findBySelector(selector)?.[0] as SVGGraphicsElement | undefined;
    try { return node ? node.getBBox().height : 0; } catch { return 0; }
  }

  // ========= Auto-ajusta el tamaño del diagrama UML de clase al contenido =========
  autoResizeUmlClass(model: any, paper: any) {
    if (!model?.isElement?.()) return;

    const width  = Math.max(this.MIN_W, (model.get('size')?.width) || this.MIN_W);
    const nameH  = this.NAME_H;

    const attrsHText = this.getTextBBox(model, paper, '.uml-class-attrs-text');
    const methsHText = this.getTextBBox(model, paper, '.uml-class-methods-text');

    const attrsH = Math.max(this.MIN_ATTRS_H, Math.round((attrsHText || 0) + this.PAD_V));
    const methsH = Math.max(this.MIN_METHS_H, Math.round((methsHText || 0) + this.PAD_V));
    const totalH = Math.round(nameH + attrsH + methsH);

    model.attr('.uml-class-name-rect/height', nameH);

    const x1 = 0, x2 = width;
    const y1 = Math.round(nameH);
    const y2 = Math.round(nameH + attrsH);

    model.attr({
      '.uml-outer': { width, height: totalH, refWidth: '100%', refHeight: '100%', stroke: '#1e293b', strokeWidth: 1.5, rx: 0, ry: 0 },
      '.sep-name':  { x1, y1, x2, y2: y1, stroke: '#1e293b', strokeWidth: 1.5 },
      '.sep-attrs': { x1, y1: y2, x2, y2, stroke: '#1e293b', strokeWidth: 1.5 }
    });

    model.attr('.uml-class-attrs-text/transform',  `translate(10, ${Math.round(nameH + 10)})`);
    model.attr('.uml-class-attrs-text/textWrap/width', width - 20);

    model.attr('.uml-class-methods-text/transform', `translate(10, ${Math.round(nameH + attrsH + 10)})`);
    model.attr('.uml-class-methods-text/textWrap/width', width - 20);

    model.resize(width, totalH);
    this.updatePorts(model);
  }
}

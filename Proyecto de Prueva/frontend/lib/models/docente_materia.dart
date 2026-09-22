import 'docente.dart';
import 'materia.dart';

class DocenteMateria {
  final int id;
  final int docenteid;
  final Docente? docente;
  final int materiaid;
  final Materia? materia;

  DocenteMateria({
    required this.id,
    required this.docenteid,
    this.docente,
    required this.materiaid,
    this.materia,
  });

  factory DocenteMateria.fromJson(Map<String, dynamic> json) {
    return DocenteMateria(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      docenteid: json['docente'] != null && json['docente'] is Map
          ? (json['docente']['id'] is int ? json['docente']['id'] : int.tryParse(json['docente']['id']?.toString() ?? '0') ?? 0)
          : 0,
      docente: json['docente'] != null && json['docente'] is Map 
          ? Docente.fromJson(json['docente']) 
          : null,
      materiaid: json['materia'] != null && json['materia'] is Map
          ? (json['materia']['id'] is int ? json['materia']['id'] : int.tryParse(json['materia']['id']?.toString() ?? '0') ?? 0)
          : 0,
      materia: json['materia'] != null && json['materia'] is Map
          ? Materia.fromJson(json['materia']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'docenteid': docenteid,
      'materiaid': materiaid,
    };
  }

  @override
  String toString() {
    final firstStr = docente?.toString() ?? 'ID: ${docenteid}';
    final secondStr = materia?.toString() ?? 'ID: ${materiaid}';
    return '(Docente: $firstStr) ↔ (Materia: $secondStr)';
  }
}

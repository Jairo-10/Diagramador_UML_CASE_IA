import 'inscripcion.dart';

  class Calificacion {
    final int id;
  final String notaFinal;
  final String observacion;
  final String trimestre;
  final String inscripcionId;
  final Inscripcion? inscripcion;

    Calificacion({
      
      required this.id, required this.notaFinal, required this.observacion, required this.trimestre, required this.inscripcionId, this.inscripcion,
    });

    factory Calificacion.fromJson(Map<String, dynamic> json) {
      return Calificacion(
        
        id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0, notaFinal: json['notafinal']?.toString() ?? '', observacion: json['observacion']?.toString() ?? '', trimestre: json['trimestre']?.toString() ?? '', inscripcionId: json['inscripcionid'] != null ? json['inscripcionid'].toString() : (json['inscripcion'] is Map ? json['inscripcion']['id']?.toString() : json['inscripcion']?.toString()) ?? '', inscripcion: json['inscripcion'] is Map<String, dynamic> ? Inscripcion.fromJson(json['inscripcion']) : null,
      );
    }

    Map<String, dynamic> toJson() {
      return {
        
        'id': id, 'notafinal': notaFinal, 'observacion': observacion, 'trimestre': trimestre, 'inscripcionid': inscripcionId,
      };
    }

    @override
    String toString() {
      return 'notaFinal: ${notaFinal}' + ", " + 'observacion: ${observacion}';
    }
  }
  
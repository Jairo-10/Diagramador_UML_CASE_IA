import 'boletin.dart';
import 'calificacion.dart';
import 'curso.dart';
import 'estudiante.dart';

  class Inscripcion {
    final String costoMatricula;
  final String estado;
  final String fechaInscripcion;
  final int id;
  final String numeroFolio;
  final String boletinId;
  final Boletin? boletin;
  final List<Calificacion> calificacion;
  final String cursoId;
  final Curso? curso;
  final String estudianteId;
  final Estudiante? estudiante;

    Inscripcion({
      
      required this.costoMatricula, required this.estado, required this.fechaInscripcion, required this.id, required this.numeroFolio, required this.boletinId, this.boletin, this.calificacion = const [], required this.cursoId, this.curso, required this.estudianteId, this.estudiante,
    });

    factory Inscripcion.fromJson(Map<String, dynamic> json) {
      return Inscripcion(
        
        costoMatricula: json['costomatricula']?.toString() ?? '', estado: json['estado']?.toString() ?? '', fechaInscripcion: json['fechainscripcion']?.toString() ?? '', id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0, numeroFolio: json['numerofolio']?.toString() ?? '', boletinId: json['boletinid'] != null ? json['boletinid'].toString() : (json['boletin'] is Map ? json['boletin']['id']?.toString() : json['boletin']?.toString()) ?? '', boletin: json['boletin'] is Map<String, dynamic> ? Boletin.fromJson(json['boletin']) : null, calificacion: json['calificacion'] is List 
          ? (json['calificacion'] as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => Calificacion.fromJson(e))
              .toList()
          : [], cursoId: json['cursoid'] != null ? json['cursoid'].toString() : (json['curso'] is Map ? json['curso']['id']?.toString() : json['curso']?.toString()) ?? '', curso: json['curso'] is Map<String, dynamic> ? Curso.fromJson(json['curso']) : null, estudianteId: json['estudianteid'] != null ? json['estudianteid'].toString() : (json['estudiante'] is Map ? json['estudiante']['id']?.toString() : json['estudiante']?.toString()) ?? '', estudiante: json['estudiante'] is Map<String, dynamic> ? Estudiante.fromJson(json['estudiante']) : null,
      );
    }

    Map<String, dynamic> toJson() {
      return {
        
        'costomatricula': costoMatricula, 'estado': estado, 'fechainscripcion': fechaInscripcion, 'id': id, 'numerofolio': numeroFolio, 'boletinid': boletinId, 'cursoid': cursoId, 'estudianteid': estudianteId,
      };
    }

    @override
    String toString() {
      return 'costoMatricula: ${costoMatricula}' + ", " + 'estado: ${estado}';
    }
  }
  
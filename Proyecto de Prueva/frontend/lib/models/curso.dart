import 'curso.dart';
import 'docente.dart';
import 'inscripcion.dart';

  class Curso {
    final int capacidadMax;
  final int id;
  final String nombre;
  final String turno;
  final List<Docente> docente;
  final List<Inscripcion> inscripcion;
  final List<Curso> curso;
  final String cursoId;
  final Curso? curso;

    Curso({
      
      required this.capacidadMax, required this.id, required this.nombre, required this.turno, this.docente = const [], this.inscripcion = const [], this.curso = const [], required this.cursoId, this.curso,
    });

    factory Curso.fromJson(Map<String, dynamic> json) {
      return Curso(
        
        capacidadMax: json['capacidadmax'] is int ? json['capacidadmax'] : int.tryParse(json['capacidadmax']?.toString() ?? '0') ?? 0, id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0, nombre: json['nombre']?.toString() ?? '', turno: json['turno']?.toString() ?? '', docente: json['docente'] is List 
          ? (json['docente'] as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => Docente.fromJson(e))
              .toList()
          : [], inscripcion: json['inscripcion'] is List 
          ? (json['inscripcion'] as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => Inscripcion.fromJson(e))
              .toList()
          : [], curso: json['curso'] is List 
          ? (json['curso'] as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => Curso.fromJson(e))
              .toList()
          : [], cursoId: json['cursoid'] != null ? json['cursoid'].toString() : (json['curso'] is Map ? json['curso']['id']?.toString() : json['curso']?.toString()) ?? '', curso: json['curso'] is Map<String, dynamic> ? Curso.fromJson(json['curso']) : null,
      );
    }

    Map<String, dynamic> toJson() {
      return {
        
        'capacidadmax': capacidadMax, 'id': id, 'nombre': nombre, 'turno': turno, 'cursoid': cursoId,
      };
    }

    @override
    String toString() {
      return 'capacidadMax: ${capacidadMax}' + ", " + 'nombre: ${nombre}';
    }
  }
  
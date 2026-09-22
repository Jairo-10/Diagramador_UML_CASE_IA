import 'docente_materia.dart';

  class Materia {
    final int horasSemanales;
  final int id;
  final String nombre;
  final String sigla;
  final List<DocenteMateria> docente_materia;

    Materia({
      
      required this.horasSemanales, required this.id, required this.nombre, required this.sigla, this.docente_materia = const [],
    });

    factory Materia.fromJson(Map<String, dynamic> json) {
      return Materia(
        
        horasSemanales: json['horassemanales'] is int ? json['horassemanales'] : int.tryParse(json['horassemanales']?.toString() ?? '0') ?? 0, id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0, nombre: json['nombre']?.toString() ?? '', sigla: json['sigla']?.toString() ?? '', docente_materia: json['docentemateria'] is List 
          ? (json['docentemateria'] as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => DocenteMateria.fromJson(e))
              .toList()
          : [],
      );
    }

    Map<String, dynamic> toJson() {
      return {
        
        'horassemanales': horasSemanales, 'id': id, 'nombre': nombre, 'sigla': sigla,
      };
    }

    @override
    String toString() {
      return 'horasSemanales: ${horasSemanales}' + ", " + 'nombre: ${nombre}';
    }
  }
  
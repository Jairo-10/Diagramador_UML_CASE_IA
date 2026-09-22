import 'curso.dart';
import 'docente_materia.dart';
import 'persona.dart';

  class Docente extends Persona {
    final String especialidad;
  final String fechaContrato;
  final int id;
  final String salario;
  final String cursoId;
  final Curso? curso;
  final List<DocenteMateria> docente_materia;

    Docente({
      
      required String - apellido, required String - celular, required String - ci, required String - fechaNacimiento, required int - id, required String - nombre, required this.especialidad, required this.fechaContrato, required this.id, required this.salario, required this.cursoId, this.curso, this.docente_materia = const [],
    }) : super(- apellido: - apellido, - celular: - celular, - ci: - ci, - fechaNacimiento: - fechaNacimiento, - id: - id, - nombre: - nombre);

    factory Docente.fromJson(Map<String, dynamic> json) {
      return Docente(
        
        - apellido: json['- apellido']?.toString() ?? '', - celular: json['- celular']?.toString() ?? '', - ci: json['- ci']?.toString() ?? '', - fechaNacimiento: json['- fechanacimiento']?.toString() ?? '', - id: json['- id'] is int ? json['- id'] : int.tryParse(json['- id']?.toString() ?? '0') ?? 0, - nombre: json['- nombre']?.toString() ?? '', especialidad: json['especialidad']?.toString() ?? '', fechaContrato: json['fechacontrato']?.toString() ?? '', id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0, salario: json['salario']?.toString() ?? '', cursoId: json['cursoid'] != null ? json['cursoid'].toString() : (json['curso'] is Map ? json['curso']['id']?.toString() : json['curso']?.toString()) ?? '', curso: json['curso'] is Map<String, dynamic> ? Curso.fromJson(json['curso']) : null, docente_materia: json['docentemateria'] is List 
          ? (json['docentemateria'] as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => DocenteMateria.fromJson(e))
              .toList()
          : [],
      );
    }

    Map<String, dynamic> toJson() {
      return {
        
        '- apellido': - apellido, '- celular': - celular, '- ci': - ci, '- fechanacimiento': - fechaNacimiento, '- id': - id, '- nombre': - nombre, 'especialidad': especialidad, 'fechacontrato': fechaContrato, 'id': id, 'salario': salario, 'cursoid': cursoId,
      };
    }

    @override
    String toString() {
      return 'especialidad: ${especialidad}' + ", " + 'fechaContrato: ${fechaContrato}';
    }
  }
  
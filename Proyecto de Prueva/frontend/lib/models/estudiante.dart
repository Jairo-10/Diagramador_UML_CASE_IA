import 'inscripcion.dart';
import 'persona.dart';

  class Estudiante extends Persona {
    final String activo;
  final String codigoRude;
  final int id;
  final String tutorContacto;
  final List<Inscripcion> inscripcion;

    Estudiante({
      
      required String - apellido, required String - celular, required String - ci, required String - fechaNacimiento, required int - id, required String - nombre, required this.activo, required this.codigoRude, required this.id, required this.tutorContacto, this.inscripcion = const [],
    }) : super(- apellido: - apellido, - celular: - celular, - ci: - ci, - fechaNacimiento: - fechaNacimiento, - id: - id, - nombre: - nombre);

    factory Estudiante.fromJson(Map<String, dynamic> json) {
      return Estudiante(
        
        - apellido: json['- apellido']?.toString() ?? '', - celular: json['- celular']?.toString() ?? '', - ci: json['- ci']?.toString() ?? '', - fechaNacimiento: json['- fechanacimiento']?.toString() ?? '', - id: json['- id'] is int ? json['- id'] : int.tryParse(json['- id']?.toString() ?? '0') ?? 0, - nombre: json['- nombre']?.toString() ?? '', activo: json['activo']?.toString() ?? '', codigoRude: json['codigorude']?.toString() ?? '', id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0, tutorContacto: json['tutorcontacto']?.toString() ?? '', inscripcion: json['inscripcion'] is List 
          ? (json['inscripcion'] as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => Inscripcion.fromJson(e))
              .toList()
          : [],
      );
    }

    Map<String, dynamic> toJson() {
      return {
        
        '- apellido': - apellido, '- celular': - celular, '- ci': - ci, '- fechanacimiento': - fechaNacimiento, '- id': - id, '- nombre': - nombre, 'activo': activo, 'codigorude': codigoRude, 'id': id, 'tutorcontacto': tutorContacto,
      };
    }

    @override
    String toString() {
      return 'activo: ${activo}' + ", " + 'codigoRude: ${codigoRude}';
    }
  }
  


  class Persona {
    final String apellido;
  final String celular;
  final String ci;
  final String fechaNacimiento;
  final int id;
  final String nombre;

    Persona({
      
      required this.apellido, required this.celular, required this.ci, required this.fechaNacimiento, required this.id, required this.nombre,
    });

    factory Persona.fromJson(Map<String, dynamic> json) {
      return Persona(
        
        apellido: json['apellido']?.toString() ?? '', celular: json['celular']?.toString() ?? '', ci: json['ci']?.toString() ?? '', fechaNacimiento: json['fechanacimiento']?.toString() ?? '', id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0, nombre: json['nombre']?.toString() ?? '',
      );
    }

    Map<String, dynamic> toJson() {
      return {
        
        'apellido': apellido, 'celular': celular, 'ci': ci, 'fechanacimiento': fechaNacimiento, 'id': id, 'nombre': nombre,
      };
    }

    @override
    String toString() {
      return 'apellido: ${apellido}' + ", " + 'celular: ${celular}';
    }
  }
  
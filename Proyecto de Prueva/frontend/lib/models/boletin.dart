import 'inscripcion.dart';

  class Boletin {
    final String codigoVerificacion;
  final String fechaEmision;
  final int id;
  final String promedioGeneral;
  final List<Inscripcion> inscripcion;

    Boletin({
      
      required this.codigoVerificacion, required this.fechaEmision, required this.id, required this.promedioGeneral, this.inscripcion = const [],
    });

    factory Boletin.fromJson(Map<String, dynamic> json) {
      return Boletin(
        
        codigoVerificacion: json['codigoverificacion']?.toString() ?? '', fechaEmision: json['fechaemision']?.toString() ?? '', id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0, promedioGeneral: json['promediogeneral']?.toString() ?? '', inscripcion: json['inscripcion'] is List 
          ? (json['inscripcion'] as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => Inscripcion.fromJson(e))
              .toList()
          : [],
      );
    }

    Map<String, dynamic> toJson() {
      return {
        
        'codigoverificacion': codigoVerificacion, 'fechaemision': fechaEmision, 'id': id, 'promediogeneral': promedioGeneral,
      };
    }

    @override
    String toString() {
      return 'codigoVerificacion: ${codigoVerificacion}' + ", " + 'fechaEmision: ${fechaEmision}';
    }
  }
  
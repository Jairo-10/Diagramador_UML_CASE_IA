import '../models/calificacion.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/inscripcion.dart';
import '../config.dart';

class InscripcionService {
  static const String baseUrl = ApiConfig.baseUrl;
  
  Future<List<Inscripcion>> getAll() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/inscripcion'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        // El backend puede devolver listas mixtas [objeto, id] debido a @JsonIdentityInfo
        // Filtrar solo los objetos completos (Maps), omitir los IDs sueltos
        return jsonList
            .whereType<Map<String, dynamic>>()
            .map((item) => Inscripcion.fromJson(item))
            .toList();
      } else {
        throw Exception('Error al cargar Inscripcions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Inscripcion?> getById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/inscripcion/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return Inscripcion.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Error al obtener Inscripcion: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Inscripcion> create(Inscripcion item) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/inscripcion'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(item.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Inscripcion.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al crear Inscripcion: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Inscripcion> update(String id, Inscripcion item) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/inscripcion/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(item.toJson()),
      );

      if (response.statusCode == 200) {
        return Inscripcion.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al actualizar Inscripcion: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/inscripcion/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Error al eliminar Inscripcion: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}

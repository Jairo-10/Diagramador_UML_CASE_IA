import '../models/inscripcion.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/estudiante.dart';
import '../config.dart';

class EstudianteService {
  static const String baseUrl = ApiConfig.baseUrl;
  
  Future<List<Estudiante>> getAll() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/estudiante'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        // El backend puede devolver listas mixtas [objeto, id] debido a @JsonIdentityInfo
        // Filtrar solo los objetos completos (Maps), omitir los IDs sueltos
        return jsonList
            .whereType<Map<String, dynamic>>()
            .map((item) => Estudiante.fromJson(item))
            .toList();
      } else {
        throw Exception('Error al cargar Estudiantes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Estudiante?> getById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/estudiante/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return Estudiante.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Error al obtener Estudiante: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Estudiante> create(Estudiante item) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/estudiante'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(item.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Estudiante.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al crear Estudiante: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Estudiante> update(String id, Estudiante item) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/estudiante/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(item.toJson()),
      );

      if (response.statusCode == 200) {
        return Estudiante.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al actualizar Estudiante: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/estudiante/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Error al eliminar Estudiante: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}

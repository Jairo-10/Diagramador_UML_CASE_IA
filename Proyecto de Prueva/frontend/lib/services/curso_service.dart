import '../models/docente.dart';
import '../models/inscripcion.dart';
import '../models/curso.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/curso.dart';
import '../config.dart';

class CursoService {
  static const String baseUrl = ApiConfig.baseUrl;
  
  Future<List<Curso>> getAll() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/curso'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        // El backend puede devolver listas mixtas [objeto, id] debido a @JsonIdentityInfo
        // Filtrar solo los objetos completos (Maps), omitir los IDs sueltos
        return jsonList
            .whereType<Map<String, dynamic>>()
            .map((item) => Curso.fromJson(item))
            .toList();
      } else {
        throw Exception('Error al cargar Cursos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Curso?> getById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/curso/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return Curso.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Error al obtener Curso: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Curso> create(Curso item) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/curso'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(item.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Curso.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al crear Curso: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Curso> update(String id, Curso item) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/curso/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(item.toJson()),
      );

      if (response.statusCode == 200) {
        return Curso.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al actualizar Curso: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/curso/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Error al eliminar Curso: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}

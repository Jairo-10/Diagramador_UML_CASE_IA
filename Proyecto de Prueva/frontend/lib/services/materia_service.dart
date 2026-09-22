import '../models/docente_materia.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/materia.dart';
import '../config.dart';

class MateriaService {
  static const String baseUrl = ApiConfig.baseUrl;
  
  Future<List<Materia>> getAll() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/materia'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        // El backend puede devolver listas mixtas [objeto, id] debido a @JsonIdentityInfo
        // Filtrar solo los objetos completos (Maps), omitir los IDs sueltos
        return jsonList
            .whereType<Map<String, dynamic>>()
            .map((item) => Materia.fromJson(item))
            .toList();
      } else {
        throw Exception('Error al cargar Materias: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Materia?> getById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/materia/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return Materia.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Error al obtener Materia: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Materia> create(Materia item) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/materia'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(item.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Materia.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al crear Materia: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Materia> update(String id, Materia item) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/materia/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(item.toJson()),
      );

      if (response.statusCode == 200) {
        return Materia.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al actualizar Materia: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/materia/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Error al eliminar Materia: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/docente_materia.dart';
import '../config.dart';

class DocenteMateriaService {
  static const String baseUrl = ApiConfig.baseUrl;
  
  Future<List<DocenteMateria>> getAll() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/docentemateria'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        // El backend puede devolver listas mixtas [objeto, id] debido a @JsonIdentityInfo
        // Filtrar solo los objetos completos (Maps), omitir los IDs sueltos
        return jsonList
            .whereType<Map<String, dynamic>>()
            .map((item) => DocenteMateria.fromJson(item))
            .toList();
      } else {
        throw Exception('Error al cargar DocenteMaterias: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<DocenteMateria?> getById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/docentemateria/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return DocenteMateria.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Error al obtener DocenteMateria: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<DocenteMateria> create(DocenteMateria item) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/docentemateria'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(item.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return DocenteMateria.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al crear DocenteMateria: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<DocenteMateria> update(String id, DocenteMateria item) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/docentemateria/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(item.toJson()),
      );

      if (response.statusCode == 200) {
        return DocenteMateria.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al actualizar DocenteMateria: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/docentemateria/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Error al eliminar DocenteMateria: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}

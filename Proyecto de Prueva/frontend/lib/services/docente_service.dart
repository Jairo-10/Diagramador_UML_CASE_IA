import '../models/docente_materia.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/docente.dart';
import '../config.dart';

class DocenteService {
  static const String baseUrl = ApiConfig.baseUrl;
  
  Future<List<Docente>> getAll() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/docente'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        // El backend puede devolver listas mixtas [objeto, id] debido a @JsonIdentityInfo
        // Filtrar solo los objetos completos (Maps), omitir los IDs sueltos
        return jsonList
            .whereType<Map<String, dynamic>>()
            .map((item) => Docente.fromJson(item))
            .toList();
      } else {
        throw Exception('Error al cargar Docentes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Docente?> getById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/docente/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return Docente.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Error al obtener Docente: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Docente> create(Docente item) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/docente'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(item.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Docente.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al crear Docente: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Docente> update(String id, Docente item) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/docente/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(item.toJson()),
      );

      if (response.statusCode == 200) {
        return Docente.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al actualizar Docente: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/docente/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Error al eliminar Docente: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}

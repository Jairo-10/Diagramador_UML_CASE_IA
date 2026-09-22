
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/calificacion.dart';
import '../config.dart';

class CalificacionService {
  static const String baseUrl = ApiConfig.baseUrl;
  
  Future<List<Calificacion>> getAll() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/calificacion'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        // El backend puede devolver listas mixtas [objeto, id] debido a @JsonIdentityInfo
        // Filtrar solo los objetos completos (Maps), omitir los IDs sueltos
        return jsonList
            .whereType<Map<String, dynamic>>()
            .map((item) => Calificacion.fromJson(item))
            .toList();
      } else {
        throw Exception('Error al cargar Calificacions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Calificacion?> getById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/calificacion/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return Calificacion.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Error al obtener Calificacion: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Calificacion> create(Calificacion item) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/calificacion'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(item.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Calificacion.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al crear Calificacion: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Calificacion> update(String id, Calificacion item) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/calificacion/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(item.toJson()),
      );

      if (response.statusCode == 200) {
        return Calificacion.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al actualizar Calificacion: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/calificacion/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Error al eliminar Calificacion: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}

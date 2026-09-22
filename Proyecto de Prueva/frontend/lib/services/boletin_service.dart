import '../models/inscripcion.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/boletin.dart';
import '../config.dart';

class BoletinService {
  static const String baseUrl = ApiConfig.baseUrl;
  
  Future<List<Boletin>> getAll() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/boletin'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        // El backend puede devolver listas mixtas [objeto, id] debido a @JsonIdentityInfo
        // Filtrar solo los objetos completos (Maps), omitir los IDs sueltos
        return jsonList
            .whereType<Map<String, dynamic>>()
            .map((item) => Boletin.fromJson(item))
            .toList();
      } else {
        throw Exception('Error al cargar Boletins: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Boletin?> getById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/boletin/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return Boletin.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Error al obtener Boletin: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Boletin> create(Boletin item) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/boletin'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(item.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Boletin.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al crear Boletin: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Boletin> update(String id, Boletin item) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/boletin/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(item.toJson()),
      );

      if (response.statusCode == 200) {
        return Boletin.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al actualizar Boletin: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/boletin/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Error al eliminar Boletin: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/persona_model.dart';
import '../config.dart';

class PersonaService {
  final String endpoint = '${Config.baseUrl}/personas';

  Future<List<Persona>> obtenerPersonas() async {
    final response = await http.get(Uri.parse('$endpoint/'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((personaJson) => Persona.fromJson(personaJson)).toList();
    } else {
      throw Exception('Error al cargar las personas');
    }
  }

  Future<Persona> crearPersona(Persona persona) async {
    final response = await http.post(
      Uri.parse('$endpoint/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(persona.toJson()),
    );

    if (response.statusCode == 201) {
      return Persona.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear la persona');
    }
  }

  Future<Persona> actualizarPersona(int id, Persona persona) async {
    final response = await http.put(
      Uri.parse('$endpoint/$id/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(persona.toJson()),
    );

    if (response.statusCode == 200) {
      return Persona.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar la persona');
    }
  }

  Future<void> eliminarPersona(int id) async {
    final response = await http.delete(Uri.parse('$endpoint/$id/'));

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar la persona');
    }
  }
}

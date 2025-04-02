import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/persona_model.dart';

class PersonaService {
  static const String baseUrl = 'http://192.168.0.156:8080/personas';

  // Obtener lista de personas (READ)
  Future<List<Persona>> obtenerPersonas() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((personaJson) => Persona.fromJson(personaJson)).toList();
    } else {
      throw Exception('Error al cargar las personas');
    }
  }

  // Crear una nueva persona (CREATE)
  Future<Persona> crearPersona(Persona persona) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(persona.toJson()), // No enviar el `id` al backend
    );

    if (response.statusCode == 201) {
      return Persona.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear la persona');
    }
  }


  // Actualizar una persona existente (UPDATE)
  Future<Persona> actualizarPersona(int id, Persona persona) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(persona.toJson()),
    );

    if (response.statusCode == 200) {
      return Persona.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar la persona');
    }
  }

  // Eliminar una persona (DELETE)
  Future<void> eliminarPersona(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar la persona');
    }
  }
}

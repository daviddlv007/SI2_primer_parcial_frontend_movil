import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/inventario_model.dart';
import '../config.dart';

class InventarioService {
  final String endpoint = '${Config.baseUrl}/inventarios';

  Future<List<Inventario>> obtenerInventarios() async {
    final response = await http.get(Uri.parse('$endpoint/'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((json) => Inventario.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los inventarios');
    }
  }

  Future<Inventario> crearInventario(Inventario inventario) async {
    final response = await http.post(
      Uri.parse('$endpoint/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(inventario.toJson()),
    );

    if (response.statusCode == 201) {
      return Inventario.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear el inventario');
    }
  }

  Future<Inventario> actualizarInventario(int id, Inventario inventario) async {
    final response = await http.put(
      Uri.parse('$endpoint/$id/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(inventario.toJson()),
    );

    if (response.statusCode == 200) {
      return Inventario.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar el inventario');
    }
  }

  Future<void> eliminarInventario(int id) async {
    final response = await http.delete(Uri.parse('$endpoint/$id/'));

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar el inventario');
    }
  }
}
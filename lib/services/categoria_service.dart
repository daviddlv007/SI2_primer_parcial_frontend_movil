import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/categoria_model.dart';
import '../config.dart';

class CategoriaService {
  final String endpoint = '${Config.baseUrl}/categorias';

  Future<List<Categoria>> obtenerCategorias() async {
    final response = await http.get(Uri.parse('$endpoint/'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((json) => Categoria.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar las categorías');
    }
  }

  Future<Categoria> crearCategoria(Categoria categoria) async {
    final response = await http.post(
      Uri.parse('$endpoint/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(categoria.toJson()),
    );

    if (response.statusCode == 201) {
      return Categoria.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear la categoría');
    }
  }

  Future<Categoria> actualizarCategoria(int id, Categoria categoria) async {
    final response = await http.put(
      Uri.parse('$endpoint/$id/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(categoria.toJson()),
    );

    if (response.statusCode == 200) {
      return Categoria.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar la categoría');
    }
  }

  Future<void> eliminarCategoria(int id) async {
    final response = await http.delete(Uri.parse('$endpoint/$id/'));

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar la categoría');
    }
  }
}
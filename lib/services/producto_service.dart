import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto_model.dart';
import '../config.dart';

class ProductoService {
  final String endpoint = '${Config.baseUrl}/productos';

  Future<List<Producto>> obtenerProductos() async {
    final response = await http.get(Uri.parse('$endpoint/'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((json) => Producto.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los productos');
    }
  }

  Future<Producto> crearProducto(Producto producto) async {
    final response = await http.post(
      Uri.parse('$endpoint/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(producto.toJson()),
    );

    if (response.statusCode == 201) {
      return Producto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear el producto');
    }
  }

  Future<Producto> actualizarProducto(int id, Producto producto) async {
    final response = await http.put(
      Uri.parse('$endpoint/$id/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(producto.toJson()),
    );

    if (response.statusCode == 200) {
      return Producto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar el producto');
    }
  }

  Future<void> eliminarProducto(int id) async {
    final response = await http.delete(Uri.parse('$endpoint/$id/'));

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar el producto');
    }
  }
}
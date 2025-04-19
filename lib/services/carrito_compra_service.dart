import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/carrito_compra_model.dart';
import '../config.dart';

class CarritoCompraService {
  final String endpoint = '${Config.baseUrl}/carritos_compra';

  Future<List<CarritoCompra>> obtenerCarritos() async {
    final response = await http.get(Uri.parse('$endpoint/'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((json) => CarritoCompra.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los carritos');
    }
  }

  Future<CarritoCompra> crearCarrito(CarritoCompra carrito) async {
    final response = await http.post(
      Uri.parse('$endpoint/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(carrito.toJson()),
    );

    if (response.statusCode == 201) {
      return CarritoCompra.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear el carrito');
    }
  }

  Future<CarritoCompra> actualizarCarrito(int id, CarritoCompra carrito) async {
    final response = await http.put(
      Uri.parse('$endpoint/$id/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(carrito.toJson()),
    );

    if (response.statusCode == 200) {
      return CarritoCompra.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar el carrito');
    }
  }

  Future<void> eliminarCarrito(int id) async {
    final response = await http.delete(Uri.parse('$endpoint/$id/'));

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar el carrito');
    }
  }
}

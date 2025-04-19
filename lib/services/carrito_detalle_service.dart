import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/carrito_detalle_model.dart';
import '../config.dart';

class CarritoDetalleService {
  final String endpoint = '${Config.baseUrl}/carritos_detalle';

  Future<List<CarritoDetalle>> obtenerDetalles() async {
    final response = await http.get(Uri.parse('$endpoint/'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((json) => CarritoDetalle.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los detalles de carrito');
    }
  }

  Future<CarritoDetalle> crearDetalle(CarritoDetalle detalle) async {
    final response = await http.post(
      Uri.parse('$endpoint/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(detalle.toJson()),
    );

    if (response.statusCode == 201) {
      return CarritoDetalle.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear el detalle de carrito');
    }
  }

  Future<CarritoDetalle> actualizarDetalle(int id, CarritoDetalle detalle) async {
    final response = await http.put(
      Uri.parse('$endpoint/$id/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(detalle.toJson()),
    );

    if (response.statusCode == 200) {
      return CarritoDetalle.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar el detalle de carrito');
    }
  }

  Future<void> eliminarDetalle(int id) async {
    final response = await http.delete(Uri.parse('$endpoint/$id/'));

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar el detalle de carrito');
    }
  }
}
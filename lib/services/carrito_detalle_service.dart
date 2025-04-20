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

  Future<List<CarritoDetalle>> obtenerDetallesPorCarrito(int carritoId) async {
    final response = await http.get(Uri.parse('$endpoint/?carrito=$carritoId'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((json) => CarritoDetalle.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los detalles del carrito');
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
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Error al crear el detalle de carrito');
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

Future<void> eliminarDetallesPorProducto(int carritoId, int productoId) async {
  try {
    print('[DEBUG] Iniciando eliminación para carrito:$carritoId, producto:$productoId');
    
    // 1. Obtener TODOS los detalles (ya que el filtro backend no funciona)
    final todosDetalles = await obtenerDetalles();
    print('[DEBUG] Total de detalles obtenidos: ${todosDetalles.length}');

    // 2. Filtrar localmente por carritoId Y productoId
    final detallesAEliminar = todosDetalles.where(
      (d) => d.carritoId == carritoId && d.productoId == productoId
    ).toList();

    print('[DEBUG] Detalles a eliminar: ${detallesAEliminar.length}');
    
    // 3. Eliminar cada uno
    for (final detalle in detallesAEliminar) {
      if (detalle.id != null) {
        print('[DEBUG] Eliminando detalle ID:${detalle.id} '
              '(Carrito:${detalle.carritoId}, Producto:${detalle.productoId})');
        await eliminarDetalle(detalle.id!);
      }
    }

    print('[DEBUG] Eliminación completada');
  } catch (e) {
    print('[ERROR FATAL] en eliminarDetallesPorProducto: $e');
    rethrow;
  }
}
}
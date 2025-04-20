import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto_model.dart';

class ApiService {
  static const String baseUrl =
      'http://192.168.100.63:8000'; // O IP real si estás en emulador

  static Future<List<Producto>> getProductos() async {
    final response = await http.get(Uri.parse('$baseUrl/api/productos/'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((e) => Producto.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar productos');
    }
  }
}

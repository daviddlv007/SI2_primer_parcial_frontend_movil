import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class AuthService {
  final String endpoint = '${Config.baseUrl}/api/token/';

  // Clave para el almacenamiento del token en SharedPreferences
  static const String _tokenKey = 'auth_token';
  static const String _userDataKey = 'user_data';

  // Método para iniciar sesión
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$endpoint/login/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Guardar el token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, data['token']);
      if (data['user'] != null) {
        await prefs.setString(_userDataKey, json.encode(data['user']));
      }
      return data;
    } else {
      throw Exception('Error al iniciar sesión: ${response.body}');
    }
  }

  // Método para registrar un nuevo usuario
  Future<Map<String, dynamic>> register(
    String nombre,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$endpoint/register/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nombre': nombre,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al registrarse: ${response.body}');
    }
  }

  // Método para obtener el usuario actual
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userDataKey);

    if (userData != null) {
      return json.decode(userData);
    }

    final token = await getToken();
    if (token == null) {
      return null;
    }

    final response = await http.get(
      Uri.parse('$endpoint/me/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      await prefs.setString(_userDataKey, json.encode(userData));
      return userData;
    } else {
      throw Exception('Error al obtener el usuario actual');
    }
  }

  // Verificar si el usuario está autenticado
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }

  // Método para registrar un nuevo usuario en la API específica
  Future<Map<String, dynamic>> registerUser({
    required String correo,
    required String nombre,
    required String password,
    String rol = 'cliente',
  }) async {
    final response = await http.post(
      Uri.parse('${Config.baseUrl}/api/usuarios/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'correo': correo,
        'nombre': nombre,
        'password': password,
        'rol': rol,
      }),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return data;
    } else {
      final errorBody = response.body;
      throw Exception('Error al registrar usuario: $errorBody');
    }
  }

  // Obtener el token de autenticación
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Actualizar información del usuario
  Future<Map<String, dynamic>> updateUser(Map<String, dynamic> userData) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Usuario no autenticado');
    }

    final response = await http.put(
      Uri.parse('$endpoint/user/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(userData),
    );

    if (response.statusCode == 200) {
      final updatedUser = json.decode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userDataKey, json.encode(updatedUser));
      return updatedUser;
    } else {
      throw Exception('Error al actualizar el usuario');
    }
  }
}

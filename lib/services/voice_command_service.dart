import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/material.dart';
import '../models/producto_model.dart';
import '../models/carrito_compra_model.dart';
import '../models/carrito_detalle_model.dart';
import '../services/producto_service.dart';
import '../services/carrito_compra_service.dart';
import '../services/carrito_detalle_service.dart';
import '../providers/cart_provider.dart';
import 'package:provider/provider.dart';

class VoiceCommandService {
  final stt.SpeechToText _speech = stt.SpeechToText();

int _textToNumber(String text) {
  final numbers = {
    'cero': 0, 'un': 1, 'uno': 1, 'dos': 2, 'tres': 3,
    'cuatro': 4, 'cinco': 5, 'seis': 6, 'siete': 7,
    'ocho': 8, 'nueve': 9, 'diez': 10, 'once': 11,
    'doce': 12, 'trece': 13, 'catorce': 14, 'quince': 15,
    'dieciséis': 16, 'diecisiete': 17, 'dieciocho': 18,
    'diecinueve': 19, 'veinte': 20
  };

  final lowerText = text.toLowerCase();
  if (numbers.containsKey(lowerText)) {
    return numbers[lowerText]!;
  }
  
  final parsedNumber = int.tryParse(text);
  if (parsedNumber != null) {
    return parsedNumber;
  }
  
  throw FormatException('Número no reconocido: $text');
}

  Future<void> processCommand(String text, BuildContext context) async {
    final command = text.toLowerCase();
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    
    try {
      if (RegExp(r'crear carrito').hasMatch(command)) {
        await _handleCreateCart(context, cartProvider);
      } 
      else if (RegExp(r'agregar\s+(\d+|un|uno|dos|tres|cuatro|cinco|seis|siete|ocho|nueve|diez)\s+(.+)').hasMatch(command)) {
        await _handleAddProduct(command, context, cartProvider);
      } 
      else if (RegExp(r'(eliminar|borrar) carrito').hasMatch(command)) {
        await _handleDeleteCart(context, cartProvider);
      } 
      else if (RegExp(r'(deseleccionar|quitar) carrito').hasMatch(command)) {
        _handleDeselectCart(context, cartProvider);
      }
      else if (RegExp(r'(eliminar|quitar|remover)\s+(.+)').hasMatch(command)) {
        await _handleRemoveProduct(command, context, cartProvider);
      }
      else {
        _showFeedback(context, 'Comando no reconocido');
      }
    } catch (e) {
      _showFeedback(context, 'Error: ${e.toString().replaceFirst('Exception: ', '')}');
    }
  }

  // Métodos auxiliares (mantienen la misma implementación que antes)
  Future<void> _handleCreateCart(BuildContext context, CartProvider provider) async {
    final service = CarritoCompraService();
    final newCart = await service.crearCarrito(CarritoCompra(usuarioId: 1));
    provider.selectCart(newCart.id!);
    _showFeedback(context, 'Nuevo carrito creado y seleccionado');
  }

  Future<void> _handleAddProduct(String command, BuildContext context, CartProvider provider) async {
    final match = RegExp(r'agregar\s+(\d+|un|uno|dos|tres|cuatro|cinco|seis|siete|ocho|nueve|diez)\s+(.+)').firstMatch(command.toLowerCase());
    
    if (match == null || match.groupCount < 2) throw FormatException('Formato incorrecto');

    final quantity = _textToNumber(match.group(1)!.trim());
    final productName = match.group(2)!.trim();

    if (provider.selectedCartId == null) throw StateError('No hay carrito seleccionado');

    final products = await ProductoService().obtenerProductos();
    final product = products.firstWhere(
      (p) => _normalizeText(p.nombre).contains(_normalizeText(productName)),
      orElse: () => throw StateError('Producto no encontrado')
    );

    await CarritoDetalleService().crearDetalle(CarritoDetalle(
      carritoId: provider.selectedCartId!,
      productoId: product.id!,
      cantidad: quantity,
      precioUnitario: product.precio,
    ));
    
    _showFeedback(context, '✅ ${product.nombre} (${quantity}x) agregado');
  }

  Future<void> _handleRemoveProduct(String command, BuildContext context, CartProvider provider) async {
  final match = RegExp(r'(eliminar|quitar|remover)\s+(.+)').firstMatch(command.toLowerCase());
  if (match == null || match.group(2) == null) {
    throw FormatException('Formato incorrecto. Ejemplo: "eliminar iPhone 15"');
  }

  final productName = match.group(2)!.trim();
  if (provider.selectedCartId == null) {
    throw StateError('No hay carrito seleccionado');
  }

  try {
    // 1. Buscar el producto
    final products = await ProductoService().obtenerProductos();
    final normalizedSearch = _normalizeText(productName);
    
    final product = products.firstWhere(
      (p) => _normalizeText(p.nombre) == normalizedSearch || 
             _normalizeText(p.nombre).contains(normalizedSearch),
      orElse: () => throw StateError('Producto "$productName" no encontrado')
    );

    // 2. Verificar que el producto tiene ID
    if (product.id == null) {
      throw StateError('El producto no tiene ID válido');
    }

    print('[DEBUG] Eliminando producto ID: ${product.id} del carrito ID: ${provider.selectedCartId}');
    
    // 3. Eliminar los detalles
    await CarritoDetalleService().eliminarDetallesPorProducto(
      provider.selectedCartId!,
      product.id!,
    );
    
    _showFeedback(context, '✅ ${product.nombre} eliminado del carrito');
  } catch (e) {
    _showFeedback(context, '⚠️ Error: ${e.toString()}');
    rethrow;
  }
}

  Future<void> _handleDeleteCart(BuildContext context, CartProvider provider) async {
    if (provider.selectedCartId == null) throw Exception('No hay carrito seleccionado');
    await CarritoCompraService().eliminarCarrito(provider.selectedCartId!);
    provider.deselectCart();
    _showFeedback(context, 'Carrito eliminado');
  }

  void _handleDeselectCart(BuildContext context, CartProvider provider) {
    provider.deselectCart();
    _showFeedback(context, 'Carrito deseleccionado');
  }

  String _normalizeText(String input) {
    return input.toLowerCase()
      .replaceAll(RegExp(r'[áàäâã]'), 'a')
      .replaceAll(RegExp(r'[éèëê]'), 'e')
      .replaceAll(RegExp(r'[íìïî]'), 'i')
      .replaceAll(RegExp(r'[óòöôõ]'), 'o')
      .replaceAll(RegExp(r'[úùüû]'), 'u')
      .replaceAll('ñ', 'n')
      .replaceAll(RegExp(r'[^a-z0-9 ]'), '')
      .trim();
  }

  void _showFeedback(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
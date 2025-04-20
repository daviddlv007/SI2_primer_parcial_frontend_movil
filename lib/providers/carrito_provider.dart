import 'package:flutter/foundation.dart';
import 'package:frontend_movil/providers/producto.dart';

// Clase que representa un item en el carrito (producto + cantidad)
class ItemCarrito {
  final ProductoM producto;
  int cantidad;

  ItemCarrito({required this.producto, this.cantidad = 1});

  double get subtotal => double.parse(producto.precio) * cantidad;
}

class CarritoProvider with ChangeNotifier {
  // Lista de items en el carrito
  final List<ItemCarrito> _items = [];

  // Getters
  List<ItemCarrito> get items => [..._items];
  int get cantidadItems => _items.length;
  int get cantidadProductos =>
      _items.fold(0, (sum, item) => sum + item.cantidad);

  // Calcular el total del carrito
  double get total => _items.fold(0, (sum, item) => sum + item.subtotal);

  // Verificar si un producto está en el carrito
  bool estaEnCarrito(int productoId) {
    return _items.any((item) => item.producto.id == productoId);
  }

  // Obtener un item del carrito por ID de producto
  ItemCarrito? getItemPorProductoId(int productoId) {
    try {
      return _items.firstWhere((item) => item.producto.id == productoId);
    } catch (e) {
      return null;
    }
  }

  // Agregar un producto al carrito
  void agregarProducto(ProductoM producto, {int cantidad = 1}) {
    if (estaEnCarrito(producto.id)) {
      // Si ya existe, incrementar cantidad
      incrementarCantidad(producto.id, cantidad);
    } else {
      // Si no existe, agregar nuevo item
      _items.add(ItemCarrito(producto: producto, cantidad: cantidad));
      notifyListeners();
    }
  }

  // Eliminar un producto del carrito
  void eliminarProducto(int productoId) {
    _items.removeWhere((item) => item.producto.id == productoId);
    notifyListeners();
  }

  // Incrementar cantidad de un producto
  void incrementarCantidad(int productoId, [int cantidad = 1]) {
    final item = getItemPorProductoId(productoId);
    if (item != null) {
      item.cantidad += cantidad;
      notifyListeners();
    }
  }

  // Decrementar cantidad de un producto
  void decrementarCantidad(int productoId, [int cantidad = 1]) {
    final item = getItemPorProductoId(productoId);
    if (item != null) {
      if (item.cantidad <= cantidad) {
        // Si la cantidad llega a cero o menos, eliminar el producto
        eliminarProducto(productoId);
      } else {
        item.cantidad -= cantidad;
        notifyListeners();
      }
    }
  }

  // Establecer cantidad específica para un producto
  void establecerCantidad(int productoId, int nuevaCantidad) {
    if (nuevaCantidad <= 0) {
      eliminarProducto(productoId);
      return;
    }

    final item = getItemPorProductoId(productoId);
    if (item != null) {
      item.cantidad = nuevaCantidad;
      notifyListeners();
    }
  }

  // Vaciar el carrito completamente
  void vaciarCarrito() {
    _items.clear();
    notifyListeners();
  }

  // Guardar el carrito en la API
  Future<bool> guardarCarrito() async {
    try {
      // Aquí implementarías la lógica para guardar en la API
      // Por ejemplo:
      // final carritoService = CarritoService();
      // await carritoService.crearCarrito(_items);

      return true;
    } catch (e) {
      print('Error al guardar el carrito: $e');
      return false;
    }
  }
}

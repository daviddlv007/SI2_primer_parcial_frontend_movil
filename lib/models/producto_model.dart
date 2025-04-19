class Producto {
  final int? id;
  final String nombre;
  final String? descripcion;
  final double precio;
  final int categoriaId;

  Producto({
    this.id,
    required this.nombre,
    this.descripcion,
    required this.precio,
    required this.categoriaId,
  });

factory Producto.fromJson(Map<String, dynamic> json) {
  print('[DEBUG] JSON recibido: $json'); // Log completo del JSON
  print('[DEBUG] Tipo de precio: ${json['precio'].runtimeType}'); // Tipo del dato
  print('[DEBUG] Valor de precio: ${json['precio']}'); // Valor crudo

  try {
    final precioConvertido = _convertirPrecio(json['precio']);
    print('[DEBUG] Precio convertido: $precioConvertido');
    
    return Producto(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      precio: precioConvertido,
      categoriaId: json['categoria'],
    );
  } catch (e) {
    print('[ERROR] Fallo en conversión: $e');
    rethrow;
  }
}

static double _convertirPrecio(dynamic precio) {
  print('[DEBUG] _convertirPrecio - Input: $precio (${precio.runtimeType})');
  
  if (precio == null) {
    print('[WARNING] Precio es nulo, usando 0.0 como valor por defecto');
    return 0.0;
  }
  
  if (precio is double) {
    print('[DEBUG] Precio ya es double');
    return precio;
  }
  
  if (precio is int) {
    print('[DEBUG] Convirtiendo int a double');
    return precio.toDouble();
  }
  
  if (precio is String) {
    print('[DEBUG] Procesando precio como String');
    final normalized = precio.replaceAll(',', '.')
                           .replaceAll(RegExp(r'[^\d.]'), '');
    print('[DEBUG] String normalizado: $normalized');
    
    final resultado = double.tryParse(normalized) ?? 0.0;
    print('[DEBUG] Resultado parseo: $resultado');
    return resultado;
  }
  
  print('[WARNING] Tipo no reconocido, intentando conversión genérica');
  final resultado = double.tryParse(precio.toString()) ?? 0.0;
  print('[DEBUG] Resultado conversión genérica: $resultado');
  return resultado;
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'categoria': categoriaId,
    };
  }

  @override
  String toString() {
    return nombre;
  }
}
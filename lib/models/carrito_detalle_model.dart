class CarritoDetalle {
  final int? id;
  final int carritoId;
  final int productoId;
  final int cantidad;
  final double precioUnitario;

  CarritoDetalle({
    this.id,
    required this.carritoId,
    required this.productoId,
    required this.cantidad,
    required this.precioUnitario,
  });

  factory CarritoDetalle.fromJson(Map<String, dynamic> json) {
    return CarritoDetalle(
      id: json['id'],
      carritoId: json['carrito'],
      productoId: json['producto'],
      cantidad: json['cantidad'],
      precioUnitario: _parsePrice(
        json['precio_unitario'],
      ), // Método seguro de conversión
    );
  }

  static double _parsePrice(dynamic price) {
    if (price == null) return 0.0;
    if (price is double) return price;
    if (price is int) return price.toDouble();
    if (price is String) {
      return double.tryParse(price.replaceAll(',', '.')) ?? 0.0;
    }
    return double.tryParse(price.toString()) ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'carrito': carritoId,
      'producto': productoId,
      'cantidad': cantidad,
      'precio_unitario': precioUnitario,
    };
  }

  @override
  String toString() {
    return 'Detalle $id para carrito $carritoId';
  }
}

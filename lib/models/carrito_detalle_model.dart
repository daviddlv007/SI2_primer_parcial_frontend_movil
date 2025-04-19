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
      precioUnitario: json['precio_unitario'].toDouble(),
    );
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
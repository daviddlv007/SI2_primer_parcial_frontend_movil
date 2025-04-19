class Inventario {
  final int? id;
  final int productoId;
  final int cantidad;
  final int umbralAlerta;

  Inventario({
    this.id,
    required this.productoId,
    required this.cantidad,
    this.umbralAlerta = 5,
  });

  factory Inventario.fromJson(Map<String, dynamic> json) {
    return Inventario(
      id: json['id'],
      productoId: json['producto'],
      cantidad: json['cantidad'],
      umbralAlerta: json['umbral_alerta'] ?? 5,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'producto': productoId,
      'cantidad': cantidad,
      'umbral_alerta': umbralAlerta,
    };
  }

  @override
  String toString() {
    return 'Inventario de producto $productoId';
  }
}
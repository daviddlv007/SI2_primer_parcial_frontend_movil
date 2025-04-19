class CarritoCompra {
  final int? id;
  final int usuarioId;
  final String estado;

  CarritoCompra({
    this.id,
    required this.usuarioId,
    this.estado = 'activo',
  });

  factory CarritoCompra.fromJson(Map<String, dynamic> json) {
    return CarritoCompra(
      id: json['id'],
      usuarioId: json['usuario'],
      estado: json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario': usuarioId,
      'estado': estado,
    };
  }

  @override
  String toString() {
    return 'Carrito $id ($estado)';
  }
}
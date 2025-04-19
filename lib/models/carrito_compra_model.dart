class CarritoCompra {
  final int? id;
  final int usuarioId;
  final String estado;
  final String? fecha;

  CarritoCompra({
    this.id,
    required this.usuarioId,
    this.estado = 'activo',
    required this.fecha,
  });

  factory CarritoCompra.fromJson(Map<String, dynamic> json) {
    return CarritoCompra(
      id: json['id'],
      usuarioId: json['usuario'],
      estado: json['estado'],
      fecha: json['fecha'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'usuario': usuarioId, 'estado': estado};
  }

  @override
  String toString() {
    return 'Carrito $id ($estado)';
  }
}

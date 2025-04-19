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
    return Producto(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      precio: json['precio'].toDouble(),
      categoriaId: json['categoria'],
    );
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
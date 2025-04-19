//ES PARA EL MODULO PRODUCTO --> ENLACE CON EL BACK
class Producto {
  final int id;
  final String nombre;
  final double precio;
  final int stock;
  final String imagen;

  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.stock,
    required this.imagen,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nombre: json['nombre'],
      precio: json['precio'].toDouble(),
      stock: json['stock'],
      imagen: json['imagen'],
    );
  }
}

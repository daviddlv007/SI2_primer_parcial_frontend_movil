// To parse this JSON data, do
//
//     final ProductoM = ProductoMFromJson(jsonString);

import 'dart:convert';

ProductoM ProductoMFromJson(String str) => ProductoM.fromJson(json.decode(str));

String ProductoMToJson(ProductoM data) => json.encode(data.toJson());

class ProductoM {
  int id;
  String nombre;
  String descripcion;
  String precio;
  int categoria;

  ProductoM({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.categoria,
  });

  factory ProductoM.fromJson(Map<String, dynamic> json) => ProductoM(
    id: json["id"],
    nombre: json["nombre"],
    descripcion: json["descripcion"],
    precio: json["precio"],
    categoria: json["categoria"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nombre": nombre,
    "descripcion": descripcion,
    "precio": precio,
    "categoria": categoria,
  };
}

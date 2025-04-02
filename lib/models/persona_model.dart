class Persona {
  final int? id;  // Hacer el id opcional
  final String nombre;
  final int edad;

  Persona({
    this.id,  // El id es opcional en el constructor.
    required this.nombre,
    required this.edad,
  });

  // Crear una persona a partir de un JSON
  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(
      id: json['id'],  // Asegúrate de que el id venga del JSON, puede ser nulo.
      nombre: json['nombre'],
      edad: json['edad'],
    );
  }

  // Convertir una persona a un JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id, // Aquí id puede ser null, pero se maneja sin problemas.
      'nombre': nombre,
      'edad': edad,
    };
  }

  @override
  String toString() {
    return '$nombre $edad'; // Permite filtrar por nombre y edad
  }  
}

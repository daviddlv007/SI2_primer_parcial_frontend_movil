import 'package:flutter/material.dart';

class CatalogoProductosView extends StatelessWidget {
  const CatalogoProductosView({super.key});

  final List<Map<String, dynamic>> productos = const [
    {
      "nombre": "ADAPTADOR HAMA DVI",
      "precio": 10.00,
      "cantidad": 12,
      // "imagen": "assets/productos/adaptador.png",
    },
    {
      "nombre": "AURICULARES SONY",
      "precio": 35.00,
      "cantidad": 8,
      // "imagen": "assets/productos/auriculares.png",
    },
    {
      "nombre": "RATÓN INALÁMBRICO",
      "precio": 18.00,
      "cantidad": 5,
      // "imagen": "assets/productos/raton.png",
    },
    {
      "nombre": "TECLADO MECÁNICO",
      "precio": 63.00,
      "cantidad": 7,
      // "imagen": "assets/productos/teclado.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CATÁLOGO DE PRODUCTOS")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Buscar Productos',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: productos.length,
                itemBuilder: (context, index) {
                  final producto = productos[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      //leading: Image.asset(producto['imagen'], width: 50),
                      title: Text(producto['nombre']),
                      subtitle: Text(
                        "Bs ${producto['precio']} - Stock: ${producto['cantidad']}",
                      ),
                      /*trailing: const Icon(
                        Icons.toggle_on,
                        size: 32,
                        color: Colors.blue,
                      ),*/
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'main_page.dart'; // Pantalla principal con Scaffold
// Contenido del body
// Menú lateral

void main() {
  runApp(const SmartCartApp());
}

class SmartCartApp extends StatelessWidget {
  const SmartCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Cart',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
        '/mas_vendidos':
            (context) => Scaffold(
              appBar: AppBar(title: Text('Productos más vendidos')),
              body: Center(child: Text('Aquí van los productos más vendidos')),
            ),
        '/descuentos':
            (context) => Scaffold(
              appBar: AppBar(title: Text('Descuentos')),
              body: Center(child: Text('Aquí van los descuentos disponibles')),
            ),
        // Puedes agregar más rutas como '/catalogo', '/carrito', '/pedidos', etc.
      },
    );
  }
}

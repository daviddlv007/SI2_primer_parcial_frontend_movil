import 'package:flutter/material.dart';

class PrincipalContent extends StatelessWidget {
  const PrincipalContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo.jpg',
            height: 100,
          ), // cambia por tu logo
          SizedBox(height: 10),
          Text(
            'Inteligente - Carrito',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'Sistema de Punto de Venta (POS) con Inteligencia Artificial para el Reconocimiento de Voz y Recomendaciones de productos a comprar',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Image.asset(
            'assets/carrito_teclado.jpg',
            height: 150,
          ), // pon imagen del carrito
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/mas_vendidos'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: Size(double.infinity, 50),
            ),
            child: Text('Productos más vendidos'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/descuentos'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: Size(double.infinity, 50),
            ),
            child: Text('Descuentos'),
          ),
        ],
      ),
    );
  }
}

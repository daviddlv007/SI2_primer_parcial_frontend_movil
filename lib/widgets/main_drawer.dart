import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/logo.jpg', height: 50), // pon aquí tu logo
                SizedBox(height: 10),
                Text(
                  "Smart - Cart",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          _drawerItem(Icons.home, 'PRINCIPAL', '/', context),
          _drawerItem(
            Icons.folder,
            'CATÁLOGO DE PRODUCTOS',
            '/catalogo',
            context,
          ),
          _drawerItem(
            Icons.discount,
            'DESCUENTOS DE TEMPORADA',
            '/descuentos',
            context,
          ),
          _drawerItem(
            Icons.shopping_cart,
            'CARRITO DE COMPRA',
            '/carrito_detalle',
            context,
          ),
          _drawerItem(Icons.receipt, 'MIS PEDIDOS', '/pedidos', context),
          _drawerItem(
            Icons.receipt,
            'Modelo CRUD simple',
            '/personas',
            context,
          ),
          _drawerItem(Icons.receipt, 'test', '/voice_test', context),
        ],
      ),
    );
  }

  Widget _drawerItem(
    IconData icon,
    String title,
    String route,
    BuildContext context,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }
}

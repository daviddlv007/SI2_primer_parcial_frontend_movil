import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Menú de Navegación',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          // Ruta a Personas
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Personas'),
            onTap: () {
              Navigator.pushReplacementNamed(
                context,
                '/persona',
              ); // Ruta definida
            },
          ),
          ExpansionTile(
            leading: const Icon(Icons.settings),
            title: const Text('Opciones'),
            children: [
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Opción 1'),
                onTap: () {
                  // Reemplazar con la ruta correspondiente
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Opción 2'),
                onTap: () {
                  // Reemplazar con la ruta correspondiente
                },
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('CATÁLOGO DE PRODUCTOS'),
            onTap: () {
              Navigator.pushNamed(context, '/catalogo');
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import '../widgets/topbar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(),  // Importa el TopBar
      drawer: const SideBar(),  // Importa el Sidebar
      body: const Center(
        child: Text('Inicio funciona correctamente'),
      ),
    );
  }
}

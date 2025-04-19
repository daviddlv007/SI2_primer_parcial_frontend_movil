import 'package:flutter/material.dart';
import '../../widgets/main_drawer.dart';
import 'principal_content.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menú"),

        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      ),
      drawer: MainDrawer(),
      body: PrincipalContent(),
    );
  }
}

import 'package:flutter/material.dart';
import 'main_page.dart';
import 'views/home_view.dart';
import 'views/persona/persona_view.dart';
// importa todas las vistas que necesites

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => MainPage(),

  '/home': (context) => const HomeView(),

  '/personas': (context) => const PersonaView(),

  '/mas_vendidos': (context) => Scaffold(
        appBar: AppBar(title: Text('Productos más vendidos')),
        body: Center(child: Text('Aquí van los productos más vendidos')),
      ),
      
  '/descuentos': (context) => Scaffold(
        appBar: AppBar(title: Text('Descuentos')),
        body: Center(child: Text('Aquí van los descuentos disponibles')),
      ),

};

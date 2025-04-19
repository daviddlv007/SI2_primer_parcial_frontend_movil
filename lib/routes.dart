import 'package:flutter/material.dart';
import 'views/home/main_page.dart';
import 'views/persona/persona_view.dart';

import 'views/test/voice_test_view.dart';
// importa todas las vistas que necesites

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => MainPage(),


  '/personas': (context) => const PersonaView(),

  '/mas_vendidos': (context) => Scaffold(
        appBar: AppBar(title: Text('Productos más vendidos')),
        body: Center(child: Text('Aquí van los productos más vendidos')),
      ),

  '/descuentos': (context) => Scaffold(
        appBar: AppBar(title: Text('Descuentos')),
        body: Center(child: Text('Aquí van los descuentos disponibles')),
      ),
  '/voice_test': (context) => const VoiceTestView(),
};

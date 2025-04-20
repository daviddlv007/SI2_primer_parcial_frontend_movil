import 'package:flutter/material.dart';
import 'package:frontend_movil/views/carrito/carrito_view.dart';
import 'package:frontend_movil/views/carrito/detalle_carrito_view.dart';
import 'package:frontend_movil/views/carrito/lista_carritos_view.dart';
import 'package:frontend_movil/views/catalogo/catalogo_productos_view.dart';
import 'package:frontend_movil/views/home/main_page.dart';
import 'package:frontend_movil/views/persona/persona_view.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => MainPage(),

  '/personas': (context) => const PersonaView(),

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

  '/catalogo': (context) => const CatalogoProductosView(),

  '/carrito': (context) => const CarritoView(),
  '/carritos': (context) => const ListaCarritosView(),
  '/carrito_detalle': (context) => const DetalleCarritoView(),
};

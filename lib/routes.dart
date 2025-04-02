import 'package:flutter/material.dart';
import 'views/home_view.dart';
import 'views/persona/persona_view.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const HomeView(),
  '/persona': (context) => const PersonaView(),
};

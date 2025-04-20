import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//import 'routes.dart';
import 'providers/cart_provider.dart';
import 'widgets/global_overlay.dart'; // ⬅️ ahora desde widgets/

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CartProvider())],
      child: const SmartCartApp(),
    ),
  );
}

class SmartCartApp extends StatelessWidget {
  const SmartCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Cart',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const GlobalOverlay(),
    );
  }
}

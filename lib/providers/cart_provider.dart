import 'package:flutter/foundation.dart';

//datos globales almacenados
class CartProvider with ChangeNotifier {
  int? _selectedCartId;

  int? get selectedCartId => _selectedCartId;

  void selectCart(int id) {
    _selectedCartId = id;
    notifyListeners();
  }

  void deselectCart() {
    _selectedCartId = null;
    notifyListeners();
  }
}

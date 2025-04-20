class CurrentCartService {
  int? _currentCartId;

  int? get id => _currentCartId;
  
  void setId(int id) => _currentCartId = id;
  
  void clear() => _currentCartId = null;
  
  bool get hasActiveCart => _currentCartId != null;
}
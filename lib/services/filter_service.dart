
class FilterService {
  static List<T> filtrar<T>(List<T> lista, String filtro) {
    return lista.where((item) {
      return item.toString().toLowerCase().contains(filtro.toLowerCase());
    }).toList();
  }
}



import 'package:flutter/material.dart';
import '../../models/producto_model.dart';
import '../../models/categoria_model.dart';
import '../../services/producto_service.dart';
import '../../services/categoria_service.dart';

class CatalogoProductosView extends StatefulWidget {
  const CatalogoProductosView({super.key});

  @override
  State<CatalogoProductosView> createState() => _CatalogoProductosViewState();
}

class _CatalogoProductosViewState extends State<CatalogoProductosView> {
  final ProductoService _productoService = ProductoService();
  final CategoriaService _categoriaService = CategoriaService();

  final TextEditingController _searchController = TextEditingController();

  List<Producto> _productos = [];
  List<Categoria> _categorias = [];
  int _categoriaSeleccionada = 0;
  String _busqueda = '';
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    try {
      final productos = await _productoService.obtenerProductos();
      final categorias = await _categoriaService.obtenerCategorias();

      setState(() {
        _productos = productos;
        _categorias = [Categoria(id: 0, nombre: 'Todos'), ...categorias];
        _cargando = false;
      });
    } catch (e) {
      setState(() => _cargando = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cargar catálogo: $e')));
    }
  }

  List<Producto> get _productosFiltrados {
    return _productos.where((p) {
      final coincideCategoria =
          _categoriaSeleccionada == 0 ||
          p.categoriaId == _categoriaSeleccionada;
      final coincideBusqueda = p.nombre.toLowerCase().contains(
        _busqueda.toLowerCase(),
      );
      return coincideCategoria && coincideBusqueda;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CATÁLOGO DE PRODUCTOS")),
      body:
          _cargando
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Buscar por nombre...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _busqueda = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButton<int>(
                      value: _categoriaSeleccionada,
                      isExpanded: true,
                      items:
                          _categorias.map((cat) {
                            return DropdownMenuItem(
                              value: cat.id,
                              child: Text(cat.nombre),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _categoriaSeleccionada = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child:
                          _productosFiltrados.isEmpty
                              ? const Center(
                                child: Text("No se encontraron productos."),
                              )
                              : ListView.builder(
                                itemCount: _productosFiltrados.length,
                                itemBuilder: (context, index) {
                                  final p = _productosFiltrados[index];
                                  return Card(
                                    elevation: 3,
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    child: ListTile(
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: Image.network(
                                          p.urlImagen,
                                          width: 45,
                                          height: 45,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (_, __, ___) => const Icon(
                                                Icons.broken_image,
                                              ),
                                        ),
                                      ),
                                      title: Text(
                                        p.nombre,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Text(
                                        "Bs ${p.precio.toStringAsFixed(2)}",
                                      ),
                                    ),
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              ),
    );
  }
}

/*import 'package:flutter/material.dart';
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
  late Future<List<ProductoModel>> _productosFuture;
  late Future<List<CategoriaModel>> _categoriasFuture;

  List<ProductoModel> _productos = [];
  List<CategoriaModel> _categorias = [];
  int? _categoriaSeleccionada;

  @override
  void initState() {
    super.initState();
    _productosFuture = ProductoService.obtenerProductos();
    _categoriasFuture = CategoriaService.obtenerCategorias();

    _loadData();
  }

  Future<void> _loadData() async {
    final productos = await ProductoService.obtenerProductos();
    final categorias = await CategoriaService.obtenerCategorias();

    setState(() {
      _productos = productos;
      _categorias = [CategoriaModel(id: 0, nombre: 'Todos'), ...categorias];
      _categoriaSeleccionada = 0;
    });
  }

  List<ProductoModel> get _productosFiltrados {
    if (_categoriaSeleccionada == 0) return _productos;
    return _productos
        .where((p) => p.categoriaId == _categoriaSeleccionada)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CATÁLOGO DE PRODUCTOS")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            DropdownButton<int>(
              isExpanded: true,
              value: _categoriaSeleccionada,
              items: _categorias
                  .map((cat) => DropdownMenuItem(
                        value: cat.id,
                        child: Text(cat.nombre),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _categoriaSeleccionada = value!;
                });
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _productos.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _productosFiltrados.length,
                      itemBuilder: (context, index) {
                        final p = _productosFiltrados[index];
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: Image.network(
                              p.imagen,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.image),
                            ),
                            title: Text(p.nombre, overflow: TextOverflow.ellipsis),
                            subtitle: Text("Bs ${p.precio} - Stock: ${p.cantidad}"),
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
}*/

import 'package:flutter/material.dart';
import '../../models/carrito_compra_model.dart';
import '../../services/carrito_compra_service.dart';

class ListaCarritosView extends StatelessWidget {
  const ListaCarritosView({super.key});

  void _abrirDetalleCarrito(BuildContext context, int idCarrito) {
    Navigator.pushNamed(context, '/carrito_detalle', arguments: idCarrito);
  }

  @override
  Widget build(BuildContext context) {
    final _carritoService = CarritoCompraService();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carritos existentes"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<CarritoCompra>>(
        future: _carritoService.obtenerCarritos(), // usa tu servicio
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final carritos = snapshot.data!;
          if (carritos.isEmpty) {
            return const Center(child: Text("No hay carritos disponibles"));
          }

          return ListView.builder(
            itemCount: carritos.length,
            itemBuilder: (context, index) {
              final carrito = carritos[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text("Carrito #${carrito.id}"),
                  subtitle: Text("Fecha: ${carrito.fecha ?? 'sin fecha'}"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _abrirDetalleCarrito(context, carrito.id!),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

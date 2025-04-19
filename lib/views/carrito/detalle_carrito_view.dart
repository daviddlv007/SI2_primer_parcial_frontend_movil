import 'package:flutter/material.dart';
import '../../models/carrito_detalle_model.dart';
import '../../services/carrito_detalle_service.dart';

class DetalleCarritoView extends StatelessWidget {
  const DetalleCarritoView({super.key});

  @override
  Widget build(BuildContext context) {
    final _detalleService = CarritoDetalleService();

    final int idCarrito = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalle Carrito #$idCarrito"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<CarritoDetalle>>(
        future: _detalleService.obtenerDetalles(), //PERO LOS FILTRA TODO JUNTO
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final detalles = snapshot.data!;
          if (detalles.isEmpty) {
            return const Center(child: Text("Este carrito está vacío."));
          }

          double total = detalles.fold(
            0,
            (sum, d) => sum + (d.precioUnitario * d.cantidad),
          );

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: detalles.length,
                  itemBuilder: (context, index) {
                    final d = detalles[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        title: Text("Producto ID: ${d.productoId}"),
                        subtitle: Text(
                          "Cantidad: ${d.cantidad}  •  Bs ${d.precioUnitario} c/u",
                        ),
                        trailing: Text(
                          "Bs ${(d.precioUnitario * d.cantidad).toStringAsFixed(2)}",
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                color: const Color.fromARGB(255, 52, 52, 212),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Bs ${total.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

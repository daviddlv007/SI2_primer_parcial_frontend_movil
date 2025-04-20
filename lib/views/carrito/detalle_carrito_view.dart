import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/carrito_provider.dart';

class DetalleCarritoView extends StatelessWidget {
  const DetalleCarritoView({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener el ID del carrito del provider
    final cartProvider = Provider.of<CartProvider>(context);
    final carritoProvider = Provider.of<CarritoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Mi Carrito"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Vaciar carrito',
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (ctx) => AlertDialog(
                      title: const Text('Vaciar carrito'),
                      content: const Text(
                        '¿Estás seguro que quieres vaciar el carrito?',
                      ),
                      actions: [
                        TextButton(
                          child: const Text('Cancelar'),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                        TextButton(
                          child: const Text('Vaciar'),
                          onPressed: () {
                            carritoProvider.vaciarCarrito();
                            Navigator.of(ctx).pop();
                          },
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Si el carrito está vacío
          if (carritoProvider.items.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.shopping_cart_outlined,
                      size: 80,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Tu carrito está vacío",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Agrega productos para comenzar",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed:
                          () => Navigator.of(context).pushNamed('/productos'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text("Ver productos"),
                    ),
                  ],
                ),
              ),
            ),

          // Si hay productos en el carrito
          if (carritoProvider.items.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: carritoProvider.items.length,
                itemBuilder: (context, index) {
                  final item = carritoProvider.items[index];

                  return Dismissible(
                    key: Key(item.producto.id.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) {
                      carritoProvider.eliminarProducto(item.producto.id!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${item.producto.nombre} eliminado"),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: const CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.shopping_bag, color: Colors.white),
                        ),
                        title: Text(
                          item.producto.nombre,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("Bs ${item.producto.precio} c/u"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed:
                                  () => carritoProvider.decrementarCantidad(
                                    item.producto.id!,
                                  ),
                            ),
                            Text(
                              "${item.cantidad}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed:
                                  () => carritoProvider.incrementarCantidad(
                                    item.producto.id!,
                                  ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              "Bs ${item.subtotal.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        isThreeLine: false,
                      ),
                    ),
                  );
                },
              ),
            ),

          // Resumen del carrito
          if (carritoProvider.items.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Bs ${carritoProvider.total.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        // Aquí implementaría el proceso de checkout
                        Navigator.of(context).pushNamed('/compra');
                      },
                      child: const Text(
                        "FINALIZAR COMPRA",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

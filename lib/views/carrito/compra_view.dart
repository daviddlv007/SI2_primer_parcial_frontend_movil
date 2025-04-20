import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/carrito_provider.dart';

class CompraView extends StatefulWidget {
  const CompraView({super.key});

  @override
  State<CompraView> createState() => _CompraViewState();
}

class _CompraViewState extends State<CompraView> {
  final _formKey = GlobalKey<FormState>();

  // Método de pago seleccionado
  String _metodoPagoSeleccionado = 'efectivo';

  // Controladores para los campos
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _direccionController = TextEditingController();

  // Para tarjetas
  final _numeroTarjetaController = TextEditingController();
  final _fechaExpiracionController = TextEditingController();
  final _cvvController = TextEditingController();

  bool _isProcessing = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    _numeroTarjetaController.dispose();
    _fechaExpiracionController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final carritoProvider = Provider.of<CarritoProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Finalizar Compra'), elevation: 0),
      body:
          carritoProvider.items.isEmpty
              ? const Center(child: Text('No hay productos en el carrito'))
              : _buildCompraForm(context, carritoProvider),
    );
  }

  Widget _buildCompraForm(
    BuildContext context,
    CarritoProvider carritoProvider,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Resumen de compra
              _buildResumenCompra(carritoProvider),
              const SizedBox(height: 24),

              // Datos de contacto
              _buildDatosContacto(),
              const SizedBox(height: 24),

              // Métodos de pago
              _buildMetodosPago(),
              const SizedBox(height: 24),

              // Detalles del método de pago seleccionado
              _buildDetallesMetodoPago(),
              const SizedBox(height: 32),

              // Botón de confirmar compra
              _buildBotonConfirmar(carritoProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResumenCompra(CarritoProvider carritoProvider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen de compra',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...carritoProvider.items
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${item.producto.nombre} x${item.cantidad}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Bs ${item.subtotal.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Bs ${carritoProvider.total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatosContacto() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Datos de contacto',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre completo',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu nombre';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu email';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _telefonoController,
              decoration: InputDecoration(
                labelText: 'Teléfono',
                prefixIcon: const Icon(Icons.phone_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _direccionController,
              decoration: InputDecoration(
                labelText: 'Dirección de entrega',
                prefixIcon: const Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: 2,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa una dirección';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetodosPago() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Método de pago',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Método: Efectivo
            _buildMetodoPagoTile(
              'efectivo',
              'Efectivo / Contra entrega',
              Icons.payments_outlined,
              Colors.green,
            ),
            const Divider(height: 4),

            // Método: Tarjeta
            _buildMetodoPagoTile(
              'tarjeta',
              'Tarjeta de crédito/débito',
              Icons.credit_card,
              Colors.blue,
            ),
            const Divider(height: 4),

            // Método: PayPal
            _buildMetodoPagoTile(
              'paypal',
              'PayPal',
              Icons.account_balance_wallet_outlined,
              Colors.indigo,
            ),

            // Método: Transferencia
            _buildMetodoPagoTile(
              'transferencia',
              'Transferencia bancaria',
              Icons.account_balance_outlined,
              Colors.amber.shade700,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetodoPagoTile(
    String value,
    String title,
    IconData icon,
    Color color,
  ) {
    return RadioListTile<String>(
      title: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
      value: value,
      groupValue: _metodoPagoSeleccionado,
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _metodoPagoSeleccionado = newValue;
          });
        }
      },
      activeColor: Theme.of(context).primaryColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _buildDetallesMetodoPago() {
    // Mostrar detalles específicos según el método de pago seleccionado
    switch (_metodoPagoSeleccionado) {
      case 'tarjeta':
        return _buildFormularioTarjeta();
      case 'paypal':
        return _buildPayPalInfo();
      case 'transferencia':
        return _buildTransferenciaInfo();
      case 'efectivo':
      default:
        return _buildEfectivoInfo();
    }
  }

  Widget _buildFormularioTarjeta() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Datos de la tarjeta',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _numeroTarjetaController,
              decoration: InputDecoration(
                labelText: 'Número de tarjeta',
                prefixIcon: const Icon(Icons.credit_card),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa el número de tarjeta';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _fechaExpiracionController,
                    decoration: InputDecoration(
                      labelText: 'MM/YY',
                      prefixIcon: const Icon(Icons.date_range),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.datetime,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Fecha inválida';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: _cvvController,
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      prefixIcon: const Icon(Icons.security),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Requerido';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock, size: 16, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  'Conexión segura para proteger tus datos',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayPalInfo() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Información de PayPal',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Serás redirigido al sitio de PayPal para completar tu pago de manera segura.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.security, color: Colors.blue.shade700),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'PayPal protege tus transacciones con encriptación avanzada',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransferenciaInfo() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_balance,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Datos para transferencia',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Por favor realiza una transferencia bancaria a la siguiente cuenta:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Banco: Banco Nacional de Bolivia',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Titular: Empresa S.A.',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Cuenta: 1234-5678-9012-3456',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Una vez realizada la transferencia, por favor envía el comprobante a nuestro WhatsApp: +591 12345678',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEfectivoInfo() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.payments, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Pago en efectivo',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Recibirás tu pedido y pagarás en efectivo al momento de la entrega.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.green.shade700,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Asegúrate de tener el monto exacto para facilitar la entrega',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotonConfirmar(CarritoProvider carritoProvider) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        onPressed:
            _isProcessing
                ? null
                : () => _procesarCompra(carritoProvider, context),
        child:
            _isProcessing
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                  'CONFIRMAR COMPRA',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
      ),
    );
  }

  void _procesarCompra(
    CarritoProvider carritoProvider,
    BuildContext context,
  ) async {
    // Validar el formulario
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos requeridos'),
        ),
      );
      return;
    }

    // Mostrar proceso
    setState(() => _isProcessing = true);

    // Simular procesamiento
    try {
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // Vaciar carrito después de la compra
      carritoProvider.vaciarCarrito();

      // Navegar a pantalla de éxito
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => _CompraExitosaView()),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al procesar el pago. Intenta nuevamente.'),
          backgroundColor: Colors.red,
        ),
      );

      setState(() => _isProcessing = false);
    }
  }
}

class _CompraExitosaView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 120,
            ),
            const SizedBox(height: 24),
            const Text(
              '¡Compra realizada con éxito!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Gracias por tu compra',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              onPressed:
                  () => Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/', (route) => false),
              child: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    );
  }
}

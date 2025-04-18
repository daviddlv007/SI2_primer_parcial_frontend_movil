import "package:flutter/material.dart";
import '../../../models/persona_model.dart';
import '../../../services/persona_service.dart';

class PersonaCreateView extends StatefulWidget {
  const PersonaCreateView({super.key});

  @override
  _PersonaCreateViewState createState() => _PersonaCreateViewState();
}

class _PersonaCreateViewState extends State<PersonaCreateView> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _edadController = TextEditingController();

  bool _isLoading = false;

  // Método para crear la persona
  void _crearPersona() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final nombre = _nombreController.text;
      final edad = int.tryParse(_edadController.text) ?? 0;

      // No pasar el id al crear la persona
      final nuevaPersona = Persona(nombre: nombre, edad: edad);

      try {
        // Crear persona en el servicio, sin enviar el id
        await PersonaService().crearPersona(nuevaPersona);
        // Si la creación es exitosa, navegar hacia atrás
        Navigator.pop(context);
      } catch (e) {
        // En caso de error, mostrar un mensaje
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear la persona: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Persona')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nombreController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _edadController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Edad'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la edad';
                  }
                  final edad = int.tryParse(value);
                  if (edad == null || edad <= 0) {
                    return 'Por favor ingrese una edad válida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                    onPressed: _crearPersona,
                    child: const Text('Guardar'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

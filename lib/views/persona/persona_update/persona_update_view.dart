import 'package:flutter/material.dart';
import '../../../models/persona_model.dart';
import '../../../services/persona_service.dart';

class PersonaUpdateView extends StatefulWidget {
  final Persona persona;  // Recibe la persona a editar

  const PersonaUpdateView({super.key, required this.persona});

  @override
  _PersonaUpdateViewState createState() => _PersonaUpdateViewState();
}

class _PersonaUpdateViewState extends State<PersonaUpdateView> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _edadController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Inicializar los controladores con los valores de la persona
    _nombreController.text = widget.persona.nombre;
    _edadController.text = widget.persona.edad.toString();
  }

  // Método para actualizar la persona
  void _actualizarPersona() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final nombre = _nombreController.text;
      final edad = int.tryParse(_edadController.text) ?? 0;

      final personaActualizada = Persona(id: widget.persona.id, nombre: nombre, edad: edad);

      try {
        // Llamar al servicio para actualizar la persona
        await PersonaService().actualizarPersona(widget.persona.id!, personaActualizada);
        // Si la actualización es exitosa, navegar hacia atrás
        Navigator.pop(context);
      } catch (e) {
        // En caso de error, mostrar un mensaje
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar la persona: $e')),
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
      appBar: AppBar(title: const Text('Actualizar Persona')),
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
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                ),
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
                decoration: const InputDecoration(
                  labelText: 'Edad',
                ),
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
                      onPressed: _actualizarPersona,
                      child: const Text('Actualizar'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../widgets/sidebar.dart';
import '../../widgets/topbar.dart';
import '../../services/persona_service.dart';
import '../../models/persona_model.dart';
import 'persona_create/persona_create_view.dart';
import 'persona_update/persona_update_view.dart';
import '../../services/filter_service.dart';

class PersonaView extends StatefulWidget {
  const PersonaView({super.key});

  @override
  _PersonaViewState createState() => _PersonaViewState();
}

class _PersonaViewState extends State<PersonaView> {
  final PersonaService _personaService = PersonaService();
  final TextEditingController _searchController = TextEditingController();
  List<Persona> personas = [];
  List<Persona> personasFiltradas = [];

  @override
  void initState() {
    super.initState();
    _cargarPersonas();
    _searchController.addListener(() => _filtrarPersonas(_searchController.text));
  }

  Future<void> _cargarPersonas() async {
    final data = await _personaService.obtenerPersonas();
    setState(() {
      personas = data;
      personasFiltradas = data; // Inicialmente, ambas listas son iguales
    });
  }

  void _filtrarPersonas(String filtro) {
    setState(() {
      personasFiltradas = FilterService.filtrar(personas, filtro);
    });
  }

  Future<void> _confirmarEliminarPersona(int? id) async {
    final bool? confirmar = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Seguro que deseas eliminar esta persona?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await _personaService.eliminarPersona(id!);
              if (mounted) {
                Navigator.pop(context, true);
                _cargarPersonas(); // Recargar la lista después de eliminar
              }
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      _cargarPersonas();
    }
  }

  // Método para manejar el toque fuera del cuadro de búsqueda
  void _onTapOutside() {
    FocusScope.of(context).requestFocus(FocusNode()); // Remover el foco del cuadro de búsqueda
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTapOutside, // Cuando el usuario toque fuera, desmarcamos el foco
      child: Scaffold(
        appBar: const TopBar(),
        drawer: const SideBar(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PersonaCreateView()),
          ).then((_) => _cargarPersonas()), // Recargar después de crear
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Buscar persona...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (text) {
                  setState(() {
                    personasFiltradas = FilterService.filtrar(personas, text);
                  });
                },
              ),
            ),
            Expanded(
              child: personasFiltradas.isEmpty
                  ? const Center(child: Text('No hay personas disponibles.'))
                  : ListView.builder(
                      itemCount: personasFiltradas.length,
                      itemBuilder: (context, index) {
                        final persona = personasFiltradas[index];
                        return Card(
                          margin: const EdgeInsets.all(10.0),
                          elevation: 5.0,
                          child: ListTile(
                            title: Text(persona.nombre),
                            subtitle: Text('Edad: ${persona.edad}'),
                            leading: CircleAvatar(child: Text(persona.id.toString())),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PersonaUpdateView(persona: persona),
                                    ),
                                  ).then((_) => _cargarPersonas()), // Recargar tras actualización
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _confirmarEliminarPersona(persona.id),
                                ),
                              ],
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

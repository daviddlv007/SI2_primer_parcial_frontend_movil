import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class CarritoView extends StatefulWidget {
  const CarritoView({super.key});

  @override
  State<CarritoView> createState() => _CarritoViewState();
}

class _CarritoViewState extends State<CarritoView> {
  final SpeechToText _speech = SpeechToText();
  bool _isListening = false;
  bool _speechAvailable = false;
  String _transcribedText = '';
  String _status = 'Presiona para iniciar';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _speechAvailable = await _speech.initialize(
      onStatus: (status) => setState(() => _status = 'Estado: $status'),
      onError: (error) => setState(() => _status = 'Error: $error'),
    );
  }

  void _startListening() {
    _speech.listen(
      onResult: (result) {
        setState(() {
          _transcribedText = result.recognizedWords;
        });
      },
    );
    setState(() => _isListening = true);
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  void _toggleMic() {
    if (!_speechAvailable) return;
    _isListening ? _stopListening() : _startListening();
  }

  void _verDetalleCarrito() {
    Navigator.pushNamed(context, '/carritos');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrito de Compra"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Diga el nombre de los productos a agregar o eliminar:"),
            const SizedBox(height: 10),
            TextField(
              controller: TextEditingController(text: _transcribedText),
              readOnly: true, // 👈 importante: NO editable
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Aquí se transcribirá tu voz...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _verDetalleCarrito,
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text("Ver detalle carrito"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _toggleMic,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: _isListening ? Colors.red : Colors.blue,
                child: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(_status),
          ],
        ),
      ),
    );
  }
}

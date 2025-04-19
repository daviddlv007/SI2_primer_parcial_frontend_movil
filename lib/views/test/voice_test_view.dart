// lib/views/voice_test_view.dart
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceTestView extends StatefulWidget {
  const VoiceTestView({Key? key}) : super(key: key);

  @override
  _VoiceTestViewState createState() => _VoiceTestViewState();
}

class _VoiceTestViewState extends State<VoiceTestView> {
  final SpeechToText _speech = SpeechToText();
  bool _isAvailable = false;
  bool _isListening = false;
  String _transcribedText = 'Presiona el micrófono y comienza a hablar';
  String _lastWords = '';
  String _status = 'Presiona para iniciar';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    try {
      _isAvailable = await _speech.initialize(
        onStatus: (status) {
          setState(() => _status = 'Estado: $status');
        },
        onError: (error) {
          setState(() => _status = 'Error: $error');
          _stopListening();
        },
      );
      setState(() {});
    } catch (e) {
      setState(() => _status = 'Error al inicializar: $e');
    }
  }

  void _startListening() {
    if (!_isAvailable || _isListening) return;

    setState(() {
      _isListening = true;
      _transcribedText = 'Escuchando...';
      _status = 'Escuchando...';
    });

    _speech.listen(
      onResult: (result) {
        setState(() {
          _lastWords = result.recognizedWords;
          if (result.finalResult) {
            _transcribedText = _lastWords;
            _status = 'Transcripción finalizada';
          } else {
            _transcribedText = _lastWords;
            _status = 'Escuchando... (parcial)';
          }
        });
      },
      localeId: 'es-ES', // Español general
      listenFor: const Duration(minutes: 1),
      pauseFor: const Duration(seconds: 5),
      partialResults: true,
      cancelOnError: true,
      listenMode: ListenMode.confirmation,
    );
  }

  void _stopListening() {
    if (!_isListening) return;
    
    _speech.stop();
    setState(() {
      _isListening = false;
      if (_lastWords.isEmpty) {
        _transcribedText = 'No se detectó voz';
      }
      _status = 'Listo para escuchar';
    });
  }

  void _toggleListening() {
    if (_isListening) {
      _stopListening();
    } else {
      _startListening();
    }
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prueba de Transcripción'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Área de visualización del texto
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              height: 200,
              width: double.infinity,
              child: Center(
                child: Text(
                  _transcribedText,
                  style: const TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Estado del reconocimiento
            Text(
              _status,
              style: TextStyle(
                color: _isListening ? Colors.green : Colors.grey[700],
                fontSize: 16,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Botón de reinicio
            if (_lastWords.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _lastWords = '';
                    _transcribedText = 'Presiona el micrófono y comienza a hablar';
                  });
                },
                child: const Text('Reiniciar'),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleListening,
        backgroundColor: _isListening ? Colors.red : Colors.blue,
        tooltip: 'Escuchar',
        child: Icon(
          _isListening ? Icons.stop : Icons.mic,
          size: 32,
        ),
      ),
    );
  }
}
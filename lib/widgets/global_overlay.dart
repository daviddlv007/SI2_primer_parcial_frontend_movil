import 'dart:async'; // Añade esta importación
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../services/voice_command_service.dart';
import '../providers/cart_provider.dart';
import '../routes.dart';

class GlobalOverlay extends StatefulWidget {
  const GlobalOverlay({super.key});

  @override
  State<GlobalOverlay> createState() => _GlobalOverlayState();
}

class _GlobalOverlayState extends State<GlobalOverlay> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final VoiceCommandService _voiceService = VoiceCommandService();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  Timer? _listeningTimer;

  bool _isListening = false;

  @override
  void dispose() {
    _listeningTimer?.cancel();
    _speech.stop();
    super.dispose();
  }

  void _startListening() async {
    if (await _speech.initialize(
      onStatus: (status) {
        print('Status: $status');
        if (status == 'done') {
          _stopListening();
        }
      },
      onError: (error) {
        print('Error: $error');
        _stopListening();
      },
    )) {
      setState(() {
        _isListening = true;
      });

      // Configurar timer para detener la escucha después de 5 segundos de inactividad
      _listeningTimer?.cancel();
      _listeningTimer = Timer(const Duration(seconds: 5), _stopListening);

      await _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            final words = result.recognizedWords;
            print("Texto reconocido: $words");

            // Reiniciar el timer cuando se detecta voz
            _listeningTimer?.cancel();
            _listeningTimer = Timer(const Duration(seconds: 2), _stopListening);

            _voiceService.processCommand(words, _navigatorKey.currentContext!)
                .then((_) => _stopListening());
          }
        },
        localeId: 'es_ES',
        listenFor: const Duration(seconds: 10),
        pauseFor: const Duration(seconds: 2),
        cancelOnError: true,
        partialResults: true,
        onSoundLevelChange: (level) {
          print('Nivel de sonido: $level');
          if (level > 0) {
            _listeningTimer?.cancel();
            _listeningTimer = Timer(const Duration(seconds: 2), _stopListening);
          }
        },
      );
    }
  }

  void _stopListening() async {
    _listeningTimer?.cancel();
    if (_isListening) {
      await _speech.stop();
      if (mounted) {
        setState(() {
          _isListening = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Navigator(
          key: _navigatorKey,
          initialRoute: '/',
          onGenerateRoute: (settings) {
            final builder = appRoutes[settings.name];
            if (builder != null) {
              return MaterialPageRoute(
                builder: (ctx) => builder(ctx),
                settings: settings,
              );
            }
            return null;
          },
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer<CartProvider>(
                  builder: (context, cart, _) => FloatingActionButton(
                    heroTag: 'cart',
                    backgroundColor: cart.selectedCartId != null ? Colors.green : Colors.grey,
                    onPressed: cart.selectedCartId != null
                        ? () => _navigatorKey.currentState?.pushNamed('/cart-detail')
                        : null,
                    child: const Icon(Icons.shopping_cart),
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  heroTag: 'mic',
                  backgroundColor: _isListening ? Colors.red : Colors.blue,
                  onPressed: _isListening ? _stopListening : _startListening,
                  child: _isListening
                      ? const Icon(Icons.mic_off)
                      : const Icon(Icons.mic),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
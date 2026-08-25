import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TranslationWebSocket {
  WebSocket? _socket;
  Future<void> connect({
    required String source,
    required String target,
    required Function(String) onTranslation,
  }) async {
    final apiUrl = dotenv.env["apiUrl"]!;
    _socket = await WebSocket.connect('ws://$apiUrl/translate/');
    _socket!.add(jsonEncode({
      'source': source,
      'target': target,
    }));
    _socket!.listen(
      (data) {
        onTranslation(data.toString());
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
      onDone: () {
        print('WebSocket disconnected');
      },
    );
  }
  void sendText(String text) {
    if (_socket != null &&
        _socket!.readyState == WebSocket.open) {
      _socket!.add(text);
    }
  }
  void disconnect() {
    _socket?.close();
    _socket = null;
  }
}
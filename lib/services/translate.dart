import 'dart:convert';
import 'dart:io';

class TranslationWebSocket {
  WebSocket? _socket;
  Future<void> connect({required String source,required String target}) async {
    _socket = await WebSocket.connect('ws://10.0.2.2:8000/translate/');

    _socket!.add(jsonEncode({
      'source': source,
      'target': target,
    }));
    // Continuously listen for translations
    _socket!.listen(
      (data) {
        print('Translated: $data');
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
    if (_socket != null) {
      _socket!.add(text);
    }
  }

  void disconnect() {
    _socket?.close();
    _socket = null;
  }
}
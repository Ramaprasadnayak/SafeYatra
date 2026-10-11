import 'package:flutter/foundation.dart';

class SosAnimationProvider extends ChangeNotifier {
  bool _playing = false;
  bool get playing => _playing;

  void start() {
    if (_playing) return;
    _playing = true;
    notifyListeners();
  }

  void finish() {
    if (!_playing) return;
    _playing = false;
    notifyListeners();
  }
}
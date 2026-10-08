import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeakTranslate extends StatefulWidget {
  final ValueChanged<String> onChange;
  final String? localeId;

  const SpeakTranslate({
    super.key,
    required this.onChange,
    this.localeId,
  });

  @override
  State<SpeakTranslate> createState() => _SpeakTranslateState();
}

class _SpeakTranslateState extends State<SpeakTranslate> {
  static const String _startSoundAsset = "audio/mic_start.mp3";

  final stt.SpeechToText _speech = stt.SpeechToText();
  final AudioPlayer _player = AudioPlayer();

  bool _initialized = false;
  bool _isListening = false;
  bool _isStarting = false;
  String _recognizedText = "";

  Future<bool> _ensureMicPermission() async {
    var status = await Permission.microphone.status;
    if (status.isGranted) return true;

    status = await Permission.microphone.request();
    if (status.isGranted) return true;

    if (status.isPermanentlyDenied || status.isRestricted) {
      _showMessage("Microphone permission is off. Opening settings...");
      await openAppSettings();
    } else {
      _showMessage("Microphone permission is required to speak.");
    }
    return false;
  }

  // ---------------------------------------------------------------------------
  // Speech init
  // ---------------------------------------------------------------------------

  Future<bool> _initSpeech() async {
    if (_initialized) return true;

    final ok = await _speech.initialize(
      onStatus: (status) {
        if (!mounted) return;
        setState(() => _isListening = status == "listening");
      },
      onError: (error) async {
        if (!mounted) return;
        setState(() => _isListening = false);

        if (error.errorMsg == "error_permission") {
          _initialized = false;
          await openAppSettings();
        } else {
          _showMessage(_friendlyError(error.errorMsg));
        }
      },
    );

    _initialized = ok;
    return ok;
  }

  @override
  void didUpdateWidget(covariant SpeakTranslate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.localeId != widget.localeId && _isListening) {
      _stopListening();
    }
  }

  String _norm(String id) => id.replaceAll('-', '_').toLowerCase();

  Future<String?> _resolveLocale(String localeId) async {
    final locales = await _speech.locales();
    final wanted = _norm(localeId);
    for (final l in locales) {
      if (_norm(l.localeId) == wanted) return l.localeId;
    }
    return null;
  }
  Future<void> _playStartSound() async {
    try {
      await _player.stop();
      final done = _player.onPlayerComplete.first;
      await _player.play(AssetSource(_startSoundAsset));
      await done.timeout(const Duration(seconds: 2));
    } catch (_) {
    }
  }

  Future<void> _startListening() async {
    if (_isStarting) return;
    setState(() => _isStarting = true);

    try {
      if (!await _ensureMicPermission()) return;
      if (!await _initSpeech()) {
        _showMessage(
          "Speech recognition unavailable. Make sure Google's speech "
          "service is installed.",
        );
        return;
      }
      String? resolvedLocale;
      if (widget.localeId != null) {
        resolvedLocale = await _resolveLocale(widget.localeId!);
        if (resolvedLocale == null) {
          _showMessage(
            "This language isn't available for speech recognition on your "
            "device. Install it in Settings → Google → Voice, or type instead.",
          );
          return;
        }
      }
      await _playStartSound();
      if (!mounted) return;

      setState(() {
        _isListening = true;
        _recognizedText = "";
      });
      widget.onChange("");

      await _speech.listen(
        localeId: resolvedLocale,
        listenFor: const Duration(seconds: 60),
        pauseFor: const Duration(seconds: 4),
        onResult: (result) {
          if (!mounted) return;
          setState(() => _recognizedText = result.recognizedWords);
          widget.onChange(result.recognizedWords);
        },
      );
    } finally {
      if (mounted) setState(() => _isStarting = false);
    }
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    if (!mounted) return;
    setState(() => _isListening = false);
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String _friendlyError(String code) {
    switch (code) {
      case "error_language_not_supported":
      case "error_language_unavailable":
        return "This language isn't installed for speech recognition.";
      case "error_no_match":
        return "Couldn't understand that. Please try again.";
      case "error_speech_timeout":
        return "No speech detected. Tap the mic and try again.";
      case "error_network":
      case "error_network_timeout":
        return "Network error. Check your internet connection.";
      case "error_audio":
        return "Microphone problem. Please try again.";
      default:
        return "Speech error: $code";
    }
  }

  @override
  void dispose() {
    _speech.cancel();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Speak in the selected language"),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: _isListening ? Colors.red : Colors.blue,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (_isListening ? Colors.red : Colors.lightBlue)
                        .withValues(alpha: 0.5),
                    blurRadius: _isListening ? 25 : 15,
                    spreadRadius: _isListening ? 6 : 3,
                  ),
                ],
              ),
              child: IconButton(
                iconSize: 36,
                onPressed: _isStarting
                    ? null
                    : (_isListening ? _stopListening : _startListening),
                icon: Icon(
                  _isListening ? Icons.stop : Icons.mic,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              _isListening && _recognizedText.isEmpty
                  ? "Listening..."
                  : _recognizedText.isEmpty
                      ? "Tap the mic and start speaking"
                      : _recognizedText,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
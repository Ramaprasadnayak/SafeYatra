import 'package:flutter/material.dart';
import 'package:safeyatra/features/translate/speak_translate.dart';
import 'package:safeyatra/features/translate/text_translate.dart';
import 'package:safeyatra/services/translate.dart';
import 'package:safeyatra/services/tts_service.dart';
import 'package:safeyatra/widgets/drop_down_button.dart';

class TranslatePage extends StatefulWidget {
  const TranslatePage({super.key});

  @override
  State<TranslatePage> createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  final TtsService tts = TtsService();
  final TranslationWebSocket translationSocket = TranslationWebSocket();
  String source = "", target = "", translation = "", mytext = "";
  @override
  void dispose() {
    translationSocket.disconnect();
    super.dispose();
  }

  Future<void> connectWebSocket() async {
    if (source.isEmpty || target.isEmpty) return;

    translationSocket.disconnect();

    await translationSocket.connect(
      source: source,
      target: target,
      onTranslation: (text) {
        if (!mounted) return;

        setState(() {
          translation = text;
        });
      },
    );
  }

  void onTextChange(String text) {
    setState(() {
      mytext = text;
    });

    if (source.isNotEmpty && target.isNotEmpty && text.isNotEmpty) {
      translationSocket.sendText(text);
    }
  }

  void onSourceChange(String value) {
    setState(() {
      source = value;
    });

    if (target.isNotEmpty) {
      connectWebSocket();
    }
  }

  void onTargetChange(String value) {
    setState(() {
      target = value;
    });

    if (source.isNotEmpty) {
      connectWebSocket();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyDropdownMenu(value: source, onChange: onSourceChange),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(Icons.swap_horiz, color: Colors.black87),
                    ),
                  ),
                ),
                MyDropdownMenu(value: target, onChange: onTargetChange),
              ],
            ),
            SizedBox(height: 5),
            SpeakTranslate(),
            SizedBox(height: 5),
            TextTranslate(text: mytext, onChange: onTextChange),
            SizedBox(height: 20),
            Icon(Icons.arrow_downward, color: Colors.grey),
            SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Translation"),
                        Row(
                          children: [
                            IconButton(
                              onPressed: translation.isEmpty
                                  ? null
                                  : () {
                                      tts.speak(translation, target);
                                    },
                              icon: const Icon(
                                Icons.volume_up,
                                color: Colors.grey,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.copy, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Text(
                      translation.isEmpty
                          ? "Translation will appear here"
                          : translation,
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

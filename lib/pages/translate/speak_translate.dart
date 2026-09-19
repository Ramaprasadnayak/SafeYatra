import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeakTranslate extends StatefulWidget {
  const SpeakTranslate({super.key});

  @override
  State<SpeakTranslate> createState() => _SpeakTranslateState();
}

class _SpeakTranslateState extends State<SpeakTranslate> {
  final stt.SpeechToText speechToText = stt.SpeechToText();

  bool isListening = false;
  String recognizedText = "";

  Future<void> startListening() async {
    bool available = await speechToText.initialize(
      onStatus: (status) {
        setState(() {
          isListening = status == "listening";
        });
      },
      onError: (error) {
        setState(() {
          isListening = false;
        });
      },
    );

    if (available) {
      setState(() {
        isListening = true;
        recognizedText = "";
      });

      await speechToText.listen(
        onResult: (result) {
          setState(() {
            recognizedText = result.recognizedWords;
          });
        },
      );
    }
  }

  Future<void> stopListening() async {
    await speechToText.stop();

    setState(() {
      isListening = false;
    });
  }

  @override
  void dispose() {
    speechToText.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Text("Speak in the selected language"),
              ],
            ),

            const SizedBox(height: 40),

            Container(
              decoration: BoxDecoration(
                color: isListening ? Colors.red : Colors.blue,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.lightBlue.withValues(alpha: 0.5),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {
                  if (isListening) {
                    stopListening();
                  } else {
                    startListening();
                  }
                },
                icon: Icon(
                  isListening ? Icons.stop : Icons.mic,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 40),

            Text(
              recognizedText.isEmpty
                  ? "Tap the mic and start speaking"
                  : recognizedText,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
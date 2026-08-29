import 'package:flutter/material.dart';
import 'package:safeyatra/features/translate/speak_translate.dart';
import 'package:safeyatra/features/translate/text_translate.dart';
import 'package:safeyatra/services/translate.dart';
import 'package:safeyatra/services/tts_service.dart';
import 'package:safeyatra/widgets/drop_down_button.dart';
import 'package:safeyatra/core/constants/language.dart';

class TranslatePage extends StatefulWidget {
  const TranslatePage({super.key});

  @override
  State<TranslatePage> createState() => _TranslatePageState();
}
class _TranslatePageState extends State<TranslatePage> {
  final TtsService tts = TtsService();

  String source = "auto";
  String target = "Kannada";
  String mytext = "";
  String? translation;

  void onTextChange(String text) {
    setState(() {
      mytext = text;
    });
  }

  void onSourceChange(String value) {
    setState(() {
      source = value;
    });
  }

  void onTargetChange(String value) {
    setState(() {
      target = value;
    });
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
                MyDropdownMenu(
                  value: source,
                  height: 500,
                  width: 200,
                  mylist: sourceLanguages,
                  onChange: onSourceChange,
                ),

                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.swap_horiz,
                      color: Colors.black87,
                    ),
                  ),
                ),

                MyDropdownMenu(
                  mylist: targetLanguages,
                  value: target,
                  height: 500,
                  width: 200,
                  onChange: onTargetChange,
                ),
              ],
            ),

            const SizedBox(height: 5),

            SpeakTranslate(),

            const SizedBox(height: 5),

            TextTranslate(
              text: mytext,
              onChange: onTextChange,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: mytext.trim().isEmpty
                  ? null
                  : () async {
                      final result = await translate(
                        context,
                        source,
                        target,
                        mytext,
                      );

                      if (!mounted) return;

                      setState(() {
                        translation = result;
                      });
                    },
              child: const Text("Translate"),
            ),

            const SizedBox(height: 20),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Translation"),

                        Row(
                          children: [
                            IconButton(
                              onPressed: translation == null
                                  ? null
                                  : () {
                                      tts.speak(
                                        translation!,
                                        target,
                                      );
                                    },
                              icon: const Icon(
                                Icons.volume_up,
                                color: Colors.grey,
                              ),
                            ),

                            IconButton(
                              onPressed: translation == null
                                  ? null
                                  : () {
                                      // Copy translation
                                    },
                              icon: const Icon(
                                Icons.copy,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    Text(
                      translation?.isNotEmpty == true
                          ? translation!
                          : "Translation will appear here",
                    ),

                    const SizedBox(height: 40),
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
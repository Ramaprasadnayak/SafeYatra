import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safeyatra/pages/translate/speak_translate.dart';
import 'package:safeyatra/pages/translate/text_translate.dart';
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
  bool isTranslating = false;
  static const Map<String, String> _locales = {
    "English": "en_IN",
    "Kannada": "kn_IN",
    "Hindi": "hi_IN",
    "Tamil": "ta_IN",
    "Telugu": "te_IN",
    "Malayalam": "ml_IN",
    "Marathi": "mr_IN",
    "Bengali": "bn_IN",
    "Gujarati": "gu_IN",
    "Punjabi": "pa_IN",
    "Urdu": "ur_IN",
    "French": "fr_FR",
    "German": "de_DE",
    "Spanish": "es_ES",
  };

  String? get _speechLocale => _locales[source];

  void onTextChange(String text) {
    setState(() => mytext = text);
  }

  void onSourceChange(String value) {
    setState(() => source = value);
  }

  void onTargetChange(String value) {
    setState(() => target = value);
  }

  bool get _canSwap =>
      source != "auto" &&
      targetLanguages.contains(source) &&
      sourceLanguages.contains(target);

  void _swapLanguages() {
    if (!_canSwap) {
      _showMessage("Choose a specific source language to swap.");
      return;
    }
    setState(() {
      final oldSource = source;
      source = target;
      target = oldSource;

      // Move the translation into the input so the user can flip directions.
      if (translation != null && translation!.isNotEmpty) {
        mytext = translation!;
        translation = null;
      }
    });
  }

  Future<void> _translate() async {
    FocusScope.of(context).unfocus();
    setState(() => isTranslating = true);

    try {
      final result = await translate(context, source, target, mytext);
      if (!mounted) return;
      setState(() => translation = result);
    } catch (e) {
      if (!mounted) return;
      _showMessage("Translation failed. Please try again.");
    } finally {
      if (mounted) setState(() => isTranslating = false);
    }
  }

  Future<void> _copyTranslation() async {
    if (translation == null) return;
    await Clipboard.setData(ClipboardData(text: translation!));
    _showMessage("Copied to clipboard");
  }

  void _speakTranslation() {
    if (translation == null) return;
    tts.speak(translation!, target);
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final hasTranslation = translation?.isNotEmpty == true;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Language selectors
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyDropdownMenu(
                  value: source,
                  height: 500,
                  width: 150,
                  mylist: sourceLanguages,
                  onChange: onSourceChange,
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: _swapLanguages,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.swap_horiz,
                        color: _canSwap ? Colors.black87 : Colors.black26,
                      ),
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

            // Voice input (uses the selected source language)
            SpeakTranslate(
              localeId: _speechLocale,
              onChange: onTextChange,
            ),

            const SizedBox(height: 5),

            // Text input (shows typed + spoken text)
            TextTranslate(
              text: mytext,
              onChange: onTextChange,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed:
                  (mytext.trim().isEmpty || isTranslating) ? null : _translate,
              child: isTranslating
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Translate"),
            ),

            const SizedBox(height: 20),

            // Result
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Translation"),
                          Row(
                            children: [
                              IconButton(
                                onPressed:
                                    hasTranslation ? _speakTranslation : null,
                                icon: const Icon(Icons.volume_up),
                                color: Colors.grey,
                              ),
                              IconButton(
                                onPressed:
                                    hasTranslation ? _copyTranslation : null,
                                icon: const Icon(Icons.copy),
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      SelectableText(
                        hasTranslation
                            ? translation!
                            : "Translation will appear here",
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
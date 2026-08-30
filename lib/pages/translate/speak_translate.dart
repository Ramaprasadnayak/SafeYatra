import 'package:flutter/material.dart';

class SpeakTranslate extends StatefulWidget {
  const SpeakTranslate({super.key});

  @override
  State<SpeakTranslate> createState() => _SpeakTranslateState();
}

class _SpeakTranslateState extends State<SpeakTranslate> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text("Speak in the selected language"),
                
              ],
            ),
            SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.lightBlue.withValues(),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.mic, color: Colors.white),
              ),
            ),
            SizedBox(height: 40),
            Text("Tap the mic and start speaking"),
          ],
        ),
      ),
    );
  }
}

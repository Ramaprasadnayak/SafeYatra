import 'package:flutter/material.dart';
class Greetings extends StatefulWidget {
  final String? username;
  const Greetings({
    super.key,
    required this.username
  });

  @override
  State<Greetings> createState() => _GreetingsState();
}

class _GreetingsState extends State<Greetings> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Card(
          shape: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text("👋"),
          ),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello ${widget.username}!",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Stay aware, stay safe.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:Theme.of(context).brightness == Brightness.light
                              ? Colors.black87
                              : Colors.white60,
                fontSize: 19,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

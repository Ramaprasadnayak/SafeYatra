import 'package:flutter/material.dart';

class Greetings extends StatefulWidget {
  final String? username;
  const Greetings({
    super.key,
    required this.username,
  });
  @override
  State<Greetings> createState() => _GreetingsState();
}

class _GreetingsState extends State<Greetings> {
  String? _username;
  @override
  void initState() {
    super.initState();
    _username = widget.username;
  }
  @override
  void didUpdateWidget(covariant Greetings oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.username != widget.username) {
      setState(() {
        _username = widget.username;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = (_username?.trim().isNotEmpty ?? false)
        ? _username!.trim()
        : 'Dear Explorer';
    return Row(
      children: [
        Card(
          shape: const CircleBorder(),
          child: const Padding(
            padding: EdgeInsets.all(15),
            child: Text('👋'),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello $name!',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Stay aware, stay safe.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.brightness == Brightness.light
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
import 'package:flutter/material.dart';
// import 'package:safeyatra/providers/theme_provider.dart';
// import 'package:provider/provider.dart';

class MyCard extends StatelessWidget {
  final IconData prefixIcon;
  final String text;
  final VoidCallback onPress;

  const MyCard({
    super.key,
    required this.prefixIcon,
    required this.text,
    required this.onPress,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onPress,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
            child: Row(
              children: [
                Icon(prefixIcon, size: 30,),
                const SizedBox(width: 16),
                Expanded(child: Text(text)),
                Icon(Icons.arrow_forward_ios)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
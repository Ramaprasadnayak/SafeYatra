import 'package:flutter/material.dart';

class SuggestionTile extends StatelessWidget {
  final String suggestion;
  final String query;
  final VoidCallback onTap;
  final VoidCallback onFill;

  const SuggestionTile({
    super.key,
    required this.suggestion,
    required this.query,
    required this.onTap,
    required this.onFill,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = DefaultTextStyle.of(context).style.copyWith(
          fontSize: 16,
          color: Theme.of(context).colorScheme.onSurface,
        );

    // Typed part = normal, the rest = bold (like the screenshot)
    final start = suggestion.toLowerCase().indexOf(query.trim().toLowerCase());
    final end = start + query.trim().length;

    final TextSpan text = start < 0
        ? TextSpan(
            text: suggestion,
            style: baseStyle.copyWith(fontWeight: FontWeight.bold))
        : TextSpan(
            style: baseStyle,
            children: [
              TextSpan(text: suggestion.substring(0, start),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: suggestion.substring(start, end)),
              TextSpan(text: suggestion.substring(end),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          );

    return ListTile(
      leading: const Icon(Icons.search),
      title: RichText(text: text),
      trailing: IconButton(
        icon: const Icon(Icons.north_west, size: 20),
        tooltip: 'Use this suggestion',
        onPressed: onFill,
      ),
      onTap: onTap,
    );
  }
}

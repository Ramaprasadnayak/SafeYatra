import 'package:flutter/material.dart';

class SuggestionTile extends StatelessWidget {
  final String suggestion;
  final String query;
  final bool highlighted;
  final VoidCallback onTap;

  const SuggestionTile({
    super.key,
    required this.suggestion,
    required this.query,
    required this.highlighted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final style = TextStyle(fontSize: 16, color: scheme.onSurface);
    const bold = TextStyle(fontWeight: FontWeight.bold);

    final q = query.trim();
    final start = q.isEmpty ? -1 : suggestion.toLowerCase().indexOf(q.toLowerCase());

    final TextSpan text = start < 0
        ? TextSpan(text: suggestion, style: style.merge(bold))
        : TextSpan(
            style: style,
            children: [
              TextSpan(text: suggestion.substring(0, start), style: bold),
              TextSpan(text: suggestion.substring(start, start + q.length)),
              TextSpan(text: suggestion.substring(start + q.length), style: bold),
            ],
          );

    return InkWell(
      onTap: onTap,
      child: Container(
        color: highlighted ? scheme.onSurface.withValues(alpha: 0.08) : null,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(Icons.search, size: 20, color: scheme.onSurface),
            const SizedBox(width: 12),
            Expanded(child: RichText(text: text, overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
    );
  }
}

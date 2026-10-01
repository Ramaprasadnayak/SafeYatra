import 'package:safeyatra/core/constants/districts.dart';

List<String> getDistrictSuggestions(String query, {int limit = 8}) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return [];

  final startsWith = <String>[];
  final contains = <String>[];

  for (final d in districts) {
    final lower = d.toLowerCase();
    if (lower.startsWith(q)) {
      startsWith.add(d);
    } else if (lower.contains(q)) {
      contains.add(d);
    }
  }
  return [...startsWith, ...contains].take(limit).toList();
}

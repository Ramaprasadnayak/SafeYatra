// lib/widgets/district_search_bar.dart
import 'package:flutter/material.dart';
import 'package:safeyatra/pages/safemaps/search_utils.dart';
import 'suggestion_tile.dart';

class DistrictSearchBar extends StatefulWidget {
  final void Function(String value) onSelected;
  const DistrictSearchBar({super.key, required this.onSelected});
  @override
  State<DistrictSearchBar> createState() => _DistrictSearchBarState();
}

class _DistrictSearchBarState extends State<DistrictSearchBar> {
  final SearchController _controller = SearchController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return SearchAnchor.bar(
      searchController: _controller,
      barHintText: 'Search city or district',
      barShape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      ),
      barSide: const WidgetStatePropertyAll(
        BorderSide(color: Colors.blue, width: 2),
      ),
      barBackgroundColor:
          WidgetStatePropertyAll(isLight ? Colors.white : Colors.black45),
      viewBackgroundColor: isLight ? Colors.white : const Color(0xFF2B2F31),
      viewShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      onSubmitted: (value) {
        _controller.closeView(value);
        widget.onSelected(value);
      },
      suggestionsBuilder: (context, controller) {
        final query = controller.text;
        final results = getDistrictSuggestions(query);

        return results.map(
          (d) => SuggestionTile(
            suggestion: d,
            query: query,
            onTap: () {
              controller.closeView(d); 
              widget.onSelected(d);
            },
            onFill: () {
              controller.text = d;
              controller.selection = TextSelection.collapsed(offset: d.length);
            },
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:safeyatra/pages/safemaps/search_utils.dart';
import 'suggestion_tile.dart';

class DistrictSearchBar extends StatefulWidget {
  final void Function(String value) onSelected;

  const DistrictSearchBar({
    super.key,
    required this.onSelected,
  });

  @override
  State<DistrictSearchBar> createState() => _DistrictSearchBarState();
}

class _DistrictSearchBarState extends State<DistrictSearchBar> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final isLight =
        Theme.of(context).brightness == Brightness.light;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        return RawAutocomplete<String>(
          optionsBuilder: (TextEditingValue value) {
            _query = value.text;

            return getDistrictSuggestions(value.text);
          },
          onSelected: (String selection) {
            widget.onSelected(selection);
          },
          fieldViewBuilder: (
            context,
            controller,
            focusNode,
            onFieldSubmitted,
          ) {
            return SearchBar(
              controller: controller,
              focusNode: focusNode,

              hintText: 'Search city or district',

              shape: const WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
              ),

              side: const WidgetStatePropertyAll(
                BorderSide(
                  color: Colors.blue,
                  width: 2,
                ),
              ),

              backgroundColor: WidgetStatePropertyAll(
                isLight
                    ? Colors.white
                    : Colors.black45,
              ),
              onChanged: (value) {
                setState(() {
                  _query = value;
                });
              },
              trailing: [
                if (controller.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: 'Clear',
                    onPressed: () {
                      controller.clear();

                      setState(() {
                        _query = '';
                      });

                      focusNode.requestFocus();
                    },
                  ),
              ],

              onSubmitted: (value) {
                focusNode.unfocus();
                widget.onSelected(value);
              },
            );
          },
          optionsViewBuilder: (
            context,
            onOptionSelected,
            options,
          ) {
            final list = options.toList();

            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,

                color: isLight
                    ? Colors.white
                    : const Color(0xFF2B2F31),

                borderRadius: BorderRadius.circular(8),

                clipBehavior: Clip.antiAlias,

                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: width,
                    maxHeight: 360,
                  ),

                  child: SizedBox(
                    width: width,

                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: list.length,

                      itemBuilder: (context, index) {
                        final option = list[index];

                        final highlighted =
                            AutocompleteHighlightedOption.of(
                                  context,
                                ) ==
                                index;

                        return SuggestionTile(
                          suggestion: option,
                          query: _query,
                          highlighted: highlighted,

                          onTap: () {
                            FocusScope.of(context).unfocus();

                            onOptionSelected(option);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
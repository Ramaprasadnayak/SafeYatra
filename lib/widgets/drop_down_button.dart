import 'package:flutter/material.dart';

class MyDropdownMenu extends StatefulWidget {
  final String value;
  final Function(String) onChange;
  final List<String> languages;

  const MyDropdownMenu({
    super.key,
    required this.value,
    required this.onChange,
    required this.languages,
  });

  @override
  State<MyDropdownMenu> createState() => _MyDropdownMenuState();
}

typedef MenuEntry = DropdownMenuEntry<String>;

class _MyDropdownMenuState extends State<MyDropdownMenu> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    final List<MenuEntry> menuEntries = widget.languages
        .map<MenuEntry>(
          (String name) => MenuEntry(
            value: name,
            label: name,
          ),
        )
        .toList();

    return DropdownMenu<String>(
      initialSelection: dropdownValue,
      dropdownMenuEntries: menuEntries,
      onSelected: (String? value) {
        if (value == null) return;

        setState(() {
          dropdownValue = value;
        });

        widget.onChange(value);
      },
    );
  }
}
import 'dart:collection';
import 'package:safeyatra/core/constants/language.dart';
import 'package:flutter/material.dart';

class MyDropdownMenu extends StatefulWidget {
  final String value;
  final Function(String) onChange;

  const MyDropdownMenu({
    super.key,
    required this.value,
    required this.onChange,
  });
   @override
  State<MyDropdownMenu> createState() => _MyDropdownMenuState();
}
typedef MenuEntry = DropdownMenuEntry<String>;
class _MyDropdownMenuState extends State<MyDropdownMenu> {
  static final List<MenuEntry> menuEntries =
      UnmodifiableListView<MenuEntry>(
    languages.map<MenuEntry>(
      (String name) => MenuEntry(
        value: name,
        label: name,
      ),
    ),
  );
  late String dropdownValue;
  @override
  void initState() {
    super.initState();
    dropdownValue = widget.value;
  }
  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: dropdownValue,
      onSelected: (String? value) {
        if (value != null) {
          setState(() {
            dropdownValue = value;
          });
          widget.onChange(value);
        }
      },
      dropdownMenuEntries: menuEntries,
    );
  }
}
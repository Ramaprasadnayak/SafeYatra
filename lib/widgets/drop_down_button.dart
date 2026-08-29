import 'package:flutter/material.dart';

class MyDropdownMenu extends StatefulWidget {
  final String value;
  final Function(String) onChange;
  final List<String> mylist;
  final double height,width;

  const MyDropdownMenu({
    super.key,
    required this.value,
    required this.onChange,
    required this.mylist,
    required this.height,
    required this.width
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
    final List<MenuEntry> menuEntries = widget.mylist
        .map<MenuEntry>((String name) => MenuEntry(value: name, label: name))
        .toList();

    return DropdownMenu<String>(
      width: widget.width,
      menuHeight: widget.height,
      initialSelection: dropdownValue,
      dropdownMenuEntries: menuEntries,

      inputDecorationTheme: const InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        isDense: true,
      ),

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

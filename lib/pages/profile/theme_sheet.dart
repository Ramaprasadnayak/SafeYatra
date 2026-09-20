import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safeyatra/providers/theme_provider.dart'; // adjust path

void showThemeSheet(BuildContext context) {
  final provider = context.read<ThemeProvider>();
  final current = provider.themeMode;

  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      Widget tile(IconData icon, String label, ThemeMode mode) {
        return ListTile(
          leading: Icon(icon),
          title: Text(label),
          trailing: current == mode ? const Icon(Icons.check_rounded) : null,
          onTap: () {
            provider.setTheme(mode);
            Navigator.pop(sheetContext);
          },
        );
      }

      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose theme',
              style: Theme.of(sheetContext).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            tile(Icons.light_mode_rounded, 'Light', ThemeMode.light),
            tile(Icons.dark_mode_rounded, 'Dark', ThemeMode.dark),
            const SizedBox(height: 12),
          ],
        ),
      );
    },
  );
}

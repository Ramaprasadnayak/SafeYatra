import 'package:flutter/material.dart';
import 'package:safeyatra/themes/app_colors.dart';

import 'package:safeyatra/pages/sos/sos_page.dart' show SosColors;

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  extensions: const [SosColors.light],
  // Background
  scaffoldBackgroundColor: AppColors.lightBackground,

  // AppBar
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.lightCardBackground,
    foregroundColor: AppColors.lightThemeText,
  ),
  dropdownMenuTheme: DropdownMenuThemeData(
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightCardBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.darkSecondaryIcon, width: 1),
      ),
    ),
    menuStyle: MenuStyle(
      backgroundColor: WidgetStatePropertyAll(AppColors.white),
    ),
  ),
  // Card
  cardTheme: CardThemeData(
    color: AppColors.lightCardBackground,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),

  // Icons
  iconTheme: const IconThemeData(
    color: AppColors.primary,
  ),

  // Outlined Button
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: const WidgetStatePropertyAll(
        AppColors.primary,
      ),
      side: const WidgetStatePropertyAll(
        BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
      ),
    ),
  ),

  // TextField / Input
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.lightInputBackground,

    hintStyle: const TextStyle(
      color: AppColors.lightHintText,
    ),

    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.lightInputBorder,
        width: 1,
      ),
    ),

    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.primary,
        width: 1,
      ),
    ),

    prefixIconColor: AppColors.lightHintText,
    suffixIconColor: AppColors.lightSecondaryIcon,
  ),

  // Text
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      color: AppColors.lightThemeText,
    ),
  ),

  // Bottom Navigation
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.lightCardBackground,

    selectedIconTheme: IconThemeData(
      color: AppColors.primary,
    ),

    unselectedIconTheme: IconThemeData(
      color: AppColors.lightThemeText,
    ),

    unselectedItemColor: AppColors.lightThemeText,
  ),
);
import 'package:flutter/material.dart';
import 'package:safeyatra/themes/app_colors.dart';
import 'package:safeyatra/pages/sos/sos_page.dart' show SosColors;

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  // Background
  scaffoldBackgroundColor: AppColors.darkBackground,
  extensions: const [SosColors.dark],
  // AppBar
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.darkBackground,
    foregroundColor: AppColors.darkThemeText,
  ),
  dropdownMenuTheme: DropdownMenuThemeData(
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkCardBackground,
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
        borderSide: BorderSide(color: AppColors.darkThemeText, width: 1),
      ),
    ),
    menuStyle: MenuStyle(
      backgroundColor: WidgetStatePropertyAll(AppColors.darkCardBackground),
    ),
  ),
  // Card
  cardTheme: CardThemeData(
    color: AppColors.darkCardBackground,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),

  // Icons
  iconTheme: const IconThemeData(color: AppColors.primaryLight),

  // Outlined Button
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: const WidgetStatePropertyAll(AppColors.primaryLight),
      side: const WidgetStatePropertyAll(
        BorderSide(color: AppColors.primaryLight, width: 2),
      ),
    ),
  ),

  // TextField / Input
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.darkInputBackground,

    hintStyle: const TextStyle(color: AppColors.darkHintText),

    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.darkInputBorder, width: 1),
    ),

    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.primaryLight, width: 1),
    ),

    prefixIconColor: AppColors.darkHintText,
    suffixIconColor: AppColors.darkSecondaryIcon,
  ),

  // Text
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: AppColors.darkThemeText),
  ),

  // Bottom Navigation
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.darkNavbar,

    selectedIconTheme: IconThemeData(color: AppColors.navbarIcon),

    selectedItemColor: AppColors.navbarIcon,

    selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),

    unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),

    unselectedIconTheme: IconThemeData(color: AppColors.darkThemeText),

    unselectedItemColor: AppColors.darkThemeText,
  ),
);

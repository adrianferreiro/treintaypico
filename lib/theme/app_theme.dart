import 'package:flutter/material.dart';

final Color primaryColor = const Color(0xFF0A4D68);

ThemeData getLightTheme() {
  final colorScheme = ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: primaryColor,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    primaryColor: colorScheme.primary,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
    textTheme: const TextTheme(
      bodySmall: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black54),
      bodyLarge: TextStyle(color: Colors.black54),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: primaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: primaryColor),
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryColor, // Button background color
      textTheme: ButtonTextTheme.primary,
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        elevation: const WidgetStatePropertyAll(5),
        backgroundColor: WidgetStatePropertyAll(Colors.grey[100]),
        alignment: AlignmentDirectional.bottomStart.add(
          const AlignmentDirectional(0, 0.2),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primaryColor),
        ),
      ),
    ),
  );
}

ThemeData getDarkTheme() {
  final colorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: primaryColor,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: const Color(0xFF1E1E1E),
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Color(0xFFFFFFFF),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        iconColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
    textTheme: const TextTheme(
      bodySmall: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      bodyLarge: TextStyle(color: Colors.white70),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[800],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: primaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: primaryColor.withValues(alpha: 0.7)),
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryColor, // Button background color
      textTheme: ButtonTextTheme.primary,
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        elevation: const WidgetStatePropertyAll(5),
        backgroundColor: const WidgetStatePropertyAll(Colors.black),
        alignment: AlignmentDirectional.bottomStart.add(
          const AlignmentDirectional(0, 0.2),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF494949),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primaryColor),
        ),
      ),
    ),
  );
}

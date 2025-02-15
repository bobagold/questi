import 'package:flutter/material.dart';

ThemeData customLightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.orange,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Colors.orange.shade50,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.orange.shade700,
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.brown.shade900,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: Colors.brown.shade800,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: Colors.brown.shade700,
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.normal,
        color: Colors.brown.shade900,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Colors.brown.shade800,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Colors.brown.shade700,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.orange.shade900,
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.orange.shade800,
      ),
      titleSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.orange.shade700,
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.orange.shade100,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.orange.shade700,
        side: BorderSide(color: Colors.orange.shade700),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.orange.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.orange.shade700),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.deepOrange.shade500, width: 2),
      ),
    ),
    listTileTheme: ListTileThemeData(
      tileColor: Colors.orange.shade50,
      textColor: Colors.brown.shade900,
      iconColor: Colors.deepOrange.shade500,
    ),
    iconTheme: IconThemeData(
      color: Colors.deepOrange.shade500,
    ),
    dividerTheme: DividerThemeData(
      color: Colors.brown.shade300,
      thickness: 1,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.orange.shade100,
      selectedItemColor: Colors.orange.shade900,
      unselectedItemColor: Colors.brown.shade700,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.orange.shade700),
      trackColor: WidgetStateProperty.all(Colors.orange.shade200),
    ),
  );
}

import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white, // Background color
      indicatorColor: Colors.transparent, // Highlight for selected item
      labelTextStyle:
          WidgetStateProperty.resolveWith<TextStyle>((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(color: Colors.blue, fontWeight: FontWeight.bold);
        }
        return TextStyle(color: Colors.grey);
      }),
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: Colors.blue, size: 30); // Selected icon
          }
          return IconThemeData(color: Colors.grey, size: 24); // Unselected icon
        },
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black45,
      ),
      iconTheme:
          IconThemeData(color: Colors.black45), // Ensures icons match the theme
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.black),
      bodySmall: TextStyle(fontSize: 12, color: Colors.black),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      labelMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.black87,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white, // Background color
      indicatorColor: Colors.transparent, // Highlight for selected item
      labelTextStyle:
          WidgetStateProperty.resolveWith<TextStyle>((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(color: Colors.blue, fontWeight: FontWeight.bold);
        }
        return TextStyle(color: Colors.grey);
      }),
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: Colors.blue, size: 30); // Selected icon
          }
          return IconThemeData(color: Colors.grey, size: 24); // Unselected icon
        },
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.black),
      bodySmall: TextStyle(fontSize: 12, color: Colors.black),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      labelMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    ),
  );
}

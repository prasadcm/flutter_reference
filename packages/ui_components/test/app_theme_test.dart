import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  group('AppThemes Light Theme Tests', () {
    late ThemeData lightTheme;

    setUp(() {
      lightTheme = AppThemes.lightTheme;
    });

    test('basic theme properties', () {
      expect(lightTheme.brightness, equals(Brightness.light));
      expect(lightTheme.primaryColor, equals(Colors.blue));
      expect(lightTheme.scaffoldBackgroundColor, equals(Colors.white));
    });

    group('AppBar Theme', () {
      test('has correct properties', () {
        final appBarTheme = lightTheme.appBarTheme;
        expect(appBarTheme.backgroundColor, equals(Colors.white));
        expect(appBarTheme.centerTitle, isTrue);
        expect(appBarTheme.titleTextStyle?.fontSize, equals(20));
        expect(appBarTheme.titleTextStyle?.fontWeight, equals(FontWeight.bold));
        expect(appBarTheme.titleTextStyle?.color, equals(Colors.black45));
        expect(appBarTheme.iconTheme?.color, equals(Colors.black45));
      });
    });

    group('Navigation Bar Theme', () {
      test('has correct basic properties', () {
        final navBarTheme = lightTheme.navigationBarTheme;
        expect(navBarTheme.backgroundColor, equals(Colors.white));
        expect(navBarTheme.indicatorColor, equals(Colors.transparent));
      });

      test('selected label style is correct', () {
        final labelStyle = lightTheme.navigationBarTheme.labelTextStyle;
        final selectedStyle = labelStyle?.resolve({WidgetState.selected});

        expect(selectedStyle?.color, equals(Colors.blue));
        expect(selectedStyle?.fontWeight, equals(FontWeight.bold));
      });

      test('unselected label style is correct', () {
        final labelStyle = lightTheme.navigationBarTheme.labelTextStyle;
        final unselectedStyle = labelStyle?.resolve({});

        expect(unselectedStyle?.color, equals(Colors.grey));
      });

      test('selected icon theme is correct', () {
        final iconTheme = lightTheme.navigationBarTheme.iconTheme;
        final selectedIconTheme = iconTheme?.resolve({WidgetState.selected});

        expect(selectedIconTheme?.color, equals(Colors.blue));
        expect(selectedIconTheme?.size, equals(30));
      });

      test('unselected icon theme is correct', () {
        final iconTheme = lightTheme.navigationBarTheme.iconTheme;
        final unselectedIconTheme = iconTheme?.resolve({});

        expect(unselectedIconTheme?.color, equals(Colors.grey));
        expect(unselectedIconTheme?.size, equals(24));
      });
    });

    group('Text Theme', () {
      test('body text styles are correct', () {
        expect(lightTheme.textTheme.bodyLarge?.fontSize, equals(16));
        expect(lightTheme.textTheme.bodyLarge?.color, equals(Colors.black));

        expect(lightTheme.textTheme.bodyMedium?.fontSize, equals(14));
        expect(lightTheme.textTheme.bodyMedium?.color, equals(Colors.black));

        expect(lightTheme.textTheme.bodySmall?.fontSize, equals(12));
        expect(lightTheme.textTheme.bodySmall?.color, equals(Colors.black));
      });

      test('label text styles are correct', () {
        expect(lightTheme.textTheme.labelLarge?.fontSize, equals(16));
        expect(
          lightTheme.textTheme.labelLarge?.fontWeight,
          equals(FontWeight.bold),
        );
        expect(lightTheme.textTheme.labelLarge?.color, equals(Colors.black));

        expect(lightTheme.textTheme.labelMedium?.fontSize, equals(14));
        expect(
          lightTheme.textTheme.labelMedium?.fontWeight,
          equals(FontWeight.bold),
        );

        expect(lightTheme.textTheme.labelSmall?.fontSize, equals(12));
        expect(
          lightTheme.textTheme.labelSmall?.fontWeight,
          equals(FontWeight.bold),
        );
      });

      test('title text styles are correct', () {
        expect(lightTheme.textTheme.titleLarge?.fontSize, equals(18));
        expect(
          lightTheme.textTheme.titleLarge?.fontWeight,
          equals(FontWeight.bold),
        );
        expect(lightTheme.textTheme.titleLarge?.color, equals(Colors.blue));

        expect(lightTheme.textTheme.titleMedium?.fontSize, equals(16));
        expect(lightTheme.textTheme.titleMedium?.color, equals(Colors.blue));

        expect(lightTheme.textTheme.titleSmall?.fontSize, equals(14));
        expect(lightTheme.textTheme.titleSmall?.color, equals(Colors.blue));
      });
    });
  });

  group('AppThemes Dark Theme Tests', () {
    late ThemeData darkTheme;

    setUp(() {
      darkTheme = AppThemes.darkTheme;
    });

    test('basic theme properties', () {
      expect(darkTheme.brightness, equals(Brightness.dark));
      expect(darkTheme.primaryColor, equals(Colors.black));
      expect(darkTheme.scaffoldBackgroundColor, equals(Colors.black87));
    });

    group('AppBar Theme', () {
      test('has correct properties', () {
        final appBarTheme = darkTheme.appBarTheme;
        expect(appBarTheme.backgroundColor, equals(Colors.black));
        expect(appBarTheme.centerTitle, isTrue);
        expect(appBarTheme.titleTextStyle?.fontSize, equals(20));
        expect(appBarTheme.titleTextStyle?.fontWeight, equals(FontWeight.bold));
        expect(appBarTheme.titleTextStyle?.color, equals(Colors.white));
        expect(appBarTheme.iconTheme?.color, equals(Colors.white));
      });
    });

    // Add similar navigation bar and text theme tests for dark theme
  });
}

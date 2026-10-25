import 'package:flutter/material.dart';

import 'screens/event_home_screen.dart';
import 'theme/app_palette.dart';

void main() => runApp(const CampusEventApp());

class CampusEventApp extends StatelessWidget {
  const CampusEventApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Event Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Manrope',
        colorScheme: const ColorScheme.light(
          primary: AppPalette.forest,
          onPrimary: Colors.white,
          primaryContainer: AppPalette.sage,
          secondary: AppPalette.accent,
          onSecondary: AppPalette.ink,
          surface: AppPalette.surface,
          onSurface: AppPalette.ink,
          outline: AppPalette.border,
        ),
        scaffoldBackgroundColor: AppPalette.canvas,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppPalette.canvas,
          foregroundColor: AppPalette.ink,
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppPalette.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 17,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: AppPalette.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: AppPalette.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: AppPalette.forest, width: 1.5),
          ),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: AppPalette.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppPalette.forest,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
      home: const EventHomeScreen(),
    );
  }
}

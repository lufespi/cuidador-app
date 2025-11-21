import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Configuração do tema Light Mode
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Esquema de cores
      colorScheme: ColorScheme.light(
        primary: AppColorsLight.buttonPrimary,
        onPrimary: AppColorsLight.buttonText,
        secondary: AppColorsLight.buttonSecondary,
        onSecondary: AppColorsLight.textWhite,
        surface: AppColorsLight.surface,
        onSurface: AppColorsLight.textPrimary,
        error: AppColorsLight.stateError,
        onError: AppColorsLight.textWhite,
      ),
      
      // Cor de fundo padrão
      scaffoldBackgroundColor: AppColorsLight.background,
      
      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColorsLight.buttonPrimary,
        foregroundColor: AppColorsLight.textWhite,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: AppColorsLight.textWhite,
        ),
      ),
      
      // Cards
      cardColor: AppColorsLight.surface,
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColorsLight.inputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColorsLight.border,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColorsLight.border,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColorsLight.buttonPrimary,
            width: 2,
          ),
        ),
      ),
      
      // Botões
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorsLight.buttonPrimary,
          foregroundColor: AppColorsLight.buttonText,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      
      // SnackBar
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColorsLight.stateSuccess,
        contentTextStyle: TextStyle(color: AppColorsLight.textWhite),
      ),
    );
  }

  /// Configuração do tema Dark Mode
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Esquema de cores
      colorScheme: ColorScheme.dark(
        primary: AppColorsDark.buttonPrimary,
        onPrimary: AppColorsDark.buttonText,
        secondary: AppColorsDark.buttonSecondary,
        onSecondary: AppColorsDark.textWhite,
        surface: AppColorsDark.surface,
        onSurface: AppColorsDark.textPrimary,
        error: AppColorsDark.stateError,
        onError: AppColorsDark.textWhite,
      ),
      
      // Cor de fundo padrão
      scaffoldBackgroundColor: AppColorsDark.background,
      
      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColorsDark.buttonPrimary,
        foregroundColor: AppColorsDark.textWhite,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: AppColorsDark.textWhite,
        ),
      ),
      
      // Cards
      cardColor: AppColorsDark.surface,
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColorsDark.inputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColorsDark.border,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColorsDark.border,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColorsDark.buttonPrimary,
            width: 2,
          ),
        ),
      ),
      
      // Botões
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorsDark.buttonPrimary,
          foregroundColor: AppColorsDark.buttonText,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      
      // SnackBar
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColorsDark.stateSuccess,
        contentTextStyle: TextStyle(color: AppColorsDark.textWhite),
      ),
    );
  }
}

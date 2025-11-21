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

  /// Configuração do tema High Contrast Mode (Alto Contraste)
  static ThemeData get highContrastTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Esquema de cores
      colorScheme: const ColorScheme.dark(
        primary: AppColorsHighContrast.buttonPrimary,
        onPrimary: AppColorsHighContrast.buttonText,
        secondary: AppColorsHighContrast.buttonSecondary,
        onSecondary: AppColorsHighContrast.buttonText,
        surface: AppColorsHighContrast.surface,
        onSurface: AppColorsHighContrast.textPrimary,
        error: AppColorsHighContrast.stateError,
        onError: AppColorsHighContrast.textWhite,
        outline: AppColorsHighContrast.border,
      ),
      
      // Cor de fundo padrão
      scaffoldBackgroundColor: AppColorsHighContrast.background,
      
      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColorsHighContrast.background,
        foregroundColor: AppColorsHighContrast.textPrimary,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: AppColorsHighContrast.buttonPrimary,
        ),
      ),
      
      // Cards
      cardColor: AppColorsHighContrast.surface,
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColorsHighContrast.inputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColorsHighContrast.border,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColorsHighContrast.border,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColorsHighContrast.buttonPrimary,
            width: 3,
          ),
        ),
        labelStyle: const TextStyle(
          color: AppColorsHighContrast.textPrimary,
        ),
        hintStyle: const TextStyle(
          color: AppColorsHighContrast.textDisabled,
        ),
      ),
      
      // Botões
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorsHighContrast.buttonPrimary,
          foregroundColor: AppColorsHighContrast.buttonText,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(
              color: AppColorsHighContrast.buttonPrimary,
              width: 2,
            ),
          ),
        ),
      ),
      
      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColorsHighContrast.textSecondary,
        ),
      ),
      
      // SnackBar
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColorsHighContrast.stateSuccess,
        contentTextStyle: TextStyle(
          color: AppColorsHighContrast.buttonText,
          fontWeight: FontWeight.bold,
        ),
      ),
      
      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColorsHighContrast.border,
        thickness: 2,
      ),
      
      // Icon
      iconTheme: const IconThemeData(
        color: AppColorsHighContrast.buttonPrimary,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_typography.dart';
import 'core/theme/theme_provider.dart' as app_theme;
import 'core/l10n/locale_provider.dart';
import 'l10n/app_localizations.dart';
import 'screens/auth/index.dart';

void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => app_theme.ThemeProvider()),
      ChangeNotifierProvider(create: (_) => LocaleProvider()),
    ],
    child: const CuidaDorApp(),
  ),
);

class CuidaDorApp extends StatelessWidget {
  const CuidaDorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<app_theme.ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    // Atualiza o multiplicador de fonte global quando o provider notifica mudanças
    AppTypography.setFontSizeMultiplier(themeProvider.fontSizeMultiplier);

    return MaterialApp(
      title: 'CuidaDor',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.isHighContrastEnabled 
          ? AppTheme.highContrastTheme 
          : AppTheme.lightTheme,
      darkTheme: themeProvider.isHighContrastEnabled 
          ? AppTheme.highContrastTheme 
          : AppTheme.darkTheme,
      themeMode: themeProvider.isHighContrastEnabled 
          ? ThemeMode.light 
          : _getThemeMode(themeProvider.themeMode),
      locale: localeProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],
      home: const LoginPage(),
    );
  }

  ThemeMode _getThemeMode(app_theme.ThemeMode mode) {
    switch (mode) {
      case app_theme.ThemeMode.light:
        return ThemeMode.light;
      case app_theme.ThemeMode.dark:
        return ThemeMode.dark;
      case app_theme.ThemeMode.system:
        return ThemeMode.system;
    }
  }
}

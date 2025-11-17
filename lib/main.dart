import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_colors.dart';
import 'screens/auth/index.dart';

void main() => runApp(const CuidaDorApp());

class CuidaDorApp extends StatelessWidget {
  const CuidaDorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CuidaDor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.buttonPrimary),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      locale: const Locale('pt', 'BR'),
      home: const LoginPage(),
    );
  }
}

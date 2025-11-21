import 'package:flutter/material.dart' as flutter show ChangeNotifier, Brightness;
import 'package:flutter/material.dart' hide ThemeMode;
import 'package:shared_preferences/shared_preferences.dart';

/// Enum para os modos de tema disponíveis
enum ThemeMode {
  light,
  dark,
  system,
}

/// Provider para gerenciar o tema da aplicação
/// Persiste a preferência do usuário usando SharedPreferences
class ThemeProvider extends flutter.ChangeNotifier {
  static const String _themeModeKey = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.system;
  
  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadThemeMode();
  }

  /// Carrega o tema salvo das preferências
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString(_themeModeKey);
    
    if (savedMode != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == savedMode,
        orElse: () => ThemeMode.system,
      );
      notifyListeners();
    }
  }

  /// Define o modo de tema e persiste a escolha
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.toString());
  }

  /// Retorna o ThemeMode do Flutter baseado na escolha do usuário
  /// e na preferência do sistema quando mode == ThemeMode.system
  ThemeMode getFlutterThemeMode(flutter.Brightness systemBrightness) {
    return _themeMode;
  }

  /// Verifica se o app está em modo escuro
  bool isDarkMode(BuildContext context) {
    if (_themeMode == ThemeMode.system) {
      return MediaQuery.of(context).platformBrightness == flutter.Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }
}

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
  static const String _highContrastKey = 'high_contrast_mode';
  static const String _fontSizeKey = 'font_size_level';

  /// id do usuário atual (vamos usar o e-mail)
  String? _currentUserId;

  ThemeMode _themeMode = ThemeMode.system;
  bool _isHighContrastEnabled = false;
  double _fontSizeLevel = 3.0; // 0-6, onde 3 é o tamanho padrão (médio)

  ThemeMode get themeMode => _themeMode;
  bool get isHighContrastEnabled => _isHighContrastEnabled;
  double get fontSizeLevel => _fontSizeLevel;

  /// Retorna o multiplicador de tamanho de fonte baseado no nível
  /// Nível 3 (médio) = 1.0x (sem mudança)
  /// Cada nível = ±2px do tamanho base
  double get fontSizeMultiplier {
    const baseSize = 14.0;
    final adjustedSize = baseSize + (_fontSizeLevel - 3.0) * 2.0;
    return adjustedSize / baseSize;
  }

  ThemeProvider() {
    // Antes de saber o usuário, carrega preferências "globais" (fallback)
    _loadThemeMode();
  }

  /// Define o usuário atual (ex.: e-mail) e carrega as preferências dele
  Future<void> setCurrentUser(String? id) async {
    _currentUserId = id;
    await _loadThemeMode();
  }

  /// Gera uma chave específica para o usuário, ou usa a global se não houver usuário
  String _key(String baseKey) {
    if (_currentUserId == null || _currentUserId!.isEmpty) {
      return baseKey;
    }
    return '${_currentUserId}_$baseKey';
  }

  /// Carrega o tema salvo das preferências
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();

    // Carregar modo de tema
    final savedMode = prefs.getString(_key(_themeModeKey));
    if (savedMode != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == savedMode,
        orElse: () => ThemeMode.system,
      );
    } else {
      _themeMode = ThemeMode.system;
    }

    // Carregar preferência de alto contraste
    _isHighContrastEnabled = prefs.getBool(_key(_highContrastKey)) ?? false;

    // Carregar nível de tamanho de fonte
    _fontSizeLevel = prefs.getDouble(_key(_fontSizeKey)) ?? 3.0;

    notifyListeners();
  }

  /// Define o modo de tema e persiste a escolha
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(_themeModeKey), mode.toString());
  }

  /// Ativa ou desativa o modo Alto Contraste
  Future<void> setHighContrast(bool enabled) async {
    _isHighContrastEnabled = enabled;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key(_highContrastKey), enabled);
  }

  /// Define o nível do tamanho de fonte (0-6) e persiste a escolha
  /// Nível 3 é o tamanho padrão (médio)
  Future<void> setFontSizeLevel(double level) async {
    if (level < 0 || level > 6) return;

    _fontSizeLevel = level;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_key(_fontSizeKey), level);
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

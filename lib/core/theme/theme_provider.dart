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
    // Nível 3 é o padrão (1.0x)
    // Cada nível adiciona ou remove 2px
    // Para fontSize base de 14: nível 0=8px, 1=10px, 2=12px, 3=14px, 4=16px, 5=18px, 6=20px
    // Multiplicador: (14 + (level-3)*2) / 14
    const baseSize = 14.0;
    final adjustedSize = baseSize + (_fontSizeLevel - 3.0) * 2.0;
    return adjustedSize / baseSize;
  }

  ThemeProvider() {
    _loadThemeMode();
  }

  /// Carrega o tema salvo das preferências
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Carregar modo de tema
    final savedMode = prefs.getString(_themeModeKey);
    if (savedMode != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == savedMode,
        orElse: () => ThemeMode.system,
      );
    }
    
    // Carregar preferência de alto contraste
    _isHighContrastEnabled = prefs.getBool(_highContrastKey) ?? false;
    
    // Carregar nível de tamanho de fonte
    _fontSizeLevel = prefs.getDouble(_fontSizeKey) ?? 3.0;
    
    notifyListeners();
  }

  /// Define o modo de tema e persiste a escolha
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.toString());
  }

  /// Ativa ou desativa o modo Alto Contraste
  Future<void> setHighContrast(bool enabled) async {
    _isHighContrastEnabled = enabled;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_highContrastKey, enabled);
  }
  
  /// Define o nível do tamanho de fonte (0-6) e persiste a escolha
  /// Nível 3 é o tamanho padrão (médio)
  Future<void> setFontSizeLevel(double level) async {
    if (level < 0 || level > 6) return;
    
    _fontSizeLevel = level;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontSizeKey, level);
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

import 'package:flutter/material.dart';

// Define toda tipografia do aplicativo, os nomes seguem o uso semântico (título, corpo, botão, etc)
// IMPORTANTE: As cores não são definidas aqui para permitir adaptação ao tema
// Use .copyWith(color: ...) quando precisar de cor específica
// Os tamanhos de fonte podem ser ajustados globalmente usando o multiplicador do ThemeProvider

class AppTypography {
  /// Multiplicador global de tamanho de fonte (padrão: 1.0)
  /// Use ThemeProvider.fontSizeMultiplier para obter o valor ajustado pelo usuário
  static double _fontSizeMultiplier = 1.0;
  
  /// Define o multiplicador global de tamanho de fonte
  /// Deve ser chamado quando o ThemeProvider notificar mudanças
  static void setFontSizeMultiplier(double multiplier) {
    _fontSizeMultiplier = multiplier;
  }
  
  /// Aplica o multiplicador ao tamanho de fonte
  static double _applyMultiplier(double baseSize) {
    return baseSize * _fontSizeMultiplier;
  }
  // === Títulos ===
  static TextStyle get heading1Primary => TextStyle(
    fontFamily: 'Inter',
    fontSize: _applyMultiplier(16),
    fontWeight: FontWeight.w600,
    // color removida - usar Theme.of(context).colorScheme.onSurface
  );

  static TextStyle get heading1Secondary => TextStyle(
    fontFamily: 'Inter',
    fontSize: _applyMultiplier(16),
    fontWeight: FontWeight.w600,
    // color removida - usar Theme.of(context).colorScheme.onPrimary
  );

  static TextStyle get heading2Primary => TextStyle(
    fontFamily: 'Inter',
    fontSize: _applyMultiplier(14),
    fontWeight: FontWeight.w600,
    // color removida - usar Theme.of(context).colorScheme.onSurface
  );

  static TextStyle get heading2Secondary => TextStyle(
    fontFamily: 'Inter',
    fontSize: _applyMultiplier(14),
    fontWeight: FontWeight.w600,
    // color removida - usar Theme.of(context).colorScheme.onPrimary
  );
  
  // == Textos de corpo ==
  static TextStyle get textPrimary => TextStyle(
    fontFamily: 'Inter',
    fontSize: _applyMultiplier(12),
    fontWeight: FontWeight.normal,
    // color removida - usar Theme.of(context).colorScheme.onSurface
  );

  static TextStyle get textDisabled => TextStyle(
    fontFamily: 'Inter',
    fontSize: _applyMultiplier(12),
    fontWeight: FontWeight.normal,
    // color removida - usar onSurface.withValues(alpha: 0.6)
  );

  static TextStyle get textLink => TextStyle(
    fontFamily: 'Inter',
    fontSize: _applyMultiplier(12),
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.underline,
    // decorationColor e color removidas - usar Theme.of(context).colorScheme.primary
  );

  // === Botões ===
  static TextStyle get buttonPrimary => TextStyle(
    fontFamily: 'Inter',
    fontSize: _applyMultiplier(14),
    fontWeight: FontWeight.w600,
    // color removida - usar Theme.of(context).colorScheme.onPrimary
  );

  static TextStyle get buttonSecondary => TextStyle(
    fontFamily: 'Inter',
    fontSize: _applyMultiplier(16),
    fontWeight: FontWeight.w600,
    // color removida - usar Theme.of(context).colorScheme.primary
  );

  static TextStyle get buttonDisabled => TextStyle(
    fontFamily: 'Inter',
    fontSize: _applyMultiplier(14),
    fontWeight: FontWeight.w600,
    // color removida - usar onSurface.withValues(alpha: 0.6)
  );

  // === Estilos específicos para formulários e labels ===
  static TextStyle get label => TextStyle(
    fontFamily: 'Inter',
    fontSize: _applyMultiplier(12),
    fontWeight: FontWeight.w500,
    // color removida - usar Theme.of(context).colorScheme.onSurface
  );

  static TextStyle get labelSmall => TextStyle(
    fontFamily: 'Inter',
    fontSize: _applyMultiplier(11),
    fontWeight: FontWeight.normal,
    // color removida - usar onSurface.withValues(alpha: 0.6)
  );

  // === Estilos de destaque ===
  static TextStyle get displayLarge => TextStyle(
    fontFamily: 'Inter',
    fontSize: _applyMultiplier(24),
    fontWeight: FontWeight.w700,
    // color removida - usar Theme.of(context).colorScheme.primary
  );

  static TextStyle get displayMedium => TextStyle(
    fontFamily: 'Inter',
    fontSize: _applyMultiplier(16),
    fontWeight: FontWeight.w600,
    // color removida - usar Theme.of(context).colorScheme.primary
  );

  static TextStyle get bodyMedium => TextStyle(
    fontFamily: 'Inter',
    fontSize: _applyMultiplier(13),
    fontWeight: FontWeight.w500,
    // color removida - usar Theme.of(context).colorScheme.onSurface
  );

  static TextStyle get captionPrimary => TextStyle(
    fontFamily: 'Inter',
    fontSize: _applyMultiplier(12),
    fontWeight: FontWeight.w600,
    // color removida - usar Theme.of(context).colorScheme.primary
  );

  // === Estilos para páginas de práticas ===
  static TextStyle get pageTitle => TextStyle(
    fontFamily: 'Inter',
    fontSize: _applyMultiplier(20),
    fontWeight: FontWeight.w600,
    // color removida - usar Theme.of(context).colorScheme.onSurface
  );

  static TextStyle get practiceTitle => TextStyle(
    fontFamily: 'Inter',
    fontSize: _applyMultiplier(22),
    fontWeight: FontWeight.w600,
    // color removida - usar Theme.of(context).colorScheme.onSurface
  );

  static TextStyle get sectionTitle => TextStyle(
    fontFamily: 'Inter',
    fontSize: _applyMultiplier(16),
    fontWeight: FontWeight.w600,
    // color removida - usar Theme.of(context).colorScheme.onSurface
  );

  static TextStyle get bodyLarge => TextStyle(
    fontFamily: 'Inter',
    fontSize: _applyMultiplier(14),
    fontWeight: FontWeight.normal,
    // color removida - usar Theme.of(context).colorScheme.onSurface
  );
}

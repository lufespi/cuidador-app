import 'package:flutter/material.dart';

// Define toda tipografia do aplicativo, os nomes seguem o uso semântico (título, corpo, botão, etc)
// IMPORTANTE: As cores não são definidas aqui para permitir adaptação ao tema
// Use .copyWith(color: ...) quando precisar de cor específica

class AppTypography {
  // === Títulos ===
  static const TextStyle heading1Primary = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    // color removida - usar Theme.of(context).colorScheme.onSurface
  );

  static const TextStyle heading1Secondary = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    // color removida - usar Theme.of(context).colorScheme.onPrimary
  );

  static const TextStyle heading2Primary = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    // color removida - usar Theme.of(context).colorScheme.onSurface
  );

  static const TextStyle heading2Secondary = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    // color removida - usar Theme.of(context).colorScheme.onPrimary
  );
  
  // == Textos de corpo ==
  static const TextStyle textPrimary = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.normal,
    // color removida - usar Theme.of(context).colorScheme.onSurface
  );

  static const TextStyle textDisabled = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.normal,
    // color removida - usar onSurface.withValues(alpha: 0.6)
  );

  static const TextStyle textLink = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.underline,
    // decorationColor e color removidas - usar Theme.of(context).colorScheme.primary
  );

  // === Botões ===
  static const TextStyle buttonPrimary = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    // color removida - usar Theme.of(context).colorScheme.onPrimary
  );

  static const TextStyle buttonSecondary = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    // color removida - usar Theme.of(context).colorScheme.primary
  );

  static const TextStyle buttonDisabled = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    // color removida - usar onSurface.withValues(alpha: 0.6)
  );

  // === Estilos específicos para formulários e labels ===
  static const TextStyle label = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    // color removida - usar Theme.of(context).colorScheme.onSurface
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 11,
    fontWeight: FontWeight.normal,
    // color removida - usar onSurface.withValues(alpha: 0.6)
  );

  // === Estilos de destaque ===
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    // color removida - usar Theme.of(context).colorScheme.primary
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    // color removida - usar Theme.of(context).colorScheme.primary
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 13,
    fontWeight: FontWeight.w500,
    // color removida - usar Theme.of(context).colorScheme.onSurface
  );

  static const TextStyle captionPrimary = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    // color removida - usar Theme.of(context).colorScheme.primary
  );

  // === Estilos para páginas de práticas ===
  static const TextStyle pageTitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    // color removida - usar Theme.of(context).colorScheme.onSurface
  );

  static const TextStyle practiceTitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 22,
    fontWeight: FontWeight.w600,
    // color removida - usar Theme.of(context).colorScheme.onSurface
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    // color removida - usar Theme.of(context).colorScheme.onSurface
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.normal,
    // color removida - usar Theme.of(context).colorScheme.onSurface
  );
}

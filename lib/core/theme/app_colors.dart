import 'package:flutter/material.dart';

// ============================================================================
// CORES LIGHT MODE
// ============================================================================
class AppColorsLight {
  // === Botões e ações principais ===
  static const Color buttonPrimary = Color(0xFF28BDBD);       // botão principal, cor da marca
  static const Color buttonPrimaryVariant = Color(0xFF07DFD5); // variação de destaque/gradiente
  static const Color buttonSecondary = Color(0xFF3D3D3D);      // botão alternativo (voltar, cancelar)
  static const Color buttonSurface = Color(0xFFFBFEFE);        // botão branco / superfície leve
  static const Color buttonText = Color(0xFFFFFFFF);           // texto sobre botões coloridos

  // === Fundo e superfícies ===
  static const Color background = Color(0xFFFBFCFC);           // fundo geral da aplicação
  static const Color surface = Color(0xFFFFFFFF);              // cartões e áreas brancas
  static const Color surfaceVariant = Color(0xFFEAFBFA);       // superfície alternativa (verde suave)

  // === Inputs e campos de formulário ===
  static const Color inputBackground = Color(0xFFDDE3E3);      // fundo dos campos de entrada

  // === Textos ===
  static const Color textPrimary = Color(0xFF3D3D3D);          // texto principal
  static const Color textSecondary = Color(0xFF28BDBD);        // texto de destaque / link
  static const Color textWhite = Color(0xFFFFFFFF);            // texto branco
  static const Color textDisabled = Color(0xFF787878);         // texto desabilitado / placeholder

  // === Bordas e divisores ===
  static const Color border = Color(0xFF28BDBD);               // bordas e divisores

  // === Estados e feedback ===
  static const Color stateSuccess = Color(0xFF1FA97A);         // sucesso / confirmação
  static const Color stateWarning = Color(0xFFF2A700);         // alerta / aviso
  static const Color stateError = Color(0xFFE55757);           // erro / falha
}

// ============================================================================
// CORES DARK MODE
// ============================================================================
class AppColorsDark {
  // === Botões e ações principais ===
  static const Color buttonPrimary = Color(0xFF28BDBD);       // botão principal, cor da marca (mantém identidade)
  static const Color buttonPrimaryVariant = Color(0xFF07DFD5); // variação de destaque/gradiente
  static const Color buttonSecondary = Color(0xFF2C2C2C);      // botão alternativo mais escuro
  static const Color buttonSurface = Color(0xFF1E1E1E);        // botão superfície escura
  static const Color buttonText = Color(0xFFFFFFFF);           // texto sobre botões coloridos

  // === Fundo e superfícies ===
  static const Color background = Color(0xFF121818);           // fundo geral escuro
  static const Color surface = Color(0xFF161D1D);              // cartões e áreas elevadas
  static const Color surfaceVariant = Color(0xFF192E2D);       // superfície alternativa (verde escuro)

  // === Inputs e campos de formulário ===
  static const Color inputBackground = Color(0xFF111717);      // fundo dos campos de entrada

  // === Textos ===
  static const Color textPrimary = Color(0xFFE8E8E8);          // texto principal claro
  static const Color textSecondary = Color(0xFF28BDBD);        // texto de destaque / link (mantém marca)
  static const Color textWhite = Color(0xFFFFFFFF);            // texto branco
  static const Color textDisabled = Color(0xFF787878);         // texto desabilitado / placeholder

  // === Bordas e divisores ===
  static const Color border = Color(0xFF28BDBD);               // bordas e divisores (mantém marca)

  // === Estados e feedback ===
  static const Color stateSuccess = Color(0xFF1FA97A);         // sucesso / confirmação
  static const Color stateWarning = Color(0xFFF2A700);         // alerta / aviso
  static const Color stateError = Color(0xFFE55757);           // erro / falha
}

// ============================================================================
// CORES HIGH CONTRAST MODE (Alto Contraste)
// ============================================================================
class AppColorsHighContrast {
  // === Botões e ações principais ===
  static const Color buttonPrimary = Color(0xFFFFFF00);        // amarelo vibrante para máximo contraste
  static const Color buttonPrimaryVariant = Color(0xFF00FFFF); // ciano/azul claro para alternativa
  static const Color buttonSecondary = Color(0xFFFFFFFF);      // branco para botões secundários
  static const Color buttonSurface = Color(0xFF000000);        // preto para superfície de botão
  static const Color buttonText = Color(0xFF000000);           // texto preto em botões amarelos

  // === Fundo e superfícies ===
  static const Color background = Color(0xFF000000);           // preto puro para fundo
  static const Color surface = Color(0xFF000000);              // preto puro para cartões
  static const Color surfaceVariant = Color(0xFF1A1A1A);       // cinza muito escuro para variação

  // === Inputs e campos de formulário ===
  static const Color inputBackground = Color(0xFF000000);      // preto para inputs

  // === Textos ===
  static const Color textPrimary = Color(0xFFFFFFFF);          // branco puro para texto principal
  static const Color textSecondary = Color(0xFFFFFF00);        // amarelo para links e destaques
  static const Color textWhite = Color(0xFFFFFFFF);            // branco
  static const Color textDisabled = Color(0xFFCCCCCC);         // cinza claro para texto desabilitado

  // === Bordas e divisores ===
  static const Color border = Color(0xFFFFFF00);               // amarelo para bordas (alto contraste)

  // === Estados e feedback ===
  static const Color stateSuccess = Color(0xFF00FF00);         // verde puro para sucesso
  static const Color stateWarning = Color(0xFFFFFF00);         // amarelo para aviso
  static const Color stateError = Color(0xFFFF0000);           // vermelho puro para erro
}

// ============================================================================
// CLASSE DE COMPATIBILIDADE (mantém código existente funcionando)
// ============================================================================
// DEPRECATED: Use AppColorsLight ou AppColorsDark diretamente
class AppColors {
  // === Botões e ações principais ===
  static const Color buttonPrimary = Color(0xFF28BDBD);
  static const Color buttonPrimaryVariant = Color(0xFF07DFD5);
  static const Color buttonSecondary = Color(0xFF3D3D3D);
  static const Color buttonSurface = Color(0xFFFBFEFE);
  static const Color buttonText = Color(0xFFFFFFFF);

  // === Fundo e superfícies ===
  static const Color background = Color(0xFFFBFCFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFEAFBFA);

  // === Inputs e campos de formulário ===
  static const Color inputBackground = Color(0xFFDDE3E3);

  // === Textos ===
  static const Color textPrimary = Color(0xFF3D3D3D);
  static const Color textSecondary = Color(0xFF28BDBD);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textDisabled = Color(0xFF787878);

  // === Bordas e divisores ===
  static const Color border = Color(0xFF28BDBD);

  // === Estados e feedback ===
  static const Color stateSuccess = Color(0xFF1FA97A);
  static const Color stateWarning = Color(0xFFF2A700);
  static const Color stateError = Color(0xFFE55757);
}

// ============================================================================
// NOMES SEMÂNTICOS (mantém compatibilidade)
// ============================================================================
class AppSemantic {
  // Identidade visual / marca
  static const Color brand = AppColors.buttonPrimary;
  static const Color brandVariant = AppColors.buttonPrimaryVariant;

  // Botões
  static const Color buttonPrimary = AppColors.buttonPrimary;
  static const Color buttonPrimaryVariant = AppColors.buttonPrimaryVariant;
  static const Color buttonSecondary = AppColors.buttonSecondary;
  static const Color buttonSurface = AppColors.buttonSurface;
  static const Color buttonText = AppColors.buttonText;

  // Fundo e superfícies
  static const Color background = AppColors.background;
  static const Color surface = AppColors.surface;
  static const Color surfaceVariant = AppColors.surfaceVariant;

  // === Inputs e campos de formulário ===
  static const Color inputBackground = AppColors.inputBackground;

  // Textos
  static const Color textPrimary = AppColors.textPrimary;
  static const Color textSecondary = AppColors.textSecondary;
  static const Color textDisabled = AppColors.textDisabled;
  static const Color textWhite = AppColors.textWhite;

  // Bordas e divisores
  static const Color border = AppColors.border;
  static const Color divider = AppColors.border;

  // Estados de feedback
  static const Color stateSuccess = AppColors.stateSuccess;
  static const Color stateWarning = AppColors.stateWarning;
  static const Color stateError = AppColors.stateError;
}

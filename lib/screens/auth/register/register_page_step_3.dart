import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/theme_provider.dart' as app_theme;
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_toggle.dart';
import '../../../core/widgets/step_indicator.dart';
import '../../settings/about/terms_page.dart';
import 'register_provider.dart';

class RegisterPageStep3 extends StatefulWidget {
  const RegisterPageStep3({super.key});

  @override
  State<RegisterPageStep3> createState() => _RegisterPageStep3State();
}

class _RegisterPageStep3State extends State<RegisterPageStep3> {
  final _formKey = GlobalKey<FormState>();
  
  double _fontSizeLevel = 3; // 0-6, onde 3 é médio
  bool _highContrast = false;
  bool _textToSpeech = false;
  bool _gdprConsent = false;
  bool _emailConsent = false;
  bool _isBackButtonPressed = false;
  bool _showErrors = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Carrega o estado atual do alto contraste e tamanho de fonte
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final themeProvider = Provider.of<app_theme.ThemeProvider>(context, listen: false);
      setState(() {
        _highContrast = themeProvider.isHighContrastEnabled;
        _fontSizeLevel = themeProvider.fontSizeLevel;
      });
    });
  }

  String _getFontSizeLabel() {
    const labels = ['Muito Pequeno', 'Pequeno', 'Pequeno-Médio', 'Médio', 'Médio-Grande', 'Grande', 'Muito Grande'];
    return labels[_fontSizeLevel.toInt()];
  }

  void _handleFinish() async {
    setState(() {
      _showErrors = true;
    });
    
    if (!_gdprConsent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você precisa concordar com a política de privacidade para continuar'),
        ),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });

    // Salvar preferências de acessibilidade localmente
    final themeProvider = Provider.of<app_theme.ThemeProvider>(context, listen: false);
    themeProvider.setFontSizeLevel(_fontSizeLevel);
    themeProvider.setHighContrast(_highContrast);

    // Salvar dados do Step 3 no Provider
    final registerProvider = Provider.of<RegisterProvider>(context, listen: false);
    registerProvider.saveStep3Data(
      fontSizeLevel: _fontSizeLevel,
      highContrast: _highContrast,
      textToSpeech: _textToSpeech,
      gdprConsent: _gdprConsent,
      emailConsent: _emailConsent,
    );

    // Enviar tudo para o backend
    final success = await registerProvider.completeRegistration();

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (success) {
      // Cadastro finalizado com sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastro finalizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Volta para a tela de login
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      // Erro ao cadastrar
      final errorMessage = registerProvider.errorMessage ?? 'Erro ao finalizar cadastro';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
      registerProvider.clearError();
    }
  }

  void _handleBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/images/cuidador-horizontal-logo.png',
                  height: 60,
                ),
                const SizedBox(height: 24),
                
                // Welcome text
                Text(
                  'Gostaria de personalizar sua experiência?',
                  style: AppTypography.heading2Primary,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                
                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        _isBackButtonPressed = true;
                      });
                    },
                    onTapUp: (_) {
                      setState(() {
                        _isBackButtonPressed = false;
                      });
                    },
                    onTapCancel: () {
                      setState(() {
                        _isBackButtonPressed = false;
                      });
                    },
                    onTap: _handleBack,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _isBackButtonPressed 
                            ? AppColors.buttonPrimary.withAlpha(25)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_back,
                            color: AppColors.textPrimary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Voltar',
                            style: AppTypography.heading2Primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Step indicators
                const StepIndicator(
                  currentStep: 2,
                  totalSteps: 3,
                ),
                const SizedBox(height: 32),
                
                // Accessibility preferences card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF192E2D)
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section title
                      Row(
                        children: [
                          Icon(
                            Icons.accessibility_new,
                            color: Theme.of(context).colorScheme.onSurface,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Preferências de Acessibilidade',
                              style: AppTypography.heading2Primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Font size
                      Text(
                        'Tamanho da Fonte: ${_getFontSizeLabel()}',
                        style: AppTypography.textPrimary.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Font size slider
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF2E3838)
                              : Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.buttonPrimary,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'A',
                              style: AppTypography.textPrimary.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SliderTheme(
                                data: SliderThemeData(
                                  activeTrackColor: AppColors.buttonPrimary,
                                  inactiveTrackColor: Colors.grey.shade400,
                                  thumbColor: AppColors.buttonPrimary,
                                  overlayColor: AppColors.buttonPrimary.withAlpha(25),
                                  trackHeight: 3,
                                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                                  showValueIndicator: ShowValueIndicator.never,
                                  trackShape: const RoundedRectSliderTrackShape(),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Slider(
                                      value: _fontSizeLevel,
                                      min: 0,
                                      max: 6,
                                      divisions: 6,
                                      onChanged: (value) {
                                        final themeProvider = Provider.of<app_theme.ThemeProvider>(context, listen: false);
                                        themeProvider.setFontSizeLevel(value);
                                        setState(() {
                                          _fontSizeLevel = value;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 2),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: List.generate(7, (index) {
                                          return Container(
                                            width: 4,
                                            height: 4,
                                            decoration: BoxDecoration(
                                              color: index <= _fontSizeLevel 
                                                  ? AppColors.buttonPrimary 
                                                  : Colors.grey.shade600,
                                              shape: BoxShape.circle,
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'A',
                              style: AppTypography.heading1Primary,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // High contrast toggle
                      Row(
                        children: [
                          Icon(
                            Icons.contrast,
                            color: Theme.of(context).colorScheme.onSurface,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Alto Contraste',
                                  style: AppTypography.textPrimary.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Melhor visibilidade para textos',
                                  style: AppTypography.textDisabled,
                                ),
                              ],
                            ),
                          ),
                          AppToggle(
                            value: _highContrast,
                            onChanged: (value) {
                              final themeProvider = Provider.of<app_theme.ThemeProvider>(context, listen: false);
                              themeProvider.setHighContrast(value);
                              setState(() {
                                _highContrast = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Text to speech toggle
                      Row(
                        children: [
                          Icon(
                            Icons.volume_up,
                            color: Theme.of(context).colorScheme.onSurface,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Texto-Para-Fala',
                                  style: AppTypography.textPrimary.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Leitura de textos em voz alta',
                                  style: AppTypography.textDisabled,
                                ),
                              ],
                            ),
                          ),
                          AppToggle(
                            value: _textToSpeech,
                            onChanged: (value) {
                              setState(() {
                                _textToSpeech = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Privacy and data usage card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF192E2D)
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section title
                      Row(
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            color: Theme.of(context).colorScheme.onSurface,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: 'Uso de Dados e Privacidade ',
                                style: AppTypography.heading2Primary.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                                children: const [
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: AppColors.stateError,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // GDPR consent
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _gdprConsent = !_gdprConsent;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _showErrors && !_gdprConsent 
                                        ? AppColors.stateError 
                                        : (_gdprConsent ? AppColors.buttonPrimary : AppColors.textDisabled),
                                    width: 2,
                                  ),
                                  color: _gdprConsent ? AppColors.buttonPrimary : Colors.transparent,
                                ),
                                  child: _gdprConsent
                                      ? Icon(
                                          Icons.circle,
                                          size: 10,
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? AppColors.background
                                              : Colors.white,
                                        )
                                      : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Concordo com o uso dos meus dados conforme a política de privacidade (LGPD).',
                                  style: AppTypography.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Email consent
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _emailConsent = !_emailConsent;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _emailConsent ? AppColors.buttonPrimary : AppColors.textDisabled,
                                    width: 2,
                                  ),
                                  color: _emailConsent ? AppColors.buttonPrimary : Colors.transparent,
                                ),
                                  child: _emailConsent
                                      ? Icon(
                                          Icons.circle,
                                          size: 10,
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? AppColors.background
                                              : Colors.white,
                                        )
                                      : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Desejo receber por e-mail dicas de bem-estar, exercícios e novidades sobre o app.',
                                  style: AppTypography.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Terms and Conditions link
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TermsPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Ler Termos e Condições',
                      style: AppTypography.textPrimary.copyWith(
                        color: AppColors.buttonPrimary,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.buttonPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Finish button
                AppButton(
                  label: _isLoading ? 'Finalizando...' : 'Finalizar Cadastro',
                  onPressed: _isLoading ? () {} : _handleFinish,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

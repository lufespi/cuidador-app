import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/theme_provider.dart' as app_theme;
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_toggle.dart';

class AccessibilityPage extends StatefulWidget {
  const AccessibilityPage({super.key});

  @override
  State<AccessibilityPage> createState() => _AccessibilityPageState();
}

class _AccessibilityPageState extends State<AccessibilityPage> {
  double _fontSizeLevel = 3; // 0-6, onde 3 é médio
  bool _highContrast = false;

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



  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.accessibility,
          style: AppTypography.heading1Secondary,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              
              // Card - Preferências de Acessibilidade
              AppCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título da seção
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/accessibility/person-standing.svg',
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.onSurface,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.accessibilityPreferences,
                          style: AppTypography.heading2Primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Descrição
                    Text(
                      l10n.adjustInterfaceForNeeds,
                      style: AppTypography.textPrimary.copyWith(
                        color: AppColors.textDisabled,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Tamanho da Fonte
                    Text(
                      l10n.fontSizeWith(_getFontSizeLabel()),
                      style: AppTypography.textPrimary.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Preview Box (acima do slider)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF2E3838)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.buttonPrimary,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          l10n.previewText,
                          textAlign: TextAlign.center,
                          style: AppTypography.textPrimary.copyWith(
                            fontSize: 6 + (_fontSizeLevel * 2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Slider de tamanho de fonte
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF2E3838)
                            : Colors.white,
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
                                overlayColor: AppColors.buttonPrimary.withValues(alpha: 0.1),
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
                    
                    // Alto Contraste toggle
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
                                l10n.highContrast,
                                style: AppTypography.textPrimary.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                l10n.highContrastDescription,
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
                    
                    // Texto-Para-Fala toggle (DESABILITADO - Em desenvolvimento)
                    Opacity(
                      opacity: 0.5,
                      child: Row(
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
                                  l10n.textToSpeech,
                                  style: AppTypography.textPrimary.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  l10n.textToSpeechDescription,
                                  style: AppTypography.textDisabled,
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Esta funcionalidade está em desenvolvimento'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: AppToggle(
                              value: false,
                              onChanged: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

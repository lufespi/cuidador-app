import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/l10n/locale_provider.dart';
import '../../../l10n/app_localizations.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String _selectedLanguage = 'pt';

  @override
  void initState() {
    super.initState();
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    _selectedLanguage = localeProvider.locale.languageCode;
  }

  void _selectLanguage(String languageCode) {
    final l10n = AppLocalizations.of(context)!;
    if (languageCode == 'es') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.languageNotAvailable(l10n.spanish)),
        ),
      );
      return;
    }
    setState(() {
      _selectedLanguage = languageCode;
    });
  }

  void _applyLanguage() {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;
    
    Locale newLocale;
    String languageName;
    
    if (_selectedLanguage == 'pt') {
      newLocale = const Locale('pt', 'BR');
      languageName = l10n.portuguese;
    } else {
      newLocale = const Locale('en', 'US');
      languageName = l10n.english;
    }
    
    localeProvider.setLocale(newLocale);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.languageApplied(languageName)),
        backgroundColor: AppColors.buttonPrimary,
      ),
    );
    Navigator.pop(context);
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
          l10n.language,
          style: AppTypography.heading1Secondary,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    
                    // Card único com tudo
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título e descrição
                          Text(
                            l10n.languageSelection,
                            style: AppTypography.heading1Primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.languageDescription,
                            style: AppTypography.textPrimary.copyWith(
                              color: AppColors.textDisabled,
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Português
                          _buildLanguageOption(
                            code: 'pt',
                            flag: 'BR',
                            language: l10n.portuguese,
                            country: l10n.brazil,
                            isSelected: _selectedLanguage == 'pt',
                            isEnabled: true,
                          ),
                          
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Divider(
                              height: 1,
                              color: AppColors.inputBackground,
                            ),
                          ),
                          
                          // Espanhol (desabilitado)
                          _buildLanguageOption(
                            code: 'es',
                            flag: 'ES',
                            language: l10n.spanish,
                            country: l10n.spain,
                            isSelected: _selectedLanguage == 'es',
                            isEnabled: false,
                          ),
                          
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Divider(
                              height: 1,
                              color: AppColors.inputBackground,
                            ),
                          ),
                          
                          // Inglês
                          _buildLanguageOption(
                            code: 'en',
                            flag: 'US',
                            language: l10n.english,
                            country: l10n.unitedStates,
                            isSelected: _selectedLanguage == 'en',
                            isEnabled: true,
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Aviso
                          Row(
                            children: [
                              const Icon(
                                Icons.language,
                                color: AppColors.textDisabled,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _selectedLanguage == 'pt'
                                      ? 'Alguns textos podem não estar totalmente traduzidos. Estamos trabalhando para adicionar suporte completo a todos os idiomas.'
                                      : 'Some texts may not be fully translated. We are working to add full support for all languages.',
                                  style: AppTypography.textPrimary.copyWith(
                                    color: AppColors.textDisabled,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            
            // Botão aplicar na parte inferior
            Padding(
              padding: const EdgeInsets.all(16),
              child: AppButton(
                label: _selectedLanguage == 'pt' ? 'Aplicar Idioma' : 'Apply Language',
                onPressed: _applyLanguage,
                height: 52,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required String code,
    required String flag,
    required String language,
    required String country,
    required bool isSelected,
    required bool isEnabled,
  }) {
    return InkWell(
      onTap: () => _selectLanguage(code),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          children: [
            // Radio button
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isEnabled
                      ? (isSelected ? AppColors.buttonPrimary : AppColors.textDisabled)
                      : AppColors.textDisabled.withAlpha(128),
                  width: 2,
                ),
                color: isSelected && isEnabled
                    ? AppColors.buttonPrimary
                    : Colors.transparent,
              ),
              child: isSelected && isEnabled
                  ? const Center(
                      child: Icon(
                        Icons.circle,
                        size: 12,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            
            const SizedBox(width: 16),
            
            // Flag (SVG)
            Container(
              width: 48,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: AppColors.inputBackground,
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SvgPicture.asset(
                  _getFlagAsset(flag),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Nome do idioma e país
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language,
                    style: AppTypography.heading2Primary.copyWith(
                      color: isEnabled ? AppColors.textPrimary : AppColors.textDisabled,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    country,
                    style: AppTypography.textPrimary.copyWith(
                      color: AppColors.textDisabled,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFlagAsset(String countryCode) {
    switch (countryCode) {
      case 'BR':
        return 'assets/icons/settings/brazil-flag.svg';
      case 'US':
        return 'assets/icons/settings/us-flag.svg';
      case 'ES':
        return 'assets/icons/settings/spain-flag.svg';
      default:
        return 'assets/icons/settings/brazil-flag.svg';
    }
  }
}

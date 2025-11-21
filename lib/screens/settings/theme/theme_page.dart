import 'package:flutter/material.dart' hide ThemeMode;
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_button.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  late ThemeMode _selectedTheme;

  @override
  void initState() {
    super.initState();
    _selectedTheme = Provider.of<ThemeProvider>(context, listen: false).themeMode;
  }

  void _saveTheme() async {
    final l10n = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    await themeProvider.setThemeMode(_selectedTheme);
    
    if (!mounted) return;
    
    String message = '';
    switch (_selectedTheme) {
      case ThemeMode.light:
        message = l10n.lightModeActivated;
        break;
      case ThemeMode.dark:
        message = l10n.darkModeActivated;
        break;
      case ThemeMode.system:
        message = l10n.systemThemeActivated;
        break;
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
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
          l10n.themeAndAppearance,
          style: AppTypography.heading1Secondary,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      
                      // Card - Modo de Exibição
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.palette_outlined,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.displayMode,
                                  style: AppTypography.heading1Primary,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              l10n.displayModeDescription,
                              style: AppTypography.textPrimary.copyWith(
                                color: AppColors.textDisabled,
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Opção Modo Claro
                            _buildThemeOption(
                              value: ThemeMode.light,
                              icon: Icons.light_mode,
                              title: l10n.lightMode,
                              description: l10n.lightModeDescription,
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // Opção Modo Escuro
                            _buildThemeOption(
                              value: ThemeMode.dark,
                              icon: Icons.dark_mode,
                              title: l10n.darkMode,
                              description: l10n.darkModeDescription,
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // Opção Tema do Sistema
                            _buildThemeOption(
                              value: ThemeMode.system,
                              icon: Icons.brightness_auto,
                              title: l10n.automaticMode,
                              description: l10n.automaticModeDescription,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            
            // Botão salvar na parte inferior
            Padding(
              padding: const EdgeInsets.all(16),
              child: AppButton(
                label: l10n.saveChanges,
                onPressed: _saveTheme,
                height: 52,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption({
    required ThemeMode value,
    required IconData icon,
    required String title,
    required String description,
  }) {
    final isSelected = _selectedTheme == value;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTheme = value;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            // Radio button
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.buttonPrimary
                      : AppColors.textDisabled,
                  width: 2,
                ),
                color: isSelected
                    ? AppColors.buttonPrimary
                    : Colors.transparent,
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(
                        Icons.circle,
                        size: 10,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            
            const SizedBox(width: 12),
            
            // Ícone e texto
            Expanded(
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 20,
                    color: isSelected 
                        ? AppColors.buttonPrimary 
                        : AppColors.textDisabled,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTypography.textPrimary.copyWith(
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                        if (description.isNotEmpty)
                          Text(
                            description,
                            style: AppTypography.textPrimary.copyWith(
                              fontSize: 12,
                              color: AppColors.textDisabled,
                            ),
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
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
}

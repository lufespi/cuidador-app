import 'package:flutter/material.dart' hide ThemeMode;
import 'package:provider/provider.dart';
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
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    await themeProvider.setThemeMode(_selectedTheme);
    
    if (!mounted) return;
    
    String message = '';
    switch (_selectedTheme) {
      case ThemeMode.light:
        message = 'Modo Claro ativado';
        break;
      case ThemeMode.dark:
        message = 'Modo Escuro ativado';
        break;
      case ThemeMode.system:
        message = 'Tema do Sistema ativado';
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Tema e Aparência',
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
                                  'Modo de Exibição',
                                  style: AppTypography.heading1Primary,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Escolha entre o modo claro, escuro ou automático para melhor conforto visual',
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
                              title: 'Modo Claro',
                              description: 'Interface clara e vibrante',
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // Opção Modo Escuro
                            _buildThemeOption(
                              value: ThemeMode.dark,
                              icon: Icons.dark_mode,
                              title: 'Modo Escuro',
                              description: 'Interface escura e confortável',
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // Opção Tema do Sistema
                            _buildThemeOption(
                              value: ThemeMode.system,
                              icon: Icons.brightness_auto,
                              title: 'Automático',
                              description: 'Segue configuração do sistema',
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
                label: 'Salvar Alterações',
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
                  Column(
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
                        ),
                    ],
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

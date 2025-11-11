import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/index.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              
              // Card - Ajustes
              AppCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título e subtítulo dentro do card
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/settings/settings.svg',
                          width: 30,
                          height: 30,
                          colorFilter: const ColorFilter.mode(
                            AppColors.textPrimary,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Ajustes',
                          style: AppTypography.textPrimary.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Acessibilidade e preferências',
                      style: AppTypography.textPrimary.copyWith(
                        color: AppColors.textDisabled,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Divider
                    Container(
                      height: 1,
                      color: AppColors.inputBackground,
                    ),
                    const SizedBox(height: 4),
                    
                    // Itens do menu
                SettingsMenuItem(
                  iconPath: 'assets/icons/settings/user-round.svg',
                  title: 'Conta',
                  subtitle: 'Gerencie suas informações pessoais.',
                  onTap: () {
                    // TODO: Navegar para página de Conta
                  },
                ),
                SettingsMenuItem(
                  iconPath: 'assets/icons/settings/person-standing.svg',
                  title: 'Acessibilidade',
                  subtitle: 'Ajustes de leitura e contraste.',
                  onTap: () {
                    // TODO: Navegar para página de Acessibilidade
                  },
                ),
                SettingsMenuItem(
                  iconPath: 'assets/icons/settings/bell-ring.svg',
                  title: 'Notificações e Alertas',
                  subtitle: 'Receba lembretes quando precisar.',
                  onTap: () {
                    // TODO: Navegar para página de Notificações
                  },
                ),
                SettingsMenuItem(
                  iconPath: 'assets/icons/settings/lock-keyhole.svg',
                  title: 'Privacidade e Segurança',
                  subtitle: 'Controle de dados e permissões.',
                  onTap: () {
                    // TODO: Navegar para página de Privacidade
                  },
                ),
                SettingsMenuItem(
                  iconPath: 'assets/icons/settings/palette.svg',
                  title: 'Tema e Aparência',
                  subtitle: 'Personalize cores e modo de exibição.',
                  onTap: () {
                    // TODO: Navegar para página de Tema
                  },
                ),
                SettingsMenuItem(
                  iconPath: 'assets/icons/settings/globe.svg',
                  title: 'Idioma',
                  subtitle: 'Selecione o idioma do app.',
                  onTap: () {
                    // TODO: Navegar para página de Idioma
                  },
                ),
                    SettingsMenuItem(
                      iconPath: 'assets/icons/settings/info.svg',
                      title: 'Sobre o App',
                      subtitle: 'Saiba mais sobre o CuidaDor.',
                      showDivider: false, // Último item não tem divider
                      onTap: () {
                        // TODO: Navegar para página Sobre o App
                      },
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

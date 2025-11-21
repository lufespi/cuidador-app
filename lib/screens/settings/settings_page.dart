import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/index.dart';
import '../../l10n/app_localizations.dart';
import '../auth/login/login_page.dart';
import 'account/account_page.dart';
import 'accessibility/accessibility_page.dart';
import 'notifications/notifications_page.dart';
import 'privacy/privacy_page.dart';
import 'theme/theme_page.dart';
import 'language/language_page.dart';
import 'about/about_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
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
                          colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.onSurface,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.settingsTitle,
                          style: AppTypography.heading1Primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.settingsSubtitle,
                      style: AppTypography.textPrimary.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Divider
                    Container(
                      height: 1,
                      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                    ),
                    const SizedBox(height: 4),
                    
                    // Itens do menu
                SettingsMenuItem(
                  iconPath: 'assets/icons/settings/user-round.svg',
                  title: l10n.account,
                  subtitle: l10n.accountDescription,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AccountPage()),
                    );
                  },
                ),
                SettingsMenuItem(
                  iconPath: 'assets/icons/settings/person-standing.svg',
                  title: l10n.accessibility,
                  subtitle: l10n.accessibilityDescription,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AccessibilityPage()),
                    );
                  },
                ),
                SettingsMenuItem(
                  iconPath: 'assets/icons/settings/bell-ring.svg',
                  title: l10n.notificationsAndAlerts,
                  subtitle: l10n.notificationsDescription,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NotificationsPage()),
                    );
                  },
                ),
                SettingsMenuItem(
                  iconPath: 'assets/icons/settings/lock-keyhole.svg',
                  title: l10n.privacyAndSecurity,
                  subtitle: l10n.privacyDescription,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PrivacyPage()),
                    );
                  },
                ),
                SettingsMenuItem(
                  iconPath: 'assets/icons/settings/palette.svg',
                  title: l10n.themeAndAppearance,
                  subtitle: l10n.themeDescription,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ThemePage()),
                    );
                  },
                ),
                SettingsMenuItem(
                  iconPath: 'assets/icons/settings/globe.svg',
                  title: l10n.language,
                  subtitle: l10n.languageDescriptionShort,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LanguagePage()),
                    );
                  },
                ),
                    SettingsMenuItem(
                      iconPath: 'assets/icons/settings/info.svg',
                      title: l10n.aboutApp,
                      subtitle: l10n.aboutDescription,
                      showDivider: false, // Último item não tem divider
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AboutPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Botão Sair (discreto)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Center(
                          child: Text(
                            l10n.logoutConfirmTitle,
                            style: AppTypography.heading1Primary,
                          ),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 8),
                            // Divider acima de Sair
                            Container(
                              height: 1,
                              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () {
                                  // Fecha o dialog
                                  Navigator.pop(context);
                                  
                                  // Remove todas as rotas e navega para o login
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (context) => const LoginPage()),
                                    (Route<dynamic> route) => false,
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: Text(
                                  l10n.logout,
                                  style: AppTypography.heading2Primary.copyWith(
                                    color: AppColors.stateError,
                                  ),
                                ),
                              ),
                            ),
                            // Divider sutil
                            Container(
                              height: 1,
                              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: Text(
                                  l10n.cancel,
                                  style: AppTypography.heading2Primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.logout,
                        color: AppColors.stateError.withValues(alpha: 0.7),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.logout,
                        style: AppTypography.heading2Primary.copyWith(
                          color: AppColors.stateError.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
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

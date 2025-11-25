import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/settings_menu_item.dart';
import 'users/users_list_page.dart';
import 'feedback/feedback_list_page.dart';

/// Página principal do painel administrativo
class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Administrador',
          style: AppTypography.heading1Secondary,
        ),
      ),
      backgroundColor: isDark ? AppColorsDark.background : AppColorsLight.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gerencie usuários e relatórios.',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark ? AppColorsDark.textDisabled : AppColorsLight.textDisabled,
                ),
              ),
              const SizedBox(height: 24),
              SettingsMenuItem(
                iconPath: 'assets/icons/settings/user-round.svg',
                title: 'Usuários',
                subtitle: 'Visualize e gerencie usuários cadastrados.',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const UsersListPage(),
                    ),
                  );
                },
              ),
              SettingsMenuItem(
                icon: Icons.feedback_outlined,
                title: 'Feedback',
                subtitle: 'Visualize o feedback enviado pelos usuários.',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const FeedbackListPage(),
                    ),
                  );
                },
              ),
              SettingsMenuItem(
                icon: Icons.description_outlined,
                title: 'Relatórios',
                subtitle: 'Exporte dados dos usuários.',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Funcionalidade disponível em breve'),
                      backgroundColor: isDark ? AppColorsDark.buttonPrimary : AppColorsLight.buttonPrimary,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

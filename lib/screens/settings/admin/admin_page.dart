import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.adminTitle,
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
                l10n.manageUsersAndReports,
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark ? AppColorsDark.textDisabled : AppColorsLight.textDisabled,
                ),
              ),
              const SizedBox(height: 24),
              SettingsMenuItem(
                iconPath: 'assets/icons/settings/user-round.svg',
                title: l10n.users,
                subtitle: l10n.viewManageUsers,
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
                title: l10n.feedback,
                subtitle: l10n.viewUserFeedback,
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
                title: l10n.reports,
                subtitle: l10n.exportUserData,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.featureAvailableSoon),
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

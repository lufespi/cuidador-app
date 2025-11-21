import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_card.dart';

class AppInfoPage extends StatelessWidget {
  const AppInfoPage({super.key});

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
          l10n.aboutTheApp,
          style: AppTypography.heading1Secondary,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              
              // Card - Objetivo
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.appObjective,
                      style: AppTypography.heading1Primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.appObjectiveDescription,
                      style: AppTypography.textPrimary,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Card - Funcionalidades
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.features,
                      style: AppTypography.heading1Primary,
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureItem(l10n.featurePainTracking),
                    _buildFeatureItem(l10n.featureReminders),
                    _buildFeatureItem(l10n.featurePractices),
                    _buildFeatureItem(l10n.featureEducation),
                    _buildFeatureItem(l10n.featureAccessibility),
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

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(
              Icons.check_circle,
              color: AppColors.buttonPrimary,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTypography.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

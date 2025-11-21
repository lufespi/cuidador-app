import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_card.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

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
          l10n.termsAndPrivacyTitle,
          style: AppTypography.heading1Secondary,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              
              // Card - Termos de Uso
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.termsOfUseTitle,
                      style: AppTypography.heading1Primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.termsIntro,
                      style: AppTypography.textPrimary,
                    ),
                    const SizedBox(height: 12),
                    _buildTermItem(l10n.termPurposeTitle, 
                      l10n.termPurposeDesc),
                    _buildTermItem(l10n.termResponsibilityTitle, 
                      l10n.termResponsibilityDesc),
                    _buildTermItem(l10n.termProperUseTitle, 
                      l10n.termProperUseDesc),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Card - Política de Privacidade
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.privacyPolicyTitle,
                      style: AppTypography.heading1Primary,
                    ),
                    const SizedBox(height: 12),
                    _buildTermItem(l10n.privacyDataCollectionTitle, 
                      l10n.privacyDataCollectionDesc),
                    _buildTermItem(l10n.privacyDataUsageTitle, 
                      l10n.privacyDataUsageDesc),
                    _buildTermItem(l10n.privacySharingTitle, 
                      l10n.privacySharingDesc),
                    _buildTermItem(l10n.privacySecurityTitle, 
                      l10n.privacySecurityDesc),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Card - Contato
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.questionsOrSuggestionsTitle,
                      style: AppTypography.heading1Primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.questionsOrSuggestionsDesc,
                      style: AppTypography.textPrimary,
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

  Widget _buildTermItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.heading2Primary,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: AppTypography.textPrimary,
          ),
        ],
      ),
    );
  }
}

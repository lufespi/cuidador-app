import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_tag.dart';
import '../../../core/widgets/content_section_card.dart';
import '../../../core/widgets/highlight_card.dart';
import '../../../l10n/app_localizations.dart';

class OsteoartriteDetailPage extends StatelessWidget {
  const OsteoartriteDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        title: Text(
          l10n.back,
          style: AppTypography.sectionTitle,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              Text(
                l10n.educationTopicOsteoarthritis,
                style: AppTypography.displayLarge,
              ),
              
              const SizedBox(height: 8),
              
              // Tags
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  AppTag.info(l10n.educationTagIntroduction),
                  AppTag.info(l10n.educationTagBasic),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Imagem ilustrativa
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).colorScheme.surface
                      : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.medical_information_outlined,
                  size: 80,
                  color: AppColors.buttonPrimary,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Conteúdo
              ContentSectionCard(
                title: l10n.osteoarthritisDefinition,
                icon: Icons.description_outlined,
                content: l10n.osteoarthritisDefinitionText,
              ),
              
              const SizedBox(height: 16),
              
              ContentSectionCard(
                title: l10n.osteoarthritisMainCauses,
                icon: Icons.help_outline,
                content: l10n.osteoarthritisMainCausesText,
              ),
              
              const SizedBox(height: 16),
              
              ContentSectionCard(
                title: l10n.osteoarthritisCommonSymptoms,
                icon: Icons.health_and_safety_outlined,
                content: l10n.osteoarthritisCommonSymptomsText,
              ),
              
              const SizedBox(height: 16),
              
              ContentSectionCard(
                title: l10n.osteoarthritisMostAffected,
                icon: Icons.location_on_outlined,
                content: l10n.osteoarthritisMostAffectedText,
              ),
              
              const SizedBox(height: 24),
              
              // Card de destaque
              HighlightCard(
                icon: Icons.info_outline,
                content: l10n.osteoarthritisHighlight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

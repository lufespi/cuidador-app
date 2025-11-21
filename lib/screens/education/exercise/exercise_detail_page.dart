import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_tag.dart';
import '../../../core/widgets/content_section_card.dart';
import '../../../core/widgets/highlight_card.dart';
import '../../../l10n/app_localizations.dart';

class ExerciseDetailPage extends StatelessWidget {
  const ExerciseDetailPage({super.key});

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
                l10n.educationTopicExercise,
                style: AppTypography.displayLarge,
              ),
              
              const SizedBox(height: 8),
              
              // Tags
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  AppTag.info(l10n.educationTagExercise),
                  AppTag.info(l10n.educationTagMovement),
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
                  Icons.fitness_center_outlined,
                  size: 80,
                  color: AppColors.buttonPrimary,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Conteúdo
              ContentSectionCard(
                title: l10n.exerciseBenefits,
                icon: Icons.star_outline,
                iconColor: const Color(0xFFF2A700),
                content: l10n.exerciseBenefitsText,
              ),
              
              const SizedBox(height: 16),
              
              ContentSectionCard(
                title: l10n.exerciseRecommendedTypes,
                icon: Icons.fitness_center_outlined,
                content: l10n.exerciseRecommendedTypesText,
              ),
              
              const SizedBox(height: 16),
              
              ContentSectionCard(
                title: l10n.exerciseRecommendedFrequency,
                icon: Icons.calendar_today_outlined,
                content: l10n.exerciseRecommendedFrequencyText,
              ),
              
              const SizedBox(height: 16),
              
              ContentSectionCard(
                title: l10n.exerciseTipsToStart,
                icon: Icons.lightbulb_outline,
                iconColor: const Color(0xFFF2A700),
                content: l10n.exerciseTipsToStartText,
              ),
              
              const SizedBox(height: 16),
              
              ContentSectionCard(
                title: l10n.exerciseWhenToAvoid,
                icon: Icons.block_outlined,
                iconColor: AppColors.stateError,
                content: l10n.exerciseWhenToAvoidText,
              ),
              
              const SizedBox(height: 24),
              
              // Card de destaque
              HighlightCard(
                icon: Icons.balance_outlined,
                iconColor: const Color(0xFFF2A700),
                content: l10n.exerciseHighlight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

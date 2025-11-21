import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_tag.dart';
import '../../../core/widgets/content_section_card.dart';
import '../../../core/widgets/highlight_card.dart';
import '../../../l10n/app_localizations.dart';

class NutritionDetailPage extends StatelessWidget {
  const NutritionDetailPage({super.key});

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
                l10n.educationTopicNutrition,
                style: AppTypography.displayLarge,
              ),
              
              const SizedBox(height: 8),
              
              // Tags
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  AppTag.info(l10n.educationTagDiet),
                  AppTag.info(l10n.educationTagNutrition),
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
                  Icons.restaurant_outlined,
                  size: 80,
                  color: AppColors.buttonPrimary,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Conteúdo
              ContentSectionCard(
                title: l10n.nutritionImportance,
                icon: Icons.favorite_outline,
                content: l10n.nutritionImportanceText,
              ),
              
              const SizedBox(height: 16),
              
              ContentSectionCard(
                title: l10n.nutritionRecommendedFoods,
                icon: Icons.check_circle_outline,
                iconColor: AppColors.stateSuccess,
                content: l10n.nutritionRecommendedFoodsText,
              ),
              
              const SizedBox(height: 16),
              
              ContentSectionCard(
                title: l10n.nutritionFoodsToAvoid,
                icon: Icons.cancel_outlined,
                iconColor: AppColors.stateError,
                content: l10n.nutritionFoodsToAvoidText,
              ),
              
              const SizedBox(height: 16),
              
              ContentSectionCard(
                title: l10n.nutritionHydration,
                icon: Icons.water_drop_outlined,
                iconColor: const Color(0xFF06B6D4),
                content: l10n.nutritionHydrationText,
              ),
              
              const SizedBox(height: 16),
              
              ContentSectionCard(
                title: l10n.nutritionSupplements,
                icon: Icons.medication_outlined,
                content: l10n.nutritionSupplementsText,
              ),
              
              const SizedBox(height: 24),
              
              // Card de destaque
              HighlightCard(
                icon: Icons.scale_outlined,
                content: l10n.nutritionHighlight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

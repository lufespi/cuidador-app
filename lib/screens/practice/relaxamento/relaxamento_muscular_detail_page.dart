import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_tag.dart';
import '../../../core/widgets/practice_timer_dialog.dart';
import '../../../l10n/app_localizations.dart';

class RelaxamentoMuscularDetailPage extends StatelessWidget {
  const RelaxamentoMuscularDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
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
              // Título e tags
              Text(
                l10n.practiceRelaxationTitle,
                style: AppTypography.practiceTitle,
              ),
              const SizedBox(height: 12),
              
              // Tags
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  AppTag.category(l10n.categoryRelaxation),
                  AppTag.info('10-15 min', icon: Icons.access_time),
                  AppTag.info(l10n.levelIntermediate),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Card de Benefícios
              _buildInfoCard(
                context: context,
                icon: 'assets/icons/practice/sparkles.svg',
                iconColor: const Color(0xFF06B6D4),
                title: l10n.benefits,
                content: l10n.practiceRelaxationBenefits,
              ),
              
              const SizedBox(height: 16),
              
              // Card de Como fazer
              _buildStepsCard(
                context: context,
                l10n: l10n,
                steps: [
                l10n.practiceRelaxationStep1,
                l10n.practiceRelaxationStep2,
                l10n.practiceRelaxationStep3,
              ]),
              
              const SizedBox(height: 16),
              
              // Card de Atenção
              _buildWarningCard(
                context: context,
                l10n: l10n,
                warning: l10n.practiceRelaxationWarning,
              ),
              
              const SizedBox(height: 24),
              
              // Botão Iniciar Sessão
              _buildStartButton(context, l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton(BuildContext context, AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => PracticeTimerDialog(
              durationInMinutes: 12,
              practiceTitle: l10n.practiceRelaxationTitle,
            ),
          );
        },
        icon: const Icon(
          Icons.play_arrow,
          color: Colors.white,
        ),
        label: Text(
          l10n.startSession,
          style: AppTypography.sectionTitle.copyWith(
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required String icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                icon,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  iconColor,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTypography.sectionTitle,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: AppTypography.bodyLarge.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepsCard({
    required BuildContext context,
    required AppLocalizations l10n,
    required List<String> steps,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/practice/footprints.svg',
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF06B6D4),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.howToDo,
                style: AppTypography.sectionTitle,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...steps.asMap().entries.map((entry) {
            final index = entry.key + 1;
            final step = entry.value;
            return Padding(
              padding: EdgeInsets.only(bottom: index < steps.length ? 12 : 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.buttonPrimary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '$index',
                        style: AppTypography.captionPrimary.copyWith(
                          color: AppColors.buttonPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      step,
                      style: AppTypography.bodyLarge.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildWarningCard({
    required BuildContext context,
    required AppLocalizations l10n,
    required String warning,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/practice/triangle-alert.svg',
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  Color(0xFFFBBF24),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.attention,
                style: AppTypography.sectionTitle,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            warning,
            style: AppTypography.bodyLarge.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

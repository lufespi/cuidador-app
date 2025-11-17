import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/practice_tag.dart';
import '../../../core/widgets/practice_timer_dialog.dart';

class RelaxamentoMuscularDetailPage extends StatelessWidget {
  const RelaxamentoMuscularDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
          ),
        ),
        title: Text(
          'Voltar',
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
                'Relaxamento Muscular',
                style: AppTypography.practiceTitle,
              ),
              const SizedBox(height: 12),
              
              // Tags
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  PracticeTag(
                    label: 'Relaxamento',
                    backgroundColor: AppColors.surfaceVariant,
                    textColor: AppColors.buttonPrimary,
                  ),
                  PracticeTag(
                    label: '10-15 min',
                    backgroundColor: AppColors.surfaceVariant,
                    textColor: AppColors.textDisabled,
                    icon: Icons.access_time,
                  ),
                  PracticeTag(
                    label: 'Intermediário',
                    backgroundColor: AppColors.surfaceVariant,
                    textColor: AppColors.textDisabled,
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Card de Benefícios
              _buildInfoCard(
                icon: 'assets/icons/practice/sparkles.svg',
                iconColor: const Color(0xFF06B6D4),
                title: 'Benefícios',
                content: 'Alivia tensão e dor muscular',
              ),
              
              const SizedBox(height: 16),
              
              // Card de Como fazer
              _buildStepsCard([
                'Deite-se confortavelmente',
                'Comece pelos pés:\n  • Contraia os músculos por 5 segundos\n  • Relaxe completamente por 10 segundos',
                'Suba pelo corpo:\n  • Panturrilhas\n  • Coxas\n  • Barriga\n  • Mãos e braços\n  • Ombros\n  • Rosto',
              ]),
              
              const SizedBox(height: 16),
              
              // Card de Atenção
              _buildWarningCard('Não force articulações doloridas'),
              
              const SizedBox(height: 24),
              
              // Botão Iniciar Sessão
              _buildStartButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const PracticeTimerDialog(
              durationInMinutes: 12,
              practiceTitle: 'Relaxamento Muscular',
            ),
          );
        },
        icon: const Icon(
          Icons.play_arrow,
          color: Colors.white,
        ),
        label: Text(
          'Iniciar Sessão',
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
    required String icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.inputBackground,
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
              color: AppColors.textDisabled,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepsCard(List<String> steps) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.inputBackground,
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
                'Como fazer',
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
                      color: AppColors.surfaceVariant,
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
                        color: AppColors.textDisabled,
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

  Widget _buildWarningCard(String warning) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.inputBackground,
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
                'Atenção',
                style: AppTypography.sectionTitle,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            warning,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textDisabled,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

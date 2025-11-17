import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'practice_tag.dart';

class PracticeCard extends StatelessWidget {
  final String iconPath;
  final Color iconBackgroundColor;
  final String title;
  final String description;
  final String categoryLabel;
  final String durationLabel;
  final String levelLabel;
  final VoidCallback onTap;

  const PracticeCard({
    super.key,
    required this.iconPath,
    required this.iconBackgroundColor,
    required this.title,
    required this.description,
    required this.categoryLabel,
    required this.durationLabel,
    required this.levelLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ícone
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBackgroundColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconPath,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    iconBackgroundColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Conteúdo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    title,
                    style: AppTypography.heading2Primary.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Descrição
                  Text(
                    description,
                    style: AppTypography.textPrimary.copyWith(
                      color: AppColors.textDisabled,
                      fontSize: 13,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Tags com quebra de linha
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      PracticeTag(
                        label: categoryLabel,
                        backgroundColor: AppColors.surfaceVariant,
                        textColor: AppColors.buttonPrimary,
                      ),
                      PracticeTag(
                        label: durationLabel,
                        backgroundColor: AppColors.surfaceVariant,
                        textColor: AppColors.textDisabled,
                        icon: Icons.access_time,
                      ),
                      PracticeTag(
                        label: levelLabel,
                        backgroundColor: AppColors.surfaceVariant,
                        textColor: AppColors.textDisabled,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 8),
            
            // Seta
            const Icon(
              Icons.chevron_right,
              color: AppColors.textDisabled,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

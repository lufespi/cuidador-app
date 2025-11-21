import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'app_tag.dart';

class EducationCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final List<String> tags;
  final VoidCallback onTap;

  const EducationCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.tags,
    required this.onTap,
  });

  IconData _getIconFromPath(String path) {
    if (path.contains('osteoartrite')) return Icons.medical_information_outlined;
    if (path.contains('nutrition')) return Icons.restaurant_outlined;
    if (path.contains('exercise')) return Icons.fitness_center_outlined;
    return Icons.school_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.inputDecorationTheme.fillColor ?? AppColors.inputBackground,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Imagem
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).colorScheme.surface
                      : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imagePath.startsWith('assets/')
                      ? Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.image_outlined,
                              color: Theme.of(context).colorScheme.primary,
                              size: 40,
                            );
                          },
                        )
                      : Icon(
                          _getIconFromPath(imagePath),
                          color: Theme.of(context).colorScheme.primary,
                          size: 40,
                        ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Conteúdo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.heading2Primary.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tags.map((tag) => AppTag.info(tag)).toList(),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Ícone de seta
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

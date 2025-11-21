import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'app_tag.dart';
import 'app_toggle.dart';

class ReminderCard extends StatelessWidget {
  final String title;
  final String description;
  final String frequency;
  final String time;
  final bool isActive;
  final IconData icon;
  final String type;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ReminderCard({
    super.key,
    required this.title,
    required this.description,
    required this.frequency,
    required this.time,
    required this.isActive,
    required this.icon,
    required this.type,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          Row(
            children: [
              // Ícone
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Conteúdo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: AppTypography.heading2Primary.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: onEdit,
                          icon: Icon(
                            Icons.edit_outlined,
                            size: 20,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: AppTypography.textPrimary.copyWith(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Toggle
              AppToggle(
                value: isActive,
                onChanged: (_) => onToggle(),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Tags de tipo, frequência e horário
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AppTag.category(type),
              AppTag.info(frequency),
              AppTag.info(
                time,
                icon: Icons.access_time,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'app_toggle.dart';

class ReminderCard extends StatelessWidget {
  final String title;
  final String description;
  final String frequency;
  final String time;
  final bool isActive;
  final IconData icon;
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
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.inputBackground,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                  color: AppColors.buttonPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppColors.buttonPrimary,
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
                          icon: const Icon(
                            Icons.edit_outlined,
                            size: 20,
                            color: AppColors.textDisabled,
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
                        color: AppColors.textDisabled,
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
          
          // Tags de frequência e horário
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  frequency,
                  style: AppTypography.textPrimary.copyWith(
                    fontSize: 12,
                    color: AppColors.buttonPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppColors.textDisabled,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: AppTypography.textPrimary.copyWith(
                        fontSize: 12,
                        color: AppColors.textDisabled,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

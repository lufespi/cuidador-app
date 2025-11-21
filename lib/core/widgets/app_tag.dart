import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Tag reutilizável para categorias, informações e metadados
/// Suporta modo Light e Dark automaticamente
class AppTag extends StatelessWidget {
  final String label;
  final IconData? icon;
  final AppTagType type;

  const AppTag({
    super.key,
    required this.label,
    this.icon,
    this.type = AppTagType.secondary,
  });

  /// Tag de categoria (verde)
  const AppTag.category(
    this.label, {
    super.key,
    this.icon,
  }) : type = AppTagType.primary;

  /// Tag de informação secundária (verde também)
  const AppTag.info(
    this.label, {
    super.key,
    this.icon,
  }) : type = AppTagType.secondary;

  @override
  Widget build(BuildContext context) {
    final isPrimary = type == AppTagType.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark 
            ? const Color(0xFF152E2E)  // Dark Mode
            : const Color(0xFFEAF9F9), // Light Mode
        borderRadius: BorderRadius.circular(12),
      ),
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 14,
                  color: AppColors.buttonPrimary,
                ),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: AppTypography.textPrimary.copyWith(
                    fontSize: 12,
                    color: AppColors.buttonPrimary,
                    fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            )
          : Text(
              label,
              style: AppTypography.textPrimary.copyWith(
                fontSize: 12,
                color: AppColors.buttonPrimary,
                fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
    );
  }
}

enum AppTagType {
  primary,   // Tag de categoria (bold)
  secondary, // Tag de informação (normal)
}

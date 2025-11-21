import 'package:flutter/material.dart';
import '../theme/app_typography.dart';

class PracticeTag extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;

  const PracticeTag({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final effectiveBgColor = backgroundColor ?? 
        (isDark ? theme.colorScheme.surface : theme.colorScheme.primary.withValues(alpha: 0.1));
    final effectiveTextColor = textColor ?? theme.colorScheme.primary;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 14,
              color: effectiveTextColor,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTypography.textPrimary.copyWith(
              color: effectiveTextColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

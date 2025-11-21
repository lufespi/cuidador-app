import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class AppDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? hint;

  const AppDropdown({
    super.key,
    this.value,
    required this.items,
    required this.onChanged,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark 
            ? theme.colorScheme.surface
            : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: DropdownButton<T>(
        value: value,
        underline: const SizedBox(),
        isDense: true,
        hint: hint != null
            ? Text(
                hint!,
                style: AppTypography.captionPrimary,
              )
            : null,
        icon: Icon(
          Icons.keyboard_arrow_down,
          size: 18,
          color: Theme.of(context).colorScheme.primary,
        ),
        style: AppTypography.captionPrimary.copyWith(
          color: theme.colorScheme.onSurface,
        ),
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}

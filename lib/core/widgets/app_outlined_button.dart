import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class AppOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Widget? icon;
  final bool enabled;

  const AppOutlinedButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: enabled ? onPressed : null,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: enabled ? AppColors.buttonPrimary : AppColors.textDisabled,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon!,
                const SizedBox(width: 8),
                Text(
                  label,
                  style: AppTypography.heading2Primary.copyWith(
                    color: enabled ? AppColors.buttonPrimary : AppColors.textDisabled,
                  ),
                ),
              ],
            )
          : Text(
              label,
              style: AppTypography.heading2Primary.copyWith(
                color: enabled ? AppColors.buttonPrimary : AppColors.textDisabled,
              ),
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class SettingsMenuItem extends StatelessWidget {
  final String? iconPath;
  final IconData? icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool showDivider;

  const SettingsMenuItem({
    super.key,
    this.iconPath,
    this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.showDivider = true,
  }) : assert(iconPath != null || icon != null, 'Forneça iconPath ou icon');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
            child: Row(
              children: [
                // Ícone
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  child: icon != null
                      ? Icon(
                          icon,
                          size: 24,
                          color: Theme.of(context).colorScheme.onSurface,
                        )
                      : SvgPicture.asset(
                          iconPath!,
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.onSurface,
                            BlendMode.srcIn,
                          ),
                        ),
                ),
                const SizedBox(width: 16),
                // Textos
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.heading2Primary,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: AppTypography.textPrimary.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                // Seta (chevron)
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        // Divider
        if (showDivider)
          Container(
            height: 1,
            color: AppColors.inputBackground,
          ),
      ],
    );
  }
}

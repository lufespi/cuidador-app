import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'app_button.dart';

/// Widget reutilizável para slider de abas (Entrar/Criar Conta)
class AppTabSlider extends StatelessWidget {
  final List<String> tabs;
  final int activeIndex;
  final ValueChanged<int> onTabChanged;
  final double height;

  const AppTabSlider({
    super.key,
    required this.tabs,
    required this.activeIndex,
    required this.onTabChanged,
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.inputDecorationTheme.fillColor ?? AppColors.inputBackground,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 50 : 25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: List.generate(
          tabs.length,
          (index) => Expanded(
            child: AppButton.tab(
              label: tabs[index],
              isActive: activeIndex == index,
              onPressed: () {
                onTabChanged(index);
              },
            ),
          ),
        ),
      ),
    );
  }
}

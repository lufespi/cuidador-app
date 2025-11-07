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
    Key? key,
    required this.tabs,
    required this.activeIndex,
    required this.onTabChanged,
    this.height = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.buttonSurface,
        borderRadius: BorderRadius.circular(28),
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

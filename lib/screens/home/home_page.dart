import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';
import '../dor/dor_page.dart';
import '../practice/practice_page.dart';
import '../education/education_page.dart';
import '../reminders/reminders_page.dart';
import '../settings/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DorPage(),
    const PracticePage(),
    const EducationPage(),
    const RemindersPage(),
    const SettingsPage(),
  ];

  Widget _buildNavIcon(String assetPath, int index, {bool filled = false}) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? AppColors.buttonPrimary : AppColors.textDisabled;
    
    if (filled && isSelected) {
      // Renderiza o ícone com preenchimento quando selecionado
      return Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            assetPath,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              color.withValues(alpha: 0.2),
              BlendMode.srcIn,
            ),
          ),
          SvgPicture.asset(
            assetPath,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              color,
              BlendMode.srcIn,
            ),
          ),
        ],
      );
    }
    
    return SvgPicture.asset(
      assetPath,
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(
        color,
        BlendMode.srcIn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.buttonPrimary,
        unselectedItemColor: AppColors.textDisabled,
        items: [
          BottomNavigationBarItem(
            icon: _buildNavIcon('assets/icons/navigation-bar/activity.svg', 0),
            label: l10n.navPain,
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon('assets/icons/navigation-bar/heart.svg', 1, filled: true),
            label: l10n.navPractices,
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon('assets/icons/navigation-bar/book-open.svg', 2, filled: true),
            label: l10n.navEducation,
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon('assets/icons/navigation-bar/bell.svg', 3, filled: true),
            label: l10n.navReminders,
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon('assets/icons/navigation-bar/settings.svg', 4, filled: true),
            label: l10n.navSettings,
          ),
        ],
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          title,
          style: AppTypography.heading1Primary,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: AppColors.textDisabled,
            ),
            const SizedBox(height: 16),
            Text(
              'Página $title',
              style: AppTypography.heading1Primary,
            ),
            const SizedBox(height: 8),
            Text(
              'Em desenvolvimento',
              style: AppTypography.heading2Primary.copyWith(
                color: AppColors.textDisabled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/practice_card.dart';
import '../../l10n/app_localizations.dart';
import 'respiratorio/respiratorio_detail_page.dart';
import 'alongamento/alongamento_detail_page.dart';
import 'liangong/liangong_detail_page.dart';
import 'respiratorio_profundo/respiratorio_profundo_detail_page.dart';
import 'suspiro/suspiro_alivio_detail_page.dart';
import 'relaxamento/relaxamento_muscular_detail_page.dart';
import 'toque/toque_calmante_detail_page.dart';

class PracticePage extends StatefulWidget {
  const PracticePage({super.key});

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  
  List<Map<String, dynamic>> _getPractices(AppLocalizations l10n) {
    return [
      {
        'title': l10n.practice478Title,
        'description': l10n.practice478Description,
        'iconPath': 'assets/icons/practice/wind.svg',
        'iconColor': const Color(0xFF3B82F6),
        'category': l10n.categoryBreathing,
        'duration': '5 min',
        'level': l10n.levelBeginner,
        'type': 'respiratorio',
      },
      {
        'title': l10n.practiceStretchingTitle,
        'description': l10n.practiceStretchingDescription,
        'iconPath': 'assets/icons/practice/sparkles.svg',
        'iconColor': const Color(0xFF8B5CF6),
        'category': l10n.categoryStretching,
        'duration': '5 min',
        'level': l10n.levelBeginner,
        'type': 'alongamento',
      },
      {
        'title': l10n.practiceLiangongTitle,
        'description': l10n.practiceLiangongDescription,
        'iconPath': 'assets/icons/practice/heart.svg',
        'iconColor': const Color(0xFFEC4899),
        'category': l10n.categoryLianGong,
        'duration': '8 min',
        'level': l10n.levelIntermediate,
        'type': 'liangong',
      },
      {
        'title': l10n.practiceDeepBreathingTitle,
        'description': l10n.practiceDeepBreathingDescription,
        'iconPath': 'assets/icons/practice/wind.svg',
        'iconColor': const Color(0xFF3B82F6),
        'category': l10n.categoryBreathing,
        'duration': '5 min',
        'level': l10n.levelBeginner,
        'type': 'respiratorio_profundo',
      },
      {
        'title': l10n.practiceSighTitle,
        'description': l10n.practiceSighDescription,
        'iconPath': 'assets/icons/practice/wind.svg',
        'iconColor': const Color(0xFF3B82F6),
        'category': l10n.categoryBreathing,
        'duration': '2 min',
        'level': l10n.levelBeginner,
        'type': 'suspiro',
      },
      {
        'title': l10n.practiceRelaxationTitle,
        'description': l10n.practiceRelaxationDescription,
        'iconPath': 'assets/icons/practice/sparkles.svg',
        'iconColor': const Color(0xFF10B981),
        'category': l10n.categoryRelaxation,
        'duration': '10-15 min',
        'level': l10n.levelIntermediate,
        'type': 'relaxamento',
      },
      {
        'title': l10n.practiceTouchTitle,
        'description': l10n.practiceTouchDescription,
        'iconPath': 'assets/icons/practice/heart.svg',
        'iconColor': const Color(0xFF06B6D4),
        'category': l10n.categoryTouch,
        'duration': '5 min',
        'level': l10n.levelBeginner,
        'type': 'toque',
      },
    ];
  }

  void _showPracticeDetails(Map<String, dynamic> practice) {
    Widget page;
    
    switch (practice['type']) {
      case 'respiratorio':
        page = const RespiratorioDetailPage();
        break;
      case 'alongamento':
        page = const AlongamentoDetailPage();
        break;
      case 'liangong':
        page = const LiangongDetailPage();
        break;
      case 'respiratorio_profundo':
        page = const RespiratorioRapidoDetailPage();
        break;
      case 'suspiro':
        page = const SuspiroAlivioDetailPage();
        break;
      case 'relaxamento':
        page = const RelaxamentoMuscularDetailPage();
        break;
      case 'toque':
        page = const ToqueCalmanteDetailPage();
        break;
      default:
        return;
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final practices = _getPractices(l10n);
    
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/practice/dumbbell.svg',
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            AppColors.buttonPrimary,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          l10n.practicesTitle,
                          style: AppTypography.pageTitle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.practicesSubtitle,
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textDisabled,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Lista de práticas
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final practice = practices[index];
                    return PracticeCard(
                      iconPath: practice['iconPath'],
                      iconBackgroundColor: practice['iconColor'],
                      title: practice['title'],
                      description: practice['description'],
                      categoryLabel: practice['category'],
                      durationLabel: practice['duration'],
                      levelLabel: practice['level'],
                      onTap: () => _showPracticeDetails(practice),
                    );
                  },
                  childCount: practices.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

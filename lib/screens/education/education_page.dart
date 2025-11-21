import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/education_card.dart';
import '../../l10n/app_localizations.dart';
import 'osteoartrite/osteoartrite_detail_page.dart';
import 'nutrition/nutrition_detail_page.dart';
import 'exercise/exercise_detail_page.dart';

class EducationPage extends StatefulWidget {
  const EducationPage({super.key});

  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {
  
  List<Map<String, dynamic>> _getEducationTopics(AppLocalizations l10n) {
    return [
      {
        'title': l10n.educationTopicOsteoarthritis,
        'imagePath': 'assets/images/old-woman.png',
        'tags': [l10n.educationTagIntroduction, l10n.educationTagBasic],
        'type': 'osteoartrite',
      },
      {
        'title': l10n.educationTopicNutrition,
        'imagePath': 'assets/images/doctor.png',
        'tags': [l10n.educationTagDiet, l10n.educationTagNutrition],
        'type': 'nutrition',
      },
      {
        'title': l10n.educationTopicExercise,
        'imagePath': 'assets/images/woman-exercise.png',
        'tags': [l10n.educationTagExercise, l10n.educationTagMovement],
        'type': 'exercise',
      },
    ];
  }

  void _showTopicDetails(Map<String, dynamic> topic) {
    Widget page;
    
    switch (topic['type']) {
      case 'osteoartrite':
        page = const OsteoartriteDetailPage();
        break;
      case 'nutrition':
        page = const NutritionDetailPage();
        break;
      case 'exercise':
        page = const ExerciseDetailPage();
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
    final educationTopics = _getEducationTopics(l10n);
    
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
                        const Icon(
                          Icons.school_outlined,
                          color: AppColors.buttonPrimary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          l10n.educationTitle,
                          style: AppTypography.pageTitle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.educationSubtitle,
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textDisabled,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Lista de tópicos
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final topic = educationTopics[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: EducationCard(
                        title: topic['title'],
                        imagePath: topic['imagePath'],
                        tags: List<String>.from(topic['tags']),
                        onTap: () => _showTopicDetails(topic),
                      ),
                    );
                  },
                  childCount: educationTopics.length,
                ),
              ),
            ),
            
            // Espaço inferior
            const SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),
          ],
        ),
      ),
    );
  }
}

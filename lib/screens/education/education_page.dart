import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/education_card.dart';
import 'osteoartrite/osteoartrite_detail_page.dart';
import 'nutrition/nutrition_detail_page.dart';
import 'exercise/exercise_detail_page.dart';

class EducationPage extends StatefulWidget {
  const EducationPage({super.key});

  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {
  
  final List<Map<String, dynamic>> _educationTopics = [
    {
      'title': 'O que é Osteoartrite?',
      'imagePath': 'assets/images/old-woman.png',
      'tags': ['Introdução', 'Básico'],
      'type': 'osteoartrite',
    },
    {
      'title': 'Nutrição e Saúde das Articulações',
      'imagePath': 'assets/images/doctor.png',
      'tags': ['Dieta', 'Nutrição'],
      'type': 'nutrition',
    },
    {
      'title': 'Exercícios e Movimento',
      'imagePath': 'assets/images/woman-exercise.png',
      'tags': ['Exercício', 'Movimento'],
      'type': 'exercise',
    },
  ];

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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.school_outlined,
                            color: AppColors.buttonPrimary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Educação',
                                style: AppTypography.heading1Primary.copyWith(
                                  fontSize: 24,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Aprenda sobre osteoartrite e autocuidado',
                                style: AppTypography.textPrimary.copyWith(
                                  color: AppColors.textDisabled,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                    final topic = _educationTopics[index];
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
                  childCount: _educationTopics.length,
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

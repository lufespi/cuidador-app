import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/practice_card.dart';
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
  
  final List<Map<String, dynamic>> _practices = [
    {
      'title': 'Respiração 4-7-8',
      'description': 'Acalma o sistema nervoso, reduz ansiedade e pode melhorar a percepção da dor. Ideal antes de dormir.',
      'iconPath': 'assets/icons/practice/wind.svg',
      'iconColor': const Color(0xFF3B82F6), // Azul
      'category': 'Respiração',
      'duration': '5 min',
      'level': 'Iniciante',
      'type': 'respiratorio',
    },
    {
      'title': 'Alongamento de Mãos',
      'description': 'Bom para rigidez matinal. Melhora mobilidade das articulações dos dedos.',
      'iconPath': 'assets/icons/practice/sparkles.svg',
      'iconColor': const Color(0xFF8B5CF6), // Roxo
      'category': 'Alongamento',
      'duration': '5 min',
      'level': 'Iniciante',
      'type': 'alongamento',
    },
    {
      'title': 'LianGong - Rotação de Ombros',
      'description': 'Melhora mobilidade dos ombros, reduz tensão na região cervical.',
      'iconPath': 'assets/icons/practice/heart.svg',
      'iconColor': const Color(0xFFEC4899), // Rosa
      'category': 'LianGong',
      'duration': '8 min',
      'level': 'Intermediário',
      'type': 'liangong',
    },
    {
      'title': 'Respiração Profunda',
      'description': 'Reduz tensão e ansiedade através da respiração diafragmática controlada.',
      'iconPath': 'assets/icons/practice/wind.svg',
      'iconColor': const Color(0xFF3B82F6), // Azul
      'category': 'Respiração',
      'duration': '5 min',
      'level': 'Iniciante',
      'type': 'respiratorio_profundo',
    },
    {
      'title': 'Suspiro de Alívio',
      'description': 'Libera tensão rapidamente através de suspiros profundos e audíveis.',
      'iconPath': 'assets/icons/practice/wind.svg',
      'iconColor': const Color(0xFF3B82F6), // Azul
      'category': 'Respiração',
      'duration': '2 min',
      'level': 'Iniciante',
      'type': 'suspiro',
    },
    {
      'title': 'Relaxamento Muscular',
      'description': 'Alivia tensão muscular através de contração e relaxamento progressivo.',
      'iconPath': 'assets/icons/practice/sparkles.svg',
      'iconColor': const Color(0xFF10B981), // Verde
      'category': 'Relaxamento',
      'duration': '10-15 min',
      'level': 'Intermediário',
      'type': 'relaxamento',
    },
    {
      'title': 'Toque Calmante',
      'description': 'Proporciona conforto imediato através do calor das mãos e toques suaves.',
      'iconPath': 'assets/icons/practice/heart.svg',
      'iconColor': const Color(0xFF06B6D4), // Ciano
      'category': 'Toque',
      'duration': '5 min',
      'level': 'Iniciante',
      'type': 'toque',
    },
  ];

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
                          'Práticas de Bem-Estar',
                          style: AppTypography.pageTitle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Exercícios e técnicas para aliviar a dor',
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
                    final practice = _practices[index];
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
                  childCount: _practices.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

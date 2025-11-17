import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/content_section_card.dart';
import '../../../core/widgets/highlight_card.dart';

class ExerciseDetailPage extends StatelessWidget {
  const ExerciseDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
          ),
        ),
        title: Text(
          'Voltar',
          style: AppTypography.sectionTitle,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              Text(
                'Exercícios e Movimento',
                style: AppTypography.displayLarge,
              ),
              
              const SizedBox(height: 8),
              
              // Tags
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildTag('Exercício'),
                  _buildTag('Movimento'),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Imagem ilustrativa
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.fitness_center_outlined,
                  size: 80,
                  color: AppColors.buttonPrimary,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Conteúdo
              ContentSectionCard(
                title: 'Benefícios do Exercício',
                icon: Icons.star_outline,
                iconColor: const Color(0xFFF2A700),
                content: 'O exercício regular é fundamental para gerenciar a osteoartrite. Ele ajuda a fortalecer os músculos ao redor das articulações, manter a flexibilidade, reduzir a dor e melhorar o humor.',
              ),
              
              const SizedBox(height: 16),
              
              ContentSectionCard(
                title: 'Tipos de Exercícios Recomendados',
                icon: Icons.fitness_center_outlined,
                content: '• Exercícios aeróbicos de baixo impacto (caminhada, natação, ciclismo)\n• Exercícios de fortalecimento muscular\n• Alongamentos e exercícios de flexibilidade\n• Exercícios de equilíbrio\n• Atividades aquáticas\n• Tai Chi e Yoga adaptados',
              ),
              
              const SizedBox(height: 16),
              
              ContentSectionCard(
                title: 'Frequência Recomendada',
                icon: Icons.calendar_today_outlined,
                content: '• Aeróbico: 30 minutos, 5 dias por semana\n• Fortalecimento: 2-3 vezes por semana\n• Flexibilidade: Diariamente\n• Sempre respeite seus limites e descanse quando necessário',
              ),
              
              const SizedBox(height: 16),
              
              ContentSectionCard(
                title: 'Dicas para Começar',
                icon: Icons.lightbulb_outline,
                iconColor: const Color(0xFFF2A700),
                content: '• Comece devagar e aumente gradualmente\n• Aqueça antes e alongue depois\n• Escolha atividades de baixo impacto\n• Use calçados adequados\n• Ouça seu corpo e pare se sentir dor\n• Mantenha-se consistente',
              ),
              
              const SizedBox(height: 16),
              
              ContentSectionCard(
                title: 'Quando Evitar Exercícios',
                icon: Icons.block_outlined,
                iconColor: AppColors.stateError,
                content: '• Durante crises de inflamação aguda\n• Se houver dor intensa\n• Após lesões não tratadas\n• Sempre consulte seu médico antes de iniciar um novo programa de exercícios',
              ),
              
              const SizedBox(height: 24),
              
              // Card de destaque
              const HighlightCard(
                icon: Icons.balance_outlined,
                iconColor: Color(0xFFF2A700),
                content: 'O movimento é essencial, mas é importante encontrar o equilíbrio certo. Nem muito pouco, nem demais.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: AppTypography.label.copyWith(
          color: AppColors.buttonPrimary,
        ),
      ),
    );
  }
}

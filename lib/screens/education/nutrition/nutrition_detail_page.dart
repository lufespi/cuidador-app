import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/content_section_card.dart';
import '../../../core/widgets/highlight_card.dart';

class NutritionDetailPage extends StatelessWidget {
  const NutritionDetailPage({super.key});

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
                'Nutrição e Saúde das Articulações',
                style: AppTypography.displayLarge,
              ),
              
              const SizedBox(height: 8),
              
              // Tags
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildTag('Dieta'),
                  _buildTag('Nutrição'),
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
                  Icons.restaurant_outlined,
                  size: 80,
                  color: AppColors.buttonPrimary,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Conteúdo
              ContentSectionCard(
                title: 'Importância da Nutrição',
                icon: Icons.favorite_outline,
                content: 'Uma dieta equilibrada desempenha papel fundamental na saúde das articulações. Os alimentos certos podem ajudar a reduzir inflamação, fortalecer ossos e cartilagens, e controlar o peso corporal.',
              ),
              
              const SizedBox(height: 16),
              
              ContentSectionCard(
                title: 'Alimentos Recomendados',
                icon: Icons.check_circle_outline,
                iconColor: AppColors.stateSuccess,
                content: '• Peixes ricos em ômega-3 (salmão, sardinha)\n• Frutas vermelhas e cítricas\n• Vegetais verde-escuros\n• Nozes e sementes\n• Azeite de oliva extravirgem\n• Alimentos ricos em vitamina D\n• Chá verde\n• Gengibre e cúrcuma',
              ),
              
              const SizedBox(height: 16),
              
              ContentSectionCard(
                title: 'Alimentos a Evitar',
                icon: Icons.cancel_outlined,
                iconColor: AppColors.stateError,
                content: '• Açúcares refinados\n• Alimentos processados\n• Gorduras trans\n• Excesso de sal\n• Carnes vermelhas em excesso\n• Bebidas açucaradas',
              ),
              
              const SizedBox(height: 16),
              
              ContentSectionCard(
                title: 'Hidratação',
                icon: Icons.water_drop_outlined,
                iconColor: const Color(0xFF06B6D4),
                content: 'Beber água suficiente é essencial para manter as articulações lubrificadas. A cartilagem contém cerca de 80% de água, e a desidratação pode aumentar o atrito nas articulações.',
              ),
              
              const SizedBox(height: 16),
              
              ContentSectionCard(
                title: 'Suplementos Úteis',
                icon: Icons.medication_outlined,
                content: '• Glucosamina e condroitina\n• Colágeno tipo II\n• Vitamina D e cálcio\n• Ômega-3\n• Vitamina C\n\nConsulte sempre um profissional de saúde antes de iniciar qualquer suplementação.',
              ),
              
              const SizedBox(height: 24),
              
              // Card de destaque
              const HighlightCard(
                icon: Icons.scale_outlined,
                content: 'Manter um peso saudável reduz a carga nas articulações e pode diminuir significativamente a dor.',
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

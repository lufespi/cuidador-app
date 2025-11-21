import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_tag.dart';
import '../../../core/widgets/content_section_card.dart';
import '../../../core/widgets/highlight_card.dart';

class OsteoartriteDetailPage extends StatelessWidget {
  const OsteoartriteDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
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
                'O que é Osteoartrite?',
                style: AppTypography.displayLarge,
              ),
              
              const SizedBox(height: 8),
              
              // Tags
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  AppTag.info('Introdução'),
                  AppTag.info('Básico'),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Imagem ilustrativa
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).colorScheme.surface
                      : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.medical_information_outlined,
                  size: 80,
                  color: AppColors.buttonPrimary,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Conteúdo
              ContentSectionCard(
                title: 'Definição',
                icon: Icons.description_outlined,
                content: 'A osteoartrite, também conhecida como artrose, é uma doença degenerativa das articulações que afeta principalmente a cartilagem. É o tipo mais comum de artrite e pode causar dor, rigidez e limitação de movimento.',
              ),
              
              const SizedBox(height: 16),
              
              ContentSectionCard(
                title: 'Causas Principais',
                icon: Icons.help_outline,
                content: '• Envelhecimento natural\n• Sobrepeso e obesidade\n• Lesões articulares anteriores\n• Uso repetitivo das articulações\n• Fatores genéticos\n• Deformidades ósseas',
              ),
              
              const SizedBox(height: 16),
              
              ContentSectionCard(
                title: 'Sintomas Comuns',
                icon: Icons.health_and_safety_outlined,
                content: '• Dor nas articulações durante ou após movimento\n• Rigidez, especialmente ao acordar\n• Perda de flexibilidade\n• Sensação de atrito ao mover a articulação\n• Inchaço ao redor da articulação',
              ),
              
              const SizedBox(height: 16),
              
              ContentSectionCard(
                title: 'Articulações Mais Afetadas',
                icon: Icons.location_on_outlined,
                content: '• Joelhos\n• Quadris\n• Mãos e dedos\n• Coluna vertebral\n• Dedos dos pés',
              ),
              
              const SizedBox(height: 24),
              
              // Card de destaque
              const HighlightCard(
                icon: Icons.info_outline,
                content: 'Embora não tenha cura, a osteoartrite pode ser gerenciada com tratamento adequado, exercícios e mudanças no estilo de vida.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

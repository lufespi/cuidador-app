import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Widget reutilizável para card de seleção de parte do corpo com imagem
class BodyPartCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  const BodyPartCard({
    Key? key,
    required this.imagePath,
    required this.label,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.buttonPrimary.withValues(alpha: 0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.buttonPrimary : AppColors.buttonPrimary.withValues(alpha: 0.5),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                label,
                style: AppTypography.textPrimary.copyWith(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? AppColors.buttonPrimary : AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card carrossel sem texto - apenas ícone
class BodyPartCarouselCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  const BodyPartCarouselCard({
    Key? key,
    required this.imagePath,
    required this.label,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.buttonPrimary.withValues(alpha: 0.1) : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.buttonPrimary : AppColors.buttonPrimary.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

/// Carrossel horizontal de seleção de partes do corpo
class BodyPartCarousel extends StatefulWidget {
  final List<Map<String, String>> bodyParts; // {imagePath, label}
  final Function(String) onPartSelected;
  final String? selectedPart;

  const BodyPartCarousel({
    Key? key,
    required this.bodyParts,
    required this.onPartSelected,
    this.selectedPart,
  }) : super(key: key);

  @override
  State<BodyPartCarousel> createState() => _BodyPartCarouselState();
}

class _BodyPartCarouselState extends State<BodyPartCarousel> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Você também pode selecionar outras regiões do corpo',
            style: AppTypography.heading2Primary,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 156,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.bodyParts.length,
            itemBuilder: (context, index) {
              final part = widget.bodyParts[index];
              return BodyPartCarouselCard(
                imagePath: part['imagePath']!,
                label: part['label']!,
                isSelected: widget.selectedPart == part['label'],
                onTap: () => widget.onPartSelected(part['label']!),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Widget reutilizável para grid de seleção de partes do corpo
class BodyPartGrid extends StatelessWidget {
  final List<Map<String, String>> bodyParts; // {imagePath, label}
  final Function(String) onPartSelected;
  final String? selectedPart;

  const BodyPartGrid({
    Key? key,
    required this.bodyParts,
    required this.onPartSelected,
    this.selectedPart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Selecione outra parte do corpo',
            style: AppTypography.heading2Primary,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.8,
            ),
            itemCount: bodyParts.length,
            itemBuilder: (context, index) {
              final part = bodyParts[index];
              return BodyPartCard(
                imagePath: part['imagePath']!,
                label: part['label']!,
                isSelected: selectedPart == part['label'],
                onTap: () => onPartSelected(part['label']!),
              );
            },
          ),
        ),
      ],
    );
  }
}


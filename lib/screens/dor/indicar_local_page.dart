import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class IndicarLocalPage extends StatefulWidget {
  const IndicarLocalPage({super.key});

  @override
  State<IndicarLocalPage> createState() => _IndicarLocalPageState();
}

class _IndicarLocalPageState extends State<IndicarLocalPage> {
  // Pontos fixos com base nas coordenadas coletadas
  final List<Map<String, double>> _pontosFixes = [
    {'x': 220.53, 'y': 382.63, 'width': 320.00, 'height': 676.80},
    {'x': 245.73, 'y': 397.06, 'width': 320.00, 'height': 676.80},
    {'x': 266.56, 'y': 383.57, 'width': 320.00, 'height': 676.80},
    {'x': 273.23, 'y': 355.75, 'width': 320.00, 'height': 676.80},
    {'x': 155.76, 'y': 97.13, 'width': 320.00, 'height': 676.80},
    {'x': 174.55, 'y': 122.90, 'width': 320.00, 'height': 676.80},
    {'x': 138.54, 'y': 124.43, 'width': 320.00, 'height': 676.80},
    {'x': 158.91, 'y': 154.87, 'width': 320.00, 'height': 676.80},
    {'x': 206.73, 'y': 187.15, 'width': 320.00, 'height': 676.80},
    {'x': 110.67, 'y': 184.74, 'width': 320.00, 'height': 676.80},
    {'x': 158.28, 'y': 218.86, 'width': 320.00, 'height': 676.80},
    {'x': 183.26, 'y': 249.56, 'width': 320.00, 'height': 676.80},
    {'x': 129.83, 'y': 253.03, 'width': 320.00, 'height': 676.80},
    {'x': 158.17, 'y': 304.21, 'width': 320.00, 'height': 676.80},
    {'x': 189.09, 'y': 368.09, 'width': 320.00, 'height': 676.80},
    {'x': 129.72, 'y': 366.35, 'width': 320.00, 'height': 676.80},
    {'x': 223.57, 'y': 263.42, 'width': 320.00, 'height': 676.80},
    {'x': 93.14, 'y': 267.78, 'width': 320.00, 'height': 676.80},
    {'x': 235.18, 'y': 323.78, 'width': 320.00, 'height': 676.80},
    {'x': 83.11, 'y': 325.36, 'width': 320.00, 'height': 676.80},
    {'x': 99.75, 'y': 381.05, 'width': 320.00, 'height': 676.80},
    {'x': 74.03, 'y': 391.55, 'width': 320.00, 'height': 676.80},
    {'x': 49.57, 'y': 376.59, 'width': 320.00, 'height': 676.80},
    {'x': 47.10, 'y': 351.71, 'width': 320.00, 'height': 676.80},
    {'x': 199.43, 'y': 450.18, 'width': 320.00, 'height': 676.80},
    {'x': 121.90, 'y': 451.23, 'width': 320.00, 'height': 676.80},
    {'x': 209.61, 'y': 548.23, 'width': 320.00, 'height': 676.80},
    {'x': 235.96, 'y': 579.20, 'width': 320.00, 'height': 676.80},
    {'x': 116.49, 'y': 540.36, 'width': 320.00, 'height': 676.80},
    {'x': 91.61, 'y': 581.04, 'width': 320.00, 'height': 676.80},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.buttonPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Indicar o Local da Dor',
              style: AppTypography.heading1Secondary,
            ),
            Text(
              'Toque no região onde você sente dor',
              style: AppTypography.textPrimary.copyWith(
                color: AppColors.textWhite,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: _buildCorpoHumano(),
        ),
      ),
    );
  }

  Widget _buildCorpoHumano() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.buttonPrimary.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Stack(
              children: [
                // Imagem do corpo humano
                Center(
                  child: Image.asset(
                    'assets/images/body-image.png',
                    fit: BoxFit.contain,
                    height: constraints.maxHeight * 0.9,
                  ),
                ),
                
                // Bolinhas nos pontos fixos
                ..._pontosFixes.asMap().entries.map((entry) {
                  final ponto = entry.value;
                  // Calcula a posição proporcional baseada no tamanho atual do container
                  final percentualX = ponto['x']! / ponto['width']!;
                  final percentualY = ponto['y']! / ponto['height']!;
                  final posX = constraints.maxWidth * percentualX;
                  final posY = constraints.maxHeight * percentualY;
                  
                  return Positioned(
                    left: posX - 10,
                    top: posY - 10,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.buttonPrimary.withOpacity(0.8),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.textWhite,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.buttonPrimary.withOpacity(0.6),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class IndicarLocalPage extends StatefulWidget {
  const IndicarLocalPage({super.key});

  @override
  State<IndicarLocalPage> createState() => _IndicarLocalPageState();
}

class _IndicarLocalPageState extends State<IndicarLocalPage> {
  // Lista para armazenar os pontos clicados para visualização
  final List<Offset> _pontosClicados = [];

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
        return GestureDetector(
          onTapDown: (details) {
            // Captura a posição do clique e imprime no debug
            final position = details.localPosition;
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            
            // Adiciona o ponto à lista para visualização
            setState(() {
              _pontosClicados.add(position);
            });
            
            // Imprime informações detalhadas no console
            debugPrint('═══════════════════════════════════════');
            debugPrint('🎯 POSIÇÃO CLICADA #${_pontosClicados.length}:');
            debugPrint('   X: ${position.dx.toStringAsFixed(2)}');
            debugPrint('   Y: ${position.dy.toStringAsFixed(2)}');
            debugPrint('   Container Width: ${width.toStringAsFixed(2)}');
            debugPrint('   Container Height: ${height.toStringAsFixed(2)}');
            debugPrint('   Percentual X: ${(position.dx / width * 100).toStringAsFixed(2)}%');
            debugPrint('   Percentual Y: ${(position.dy / height * 100).toStringAsFixed(2)}%');
            debugPrint('═══════════════════════════════════════\n');
          },
          child: Container(
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
                
                // Bolinhas nos pontos clicados
                ..._pontosClicados.asMap().entries.map((entry) {
                  return Positioned(
                    left: entry.value.dx - 10,
                    top: entry.value.dy - 10,
                    child: GestureDetector(
                      onTap: () {
                        // Remove o ponto ao clicar nele
                        setState(() {
                          _pontosClicados.removeAt(entry.key);
                        });
                        debugPrint('❌ Ponto #${entry.key + 1} removido');
                      },
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
                        child: Center(
                          child: Text(
                            '${entry.key + 1}',
                            style: AppTypography.textPrimary.copyWith(
                              color: AppColors.textWhite,
                              fontWeight: FontWeight.bold,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
                
                // Texto de instrução para debug
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.buttonPrimary.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '🔍 MODO DEBUG: Toque na tela e veja as coordenadas no console',
                          textAlign: TextAlign.center,
                          style: AppTypography.textPrimary.copyWith(
                            color: AppColors.textWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (_pontosClicados.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Toque nas bolinhas para removê-las • ${_pontosClicados.length} ponto(s)',
                            textAlign: TextAlign.center,
                            style: AppTypography.textPrimary.copyWith(
                              color: AppColors.textWhite,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

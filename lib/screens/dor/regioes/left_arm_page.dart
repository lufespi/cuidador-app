import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/body_part_selector.dart';
import 'head_page.dart';
import 'torso_page.dart';
import 'right_arm_page.dart';
import 'left_hand_page.dart';
import 'right_hand_page.dart';
import 'left_leg_page.dart';
import 'right_leg_page.dart';
import 'left_foot_page.dart';
import 'right_foot_page.dart';

class LeftArmPage extends StatefulWidget {
  const LeftArmPage({super.key});

  @override
  State<LeftArmPage> createState() => _LeftArmPageState();
}

class _LeftArmPageState extends State<LeftArmPage> {
  final List<String> _pontosSelecionados = [];
  // DEBUG: pontos clicados na imagem
  final List<Offset> _pontosDebug = [];

  final List<Map<String, String>> _bodyParts = [
    {'imagePath': 'assets/images/body-parts/Head.png', 'label': 'Cabeça'},
    {'imagePath': 'assets/images/body-parts/Torso.png', 'label': 'Torso'},
    {'imagePath': 'assets/images/body-parts/Left-Arm.png', 'label': 'Braço E.'},
    {'imagePath': 'assets/images/body-parts/Right-Arm.png', 'label': 'Braço D.'},
    {'imagePath': 'assets/images/body-parts/Left-Hand.png', 'label': 'Mão E.'},
    {'imagePath': 'assets/images/body-parts/Right-Hand.png', 'label': 'Mão D.'},
    {'imagePath': 'assets/images/body-parts/Left-Leg.png', 'label': 'Perna E.'},
    {'imagePath': 'assets/images/body-parts/Right-Leg.png', 'label': 'Perna D.'},
    {'imagePath': 'assets/images/body-parts/Left-Foot.png', 'label': 'Pé E.'},
    {'imagePath': 'assets/images/body-parts/Right-Foot.png', 'label': 'Pé D.'},
  ];

  void _navegarParaParte(String parte) {
    Widget? page;
    switch (parte) {
      case 'Cabeça':
        page = const HeadPage();
        break;
      case 'Torso':
        page = const TorsoPage();
        break;
      case 'Braço E.':
        return; // Já está na página
      case 'Braço D.':
        page = const RightArmPage();
        break;
      case 'Mão E.':
        page = const LeftHandPage();
        break;
      case 'Mão D.':
        page = const RightHandPage();
        break;
      case 'Perna E.':
        page = const LeftLegPage();
        break;
      case 'Perna D.':
        page = const RightLegPage();
        break;
      case 'Pé E.':
        page = const LeftFootPage();
        break;
      case 'Pé D.':
        page = const RightFootPage();
        break;
    }
    
    if (page != null && mounted) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page!));
    }
  }

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
              'Braço Esquerdo',
              style: AppTypography.heading1Secondary,
            ),
            Text(
              'Toque na região onde você sente dor',
              style: AppTypography.textPrimary.copyWith(
                color: AppColors.textWhite,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.buttonPrimary.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GestureDetector(
                      onTapDown: (details) {
                        final position = details.localPosition;
                        setState(() {
                          _pontosDebug.add(position);
                        });
                        debugPrint('═══════════════════════════════════════');
                        debugPrint('🎯 POSIÇÃO CLICADA #${_pontosDebug.length}:');
                        debugPrint('   X: ${position.dx.toStringAsFixed(2)}');
                        debugPrint('   Y: ${position.dy.toStringAsFixed(2)}');
                        debugPrint('   Container Width: ${constraints.maxWidth.toStringAsFixed(2)}');
                        debugPrint('   Container Height: ${constraints.maxHeight.toStringAsFixed(2)}');
                        debugPrint('   Percentual X: ${(position.dx / constraints.maxWidth * 100).toStringAsFixed(2)}%');
                        debugPrint('   Percentual Y: ${(position.dy / constraints.maxHeight * 100).toStringAsFixed(2)}%');
                        debugPrint('═══════════════════════════════════════\n');
                      },
                      child: Stack(
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/images/body-parts/Left-Arm.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          ..._pontosDebug.asMap().entries.map((entry) {
                            return Positioned(
                              left: entry.value.dx - 10,
                              top: entry.value.dy - 10,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _pontosDebug.removeAt(entry.key);
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
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          BodyPartCarousel(
            bodyParts: _bodyParts,
            selectedPart: 'Braço E.',
            onPartSelected: (part) {
              _navegarParaParte(part);
            },
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, _pontosSelecionados);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Confirmar Seleção',
                  style: AppTypography.buttonPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

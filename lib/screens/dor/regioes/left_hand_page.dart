import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/body_part_selector.dart';
import 'head_page.dart';
import 'torso_page.dart';
import 'left_arm_page.dart';
import 'right_arm_page.dart';
import 'right_hand_page.dart';
import 'left_leg_page.dart';
import 'right_leg_page.dart';
import 'left_foot_page.dart';
import 'right_foot_page.dart';

class LeftHandPage extends StatefulWidget {
  const LeftHandPage({super.key});

  @override
  State<LeftHandPage> createState() => _LeftHandPageState();
}

class _LeftHandPageState extends State<LeftHandPage> {
  static final Map<String, List<String>> _selecoesSalvas = {};
  static const String _chaveRegiao = 'Mão E.';
  
  final List<String> _pontosSelecionados = [];

  @override
  void initState() {
    super.initState();
    if (_selecoesSalvas.containsKey(_chaveRegiao)) {
      _pontosSelecionados.addAll(_selecoesSalvas[_chaveRegiao]!);
    }
  }

  void _salvarSelecoes() {
    _selecoesSalvas[_chaveRegiao] = List.from(_pontosSelecionados);
  }
  
  // Pontos fixos clicáveis
  final List<Map<String, dynamic>> _pontosFixos = [
    {'xPercent': 72.76, 'yPercent': 56.69, 'label': 'Ponto 1'},
    {'xPercent': 64.49, 'yPercent': 48.59, 'label': 'Ponto 2'},
    {'xPercent': 60.19, 'yPercent': 81.12, 'label': 'Ponto 3'},
    {'xPercent': 56.90, 'yPercent': 66.06, 'label': 'Ponto 4'},
    {'xPercent': 46.27, 'yPercent': 86.17, 'label': 'Ponto 5'},
    {'xPercent': 45.05, 'yPercent': 69.19, 'label': 'Ponto 6'},
    {'xPercent': 35.37, 'yPercent': 82.63, 'label': 'Ponto 7'},
    {'xPercent': 35.63, 'yPercent': 69.63, 'label': 'Ponto 8'},
    {'xPercent': 26.58, 'yPercent': 80.42, 'label': 'Ponto 9'},
    {'xPercent': 27.28, 'yPercent': 66.16, 'label': 'Ponto 10'},
    {'xPercent': 39.64, 'yPercent': 16.86, 'label': 'Ponto 11'},
    {'xPercent': 42.43, 'yPercent': 38.41, 'label': 'Ponto 12'},
  ];

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
        page = const LeftArmPage();
        break;
      case 'Braço D.':
        page = const RightArmPage();
        break;
      case 'Mão E.':
        return; // Já está na página
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
              'Mão Esquerda',
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
                    return Stack(
                      children: [
                        Center(
                          child: Transform.scale(
                            scale: 1.5,
                            child: Image.asset(
                              'assets/images/body-parts/Left-Hand.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        // Pontos fixos clicáveis
                        ..._pontosFixos.map((ponto) {
                          final left = constraints.maxWidth * (ponto['xPercent'] / 100) - 10;
                          final top = constraints.maxHeight * (ponto['yPercent'] / 100) - 10;
                          final isSelected = _pontosSelecionados.contains(ponto['label']);
                          return Positioned(
                            left: left,
                            top: top,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    _pontosSelecionados.remove(ponto['label']);
                                  } else {
                                    _pontosSelecionados.add(ponto['label']);
                                  }
                                });
                              },
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.stateError.withOpacity(0.9)
                                      : AppColors.buttonPrimary.withOpacity(0.8),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.textWhite,
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (isSelected
                                          ? AppColors.stateError
                                          : AppColors.buttonPrimary).withOpacity(0.6),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          BodyPartCarousel(
            bodyParts: _bodyParts,
            selectedPart: 'Mão E.',
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
                  _salvarSelecoes();
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

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/body_part_selector.dart';
import '../../../core/widgets/app_button.dart';
import 'head_page.dart';
import 'left_arm_page.dart';
import 'right_arm_page.dart';
import 'left_hand_page.dart';
import 'right_hand_page.dart';
import 'left_leg_page.dart';
import 'right_leg_page.dart';
import 'left_foot_page.dart';
import 'right_foot_page.dart';

class TorsoPage extends StatefulWidget {
  const TorsoPage({super.key});

  @override
  State<TorsoPage> createState() => _TorsoPageState();
}

class _TorsoPageState extends State<TorsoPage> {
  // Map estático para manter seleções entre navegações
  static final Map<String, List<String>> _selecoesSalvas = {};
  static const String _chaveRegiao = 'Torso';
  
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
    {'xPercent': 51.03, 'yPercent': 13.55, 'label': 'Ponto 1'},
    {'xPercent': 49.65, 'yPercent': 34.27, 'label': 'Ponto 2'},
    {'xPercent': 65.82, 'yPercent': 34.77, 'label': 'Ponto 3'},
    {'xPercent': 34.32, 'yPercent': 35.35, 'label': 'Ponto 4'},
    {'xPercent': 28.11, 'yPercent': 18.06, 'label': 'Ponto 5'},
    {'xPercent': 70.35, 'yPercent': 16.67, 'label': 'Ponto 6'},
    {'xPercent': 50.40, 'yPercent': 54.42, 'label': 'Ponto 7'},
    {'xPercent': 66.45, 'yPercent': 73.05, 'label': 'Ponto 8'},
    {'xPercent': 36.96, 'yPercent': 72.50, 'label': 'Ponto 9'},
  ];

  List<Map<String, String>> _getBodyParts(AppLocalizations l10n) {
    return [
      {'imagePath': 'assets/images/body-parts/Head.png', 'label': l10n.head},
      {'imagePath': 'assets/images/body-parts/Torso.png', 'label': l10n.torso},
      {'imagePath': 'assets/images/body-parts/Left-Arm.png', 'label': l10n.leftArm},
      {'imagePath': 'assets/images/body-parts/Right-Arm.png', 'label': l10n.rightArm},
      {'imagePath': 'assets/images/body-parts/Left-Hand.png', 'label': l10n.leftHand},
      {'imagePath': 'assets/images/body-parts/Right-Hand.png', 'label': l10n.rightHand},
      {'imagePath': 'assets/images/body-parts/Left-Leg.png', 'label': l10n.leftLeg},
      {'imagePath': 'assets/images/body-parts/Right-Leg.png', 'label': l10n.rightLeg},
      {'imagePath': 'assets/images/body-parts/Left-Foot.png', 'label': l10n.leftFoot},
      {'imagePath': 'assets/images/body-parts/Right-Foot.png', 'label': l10n.rightFoot},
    ];
  }

  void _navegarParaParte(String parte, AppLocalizations l10n) {
    Widget? page;
    if (parte == l10n.head) {
      page = const HeadPage();
    } else if (parte == l10n.torso) {
      return; // Já está na página
    } else if (parte == l10n.leftArm) {
      page = const LeftArmPage();
    } else if (parte == l10n.rightArm) {
      page = const RightArmPage();
    } else if (parte == l10n.leftHand) {
      page = const LeftHandPage();
    } else if (parte == l10n.rightHand) {
      page = const RightHandPage();
    } else if (parte == l10n.leftLeg) {
      page = const LeftLegPage();
    } else if (parte == l10n.rightLeg) {
      page = const RightLegPage();
    } else if (parte == l10n.leftFoot) {
      page = const LeftFootPage();
    } else if (parte == l10n.rightFoot) {
      page = const RightFootPage();
    }
    
    if (page != null && mounted) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bodyParts = _getBodyParts(l10n);
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.torso,
              style: AppTypography.heading1Secondary,
            ),
            Text(
              l10n.selectPainArea,
              style: AppTypography.heading2Secondary,
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
                    color: AppColors.buttonPrimary.withValues(alpha: 0.3),
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
                              'assets/images/body-parts/Torso.png',
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
                                      ? AppColors.stateError.withValues(alpha: 0.9)
                                      : AppColors.buttonPrimary.withValues(alpha: 0.8),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.textWhite,
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (isSelected
                                          ? AppColors.stateError
                                          : AppColors.buttonPrimary).withValues(alpha: 0.6),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          BodyPartCarousel(
            bodyParts: bodyParts,
            selectedPart: l10n.torso,
            onPartSelected: (part) {
              _navegarParaParte(part, l10n);
            },
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: AppButton(
              label: l10n.confirmSelection,
              onPressed: () {
                _salvarSelecoes();
                Navigator.pop(context, _pontosSelecionados);
              },
            ),
          ),
        ],
      ),
    );
  }
}

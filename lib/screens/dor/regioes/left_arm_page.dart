import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
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
  static final Map<String, List<String>> _selecoesSalvas = {};
  static const String _chaveRegiao = 'Braço E.';
  
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
    {'xPercent': 41.15, 'yPercent': 17.44, 'label': 'Ponto 1'},
    {'xPercent': 48.28, 'yPercent': 45.07, 'label': 'Ponto 2'},
    {'xPercent': 52.89, 'yPercent': 71.20, 'label': 'Ponto 3'},
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
      page = const TorsoPage();
    } else if (parte == l10n.leftArm) {
      return; // Já está na página
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
              l10n.leftArm,
              style: AppTypography.heading1Secondary,
            ),
            Text(
              l10n.selectPainArea,
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
                          child: Image.asset(
                            'assets/images/body-parts/Left-Arm.png',
                            fit: BoxFit.contain,
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
                        }),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          BodyPartCarousel(
            bodyParts: bodyParts,
            selectedPart: l10n.leftArm,
            onPartSelected: (part) {
              _navegarParaParte(part, l10n);
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
                  l10n.confirmSelection,
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

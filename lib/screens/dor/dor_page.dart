import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_outlined_button.dart';
import '../../core/widgets/app_dropdown.dart';
import '../../core/widgets/app_text_field.dart';
import '../../l10n/app_localizations.dart';
import 'indicar_local_page.dart';

class DorPage extends StatefulWidget {
  const DorPage({super.key});

  @override
  State<DorPage> createState() => _DorPageState();
}

class _DorPageState extends State<DorPage> {
  double _nivelDor = 5.0;
  final TextEditingController _anotacaoController = TextEditingController();
  String _periodoHistorico = '30'; // dias

  @override
  void dispose() {
    _anotacaoController.dispose();
    super.dispose();
  }

  String _getDescricaoDor(AppLocalizations l10n) {
    if (_nivelDor == 0) return l10n.painNoPain;
    if (_nivelDor >= 1 && _nivelDor <= 2) return l10n.painMinimal;
    if (_nivelDor >= 3 && _nivelDor <= 4) return l10n.painMild;
    if (_nivelDor >= 5 && _nivelDor <= 6) return l10n.painModerate;
    if (_nivelDor >= 7 && _nivelDor <= 8) return l10n.painSevere;
    return l10n.painUnbearable; // 9-10
  }

  String _getSubtituloDor(AppLocalizations l10n) {
    if (_nivelDor == 0) return l10n.painNoPainDesc;
    if (_nivelDor >= 1 && _nivelDor <= 2) return l10n.painMinimalDesc;
    if (_nivelDor >= 3 && _nivelDor <= 4) return l10n.painMildDesc;
    if (_nivelDor >= 5 && _nivelDor <= 6) return l10n.painModerateDesc;
    if (_nivelDor >= 7 && _nivelDor <= 8) return l10n.painSevereDesc;
    return l10n.painUnbearableDesc; // 9-10
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),

              // Card - Como você está se sentindo hoje
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/pain/stethoscope.svg',
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          AppColors.buttonPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.painPageTitle,
                        style: AppTypography.heading2Primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.painPageSubtitle,
                    style: AppTypography.textDisabled,
                  ),
                  const SizedBox(height: 20),

                  // Nível de Dor
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.painLevel,
                        style: AppTypography.label,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${_nivelDor.toInt()}',
                            style: AppTypography.displayLarge.copyWith(
                              color: const Color(0xFF28BDBD),
                            ),
                          ),
                          Text(
                            '/10',
                            style: AppTypography.heading2Primary.copyWith(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Slider
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: AppColors.buttonPrimary,
                      inactiveTrackColor: AppColors.inputBackground,
                      thumbColor: AppColors.buttonPrimary,
                      overlayColor: AppColors.buttonPrimary.withValues(alpha: 0.2),
                      trackHeight: 6,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 10,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 20,
                      ),
                      tickMarkShape: const RoundSliderTickMarkShape(
                        tickMarkRadius: 0,
                      ),
                    ),
                    child: Slider(
                      value: _nivelDor,
                      min: 0,
                      max: 10,
                      divisions: 10,
                      onChanged: (value) {
                        setState(() {
                          _nivelDor = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Descrição da dor
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF192E2D)
                          : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getDescricaoDor(l10n),
                          style: AppTypography.displayMedium.copyWith(
                            color: const Color(0xFF28BDBD),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getSubtituloDor(l10n),
                          style: AppTypography.textDisabled,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Botão indicar local da dor
                  Center(
                    child: AppOutlinedButton(
                      label: l10n.indicatePainLocation,
                      icon: SvgPicture.asset(
                        'assets/icons/pain/locate-fixed.svg', 
                        width: 18, 
                        height: 18,
                        colorFilter: const ColorFilter.mode(AppColors.buttonPrimary, BlendMode.srcIn),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const IndicarLocalPage(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Campo de anotação
                  Text(
                    l10n.addAnnotation,
                    style: AppTypography.label,
                  ),
                  const SizedBox(height: 8),
                  AppTextField(
                    label: '',
                    hint: l10n.annotationHint,
                    controller: _anotacaoController,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                  // Botão Salvar Registro
                  AppButton(
                    label: l10n.saveRecord,
                    onPressed: () {
                      // Lógica para salvar registro
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.recordSavedSuccess),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Card - Histórico últimos 30 dias
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/pain/activity.svg',
                            width: 20,
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                              AppColors.buttonPrimary,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.history,
                            style: AppTypography.heading2Primary,
                          ),
                        ],
                      ),
                      // Dropdown de período
                      AppDropdown<String>(
                        value: _periodoHistorico,
                        items: [
                          DropdownMenuItem(value: '7', child: Text('7 ${l10n.days}')),
                          DropdownMenuItem(value: '14', child: Text('14 ${l10n.days}')),
                          DropdownMenuItem(value: '30', child: Text('30 ${l10n.days}')),
                          DropdownMenuItem(value: '60', child: Text('60 ${l10n.days}')),
                          DropdownMenuItem(value: '90', child: Text('90 ${l10n.days}')),
                          DropdownMenuItem(value: 'custom', child: Text(l10n.customPeriod)),
                        ],
                        onChanged: (value) {
                          if (value == 'custom') {
                            // TODO: Implementar seletor de data personalizado
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.customPeriodSoon),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          } else {
                            setState(() {
                              _periodoHistorico = value!;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.visualizePainPattern,
                    style: AppTypography.textDisabled,
                  ),
                  const SizedBox(height: 20),

                  // Placeholder para gráfico
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.buttonPrimary.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.insert_chart_outlined,
                            size: 48,
                            color: AppColors.buttonPrimary.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.chartWillBeDisplayed,
                            style: AppTypography.textDisabled,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Card - Histórico Recente
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/pain/calendar.svg',
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          AppColors.buttonPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.recentHistory,
                        style: AppTypography.heading2Primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.basedOnPreviousRecords,
                    style: AppTypography.textDisabled,
                  ),
                  const SizedBox(height: 20),

                  // Lista de registros recentes
                  _buildRegistroRecente(
                    nivel: 7,
                    data: '26 de out de 11:13',
                    descricao: l10n.painAfterExercise,
                    cor: AppColors.stateError,
                  ),
                  const SizedBox(height: 12),
                  _buildRegistroRecente(
                    nivel: 6,
                    data: '23 de out de 14:25',
                    descricao: l10n.morningStiffness,
                    cor: AppColors.stateWarning,
                  ),
                  const SizedBox(height: 12),
                  _buildRegistroRecente(
                    nivel: 5,
                    data: '20 de out de 16:32',
                    descricao: l10n.moderatePainAfterWalk,
                    cor: AppColors.stateWarning,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80), // Espaço para bottom navigation
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegistroRecente({
    required int nivel,
    required String data,
    required String descricao,
    required Color cor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.buttonPrimary.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Número do nível
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF192E2D)  // Mesma cor do subcard "Dor Moderada" no dark
                  : AppColors.surfaceVariant, // Mesma cor do subcard no light
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '$nivel',
                style: AppTypography.displayLarge.copyWith(
                  color: AppColors.buttonPrimary, // Verde principal
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Informações
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data,
                  style: AppTypography.labelSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  descricao,
                  style: AppTypography.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

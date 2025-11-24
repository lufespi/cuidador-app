import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_card.dart';
import 'body_region_mapper.dart';

class PainDetailPage extends StatelessWidget {
  const PainDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final int nivel = args['nivel'];
    final DateTime data = args['data'];
    final String descricao = args['descricao'];
    final List<dynamic> bodyParts = args['bodyParts'];

    // Converte bodyParts para descrições legíveis
    final descricoes = bodyParts.map((part) {
      if (part is String) {
        final parts = part.split(':');
        if (parts.length == 2) {
          return BodyRegionMapper.getNomePontoDetalhe(parts[0], parts[1]);
        }
      }
      return part.toString();
    }).toList();

    // Agrupa por parte do corpo
    final agrupados = BodyRegionMapper.agruparPorParteDoCorpo(descricoes);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Detalhes do Registro',
          style: AppTypography.heading1Primary,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card - Nível de Dor
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/pain/pain-level.svg',
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            AppColors.buttonPrimary,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Nível de Dor',
                          style: AppTypography.heading2Primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Indicador visual do nível
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _getCorNivel(nivel).withValues(alpha: 0.2),
                              border: Border.all(
                                color: _getCorNivel(nivel),
                                width: 4,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '$nivel',
                                style: AppTypography.displayLarge.copyWith(
                                  fontSize: 48,
                                  color: _getCorNivel(nivel),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _getDescricaoNivel(nivel),
                            style: AppTypography.heading2Primary.copyWith(
                              color: _getCorNivel(nivel),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Card - Data e Hora
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/pain/calendar.svg',
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            AppColors.buttonPrimary,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Data e Hora',
                          style: AppTypography.heading2Primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
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
                            _formatarDataCompleta(data),
                            style: AppTypography.bodyLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatarHora(data),
                            style: AppTypography.textDisabled,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Card - Locais da Dor
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/pain/body.svg',
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            AppColors.buttonPrimary,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Locais da Dor',
                          style: AppTypography.heading2Primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Lista agrupada por parte do corpo
                    if (agrupados.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Nenhum local especificado',
                            style: TextStyle(color: AppColors.textDisabled),
                          ),
                        ),
                      )
                    else
                      ...agrupados.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
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
                                  entry.key,
                                  style: AppTypography.heading2Primary.copyWith(
                                    color: AppColors.buttonPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: entry.value.map((local) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.stateError.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: AppColors.stateError.withValues(alpha: 0.5),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        local,
                                        style: AppTypography.labelSmall.copyWith(
                                          color: AppColors.stateError,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Card - Descrição/Anotações
              if (descricao.isNotEmpty && descricao != 'Sem descrição')
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.description_outlined,
                            color: AppColors.buttonPrimary,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Anotações',
                            style: AppTypography.heading2Primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF192E2D)
                              : AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          descricao,
                          style: AppTypography.bodyMedium,
                        ),
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

  Color _getCorNivel(int nivel) {
    if (nivel >= 8) return AppColors.stateError;
    if (nivel >= 5) return AppColors.stateWarning;
    if (nivel >= 3) return const Color(0xFFFFA726); // Laranja claro
    return AppColors.stateSuccess;
  }

  String _getDescricaoNivel(int nivel) {
    if (nivel >= 8) return 'Dor Severa';
    if (nivel >= 5) return 'Dor Moderada';
    if (nivel >= 3) return 'Dor Leve';
    return 'Dor Mínima';
  }

  String _formatarDataCompleta(DateTime data) {
    final meses = [
      'janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho',
      'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro'
    ];
    final diasSemana = [
      'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado', 'Domingo'
    ];
    
    return '${diasSemana[data.weekday - 1]}, ${data.day} de ${meses[data.month - 1]} de ${data.year}';
  }

  String _formatarHora(DateTime data) {
    return '${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
  }
}

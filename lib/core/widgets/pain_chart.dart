import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class PainChart extends StatelessWidget {
  final List<Map<String, dynamic>> registros;
  final bool isLoading;
  final String? errorMessage;

  const PainChart({
    super.key,
    required this.registros,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 150,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage != null) {
      return Container(
        height: 150,
        decoration: BoxDecoration(
          color: AppColors.stateError.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.stateError.withValues(alpha: 0.3),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: AppColors.stateError,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                'Erro ao carregar gráfico',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.stateError,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (registros.isEmpty) {
      return Container(
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
                'Nenhum registro neste período',
                style: AppTypography.textDisabled,
              ),
            ],
          ),
        ),
      );
    }

    // Prepara os dados para o gráfico
    final spots = <FlSpot>[];
    final dates = <DateTime>[];
    
    // Ordena os registros por data
    final sortedRegistros = List<Map<String, dynamic>>.from(registros)
      ..sort((a, b) => (a['dataCompleta'] as DateTime)
          .compareTo(b['dataCompleta'] as DateTime));

    for (int i = 0; i < sortedRegistros.length; i++) {
      final registro = sortedRegistros[i];
      final nivel = (registro['nivel'] as int).toDouble();
      dates.add(registro['dataCompleta'] as DateTime);
      spots.add(FlSpot(i.toDouble(), nivel));
    }

    return Container(
      height: 200,
      padding: const EdgeInsets.only(right: 16, top: 16, bottom: 8),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 2,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: AppColors.buttonPrimary.withValues(alpha: 0.1),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < dates.length) {
                    final date = dates[value.toInt()];
                    // Mostra apenas alguns labels para não ficar muito poluído
                    if (dates.length <= 7 || value.toInt() % (dates.length ~/ 5).clamp(1, dates.length) == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          '${date.day}/${date.month}',
                          style: AppTypography.labelSmall.copyWith(
                            fontSize: 10,
                          ),
                        ),
                      );
                    }
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 2,
                reservedSize: 32,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: AppTypography.labelSmall.copyWith(
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              left: BorderSide(
                color: AppColors.buttonPrimary.withValues(alpha: 0.2),
              ),
              bottom: BorderSide(
                color: AppColors.buttonPrimary.withValues(alpha: 0.2),
              ),
            ),
          ),
          minX: 0,
          maxX: spots.length > 1 ? spots.length - 1.0 : 1,
          minY: 0,
          maxY: 10,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppColors.buttonPrimary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  final nivel = spot.y.toInt();
                  Color dotColor;
                  
                  if (nivel >= 8) {
                    dotColor = AppColors.stateError;
                  } else if (nivel >= 5) {
                    dotColor = AppColors.stateWarning;
                  } else if (nivel >= 3) {
                    dotColor = const Color(0xFFFFA726);
                  } else {
                    dotColor = AppColors.stateSuccess;
                  }
                  
                  return FlDotCirclePainter(
                    radius: 4,
                    color: dotColor,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.buttonPrimary.withValues(alpha: 0.1),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) => 
                  Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF192E2D)
                      : Colors.white,
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((LineBarSpot touchedSpot) {
                  final index = touchedSpot.x.toInt();
                  if (index >= 0 && index < dates.length) {
                    final date = dates[index];
                    final nivel = touchedSpot.y.toInt();
                    
                    return LineTooltipItem(
                      'Nível: $nivel\n${date.day}/${date.month} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
                      AppTypography.labelSmall.copyWith(
                        color: AppColors.buttonPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                  return null;
                }).toList();
              },
            ),
            handleBuiltInTouches: true,
          ),
        ),
      ),
    );
  }
}

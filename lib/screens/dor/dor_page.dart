import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_outlined_button.dart';
import '../../core/widgets/app_dropdown.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/pain_chart.dart';
import '../../l10n/app_localizations.dart';
import '../../data/services/pain_service.dart';
import 'dor_provider.dart';
import 'indicar_local_page.dart';

class DorPage extends StatefulWidget {
  const DorPage({super.key});

  @override
  State<DorPage> createState() => _DorPageState();
}

class _DorPageState extends State<DorPage> {
  final PainService _painService = PainService();
  double _nivelDor = 5.0;
  final TextEditingController _anotacaoController = TextEditingController();
  String _periodoHistorico = '30'; // dias
  String _periodoLista = 'today'; // período para lista de registros
  int _paginaAtual = 0; // página atual da lista
  final int _itensPorPagina = 10;
  List<Map<String, dynamic>> _registrosRecentes = [];
  List<Map<String, dynamic>> _registrosGrafico = [];
  bool _isLoadingRegistros = false;
  bool _isLoadingGrafico = false;
  bool _isSavingRecord = false;
  String? _errorLoadingRegistros;

  @override
  void initState() {
    super.initState();
    _carregarRegistrosRecentes();
    _carregarRegistrosGrafico();
  }

  @override
  void dispose() {
    _anotacaoController.dispose();
    super.dispose();
  }

  Future<void> _carregarRegistrosRecentes() async {
    setState(() {
      _isLoadingRegistros = true;
      _paginaAtual = 0; // Reset página ao mudar período
    });

    try {
      // Calcula data inicial baseada no período selecionado da lista
      DateTime? startDate;
      if (_periodoLista == 'today') {
        startDate = DateTime.now().subtract(const Duration(hours: 24));
      } else if (_periodoLista != 'custom') {
        final dias = int.parse(_periodoLista);
        startDate = DateTime.now().subtract(Duration(days: dias));
      }

      final registros = await _painService.getPainRecords(
        startDate: startDate,
        limit: 100, // Carregar mais para permitir paginação
      );
      if (mounted) {
        setState(() {
          _registrosRecentes = registros.map((record) {
            return {
              'id': record.id,
              'nivel': record.intensidade,
              'data': _formatarData(record.dataRegistro),
              'descricao': record.descricao ?? 'Sem descrição',
              'bodyParts': record.bodyParts,
              'dataCompleta': record.dataRegistro,
            };
          }).toList();
          _isLoadingRegistros = false;
          _errorLoadingRegistros = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingRegistros = false;
          _errorLoadingRegistros = e.toString();
        });
        debugPrint('Erro ao carregar registros: $e');
      }
    }
  }

  Future<void> _carregarRegistrosGrafico() async {
    setState(() {
      _isLoadingGrafico = true;
    });

    try {
      // Calcula data inicial baseada no período do gráfico
      DateTime? startDate;
      if (_periodoHistorico != 'custom') {
        final dias = int.parse(_periodoHistorico);
        startDate = DateTime.now().subtract(Duration(days: dias));
      }

      final registros = await _painService.getPainRecords(
        startDate: startDate,
        limit: 50,
      );
      if (mounted) {
        setState(() {
          _registrosGrafico = registros.map((record) {
            return {
              'id': record.id,
              'nivel': record.intensidade,
              'data': _formatarData(record.dataRegistro),
              'descricao': record.descricao ?? 'Sem descrição',
              'bodyParts': record.bodyParts,
              'dataCompleta': record.dataRegistro,
            };
          }).toList();
          _isLoadingGrafico = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingGrafico = false;
        });
        debugPrint('Erro ao carregar registros do gráfico: $e');
      }
    }
  }

  String _formatarData(DateTime data) {
    final now = DateTime.now();
    final diff = now.difference(data);
    
    if (diff.inDays == 0) {
      return '${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1) {
      return 'Ontem às ${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
    } else {
      final meses = ['jan', 'fev', 'mar', 'abr', 'mai', 'jun', 'jul', 'ago', 'set', 'out', 'nov', 'dez'];
      return '${data.day} de ${meses[data.month - 1]} de ${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _salvarRegistro() async {
    if (_isSavingRecord) return; // Previne múltiplos cliques

    final dorProvider = Provider.of<DorProvider>(context, listen: false);
    final localizacoes = dorProvider.getLocalizacoesParaSalvar();

    // Se não há localizações, mostra popup de confirmação
    if (localizacoes.isEmpty) {
      final confirmar = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Nenhum local da dor indicado'),
          content: const Text(
            'Você não indicou nenhum local da dor. Deseja salvar o registro mesmo assim?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Salvar'),
            ),
          ],
        ),
      );

      // Se usuário cancelou, não salva
      if (confirmar != true) return;
    }

    if (!mounted) return;

    setState(() {
      _isSavingRecord = true;
    });

    try {
      await _painService.createPainRecord(
        bodyParts: localizacoes,
        intensidade: _nivelDor.round(),
        descricao: _anotacaoController.text.isNotEmpty ? _anotacaoController.text : null,
      );

      if (!mounted) return;
      
      // Limpa as seleções após salvar
      dorProvider.limparSelecoes();
      _anotacaoController.clear();
      setState(() {
        _nivelDor = 5.0; // Reset nível de dor
      });

      // Recarrega os registros
      await Future.wait([
        _carregarRegistrosRecentes(),
        _carregarRegistrosGrafico(),
      ]);

      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registro de dor salvo com sucesso!'),
          backgroundColor: AppColors.stateSuccess,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar registro: $e'),
            backgroundColor: AppColors.stateError,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSavingRecord = false;
        });
      }
    }
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

  // Getters para paginação
  int get _totalPaginas => (_registrosRecentes.length / _itensPorPagina).ceil();
  
  List<Map<String, dynamic>> get _registrosPaginaAtual {
    final inicio = _paginaAtual * _itensPorPagina;
    final fim = (inicio + _itensPorPagina).clamp(0, _registrosRecentes.length);
    return _registrosRecentes.sublist(inicio, fim);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              _carregarRegistrosRecentes(),
              _carregarRegistrosGrafico(),
            ]);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                      Expanded(
                        child: Text(
                          l10n.painPageTitle,
                          style: AppTypography.heading2Primary,
                        ),
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
                      Flexible(
                        child: Text(
                          l10n.painLevel,
                          style: AppTypography.label,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
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
                        // Limpa seleções anteriores antes de abrir a página
                        final dorProvider = Provider.of<DorProvider>(context, listen: false);
                        dorProvider.limparSelecoes();
                        
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

                  // Mostra localizações selecionadas
                  Consumer<DorProvider>(
                    builder: (context, dorProvider, child) {
                      final descricoes = dorProvider.descricoesPontos;
                      if (descricoes.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Locais selecionados:',
                            style: AppTypography.label,
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: descricoes.map((desc) {
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
                                  desc,
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.stateError,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),

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
                    label: _isSavingRecord ? 'Salvando...' : l10n.saveRecord,
                    onPressed: _isSavingRecord ? null : _salvarRegistro,
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
                      Expanded(
                        child: Row(
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
                            Flexible(
                              child: Text(
                                l10n.history,
                                style: AppTypography.heading2Primary,
                              ),
                            ),
                          ],
                        ),
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
                            _carregarRegistrosGrafico();
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

                  // Gráfico de histórico de dor
                  PainChart(
                    registros: _registrosGrafico,
                    isLoading: _isLoadingGrafico,
                    errorMessage: null,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
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
                            Flexible(
                              child: Text(
                                l10n.recentHistory,
                                style: AppTypography.heading2Primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Dropdown de período
                      AppDropdown<String>(
                        value: _periodoLista,
                        items: [
                          DropdownMenuItem(value: 'today', child: Text('Hoje')),
                          DropdownMenuItem(value: '7', child: Text('Últimos 7 dias')),
                          DropdownMenuItem(value: '14', child: Text('Últimos 14 dias')),
                          DropdownMenuItem(value: '30', child: Text('Últimos 30 dias')),
                          DropdownMenuItem(value: 'custom', child: Text('Personalizado')),
                        ],
                        onChanged: (value) {
                          if (value == 'custom') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.customPeriodSoon),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          } else {
                            setState(() {
                              _periodoLista = value!;
                            });
                            _carregarRegistrosRecentes();
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.basedOnPreviousRecords,
                    style: AppTypography.textDisabled,
                  ),
                  const SizedBox(height: 20),

                  // Lista de registros recentes (paginada)
                  _isLoadingRegistros
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : _errorLoadingRegistros != null
                          ? Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.stateError.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.stateError.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: AppColors.stateError,
                                    size: 48,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Erro ao carregar registros',
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: AppColors.stateError,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextButton.icon(
                                    onPressed: _carregarRegistrosRecentes,
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('Tentar novamente'),
                                  ),
                                ],
                              ),
                            )
                          : _registrosRecentes.isEmpty
                          ? Center(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceVariant.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.inbox_outlined,
                                      size: 48,
                                      color: AppColors.textDisabled,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Nenhum registro encontrado',
                                      style: AppTypography.textDisabled,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Registre sua primeira dor acima',
                                      style: AppTypography.labelSmall.copyWith(
                                        color: AppColors.textDisabled,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                // Registros da página atual
                                ..._registrosPaginaAtual.map((registro) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _buildRegistroRecente(
                                      id: registro['id'],
                                      nivel: registro['nivel'],
                                      data: registro['data'],
                                      descricao: registro['descricao'],
                                      bodyParts: registro['bodyParts'],
                                      dataCompleta: registro['dataCompleta'],
                                    ),
                                  );
                                }).toList(),
                                
                                // Paginação
                                if (_totalPaginas > 1) ...[
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.chevron_left),
                                        onPressed: _paginaAtual > 0
                                            ? () {
                                                setState(() {
                                                  _paginaAtual--;
                                                });
                                              }
                                            : null,
                                        color: AppColors.buttonPrimary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Página ${_paginaAtual + 1} de $_totalPaginas',
                                        style: AppTypography.bodyMedium,
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: const Icon(Icons.chevron_right),
                                        onPressed: _paginaAtual < _totalPaginas - 1
                                            ? () {
                                                setState(() {
                                                  _paginaAtual++;
                                                });
                                              }
                                            : null,
                                        color: AppColors.buttonPrimary,
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                ],
              ),
            ),

            const SizedBox(height: 80), // Espaço para bottom navigation
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegistroRecente({
    required String id,
    required int nivel,
    required String data,
    required String descricao,
    required List<dynamic> bodyParts,
    required DateTime dataCompleta,
  }) {
    final cor = nivel >= 7
        ? AppColors.stateError
        : nivel >= 5
            ? AppColors.stateWarning
            : AppColors.stateSuccess;

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.pushNamed(
          context,
          '/pain-detail',
          arguments: {
            'id': id,
            'nivel': nivel,
            'data': dataCompleta,
            'descricao': descricao,
            'bodyParts': bodyParts,
          },
        );
        
        // Se retornou true, significa que o registro foi excluído ou editado
        if (result == true && mounted) {
          await Future.wait([
            _carregarRegistrosRecentes(),
            _carregarRegistrosGrafico(),
          ]);
        }
      },
      child: Container(
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
                    ? const Color(0xFF192E2D)
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '$nivel',
                  style: AppTypography.displayLarge.copyWith(
                    color: AppColors.buttonPrimary,
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

            // Indicador de cor
            Container(
              width: 4,
              height: 48,
              decoration: BoxDecoration(
                color: cor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

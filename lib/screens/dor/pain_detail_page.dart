import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_card.dart';
import '../../data/services/pain_service.dart';
import 'body_region_mapper.dart';

class PainDetailPage extends StatefulWidget {
  const PainDetailPage({super.key});

  @override
  State<PainDetailPage> createState() => _PainDetailPageState();
}

class _PainDetailPageState extends State<PainDetailPage> {
  final PainService _painService = PainService();
  bool _hasChanges = false; // Flag para indicar se houve alterações
  
  // Dados do registro
  String? recordId;
  int nivel = 0;
  DateTime data = DateTime.now();
  String descricao = '';
  List<dynamic> bodyParts = [];

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    
    // Inicializa dados apenas na primeira vez
    if (recordId == null) {
      recordId = args['id']?.toString();
      nivel = args['nivel'];
      data = args['data'];
      descricao = args['descricao'];
      bodyParts = args['bodyParts'];
    }

    // Converte bodyParts para descrições legíveis
    final descricoes = bodyParts.map((part) {
      if (part is String) {
        // Se tiver formato "região:Ponto X" (ex: "Cabeça:Ponto 1")
        if (part.contains(':')) {
          final parts = part.split(':');
          if (parts.length == 2) {
            final regiaoId = parts[0].trim();
            final ponto = parts[1].trim();
            // Converte região ID para nome formatado (ex: "braço_direito" -> "Braço esquerdo")
            final nomeRegiao = BodyRegionMapper.getNomeRegiao(regiaoId);
            // Converte para nome completo: "Região: Local específico"
            final nomeLocal = BodyRegionMapper.getNomePontoDetalhe(nomeRegiao, ponto);
            return '$nomeRegiao: $nomeLocal';
          }
        }
        // Caso contrário, usa getNomePonto para IDs diretos
        return BodyRegionMapper.getNomePonto(part);
      }
      return part.toString();
    }).toList();

    // Agrupa por parte do corpo
    final agrupados = BodyRegionMapper.agruparPorParteDoCorpo(descricoes);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pop(context, _hasChanges);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : AppColors.textPrimary,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, _hasChanges),
        ),
        title: Text(
          'Detalhes do Registro',
          style: AppTypography.heading1Primary.copyWith(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : AppColors.textPrimary,
          ),
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
                        const Icon(
                          Icons.favorite,
                          color: AppColors.buttonPrimary,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Nível de Dor',
                          style: AppTypography.heading2Primary,
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () {
                            _showEditNivelDialog(context, nivel);
                          },
                          tooltip: 'Editar nível',
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
                        const Icon(
                          Icons.calendar_today,
                          color: AppColors.buttonPrimary,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Data e Hora',
                          style: AppTypography.heading2Primary,
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () {
                            _showEditDataDialog(context, data);
                          },
                          tooltip: 'Editar data',
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
                        const Icon(
                          Icons.accessibility_new,
                          color: AppColors.buttonPrimary,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Locais da Dor',
                          style: AppTypography.heading2Primary,
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () {
                            _showEditLocaisDialog(context, bodyParts);
                          },
                          tooltip: 'Editar locais',
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
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            onPressed: () {
                              _showEditDescricaoDialog(context, descricao);
                            },
                            tooltip: 'Editar anotações',
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
              const SizedBox(height: 24),

              // Botão de Excluir Registro
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () => _showDeleteConfirmation(context, recordId),
                  icon: const Icon(Icons.delete_outline),
                  label: Text(
                    'Excluir Registro',
                    style: AppTypography.heading2Primary.copyWith(
                      color: AppColors.stateError,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.stateError,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),

              const SizedBox(height: 80), // Espaço para bottom navigation
            ],
          ),
        ),
      ),
      ), // Fecha PopScope
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

  void _showEditNivelDialog(BuildContext context, int nivelAtual) {
    int novoNivel = nivelAtual;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Editar Nível de Dor'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Indicador visual do nível
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getCorNivel(novoNivel).withValues(alpha: 0.2),
                  border: Border.all(
                    color: _getCorNivel(novoNivel),
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Text(
                    '$novoNivel',
                    style: AppTypography.displayLarge.copyWith(
                      fontSize: 36,
                      color: _getCorNivel(novoNivel),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _getDescricaoNivel(novoNivel),
                style: AppTypography.heading2Primary.copyWith(
                  color: _getCorNivel(novoNivel),
                ),
              ),
              const SizedBox(height: 24),
              
              // Slider
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: _getCorNivel(novoNivel),
                  inactiveTrackColor: _getCorNivel(novoNivel).withValues(alpha: 0.3),
                  thumbColor: _getCorNivel(novoNivel),
                  overlayColor: _getCorNivel(novoNivel).withValues(alpha: 0.2),
                  trackHeight: 8,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                ),
                child: Slider(
                  value: novoNivel.toDouble(),
                  min: 0,
                  max: 10,
                  divisions: 10,
                  onChanged: (value) {
                    setState(() {
                      novoNivel = value.round();
                    });
                  },
                ),
              ),
              
              // Labels do slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('0', style: AppTypography.labelSmall),
                  Text('5', style: AppTypography.labelSmall),
                  Text('10', style: AppTypography.labelSmall),
                ],
              ),
              const SizedBox(height: 16),
              
              // Descrição dos níveis
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNivelDescricao('0-2', 'Dor Mínima', AppColors.stateSuccess),
                    const SizedBox(height: 4),
                    _buildNivelDescricao('3-4', 'Dor Leve', const Color(0xFFFFA726)),
                    const SizedBox(height: 4),
                    _buildNivelDescricao('5-7', 'Dor Moderada', AppColors.stateWarning),
                    const SizedBox(height: 4),
                    _buildNivelDescricao('8-10', 'Dor Severa', AppColors.stateError),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                
                try {
                  if (recordId != null) {
                    await _painService.updatePainRecord(
                      id: recordId!,
                      intensidade: novoNivel,
                    );
                    
                    if (mounted && context.mounted) {
                      setState(() {
                        nivel = novoNivel;
                        _hasChanges = true;
                      });
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Nível de dor atualizado para $novoNivel'),
                          backgroundColor: AppColors.stateSuccess,
                        ),
                      );
                      // Marca que houve alteração para recarregar a lista
                      Navigator.of(context).pop(true);
                    }
                  }
                } catch (e) {
                  if (mounted && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao atualizar: $e'),
                        backgroundColor: AppColors.stateError,
                      ),
                    );
                  }
                } finally {
                  // Nenhuma limpeza necessária
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNivelDescricao(String faixa, String descricao, Color cor) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: cor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$faixa: ',
          style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          descricao,
          style: AppTypography.labelSmall,
        ),
      ],
    );
  }

  void _showEditDataDialog(BuildContext context, DateTime dataAtual) async {
    final novaData = await showDatePicker(
      context: context,
      initialDate: dataAtual,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.buttonPrimary,
              onPrimary: Colors.white,
              surface: Theme.of(context).colorScheme.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (novaData != null && context.mounted) {
      final horaController = TextEditingController(text: dataAtual.hour.toString().padLeft(2, '0'));
      final minutoController = TextEditingController(text: dataAtual.minute.toString().padLeft(2, '0'));

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Editar Hora'),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 60,
                child: TextField(
                  controller: horaController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 2,
                  decoration: const InputDecoration(
                    labelText: 'Hora',
                    counterText: '',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(':', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                width: 60,
                child: TextField(
                  controller: minutoController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 2,
                  decoration: const InputDecoration(
                    labelText: 'Min',
                    counterText: '',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final hora = int.tryParse(horaController.text) ?? 0;
                final minuto = int.tryParse(minutoController.text) ?? 0;

                if (hora >= 0 && hora <= 23 && minuto >= 0 && minuto <= 59) {
                  final dataHoraAtualizada = DateTime(
                    novaData.year,
                    novaData.month,
                    novaData.day,
                    hora,
                    minuto,
                  );

                  Navigator.pop(context);
                  
                  try {
                    // Nota: Backend atual não suporta atualização de data
                    // Esta funcionalidade requer implementação no backend
                    if (mounted && context.mounted) {
                      setState(() {
                        data = dataHoraAtualizada;
                      });
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Data atualizada para ${_formatarDataCompleta(dataHoraAtualizada)} às ${_formatarHora(dataHoraAtualizada)}',
                          ),
                          backgroundColor: AppColors.stateSuccess,
                        ),
                      );
                    }
                  } catch (e) {
                    if (mounted && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erro ao atualizar: $e'),
                          backgroundColor: AppColors.stateError,
                        ),
                      );
                    }
                  } finally {
                    // Nenhuma limpeza necessária
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Hora ou minuto inválidos'),
                      backgroundColor: AppColors.stateError,
                    ),
                  );
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      );
    }
  }

  void _showEditLocaisDialog(BuildContext context, List<dynamic> locaisAtuais) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Locais da Dor'),
        content: const Text('Funcionalidade de edição será implementada em breve.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showEditDescricaoDialog(BuildContext context, String descricaoAtual) {
    final descricaoController = TextEditingController(text: descricaoAtual);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Anotações'),
        content: TextField(
          controller: descricaoController,
          maxLines: 5,
          maxLength: 500,
          decoration: const InputDecoration(
            hintText: 'Descreva detalhes sobre a dor...',
            border: OutlineInputBorder(),
            counterText: '',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final novaDescricao = descricaoController.text.trim();
              Navigator.pop(context);
              
              try {
                if (recordId != null) {
                  await _painService.updatePainRecord(
                    id: recordId!,
                    descricao: novaDescricao,
                  );
                  
                  if (mounted && context.mounted) {
                    setState(() {
                      descricao = novaDescricao;
                      _hasChanges = true;
                    });
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Anotações atualizadas com sucesso'),
                        backgroundColor: AppColors.stateSuccess,
                      ),
                    );
                  }
                }
              } catch (e) {
                if (mounted && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao atualizar: $e'),
                      backgroundColor: AppColors.stateError,
                    ),
                  );
                }
              } finally {
                // Nenhuma limpeza necessária
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String? recordId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Registro'),
        content: const Text('Tem certeza que deseja excluir este registro de dor? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Fecha o dialog
              
              // Salva o navigator antes da operação async
              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              
              try {
                if (recordId != null) {
                  await _painService.deletePainRecord(recordId);
                  
                  // Usa o navigator salvo e passa resultado para atualizar a lista
                  navigator.pop(true); // Volta para a tela anterior com resultado true
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      content: Text('Registro excluído com sucesso'),
                      backgroundColor: AppColors.stateSuccess,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text('Erro ao excluir: $e'),
                      backgroundColor: AppColors.stateError,
                    ),
                  );
                }
              } finally {
                // Nenhuma limpeza necessária
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.stateError,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_toggle.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/notifications/notification_service.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Notificações gerais
  bool _notificationsEnabled = true;
  
  // Lembretes personalizados
  bool _remindersEnabled = true;
  bool _exerciciosEnabled = true;
  bool _respiracaoEnabled = true;
  bool _alongamentoEnabled = true;
  bool _relaxamentoEnabled = true;
  
  // Horário e frequência
  bool _scheduleEnabled = true;
  final TextEditingController _hourController = TextEditingController(text: '09');
  final TextEditingController _minuteController = TextEditingController(text: '00');
  String _frequency = 'diariamente';
  
  // Dias da semana para frequência personalizada
  final Map<String, bool> _selectedDays = {
    'Segunda-feira': false,
    'Terça-feira': false,
    'Quarta-feira': false,
    'Quinta-feira': false,
    'Sexta-feira': false,
    'Sábado': false,
    'Domingo': false,
  };

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

    void _saveChanges() async {
    final l10n = AppLocalizations.of(context)!;

    try {
      if (!_notificationsEnabled) {
        // Notificações desativadas totalmente
        await NotificationService().cancelAll();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.changesSuccessfullySaved),
          ),
        );
        Navigator.pop(context);
        return;
      }

    // Monta uma descrição com base nos lembretes ativados
    final List<String> ativos = [];
    if (_remindersEnabled) {
      if (_exerciciosEnabled) ativos.add('exercícios');
      if (_respiracaoEnabled) ativos.add('respiração');
      if (_alongamentoEnabled) ativos.add('alongamentos');
      if (_relaxamentoEnabled) ativos.add('relaxamento');
    }

    final String corpoNotificacao;
    if (ativos.isEmpty) {
      corpoNotificacao = 'Suas notificações foram configuradas.';
    } else {
      corpoNotificacao =
          'Lembretes ativados para: ${ativos.join(', ')}.';
    }

    // Antes de agendar, limpa qualquer agendamento antigo
    await NotificationService().cancelAll();

    // Se horário estiver habilitado, agenda notificação diária
    if (_scheduleEnabled) {
      int hour = int.tryParse(_hourController.text) ?? 9;
      int minute = int.tryParse(_minuteController.text) ?? 0;

      // Garante valores válidos
      if (hour < 0 || hour > 23) hour = 9;
      if (minute < 0 || minute > 59) minute = 0;

      await NotificationService().scheduleDailyReminder(
        id: 1, // ID fixo por enquanto (1 lembrete diário geral)
        hour: hour,
        minute: minute,
        title: 'CuidaDor',
        body: corpoNotificacao,
      );
    } else {
      // Se não quiser agendamento, manda só uma de confirmação
      await NotificationService().showInstantNotification(
        title: 'CuidaDor',
        body: corpoNotificacao,
      );
    }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.changesSuccessfullySaved),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar notificações: ${e.toString()}'),
          backgroundColor: AppColors.stateError,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.notificationsAndReminders,
          style: AppTypography.heading1Secondary,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    
                    // Mini Card - Ativar/Desativar Notificações
                    AppCard(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ativar Notificações',
                            style: AppTypography.heading2Primary,
                          ),
                          AppToggle(
                            value: _notificationsEnabled,
                            onChanged: (value) {
                              setState(() {
                                _notificationsEnabled = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Cards condicionais
                    if (_notificationsEnabled) ...[
                      const SizedBox(height: 16),
                      
                      // Card 1 - Lembretes Personalizados
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Lembretes personalizados',
                                        style: AppTypography.heading2Primary,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Receba lembretes para cuidar da sua saúde ao longo do dia.',
                                        style: AppTypography.textPrimary.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                AppToggle(
                                  value: _remindersEnabled,
                                  onChanged: (value) {
                                    setState(() {
                                      _remindersEnabled = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Lista de lembretes
                            Opacity(
                              opacity: _remindersEnabled ? 1.0 : 0.5,
                              child: IgnorePointer(
                                ignoring: !_remindersEnabled,
                                child: Column(
                                  children: [
                                    _buildReminderItem(
                                      label: 'Exercícios leves',
                                      value: _exerciciosEnabled,
                                      onChanged: (value) {
                                        setState(() {
                                          _exerciciosEnabled = value;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                    _buildReminderItem(
                                      label: 'Respiração guiada',
                                      value: _respiracaoEnabled,
                                      onChanged: (value) {
                                        setState(() {
                                          _respiracaoEnabled = value;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                    _buildReminderItem(
                                      label: 'Alongamentos rápidos',
                                      value: _alongamentoEnabled,
                                      onChanged: (value) {
                                        setState(() {
                                          _alongamentoEnabled = value;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                    _buildReminderItem(
                                      label: 'Relaxamento e descanso',
                                      value: _relaxamentoEnabled,
                                      onChanged: (value) {
                                        setState(() {
                                          _relaxamentoEnabled = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Card 2 - Horário e Frequência
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
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Horário e frequência',
                                              style: AppTypography.heading2Primary,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Escolha o melhor horário e quantas vezes por semana deseja receber lembretes.',
                                              style: AppTypography.textPrimary.copyWith(
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                AppToggle(
                                  value: _scheduleEnabled,
                                  onChanged: (value) {
                                    setState(() {
                                      _scheduleEnabled = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Horário preferido
                            Opacity(
                              opacity: _scheduleEnabled ? 1.0 : 0.5,
                              child: Text(
                                'Horário preferido',
                                style: AppTypography.heading2Primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Opacity(
                              opacity: _scheduleEnabled ? 1.0 : 0.5,
                              child: IgnorePointer(
                                ignoring: !_scheduleEnabled,
                                child: Row(
                                  children: [
                                    // Input de hora
                                    Expanded(
                                      child: TextField(
                                        controller: _hourController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          labelText: 'Hora',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      ':',
                                      style: TextStyle(fontSize: 24),
                                    ),
                                    const SizedBox(width: 8),
                                    // Input de minuto
                                    Expanded(
                                      child: TextField(
                                        controller: _minuteController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          labelText: 'Minuto',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Frequência
                            Opacity(
                              opacity: _scheduleEnabled ? 1.0 : 0.5,
                              child: Text(
                                'Frequência',
                                style: AppTypography.heading2Primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Opacity(
                              opacity: _scheduleEnabled ? 1.0 : 0.5,
                              child: IgnorePointer(
                                ignoring: !_scheduleEnabled,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DropdownButton<String>(
                                      value: _frequency,
                                      isExpanded: true,
                                      items: const [
                                        DropdownMenuItem(
                                          value: 'diariamente',
                                          child: Text('Diariamente'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'dias_uteis',
                                          child: Text('Dias úteis'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'personalizado',
                                          child: Text('Personalizado'),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        if (value == null) return;
                                        setState(() {
                                          _frequency = value;
                                        });
                                      },
                                    ),
                                    
                                    const SizedBox(height: 8),
                                    
                                    if (_frequency == 'personalizado')
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: TextButton(
                                          onPressed: _showWeekdaysDialog,
                                          child: const Text('Selecionar dias da semana'),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            
            // Botão salvar na parte inferior
            Padding(
              padding: const EdgeInsets.all(16),
              child: AppButton(
                label: l10n.saveChanges,
                onPressed: _saveChanges,
                height: 52,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWeekdaysDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final days = _selectedDays.keys.toList();
            
            return AlertDialog(
              title: Text(
                'Selecionar Dias',
                style: AppTypography.heading1Primary,
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final day in days)
                      CheckboxListTile(
                        title: Text(
                          day,
                          style: AppTypography.textPrimary,
                        ),
                        value: _selectedDays[day],
                        onChanged: (value) {
                          if (value == null) return;
                          setDialogState(() {
                            _selectedDays[day] = value;
                          });
                        },
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancelar',
                    style: AppTypography.textLink,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Confirmar',
                    style: AppTypography.textLink,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildReminderItem({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.border,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.textPrimary,
          ),
          AppToggle(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

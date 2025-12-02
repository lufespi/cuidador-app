import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/reminder_card.dart';
import '../../core/notifications/notification_service.dart';
import '../../core/utils/input_formatters.dart';
import '../../l10n/app_localizations.dart';
import '../../data/models/reminder_model.dart';
import '../../data/services/reminder_service.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  final ReminderService _reminderService = ReminderService();
  List<ReminderModel> _reminders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    setState(() => _isLoading = true);
    
    try {
      final reminders = await _reminderService.getReminders();
      if (mounted) {
        setState(() {
          _reminders = reminders;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar lembretes: ${e.toString()}'),
            backgroundColor: AppColors.stateError,
          ),
        );
      }
    }
  }

  void _toggleReminder(int index) async {
    final reminder = _reminders[index];
    final newState = !reminder.isActive;
    
    try {
      // Atualiza no backend
      final updatedReminder = await _reminderService.updateReminder(
        reminder.id!,
        reminder.copyWith(isActive: newState),
      );
      
      setState(() {
        _reminders[index] = updatedReminder;
      });
      
      if (newState) {
        // Ativar: agendar notificação
        await _scheduleReminderNotification(updatedReminder);
      } else {
        // Desativar: cancelar notificação
        await _cancelReminderNotification(updatedReminder);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar lembrete: ${e.toString()}'),
            backgroundColor: AppColors.stateError,
          ),
        );
      }
    }
  }
  
  Future<void> _scheduleReminderNotification(ReminderModel reminder) async {
    try {
      // Verifica se as notificações estão habilitadas globalmente
      final prefs = await SharedPreferences.getInstance();
      final notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      
      if (!notificationsEnabled) {
        // Notificações desabilitadas globalmente, não agenda
        return;
      }

      // Parse do horário (formato HH:mm)
      final timeParts = reminder.time.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      
      // Usar o ID do lembrete como ID da notificação
      final notificationId = reminder.id.hashCode;
      
      await NotificationService().scheduleDailyReminder(
        id: notificationId,
        hour: hour,
        minute: minute,
        title: reminder.title,
        body: reminder.description,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lembrete agendado para ${reminder.time}'),
            backgroundColor: AppColors.stateSuccess,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao agendar notificação: $e'),
            backgroundColor: AppColors.stateError,
          ),
        );
      }
    }
  }
  
  Future<void> _cancelReminderNotification(ReminderModel reminder) async {
    try {
      final notificationId = reminder.id.hashCode;
      await NotificationService().cancelNotification(notificationId);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notificação cancelada'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao cancelar notificação: $e'),
            backgroundColor: AppColors.stateError,
          ),
        );
      }
    }
  }

  void _editReminder(int index) {
    _showReminderDialog(reminder: _reminders[index], index: index);
  }

  void _deleteReminder(int index) async {
    final l10n = AppLocalizations.of(context)!;
    final reminder = _reminders[index];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          l10n.deleteReminder,
          style: AppTypography.heading2Primary,
        ),
        content: Text(
          l10n.deleteReminderConfirmation,
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.textDisabled,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.no,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textDisabled,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              
              try {
                // Deleta no backend
                await _reminderService.deleteReminder(reminder.id!);
                
                // Remove da lista local
                setState(() {
                  _reminders.removeAt(index);
                });
                
                // Cancelar notificação se estava ativa
                if (reminder.isActive) {
                  await _cancelReminderNotification(reminder);
                }
                
                navigator.pop();
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Lembrete excluído com sucesso'),
                    backgroundColor: AppColors.stateSuccess,
                  ),
                );
              } catch (e) {
                navigator.pop();
                messenger.showSnackBar(
                  SnackBar(
                    content: Text('Erro ao excluir lembrete: ${e.toString()}'),
                    backgroundColor: AppColors.stateError,
                  ),
                );
              }
            },
            child: Text(
              l10n.yes,
              style: AppTypography.captionPrimary.copyWith(
                color: AppColors.stateError,
              ),
            ),
          ),
        ],
      ),
    );
  }



  void _showReminderDialog({ReminderModel? reminder, int? index}) async {
    showDialog(
      context: context,
      builder: (context) => AddReminderDialog(
        reminder: reminder,
        onDelete: index != null ? () => _deleteReminder(index) : null,
        onSave: (newReminderData) async {
          final messenger = ScaffoldMessenger.of(context);
          
          try {
            if (index != null) {
              // Editando lembrete existente
              final oldReminder = _reminders[index];
              
              // Cancela notificação antiga se estava ativo
              if (oldReminder.isActive) {
                await _cancelReminderNotification(oldReminder);
              }
              
              // Atualiza no backend
              final updatedReminder = await _reminderService.updateReminder(
                oldReminder.id!,
                ReminderModel(
                  id: oldReminder.id,
                  userId: oldReminder.userId,
                  type: newReminderData['type'],
                  title: newReminderData['title'],
                  description: newReminderData['description'] ?? '',
                  frequency: newReminderData['frequency'] ?? 'Diário',
                  time: newReminderData['time'],
                  isActive: newReminderData['isActive'] ?? true,
                  selectedDays: newReminderData['selected_days'],
                ),
              );
              
              setState(() {
                _reminders[index] = updatedReminder;
              });
              
              // Agenda notificação se ativo
              if (updatedReminder.isActive) {
                await _scheduleReminderNotification(updatedReminder);
              }
            } else {
              // Criando novo lembrete
              final newReminder = await _reminderService.createReminder(
                ReminderModel(
                  type: newReminderData['type'],
                  title: newReminderData['title'],
                  description: newReminderData['description'] ?? '',
                  frequency: newReminderData['frequency'] ?? 'Diário',
                  time: newReminderData['time'],
                  isActive: newReminderData['isActive'] ?? true,
                  selectedDays: newReminderData['selected_days'],
                ),
              );
              
              setState(() {
                _reminders.add(newReminder);
              });
              
              // Agenda notificação se ativo
              if (newReminder.isActive) {
                await _scheduleReminderNotification(newReminder);
              }
            }
          } catch (e) {
            messenger.showSnackBar(
              SnackBar(
                content: Text('Erro ao salvar lembrete: ${e.toString()}'),
                backgroundColor: AppColors.stateError,
              ),
            );
          }
        },
      ),
    );
  }

  String _getReminderTypeLabel(String type, AppLocalizations l10n) {
    switch (type) {
      case 'exercise':
        return l10n.reminderTypeExercise;
      case 'medication':
        return l10n.reminderTypeMedication;
      case 'appointment':
        return l10n.reminderTypeAppointment;
      case 'practice':
        return l10n.reminderTypePractice;
      case 'hydration':
        return l10n.reminderTypeHydration;
      case 'diet':
        return l10n.reminderTypeDiet;
      default:
        return l10n.reminderTypeLabel;
    }
  }

  IconData _getReminderIcon(String type) {
    switch (type) {
      case 'exercise':
        return Icons.fitness_center_outlined;
      case 'medication':
        return Icons.medication_outlined;
      case 'appointment':
        return Icons.calendar_today_outlined;
      case 'practice':
        return Icons.self_improvement_outlined;
      case 'hydration':
        return Icons.water_drop_outlined;
      case 'diet':
        return Icons.restaurant_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.notifications_outlined,
                        color: AppColors.buttonPrimary,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.remindersTitle,
                              style: AppTypography.pageTitle,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.remindersSubtitle,
                              style: AppTypography.bodyLarge.copyWith(
                                color: AppColors.textDisabled,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () => _showReminderDialog(),
                        backgroundColor: AppColors.buttonPrimary,
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Lista de lembretes
            Expanded(
              child: _reminders.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_off_outlined,
                            size: 64,
                            color: AppColors.textDisabled.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noReminders,
                            style: AppTypography.heading2Primary.copyWith(
                              color: AppColors.textDisabled,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.noRemindersDescription,
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.textDisabled,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _reminders.length,
                      itemBuilder: (context, index) {
                        final reminder = _reminders[index];
                        return ReminderCard(
                          title: reminder.title,
                          description: reminder.description,
                          frequency: reminder.frequency,
                          time: reminder.time,
                          isActive: reminder.isActive,
                          icon: _getReminderIcon(reminder.type),
                          type: _getReminderTypeLabel(reminder.type, l10n),
                          onToggle: () => _toggleReminder(index),
                          onEdit: () => _editReminder(index),
                          onDelete: () => _deleteReminder(index),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dialog para adicionar/editar lembrete
class AddReminderDialog extends StatefulWidget {
  final ReminderModel? reminder;
  final Function(Map<String, dynamic>) onSave;
  final VoidCallback? onDelete;

  const AddReminderDialog({
    super.key,
    this.reminder,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<AddReminderDialog> createState() => _AddReminderDialogState();
}

class _AddReminderDialogState extends State<AddReminderDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _timeController = TextEditingController();
  String _selectedType = 'exercise';
  String? _selectedFrequency;

  List<Map<String, dynamic>> _reminderTypes = [];
  List<String> _frequencies = [];
  Map<String, bool> _selectedDays = {};
  Map<String, Map<String, String>> _placeholdersByType = {};

  @override
  void initState() {
    super.initState();
    
    // Inicializa depois que o context está disponível
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final l10n = AppLocalizations.of(context)!;
      
      setState(() {
        _reminderTypes = [
          {'value': 'exercise', 'label': l10n.reminderTypeExercise},
          {'value': 'medication', 'label': l10n.reminderTypeMedication},
          {'value': 'appointment', 'label': l10n.reminderTypeAppointment},
          {'value': 'practice', 'label': l10n.reminderTypePractice},
          {'value': 'hydration', 'label': l10n.reminderTypeHydration},
          {'value': 'diet', 'label': l10n.reminderTypeDiet},
        ];

        _placeholdersByType = {
          'exercise': {
            'title': l10n.exampleMorningWalk,
            'message': l10n.exampleMorningWalkDesc,
          },
          'medication': {
            'title': l10n.exampleTakeMedication,
            'message': l10n.exampleTakeMedicationDesc,
          },
          'appointment': {
            'title': l10n.exampleMedicalAppointment,
            'message': l10n.exampleMedicalAppointmentDesc,
          },
          'practice': {
            'title': l10n.exampleBreathing478,
            'message': l10n.exampleBreathing478Desc,
          },
          'hydration': {
            'title': l10n.exampleDrinkWater,
            'message': l10n.exampleDrinkWaterDesc,
          },
          'diet': {
            'title': l10n.exampleHealthySnack,
            'message': l10n.exampleHealthySnackDesc,
          },
        };

        _frequencies = [
          l10n.reminderDaily,
          l10n.reminderWeekdays,
          l10n.reminderWeekends,
          l10n.reminderCustom,
        ];

        _selectedDays = {
          l10n.monday: false,
          l10n.tuesday: false,
          l10n.wednesday: false,
          l10n.thursday: false,
          l10n.friday: false,
          l10n.saturday: false,
          l10n.sunday: false,
        };
        
        // Define frequência inicial
        _selectedFrequency ??= _frequencies[0]; // Primeiro item por padrão
      });
    });
    
    if (widget.reminder != null) {
      _titleController.text = widget.reminder!.title;
      _descriptionController.text = widget.reminder!.description;
      _selectedType = widget.reminder!.type;
      _timeController.text = widget.reminder!.time;
    } else {
      // Valor padrão
      _timeController.text = '08:00';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  String get _titlePlaceholder {
    return _placeholdersByType[_selectedType]?['title'] ?? 
           AppLocalizations.of(context)!.reminderTitlePlaceholder;
  }

  String get _messagePlaceholder {
    return _placeholdersByType[_selectedType]?['message'] ?? 
           AppLocalizations.of(context)!.reminderDescriptionPlaceholder;
  }

  void _showWeekdaysDialog() {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final days = _selectedDays.keys.toList();
            
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                l10n.selectDays,
                style: AppTypography.heading1Primary,
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Organizar em 2 colunas
                    for (int i = 0; i < days.length; i += 2)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            // Primeira coluna
                            Expanded(
                              child: _buildDayButton(
                                days[i],
                                setDialogState,
                              ),
                            ),
                            
                            const SizedBox(width: 8),
                            
                            // Segunda coluna (se existir)
                            Expanded(
                              child: i + 1 < days.length
                                  ? _buildDayButton(
                                      days[i + 1],
                                      setDialogState,
                                    )
                                  : const SizedBox(),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    l10n.cancel,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textDisabled,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      // Atualiza o estado principal
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    l10n.confirm,
                    style: AppTypography.captionPrimary.copyWith(
                      color: AppColors.buttonPrimary,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDayButton(String day, StateSetter setDialogState) {
    final isSelected = _selectedDays[day]!;
    
    return InkWell(
      onTap: () {
        setDialogState(() {
          _selectedDays[day] = !_selectedDays[day]!;
        });
      },
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.buttonPrimary
              : AppColors.buttonPrimary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            day,
            style: (isSelected ? AppTypography.captionPrimary : AppTypography.bodyMedium).copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _save() {
    final l10n = AppLocalizations.of(context)!;
    
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseEnterTitle)),
      );
      return;
    }

    if (_timeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseEnterTime)),
      );
      return;
    }

    final reminder = {
      'type': _selectedType,
      'title': _titleController.text,
      'description': _descriptionController.text,
      'frequency': _selectedFrequency,
      'time': _timeController.text,
      'isActive': widget.reminder?.isActive ?? true,
      'selected_days': _selectedDays,
    };

    widget.onSave(reminder);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Obter dimensões da tela para criar quadrado
    final screenSize = MediaQuery.of(context).size;
    final dialogSize = screenSize.width * 0.9; // 90% da largura da tela
    
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        width: dialogSize,
        height: dialogSize, // Mesmo valor para fazer quadrado
        child: Column(
          children: [
            // Header fixo (não rola)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                children: [
                  const Icon(
                    Icons.notifications_outlined,
                    color: AppColors.buttonPrimary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.reminder == null ? l10n.addReminder : l10n.editReminder,
                      style: AppTypography.displayMedium,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    color: AppColors.textDisabled,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            
            // Divider
            Container(
              height: 1,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1)
                  : AppColors.inputBackground,
            ),
            
            // Conteúdo rolável
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              // Dropdown de tipo
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                decoration: InputDecoration(
                  hintText: l10n.reminderTypeHint,
                  hintStyle: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textDisabled,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF2E3838)
                      : AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.buttonPrimary,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.buttonPrimary,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.buttonPrimary,
                      width: 2,
                    ),
                  ),
                ),
                items: _reminderTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type['value'] as String,
                    child: Text(
                      type['label'] as String,
                      style: AppTypography.textPrimary,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedType = value;
                    });
                  }
                },
              ),
              
              const SizedBox(height: 16),
              
              // Campo de título
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: _titlePlaceholder,
                  hintStyle: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textDisabled,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF2E3838)
                      : AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.buttonPrimary,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.buttonPrimary,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.buttonPrimary,
                      width: 2,
                    ),
                  ),
                ),
                style: AppTypography.textPrimary,
              ),
              
              const SizedBox(height: 16),
              
              // Campo de mensagem/descrição
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: _messagePlaceholder,
                  hintStyle: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textDisabled,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF2E3838)
                      : AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.buttonPrimary,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.buttonPrimary,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.buttonPrimary,
                      width: 2,
                    ),
                  ),
                ),
                style: AppTypography.textPrimary,
              ),
              
              const SizedBox(height: 16),
              
              // Dropdown de frequência
              DropdownButtonFormField<String>(
                initialValue: _selectedFrequency,
                decoration: InputDecoration(
                  hintText: l10n.reminderFrequencyHint,
                  hintStyle: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textDisabled,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF2E3838)
                      : AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.buttonPrimary,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.buttonPrimary,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.buttonPrimary,
                      width: 2,
                    ),
                  ),
                ),
                items: _frequencies.map((frequency) {
                  return DropdownMenuItem(
                    value: frequency,
                    child: Text(
                      frequency,
                      style: AppTypography.textPrimary,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedFrequency = value;
                      
                      // Reseta os dias selecionados se mudar para outra opção
                      if (value != AppLocalizations.of(context)!.reminderCustom) {
                        _selectedDays.updateAll((key, val) => false);
                      }
                    });
                    
                    // Abre o popup se for personalizado
                    if (value == AppLocalizations.of(context)!.reminderCustom) {
                      _showWeekdaysDialog();
                    }
                  }
                },
              ),
              
              const SizedBox(height: 16),
              
              // Campo de horário
              TextField(
                controller: _timeController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  TimeInputFormatter(),
                ],
                decoration: InputDecoration(
                  hintText: l10n.reminderTimeHint,
                  hintStyle: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textDisabled,
                  ),
                  prefixIcon: const Icon(
                    Icons.access_time,
                    color: AppColors.textDisabled,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF2E3838)
                      : AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.buttonPrimary,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.buttonPrimary,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.buttonPrimary,
                      width: 2,
                    ),
                  ),
                ),
                style: AppTypography.textPrimary,
              ),
              
              const SizedBox(height: 24),
              
              // Botão de criar/salvar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    widget.reminder == null ? l10n.createReminder : l10n.saveChanges,
                    style: AppTypography.sectionTitle.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              // Botão de excluir (apenas ao editar)
              if (widget.reminder != null && widget.onDelete != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Fecha o dialog de edição
                      Navigator.pop(context);
                      // Chama o callback de exclusão
                      widget.onDelete!();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.stateError,
                      side: const BorderSide(color: AppColors.stateError),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.delete_outline, size: 20),
                    label: Text(
                      l10n.deleteReminder,
                      style: AppTypography.sectionTitle.copyWith(
                        color: AppColors.stateError,
                      ),
                    ),
                  ),
                ),
              ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

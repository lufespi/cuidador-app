import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/reminder_card.dart';
import '../../l10n/app_localizations.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  // Lista de lembretes
  final List<Map<String, dynamic>> _reminders = [
    {
      'id': '1',
      'type': 'exercise',
      'title': 'Respiração Matinal',
      'description': 'Faça 5 minutos de respiração 4-7-8',
      'frequency': 'Diário',
      'time': '08:00',
      'isActive': true,
      'icon': Icons.air_outlined,
    },
    {
      'id': '2',
      'type': 'medication',
      'title': 'Medicação',
      'description': 'Tomar medicamento prescrito',
      'frequency': 'Diário',
      'time': '12:00',
      'isActive': false,
      'icon': Icons.medication_outlined,
    },
  ];

  void _toggleReminder(int index) {
    setState(() {
      _reminders[index]['isActive'] = !_reminders[index]['isActive'];
    });
  }

  void _editReminder(int index) {
    _showReminderDialog(reminder: _reminders[index], index: index);
  }

  void _deleteReminder(int index) {
    final l10n = AppLocalizations.of(context)!;
    
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
            onPressed: () {
              setState(() {
                _reminders.removeAt(index);
              });
              Navigator.pop(context);
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



  void _showReminderDialog({Map<String, dynamic>? reminder, int? index}) {
    showDialog(
      context: context,
      builder: (context) => AddReminderDialog(
        reminder: reminder,
        onSave: (newReminder) {
          setState(() {
            if (index != null) {
              _reminders[index] = newReminder;
            } else {
              _reminders.add(newReminder);
            }
          });
        },
        onDelete: index != null ? () {
          setState(() {
            _reminders.removeAt(index);
          });
        } : null,
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
      body: SafeArea(
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
                          title: reminder['title'],
                          description: reminder['description'],
                          frequency: reminder['frequency'],
                          time: reminder['time'],
                          isActive: reminder['isActive'],
                          icon: _getReminderIcon(reminder['type']),
                          type: _getReminderTypeLabel(reminder['type'], l10n),
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
  final Map<String, dynamic>? reminder;
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
      _titleController.text = widget.reminder!['title'];
      _descriptionController.text = widget.reminder!['description'];
      _selectedType = widget.reminder!['type'];
      _timeController.text = widget.reminder!['time'];
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
      'id': widget.reminder?['id'] ?? DateTime.now().toString(),
      'type': _selectedType,
      'title': _titleController.text,
      'description': _descriptionController.text,
      'frequency': _selectedFrequency,
      'time': _timeController.text,
      'isActive': widget.reminder?['isActive'] ?? true,
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
              if (widget.reminder != null) ...[
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: _showDeleteConfirmation,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      l10n.deleteReminder,
                      style: AppTypography.sectionTitle.copyWith(
                        color: AppColors.stateError.withValues(alpha: 0.7),
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

  void _showDeleteConfirmation() {
    final l10n = AppLocalizations.of(context)!;
    
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
            onPressed: () {
              Navigator.pop(context); // Apenas fecha o dialog de confirmação
            },
            child: Text(
              l10n.no,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textDisabled,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fecha o dialog de confirmação
              Navigator.pop(context); // Fecha o dialog de edição
              if (widget.onDelete != null) {
                widget.onDelete!(); // Remove o lembrete
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
}

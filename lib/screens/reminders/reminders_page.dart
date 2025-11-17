import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/reminder_card.dart';

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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Excluir Lembrete',
          style: AppTypography.heading2Primary,
        ),
        content: Text(
          'Tem certeza que deseja excluir este lembrete?',
          style: AppTypography.textPrimary.copyWith(
            color: AppColors.textDisabled,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Não',
              style: AppTypography.textPrimary.copyWith(
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
              'Sim',
              style: AppTypography.textPrimary.copyWith(
                color: AppColors.stateError,
                fontWeight: FontWeight.w600,
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

  String _getReminderTypeLabel(String type) {
    switch (type) {
      case 'exercise':
        return 'Exercício';
      case 'medication':
        return 'Medicação';
      case 'appointment':
        return 'Consulta';
      case 'practice':
        return 'Prática';
      case 'hydration':
        return 'Hidratação';
      case 'diet':
        return 'Dieta';
      default:
        return 'Lembrete';
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
    return Scaffold(
      backgroundColor: AppColors.background,
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
                              'Lembretes',
                              style: AppTypography.heading1Primary.copyWith(
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Não esqueça seus cuidados',
                              style: AppTypography.textPrimary.copyWith(
                                color: AppColors.textDisabled,
                                fontSize: 14,
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
                            'Nenhum lembrete criado',
                            style: AppTypography.heading2Primary.copyWith(
                              color: AppColors.textDisabled,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Toque no botão + para criar',
                            style: AppTypography.textPrimary.copyWith(
                              color: AppColors.textDisabled,
                              fontSize: 14,
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
                          type: _getReminderTypeLabel(reminder['type']),
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
  String _selectedFrequency = 'Diário';

  final List<Map<String, dynamic>> _reminderTypes = [
    {'value': 'exercise', 'label': 'Exercício'},
    {'value': 'medication', 'label': 'Medicação'},
    {'value': 'appointment', 'label': 'Consulta'},
    {'value': 'practice', 'label': 'Prática'},
    {'value': 'hydration', 'label': 'Hidratação'},
    {'value': 'diet', 'label': 'Dieta'},
  ];

  // Exemplos de título e mensagem por tipo
  final Map<String, Map<String, String>> _placeholdersByType = {
    'exercise': {
      'title': 'Caminhada Matinal',
      'message': 'Faça 30 minutos de caminhada leve',
    },
    'medication': {
      'title': 'Tomar Medicamento',
      'message': 'Medicação prescrita pelo médico',
    },
    'appointment': {
      'title': 'Consulta Médica',
      'message': 'Lembre-se de levar exames e documentos',
    },
    'practice': {
      'title': 'Respiração 4-7-8',
      'message': 'Faça 5 minutos de exercícios respiratórios',
    },
    'hydration': {
      'title': 'Beber Água',
      'message': 'Hidrate-se com um copo de água',
    },
    'diet': {
      'title': 'Lanche Saudável',
      'message': 'Coma uma fruta ou alimento nutritivo',
    },
  };

  final List<String> _frequencies = [
    'Diário',
    'Dias úteis',
    'Fins de semana',
    'Personalizado',
  ];

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
  void initState() {
    super.initState();
    if (widget.reminder != null) {
      _titleController.text = widget.reminder!['title'];
      _descriptionController.text = widget.reminder!['description'];
      _selectedType = widget.reminder!['type'];
      _selectedFrequency = widget.reminder!['frequency'];
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
    return _placeholdersByType[_selectedType]?['title'] ?? 'Título do lembrete';
  }

  String get _messagePlaceholder {
    return _placeholdersByType[_selectedType]?['message'] ?? 'Descrição do lembrete';
  }

  void _showWeekdaysDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final days = _selectedDays.keys.toList();
            
            return AlertDialog(
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                'Selecionar Dias',
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
                    'Cancelar',
                    style: AppTypography.textPrimary.copyWith(
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
                    'Confirmar',
                    style: AppTypography.textPrimary.copyWith(
                      color: AppColors.buttonPrimary,
                      fontWeight: FontWeight.w600,
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
            style: AppTypography.textPrimary.copyWith(
              color: Colors.white,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  void _save() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira um título')),
      );
      return;
    }

    if (_timeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira um horário')),
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
    // Obter dimensões da tela para criar quadrado
    final screenSize = MediaQuery.of(context).size;
    final dialogSize = screenSize.width * 0.9; // 90% da largura da tela
    
    return Dialog(
      backgroundColor: AppColors.surface,
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
                  Text(
                    widget.reminder == null ? 'Adicionar Lembrete' : 'Editar Lembrete',
                    style: AppTypography.heading2Primary.copyWith(
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
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
              color: AppColors.inputBackground,
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
                value: _selectedType,
                decoration: InputDecoration(
                  hintText: 'Tipo de lembrete',
                  hintStyle: AppTypography.textPrimary.copyWith(
                    color: AppColors.textDisabled,
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
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
                  hintStyle: AppTypography.textPrimary.copyWith(
                    color: AppColors.textDisabled,
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
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
                  hintStyle: AppTypography.textPrimary.copyWith(
                    color: AppColors.textDisabled,
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
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
                value: _selectedFrequency,
                decoration: InputDecoration(
                  hintText: 'Frequência',
                  hintStyle: AppTypography.textPrimary.copyWith(
                    color: AppColors.textDisabled,
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
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
                      if (value != 'Personalizado') {
                        _selectedDays.updateAll((key, val) => false);
                      }
                    });
                    
                    // Abre o popup se for personalizado
                    if (value == 'Personalizado') {
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
                  hintText: 'Horário (ex: 08:00)',
                  hintStyle: AppTypography.textPrimary.copyWith(
                    color: AppColors.textDisabled,
                  ),
                  prefixIcon: const Icon(
                    Icons.access_time,
                    color: AppColors.textDisabled,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
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
                    widget.reminder == null ? 'Criar Lembrete' : 'Salvar Alterações',
                    style: AppTypography.textPrimary.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
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
                      'Excluir Lembrete',
                      style: AppTypography.heading2Primary.copyWith(
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Excluir Lembrete',
          style: AppTypography.heading2Primary,
        ),
        content: Text(
          'Tem certeza que deseja excluir este lembrete?',
          style: AppTypography.textPrimary.copyWith(
            color: AppColors.textDisabled,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Apenas fecha o dialog de confirmação
            },
            child: Text(
              'Não',
              style: AppTypography.textPrimary.copyWith(
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
              'Sim',
              style: AppTypography.textPrimary.copyWith(
                color: AppColors.stateError,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

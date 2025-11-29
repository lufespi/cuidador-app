import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/utils/input_formatters.dart';
import '../../../../data/services/auth_service.dart';

class EditBirthDatePage extends StatefulWidget {
  final String currentBirthDate;

  const EditBirthDatePage({
    super.key,
    required this.currentBirthDate,
  });

  @override
  State<EditBirthDatePage> createState() => _EditBirthDatePageState();
}

class _EditBirthDatePageState extends State<EditBirthDatePage> {
  final AuthService _authService = AuthService();
  final TextEditingController _dateController = TextEditingController();
  late DateTime _selectedDate;
  late DateTime _initialDate;
  bool _hasChanges = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Tentar parsear a data atual, se falhar usa data padrão
    try {
      final parts = widget.currentBirthDate.split('/');
      if (parts.length == 3) {
        _selectedDate = DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      } else {
        _selectedDate = DateTime(2000, 1, 1);
      }
    } catch (e) {
      _selectedDate = DateTime(2000, 1, 1);
    }
    _initialDate = _selectedDate;
    _dateController.text = _formatDate(_selectedDate);
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  void _checkForChanges() {
    setState(() {
      _hasChanges = _selectedDate != _initialDate;
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.buttonPrimary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
      _checkForChanges();
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
  
  DateTime? _parseDate(String text) {
    try {
      final parts = text.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        
        // Validação básica
        if (day >= 1 && day <= 31 && month >= 1 && month <= 12 && year >= 1900 && year <= DateTime.now().year) {
          return DateTime(year, month, day);
        }
      }
    } catch (e) {
      // Ignora erros de parse
    }
    return null;
  }

  void _saveChanges() async {
    final l10n = AppLocalizations.of(context)!;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Salva no backend
      await _authService.updateProfile(dataNascimento: _selectedDate);
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.birthDateUpdatedSuccess),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, _formatDate(_selectedDate));
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
          l10n.editBirthDate,
          style: AppTypography.heading1Secondary,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.birthdate,
                              style: AppTypography.heading2Primary,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Selecione sua data de nascimento.',
                              style: TextStyle(
                                color: AppColors.textDisabled,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 20),
                            
                            TextField(
                              controller: _dateController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                DateInputFormatter(),
                              ],
                              onChanged: (value) {
                                if (value.length == 10) {
                                  final parsed = _parseDate(value);
                                  if (parsed != null) {
                                    setState(() {
                                      _selectedDate = parsed;
                                    });
                                    _checkForChanges();
                                  }
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'DD/MM/AAAA',
                                hintStyle: AppTypography.bodyLarge.copyWith(
                                  color: AppColors.textDisabled,
                                ),
                                prefixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.calendar_today,
                                    color: AppColors.buttonPrimary,
                                    size: 20,
                                  ),
                                  onPressed: _selectDate,
                                ),
                                filled: true,
                                fillColor: Theme.of(context).brightness == Brightness.dark
                                    ? const Color(0xFF2E3838)
                                    : Colors.white,
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
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            
            // Botão salvar na parte inferior
            Padding(
              padding: const EdgeInsets.all(16),
              child: AppButton(
                label: _isLoading ? 'Salvando...' : l10n.saveChanges,
                onPressed: _hasChanges && !_isLoading ? _saveChanges : null,
                height: 52,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

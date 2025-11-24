import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../data/services/auth_service.dart';

class EditComorbiditiesPage extends StatefulWidget {
  final String currentComorbidities;

  const EditComorbiditiesPage({
    super.key,
    required this.currentComorbidities,
  });

  @override
  State<EditComorbiditiesPage> createState() => _EditComorbiditiesPageState();
}

class _EditComorbiditiesPageState extends State<EditComorbiditiesPage> {
  final _formKey = GlobalKey<FormState>();
  final _otherComorbidityController = TextEditingController();
  final AuthService _authService = AuthService();
  late List<String> _selectedComorbidities;
  late String _initialComorbidities;
  bool _hasChanges = false;
  bool _isLoading = false;

  final List<String> _comorbidityOptions = [
    'Hipertensão',
    'Diabetes',
    'Osteoporose',
    'Outra',
  ];

  @override
  void initState() {
    super.initState();
    _initialComorbidities = widget.currentComorbidities;
    _selectedComorbidities = [];
    
    // Parse as comorbidades atuais
    if (widget.currentComorbidities != 'Nenhuma') {
      final comorbidities = widget.currentComorbidities.split(', ');
      for (var comorbidity in comorbidities) {
        if (_comorbidityOptions.take(3).contains(comorbidity)) {
          _selectedComorbidities.add(comorbidity);
        } else {
          // É uma comorbidade personalizada
          _selectedComorbidities.add('Outra');
          _otherComorbidityController.text = comorbidity;
        }
      }
    }
    
    _otherComorbidityController.addListener(_checkForChanges);
  }

  @override
  void dispose() {
    _otherComorbidityController.dispose();
    super.dispose();
  }

  void _checkForChanges() {
    setState(() {
      final currentValue = _getCurrentComorbiditiesText();
      _hasChanges = currentValue != _initialComorbidities;
    });
  }

  String _getCurrentComorbiditiesText() {
    if (_selectedComorbidities.isEmpty) {
      return 'Nenhuma';
    }
    
    final comorbidities = _selectedComorbidities.map((c) {
      if (c == 'Outra') {
        return _otherComorbidityController.text;
      }
      return c;
    }).where((c) => c.isNotEmpty).toList();
    
    return comorbidities.join(', ');
  }

  void _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final l10n = AppLocalizations.of(context)!;

    try {
      final comorbidities = _getCurrentComorbiditiesText();

      // Salva no backend
      await _authService.updateProfile(comorbidades: comorbidities);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.comorbiditiesUpdatedSuccess),
            backgroundColor: AppColors.stateSuccess,
          ),
        );
        Navigator.pop(context, comorbidities);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar comorbidades: $e'),
            backgroundColor: AppColors.stateError,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildComorbidityOption(String comorbidity) {
    final isSelected = _selectedComorbidities.contains(comorbidity);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedComorbidities.remove(comorbidity);
          } else {
            _selectedComorbidities.add(comorbidity);
          }
          _checkForChanges();
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected 
                      ? AppColors.buttonPrimary 
                      : AppColors.textDisabled,
                  width: 2,
                ),
                color: isSelected ? AppColors.buttonPrimary : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.circle,
                      size: 10,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                comorbidity,
                style: AppTypography.textPrimary.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
          l10n.editComorbidities,
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        
                        AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.comorbidities,
                                style: AppTypography.heading2Primary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.selectAllThatApply,
                                style: AppTypography.textPrimary.copyWith(
                                  color: AppColors.textDisabled,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 20),
                              
                              ..._comorbidityOptions.map((comorbidity) => _buildComorbidityOption(comorbidity)),
                              
                              if (_selectedComorbidities.contains('Outra')) ...[
                                const SizedBox(height: 12),
                                AppTextField(
                                  controller: _otherComorbidityController,
                                  label: 'Especifique a comorbidade',
                                  maxLines: 2,
                                  validator: (value) {
                                    if (_selectedComorbidities.contains('Outra') &&
                                        (value == null || value.isEmpty)) {
                                      return 'Por favor, especifique a comorbidade';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                      ],
                    ),
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

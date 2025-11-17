import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_button.dart';

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
  late List<String> _selectedComorbidities;
  late String _initialComorbidities;
  bool _hasChanges = false;

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

  void _saveChanges() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final comorbidities = _getCurrentComorbiditiesText();
    
    // TODO: Salvar alteração das comorbidades
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Comorbidades atualizadas com sucesso!'),
        backgroundColor: AppColors.stateSuccess,
      ),
    );
    Navigator.pop(context, comorbidities);
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.buttonPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Editar Comorbidades',
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
                                'Comorbidades',
                                style: AppTypography.heading2Primary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Selecione todas que se aplicam',
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
                label: 'Salvar Alterações',
                onPressed: _hasChanges ? _saveChanges : null,
                height: 52,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

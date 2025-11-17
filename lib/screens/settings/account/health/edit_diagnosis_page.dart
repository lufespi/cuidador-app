import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_button.dart';

class EditDiagnosisPage extends StatefulWidget {
  final String currentDiagnosis;

  const EditDiagnosisPage({
    super.key,
    required this.currentDiagnosis,
  });

  @override
  State<EditDiagnosisPage> createState() => _EditDiagnosisPageState();
}

class _EditDiagnosisPageState extends State<EditDiagnosisPage> {
  final _formKey = GlobalKey<FormState>();
  final _otherDiagnosisController = TextEditingController();
  late String _selectedDiagnosis;
  late String _initialDiagnosis;
  bool _hasChanges = false;

  final List<String> _diagnosisOptions = [
    'Artrite reumatoide',
    'Artrose',
    'Fibromialgia',
    'Outro diagnóstico',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDiagnosis = widget.currentDiagnosis;
    _initialDiagnosis = widget.currentDiagnosis;
    
    // Se o diagnóstico atual não está na lista, é um "Outro diagnóstico"
    if (!_diagnosisOptions.take(3).contains(widget.currentDiagnosis)) {
      _otherDiagnosisController.text = widget.currentDiagnosis;
      _selectedDiagnosis = 'Outro diagnóstico';
    }
    
    _otherDiagnosisController.addListener(_checkForChanges);
  }

  @override
  void dispose() {
    _otherDiagnosisController.dispose();
    super.dispose();
  }

  void _checkForChanges() {
    setState(() {
      final currentValue = _selectedDiagnosis == 'Outro diagnóstico' 
          ? _otherDiagnosisController.text 
          : _selectedDiagnosis;
      _hasChanges = currentValue != _initialDiagnosis;
    });
  }

  void _saveChanges() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Retorna o diagnóstico selecionado ou o texto personalizado
    final diagnosis = _selectedDiagnosis == 'Outro diagnóstico'
        ? _otherDiagnosisController.text
        : _selectedDiagnosis;
        
    // TODO: Salvar alteração do diagnóstico
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Diagnóstico principal atualizado com sucesso!'),
        backgroundColor: AppColors.stateSuccess,
      ),
    );
    Navigator.pop(context, diagnosis);
  }

  Widget _buildDiagnosisOption(String diagnosis) {
    final isSelected = _selectedDiagnosis == diagnosis;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDiagnosis = diagnosis;
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
                diagnosis,
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
          'Editar Diagnóstico Principal',
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
                                'Diagnóstico Principal',
                                style: AppTypography.heading2Primary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Informe o diagnóstico principal ou condição de saúde que está sendo tratada.',
                                style: AppTypography.textPrimary.copyWith(
                                  color: AppColors.textDisabled,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 20),
                              
                              ..._diagnosisOptions.map((diagnosis) => _buildDiagnosisOption(diagnosis)),
                              
                              if (_selectedDiagnosis == 'Outro diagnóstico') ...[
                                const SizedBox(height: 12),
                                AppTextField(
                                  controller: _otherDiagnosisController,
                                  label: 'Especifique o diagnóstico',
                                  maxLines: 2,
                                  validator: (value) {
                                    if (_selectedDiagnosis == 'Outro diagnóstico' &&
                                        (value == null || value.isEmpty)) {
                                      return 'Por favor, especifique o diagnóstico';
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

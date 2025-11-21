import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/step_indicator.dart';
import 'register_page_step_3.dart';

class RegisterPageStep2 extends StatefulWidget {
  const RegisterPageStep2({super.key});

  @override
  State<RegisterPageStep2> createState() => _RegisterPageStep2State();
}

class _RegisterPageStep2State extends State<RegisterPageStep2> {
  final _formKey = GlobalKey<FormState>();
  final _otherDiagnosisController = TextEditingController();
  final _otherComorbidityController = TextEditingController();
  
  String? _selectedDiagnosis;
  final List<String> _selectedComorbidities = [];
  bool _isBackButtonPressed = false;
  bool _showErrors = false;

  @override
  void dispose() {
    _otherDiagnosisController.dispose();
    _otherComorbidityController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    setState(() {
      _showErrors = true;
    });
    
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedDiagnosis == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, selecione o diagnóstico principal'),
          ),
        );
        return;
      }
      
      if (_selectedDiagnosis == 'Outro diagnóstico' && _otherDiagnosisController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, especifique seu diagnóstico'),
          ),
        );
        return;
      }
      
      if (_selectedComorbidities.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, selecione pelo menos uma comorbidade ou "Nenhuma"'),
          ),
        );
        return;
      }
      
      if (_selectedComorbidities.contains('Outra') && _otherComorbidityController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, especifique a comorbidade'),
          ),
        );
        return;
      }
      
      // Navigate to next step
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RegisterPageStep3(),
        ),
      );
    }
  }

  void _handleBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/images/cuidador-horizontal-logo.png',
                  height: 60,
                ),
                const SizedBox(height: 24),
                
                // Welcome text
                Text(
                  'Conte um pouco sobre você para começarmos seu acompanhamento personalizado.',
                  style: AppTypography.textPrimary.copyWith(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                
                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        _isBackButtonPressed = true;
                      });
                    },
                    onTapUp: (_) {
                      setState(() {
                        _isBackButtonPressed = false;
                      });
                    },
                    onTapCancel: () {
                      setState(() {
                        _isBackButtonPressed = false;
                      });
                    },
                    onTap: _handleBack,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _isBackButtonPressed 
                            ? AppColors.buttonPrimary.withAlpha(25)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_back,
                            color: AppColors.textPrimary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Voltar',
                            style: AppTypography.textPrimary.copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Step indicators
                const StepIndicator(
                  currentStep: 1,
                  totalSteps: 3,
                ),
                const SizedBox(height: 32),
                
                // Primary diagnosis card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF192E2D)
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section title
                      Row(
                        children: [
                          Icon(
                            Icons.medical_services_outlined,
                            color: Theme.of(context).colorScheme.onSurface,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Dados de Saúde',
                            style: AppTypography.heading2Primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Selecione seu diagnóstico principal e comorbidades. Você pode editar isso mais tarde.',
                        style: AppTypography.textPrimary.copyWith(fontSize: 12),
                      ),
                      const SizedBox(height: 24),
                      
                      // Primary diagnosis section
                      RichText(
                        text: TextSpan(
                          text: 'Diagnóstico Principal ',
                          style: AppTypography.heading2Primary.copyWith(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          children: const [
                            TextSpan(
                              text: '*',
                              style: TextStyle(
                                color: AppColors.stateError,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      _buildDiagnosisOption('Artrite reumatoide'),
                      _buildDiagnosisOption('Artrose'),
                      _buildDiagnosisOption('Fibromialgia'),
                      _buildDiagnosisOption('Outro diagnóstico'),
                      
                      if (_selectedDiagnosis == 'Outro diagnóstico') ...[
                        const SizedBox(height: 8),
                        AppTextField(
                          label: '',
                          hint: 'Especifique seu diagnóstico',
                          controller: _otherDiagnosisController,
                          validator: (value) {
                            if (_showErrors && (value == null || value.trim().isEmpty)) {
                              return 'Campo obrigatório';
                            }
                            return null;
                          },
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Comorbidities card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF192E2D)
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Comorbidities section
                      RichText(
                        text: TextSpan(
                          text: 'Comorbidades ',
                          style: AppTypography.heading2Primary.copyWith(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          children: const [
                            TextSpan(
                              text: '*',
                              style: TextStyle(
                                color: AppColors.stateError,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Selecione todas que se aplicam (ou "Nenhuma")',
                        style: AppTypography.textPrimary.copyWith(fontSize: 12),
                      ),
                      const SizedBox(height: 16),
                      
                      _buildComorbidityOption('Hipertensão'),
                      _buildComorbidityOption('Diabetes'),
                      _buildComorbidityOption('Osteoporose'),
                      _buildComorbidityOption('Outra'),
                      _buildComorbidityOption('Nenhuma'),
                      
                      if (_selectedComorbidities.contains('Outra')) ...[
                        const SizedBox(height: 8),
                        AppTextField(
                          label: '',
                          hint: 'Especifique a comorbidade',
                          controller: _otherComorbidityController,
                          validator: (value) {
                            if (_showErrors && (value == null || value.trim().isEmpty)) {
                              return 'Campo obrigatório';
                            }
                            return null;
                          },
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Continue button
                AppButton(
                  label: 'Continuar',
                  onPressed: _handleContinue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDiagnosisOption(String title) {
    final isSelected = _selectedDiagnosis == title;
    final showError = _showErrors && _selectedDiagnosis == null;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDiagnosis = title;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: showError 
                      ? AppColors.stateError 
                      : (isSelected ? AppColors.buttonPrimary : AppColors.textDisabled),
                  width: 2,
                ),
                color: isSelected ? AppColors.buttonPrimary : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(
                      Icons.circle,
                      size: 10,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.background
                          : Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTypography.textPrimary.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComorbidityOption(String title) {
    final isSelected = _selectedComorbidities.contains(title);
    final showError = _showErrors && _selectedComorbidities.isEmpty;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          if (title == 'Nenhuma') {
            // Se selecionar "Nenhuma", limpa outras seleções
            if (isSelected) {
              _selectedComorbidities.remove(title);
            } else {
              _selectedComorbidities.clear();
              _selectedComorbidities.add(title);
            }
          } else {
            // Se selecionar outra opção, remove "Nenhuma"
            _selectedComorbidities.remove('Nenhuma');
            if (isSelected) {
              _selectedComorbidities.remove(title);
            } else {
              _selectedComorbidities.add(title);
            }
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: showError 
                      ? AppColors.stateError 
                      : (isSelected ? AppColors.buttonPrimary : AppColors.textDisabled),
                  width: 2,
                ),
                color: isSelected ? AppColors.buttonPrimary : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(
                      Icons.circle,
                      size: 10,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.background
                          : Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTypography.textPrimary.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

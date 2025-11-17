import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_button.dart';

class EditNamePage extends StatefulWidget {
  final String currentFirstName;
  final String currentLastName;

  const EditNamePage({
    super.key,
    required this.currentFirstName,
    required this.currentLastName,
  });

  @override
  State<EditNamePage> createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.currentFirstName);
    _lastNameController = TextEditingController(text: widget.currentLastName);
    
    // Adicionar listeners para detectar mudanças
    _firstNameController.addListener(_checkForChanges);
    _lastNameController.addListener(_checkForChanges);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _checkForChanges() {
    setState(() {
      _hasChanges = _firstNameController.text != widget.currentFirstName ||
                    _lastNameController.text != widget.currentLastName;
    });
  }

  void _saveChanges() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    // TODO: Salvar alteração do nome
    final fullName = '${_firstNameController.text} ${_lastNameController.text}';
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nome atualizado com sucesso!'),
        backgroundColor: AppColors.stateSuccess,
      ),
    );
    Navigator.pop(context, {
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'fullName': fullName,
    });
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
          'Editar Nome',
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
                      
                      Form(
                        key: _formKey,
                        child: AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nome Completo',
                                style: AppTypography.heading2Primary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Digite seu nome e sobrenome.',
                                style: AppTypography.textPrimary.copyWith(
                                  color: AppColors.textDisabled,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 20),
                              
                              AppTextField(
                                controller: _firstNameController,
                                label: 'Nome',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira seu nome';
                                  }
                                  return null;
                                },
                              ),
                              
                              const SizedBox(height: 16),
                              
                              AppTextField(
                                controller: _lastNameController,
                                label: 'Sobrenome',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira seu sobrenome';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
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

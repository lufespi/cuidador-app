import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../data/services/auth_service.dart';

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
  final AuthService _authService = AuthService();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  bool _hasChanges = false;
  bool _isLoading = false;

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

  void _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    final l10n = AppLocalizations.of(context)!;
    final fullName = '${_firstNameController.text} ${_lastNameController.text}';
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Salva no backend
      await _authService.updateProfile(nome: fullName);
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.nameUpdatedSuccess),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pop(context, {
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'fullName': fullName,
      });
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
          l10n.editName,
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
                                l10n.name,
                                style: AppTypography.heading2Primary,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Digite seu nome e sobrenome.',
                                style: TextStyle(
                                  color: AppColors.textDisabled,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 20),
                              
                              AppTextField(
                                controller: _firstNameController,
                                label: l10n.firstName,
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
                                label: l10n.lastName,
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../data/services/auth_service.dart';

class EditPhonePage extends StatefulWidget {
  final String currentPhone;

  const EditPhonePage({
    super.key,
    required this.currentPhone,
  });

  @override
  State<EditPhonePage> createState() => _EditPhonePageState();
}

class _EditPhonePageState extends State<EditPhonePage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  late TextEditingController _phoneController;
  final TextEditingController _passwordController = TextEditingController();
  bool _hasChanges = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.currentPhone);
    _phoneController.addListener(_checkForChanges);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _checkForChanges() {
    setState(() {
      _hasChanges = _phoneController.text != widget.currentPhone;
    });
  }

  void _showPasswordDialog() {
    final l10n = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Confirmar Alteração',
                    style: AppTypography.heading1Primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Por segurança, digite sua senha atual para confirmar a alteração.',
                    style: AppTypography.textPrimary.copyWith(
                      color: AppColors.textDisabled,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _passwordController,
                    label: l10n.currentPassword,
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          _passwordController.clear();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          l10n.cancel,
                          style: AppTypography.textPrimary.copyWith(
                            color: AppColors.textDisabled,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {
                          // TODO: Validar senha e salvar alteração
                          if (_passwordController.text.isNotEmpty) {
                            Navigator.of(context).pop();
                            _saveChanges();
                          }
                        },
                        child: Text(
                          l10n.confirm,
                          style: AppTypography.textPrimary.copyWith(
                            color: AppColors.buttonPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  void _saveChanges() async {
    final l10n = AppLocalizations.of(context)!;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Remove formatação do telefone (mantém apenas números)
      final phoneDigits = _phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');
      
      // Salva no backend
      await _authService.updateProfile(telefone: phoneDigits);
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.phoneUpdatedSuccess),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, _phoneController.text);
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
          l10n.editPhone,
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
                              l10n.phone,
                              style: AppTypography.heading2Primary,
                            ),
                              const SizedBox(height: 8),
                              Text(
                                'Digite seu número de telefone com DDD.',
                                style: AppTypography.textPrimary.copyWith(
                                  color: AppColors.textDisabled,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 20),
                              
                              AppTextField(
                                controller: _phoneController,
                                label: l10n.phone,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  _PhoneNumberFormatter(),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira seu telefone';
                                  }
                                  // Remove formatação para validar
                                  final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
                                  if (digitsOnly.length < 10) {
                                    return 'Telefone deve ter pelo menos 10 dígitos';
                                  }
                                  if (digitsOnly.length > 11) {
                                    return 'Telefone deve ter no máximo 11 dígitos';
                                  }
                                  return null;
                                },
                              ),
                              
                              const SizedBox(height: 12),
                              
                              Text(
                                'Formato: (XX) XXXXX-XXXX ou (XX) XXXX-XXXX',
                                style: AppTypography.textPrimary.copyWith(
                                  color: AppColors.textDisabled,
                                  fontSize: 11,
                                ),
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
            ),
            
            // Botão salvar na parte inferior
            Padding(
              padding: const EdgeInsets.all(16),
              child: AppButton(
                label: _isLoading ? 'Salvando...' : l10n.saveChanges,
                onPressed: _hasChanges && !_isLoading ? _showPasswordDialog : null,
                height: 52,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Formatter personalizado para número de telefone brasileiro
class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    final buffer = StringBuffer();
    int cursorPosition = newValue.selection.end;

    // Remove caracteres não numéricos
    final digitsOnly = text.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.isEmpty) {
      return newValue.copyWith(text: '', selection: const TextSelection.collapsed(offset: 0));
    }

    // Formatação baseada no tamanho
    if (digitsOnly.length <= 2) {
      // (XX
      buffer.write('(${digitsOnly.substring(0, digitsOnly.length)}');
      cursorPosition = buffer.length;
    } else if (digitsOnly.length <= 6) {
      // (XX) XXXX
      buffer.write('(${digitsOnly.substring(0, 2)}) ${digitsOnly.substring(2)}');
      cursorPosition = buffer.length;
    } else if (digitsOnly.length <= 10) {
      // (XX) XXXX-XXXX
      buffer.write('(${digitsOnly.substring(0, 2)}) ${digitsOnly.substring(2, 6)}-${digitsOnly.substring(6)}');
      cursorPosition = buffer.length;
    } else {
      // (XX) XXXXX-XXXX
      buffer.write('(${digitsOnly.substring(0, 2)}) ${digitsOnly.substring(2, 7)}-${digitsOnly.substring(7, 11)}');
      cursorPosition = buffer.length;
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}

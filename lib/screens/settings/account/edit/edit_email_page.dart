import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../data/services/auth_service.dart';

class EditEmailPage extends StatefulWidget {
  final String currentEmail;

  const EditEmailPage({
    super.key,
    required this.currentEmail,
  });

  @override
  State<EditEmailPage> createState() => _EditEmailPageState();
}

class _EditEmailPageState extends State<EditEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  late TextEditingController _emailController;
  final TextEditingController _passwordController = TextEditingController();
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.currentEmail);
    _emailController.addListener(_checkForChanges);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _checkForChanges() {
    setState(() {
      _hasChanges = _emailController.text != widget.currentEmail;
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
                        onPressed: () async {
                          if (_passwordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.passwordRequired),
                                backgroundColor: AppColors.stateError,
                              ),
                            );
                            return;
                          }
                          
                          Navigator.of(context).pop();
                          await _saveChanges();
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

  Future<void> _saveChanges() async {
    try {
      // Primeiro verifica a senha tentando alterar para a mesma senha atual
      // (backend validará a senha_atual)
      await _authService.changePassword(
        senhaAtual: _passwordController.text,
        novaSenha: _passwordController.text,
      );
      
      // Se a senha estiver correta, atualiza o email
      // Nota: Backend atual não suporta atualização de email via PUT /profile
      // Por segurança, email não deve ser alterado facilmente
      // Implementação futura: criar endpoint específico PUT /email
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Alteração de e-mail não está disponível no momento. Entre em contato com o suporte.'),
          backgroundColor: AppColors.stateWarning,
        ),
      );
      
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: AppColors.stateError,
        ),
      );
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
          l10n.editEmail,
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
                              l10n.email,
                              style: AppTypography.heading2Primary,
                            ),
                              const SizedBox(height: 8),
                              Text(
                                'Digite seu endereço de e-mail. Enviaremos um código de verificação para confirmar.',
                                style: AppTypography.textPrimary.copyWith(
                                  color: AppColors.textDisabled,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 20),
                              
                              AppTextField(
                                controller: _emailController,
                                label: l10n.email,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira seu e-mail';
                                  }
                                  // Validação básica de e-mail
                                  final emailRegex = RegExp(
                                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                                  );
                                  if (!emailRegex.hasMatch(value)) {
                                    return 'Por favor, insira um e-mail válido';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Card de aviso sobre verificação
                        AppCard(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: AppColors.buttonPrimary,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Um código de verificação será enviado para o novo e-mail.',
                                  style: AppTypography.textPrimary.copyWith(
                                    color: AppColors.textDisabled,
                                    fontSize: 11,
                                    height: 1.4,
                                  ),
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
                label: l10n.saveChanges,
                onPressed: _hasChanges ? _showPasswordDialog : null,
                height: 52,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

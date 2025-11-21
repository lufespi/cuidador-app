import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_button.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedType = '';

  @override
  void initState() {
    super.initState();
    // Inicializar com chave de tradução
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _selectedType = 'suggestion'; // Usar key ao invés de texto
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    final l10n = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate()) {
      // TODO: Implementar envio de feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.feedbackSentSuccess),
          backgroundColor: AppColors.buttonPrimary,
        ),
      );
      Navigator.pop(context);
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
          l10n.feedbackTitle,
          style: AppTypography.heading1Secondary,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 24),
                
                // Card - Informações
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.yourOpinionMatters,
                        style: AppTypography.heading1Primary,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.feedbackInstructions,
                        style: AppTypography.textPrimary,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Card - Formulário
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tipo de Feedback
                      Text(
                        l10n.feedbackType,
                        style: AppTypography.heading2Primary,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(25),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedType.isEmpty ? null : _selectedType,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context).brightness == Brightness.dark
                                ? const Color(0xFF2E3838)
                                : Colors.white,
                            isDense: true,
                            constraints: const BoxConstraints(minHeight: 48),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
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
                          items: [
                            DropdownMenuItem(value: 'suggestion', child: Text(l10n.suggestion)),
                            DropdownMenuItem(value: 'problem', child: Text(l10n.problem)),
                            DropdownMenuItem(value: 'compliment', child: Text(l10n.compliment)),
                            DropdownMenuItem(value: 'other', child: Text(l10n.other)),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedType = value!;
                            });
                          },
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Nome
                      AppTextField(
                        label: l10n.nameOptional,
                        hint: l10n.yourName,
                        controller: _nameController,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // E-mail
                      AppTextField(
                        label: l10n.emailOptional,
                        hint: l10n.emailHint,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            if (!value.contains('@')) {
                              return l10n.errorInvalidEmail;
                            }
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Mensagem
                      AppTextField(
                        label: l10n.messageRequired,
                        hint: l10n.describeFeedback,
                        controller: _messageController,
                        maxLines: 6,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.feedbackRequired;
                          }
                          if (value.trim().length < 10) {
                            return l10n.feedbackMinLength;
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Botão Enviar
                      AppButton(
                        label: l10n.sendFeedback,
                        onPressed: _submitFeedback,
                        height: 48,
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
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../data/services/admin_service.dart';
import '../../../../data/models/user_model.dart';
import 'package:intl/intl.dart';

/// Página de detalhes de usuário
class UserDetailPage extends StatefulWidget {
  final int userId;

  const UserDetailPage({super.key, required this.userId});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final AdminService _adminService = AdminService();
  UserModel? _user;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final user = await _adminService.getUserById(widget.userId);
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _showResetPasswordDialog() async {
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Redefinir Senha'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Nova Senha',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmar Senha',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final password = passwordController.text;
                final confirmPassword = confirmPasswordController.text;

                if (password != confirmPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('As senhas devem ser iguais.')),
                  );
                  return;
                }

                if (password.length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('A senha deve ter no mínimo 6 caracteres.')),
                  );
                  return;
                }

                try {
                  await _adminService.resetUserPassword(widget.userId, password);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Senha redefinida com sucesso!')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Detalhes do Usuário',
          style: AppTypography.heading1Secondary,
        ),
      ),
      backgroundColor: isDark ? AppColorsDark.background : AppColorsLight.background,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: isDark ? AppColorsDark.stateError : AppColorsLight.stateError,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage,
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDark ? AppColorsDark.stateError : AppColorsLight.stateError,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      AppButton(
                        label: 'Tentar Novamente',
                        onPressed: _loadUser,
                        kind: AppButtonKind.buttonSecondary,
                        block: false,
                      ),
                    ],
                  ),
                )
              : SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card de informações pessoais
                        AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_user!.nome ?? 'Sem nome', style: AppTypography.heading1Primary),
                              const SizedBox(height: 12),
                              _buildInfoRow('Email', _user!.email, isDark),
                              if (_user!.telefone != null && _user!.telefone!.isNotEmpty)
                                _buildInfoRow('Telefone', _user!.telefone!, isDark),
                              if (_user!.dataNascimento != null)
                                _buildInfoRow('Data de Nascimento', _formatDate(_user!.dataNascimento), isDark),
                              if (_user!.genero != null && _user!.genero!.isNotEmpty)
                                _buildInfoRow('Sexo', _user!.genero!, isDark),
                              _buildInfoRow('Cadastrado em', _formatDate(_user!.createdAt), isDark),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Card de saúde
                        if (_user!.diagnostico != null || _user!.comorbidades != null) ...[
                          AppCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Dados de Saúde', style: AppTypography.heading2Primary),
                                const SizedBox(height: 12),
                                if (_user!.diagnostico != null && _user!.diagnostico!.isNotEmpty)
                                  _buildInfoRow('Diagnóstico', _user!.diagnostico!, isDark),
                                if (_user!.comorbidades != null && _user!.comorbidades!.isNotEmpty)
                                  _buildInfoRow('Comorbidades', _user!.comorbidades!, isDark),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        
                        // Botão de redefinir senha
                        SizedBox(
                          width: double.infinity,
                          child: AppButton(
                            label: 'Redefinir Senha',
                            onPressed: _showResetPasswordDialog,
                            kind: AppButtonKind.buttonSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: isDark ? AppColorsDark.textDisabled : AppColorsLight.textDisabled,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTypography.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

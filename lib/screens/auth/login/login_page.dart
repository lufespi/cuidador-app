import 'package:flutter/material.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/app_tab_slider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;
  int _activeTabIndex = 0; // 0 = Entrar, 1 = Criar Conta

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // Validação básica
    if (_emailController.text.isEmpty || _senhaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos'),
          backgroundColor: AppColors.stateError,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Simular delay de login
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login realizado com sucesso!'),
            backgroundColor: AppColors.stateSuccess,
          ),
        );
        // Aqui você pode navegar para a tela principal
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handlePreRegister() async {
    // Validação básica
    if (_emailController.text.isEmpty || _senhaController.text.isEmpty || _confirmarSenhaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos'),
          backgroundColor: AppColors.stateError,
        ),
      );
      return;
    }

    if (_senhaController.text != _confirmarSenhaController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('As senhas não coincidem'),
          backgroundColor: AppColors.stateError,
        ),
      );
      return;
    }

    // TODO: Implementar navegação para a tela de registro
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tela de registro em desenvolvimento'),
        backgroundColor: AppColors.buttonPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 32),
              AppLogo(
                iconSize: 120,
                imagePath: 'assets/images/cuidador-main-logo.png',
                title: null,
                subtitle: 'Gerencie sua saúde osteoarticular',
                subtitleStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF858585),
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 48),

              // Abas de Login/Cadastro
              _buildTabButtons(),
              const SizedBox(height: 32),

              // Email
              AppTextField(
                label: 'E-mail',
                hint: 'seu@email.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Senha
              AppTextField(
                label: 'Senha',
                hint: '••••••',
                controller: _senhaController,
                obscureText: !_showPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _showPassword ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.textDisabled,
                  ),
                  onPressed: () {
                    setState(() => _showPassword = !_showPassword);
                  },
                ),
              ),
              
              // Confirmar Senha (apenas na tela de registro)
              if (_activeTabIndex == 1) ...[
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Confirmar Senha',
                  hint: '••••••',
                  controller: _confirmarSenhaController,
                  obscureText: !_showConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.textDisabled,
                    ),
                    onPressed: () {
                      setState(() => _showConfirmPassword = !_showConfirmPassword);
                    },
                  ),
                ),
              ],
              
              const SizedBox(height: 24),

              // Botão de ação (Entrar ou Criar Conta)
              _isLoading
                  ? const SizedBox(
                      height: 52,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.buttonPrimary,
                        ),
                      ),
                    )
                  : _activeTabIndex == 0
                      ? AppButton.continuar(
                          onPressed: _handleLogin,
                        )
                      : AppButton.criarConta(
                          onPressed: _handlePreRegister,
                        ),
              const SizedBox(height: 16),

              // Link Esqueci Senha (apenas na tela de login)
              if (_activeTabIndex == 0)
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funcionalidade em desenvolvimento'),
                      ),
                    );
                  },
                  child: const Text(
                    'Esqueci minha senha',
                    style: AppTypography.textLink,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói o slider de abas (Entrar / Criar Conta)
  Widget _buildTabButtons() {
    return AppTabSlider(
      tabs: const ['Entrar', 'Criar Conta'],
      activeIndex: _activeTabIndex,
      onTabChanged: (index) {
        setState(() {
          _activeTabIndex = index;
          // Limpar campos ao trocar de tab
          _emailController.clear();
          _senhaController.clear();
          _confirmarSenhaController.clear();
          _showPassword = false;
          _showConfirmPassword = false;
        });
      },
    );
  }
}
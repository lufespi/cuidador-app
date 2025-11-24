import 'package:flutter/material.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/app_tab_slider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../register/register_page_step_1.dart';
import '../../home/home_page.dart';
import '../../../data/api_service.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme_provider.dart';



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
  if (_emailController.text.isEmpty || _senhaController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Por favor, preencha e-mail e senha'),
      ),
    );
    return;
  }

  setState(() {
    _isLoading = true;
  });

  try {
    final api = ApiService();
    final success = await api.login(
      _emailController.text.trim(),
      _senhaController.text,
    );

    if (!mounted) return;

    if (success) {
      final email = _emailController.text.trim();

      // carregamos as configurações do usuário atual
      Provider.of<ThemeProvider>(context, listen: false)
          .setCurrentUser(email);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Credenciais inválidas. Tente novamente.'),
        ),
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao fazer login: $e'),
        ),
      );
    }
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

 Future<void> _handlePreRegister() async {
  if (_emailController.text.isEmpty ||
      _senhaController.text.isEmpty ||
      _confirmarSenhaController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Por favor, preencha todos os campos'),
      ),
    );
    return;
  }

  if (_senhaController.text != _confirmarSenhaController.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('As senhas não coincidem'),
      ),
    );
    return;
  }

  setState(() {
    _isLoading = true;
  });

  try {
    final api = ApiService();
    final created = await api.register(
      _emailController.text.trim(),
      _senhaController.text,
    );

    if (!mounted) return;

    if (created) {
      // Usuário cadastrado no backend → segue pro fluxo de cadastro em etapas
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RegisterPageStep1(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível cadastrar. Tente outro e-mail.'),
        ),
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao cadastrar: $e'),
        ),
      );
    }
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
                subtitle: l10n.welcomeBack,
                subtitleStyle: AppTypography.heading2Primary.copyWith(
                  color: const Color(0xFF858585),
                ),
              ),
              const SizedBox(height: 48),

              // Abas de Login/Cadastro
              _buildTabButtons(l10n),
              const SizedBox(height: 32),

              // Email
              AppTextField(
                label: l10n.email,
                hint: l10n.emailHint,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Senha
              AppTextField(
                label: l10n.password,
                hint: l10n.passwordHint,
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
                  label: l10n.confirmPassword,
                  hint: l10n.passwordHint,
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
                      SnackBar(
                        content: Text(l10n.errorFillAllFields),
                      ),
                    );
                  },
                  child: Text(
                    l10n.forgotPassword,
                    style: AppTypography.textLink,
                  ),
                ),
              
              const SizedBox(height: 24),
              
              // Copyright (marca d'água)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  l10n.copyrightText,
                  style: AppTypography.textPrimary.copyWith(
                    color: AppColors.textDisabled,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói o slider de abas (Entrar / Criar Conta)
  Widget _buildTabButtons(AppLocalizations l10n) {
    return AppTabSlider(
      tabs: [l10n.login, l10n.createAccount],
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
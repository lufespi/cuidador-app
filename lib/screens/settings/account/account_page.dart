import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/user_model.dart';
import '../../auth/login/login_page.dart';
import 'edit/edit_name_page.dart';
import 'edit/edit_birth_date_page.dart';
import 'edit/edit_gender_page.dart';
import 'edit/edit_phone_page.dart';
import 'edit/edit_email_page.dart';
import 'edit/edit_password_page.dart';
import 'health/edit_diagnosis_page.dart';
import 'health/edit_comorbidities_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final AuthService _authService = AuthService();
  UserModel? _user;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await _authService.getProfile();
      if (mounted) {
        setState(() {
          _user = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Erro ao carregar perfil: $e';
          _isLoading = false;
        });
      }
    }
  }

  String get _userFullName => _user?.nome ?? 'Carregando...';
  String get _userFirstName => _user?.nome?.split(' ').first ?? '';
  String get _userLastName => _user?.nome?.split(' ').skip(1).join(' ') ?? '';
  String get _userBirthDate => _user?.dataNascimento != null
      ? '${_user!.dataNascimento!.day.toString().padLeft(2, '0')}/${_user!.dataNascimento!.month.toString().padLeft(2, '0')}/${_user!.dataNascimento!.year}'
      : 'Não informado';
  String get _userGender {
    final genero = _user?.genero;
    if (genero == null) return 'Não informado';
    switch (genero.toLowerCase()) {
      case 'masculino':
        return 'Masculino';
      case 'feminino':
        return 'Feminino';
      case 'outro':
        return 'Outro';
      default:
        return genero;
    }
  }
  String get _userPhone => _user?.telefone != null && _user!.telefone!.isNotEmpty
      ? _formatPhone(_user!.telefone!)
      : 'Não informado';
  String get _userEmail => _user?.email ?? 'Não informado';
  String get _userDiagnosisValue => _user?.diagnostico ?? 'Não informado';
  String get _userComorbiditiesValue => _user?.comorbidades ?? 'Nenhuma';

  String _formatPhone(String phone) {
    // Remove caracteres não numéricos
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length == 11) {
      return '(${digits.substring(0, 2)}) ${digits.substring(2, 7)}-${digits.substring(7)}';
    } else if (digits.length == 10) {
      return '(${digits.substring(0, 2)}) ${digits.substring(2, 6)}-${digits.substring(6)}';
    }
    return phone;
  }

  Future<void> _navigateToEditName() async {
    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (context) => EditNamePage(
          currentFirstName: _userFirstName,
          currentLastName: _userLastName,
        ),
      ),
    );
    
    // Recarrega perfil após edição
    if (result != null && mounted) {
      await _loadUserProfile();
    }
  }

  Future<void> _navigateToEditBirthDate() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => EditBirthDatePage(currentBirthDate: _userBirthDate),
      ),
    );
    
    // Recarrega perfil após edição
    if (result != null && mounted) {
      await _loadUserProfile();
    }
  }

  Future<void> _navigateToEditGender() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => EditGenderPage(currentGender: _userGender),
      ),
    );
    
    // Recarrega perfil após edição
    if (result != null && mounted) {
      await _loadUserProfile();
    }
  }

  Future<void> _navigateToEditPhone() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => EditPhonePage(currentPhone: _userPhone),
      ),
    );
    
    // Recarrega perfil após edição
    if (result != null && mounted) {
      await _loadUserProfile();
    }
  }

  Future<void> _navigateToEditEmail() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => EditEmailPage(currentEmail: _userEmail),
      ),
    );
    
    // Recarrega perfil após edição
    if (result != null && mounted) {
      await _loadUserProfile();
    }
  }

  Future<void> _navigateToEditDiagnosis() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => EditDiagnosisPage(currentDiagnosis: _userDiagnosisValue),
      ),
    );
    
    if (result != null && mounted) {
      // Recarrega perfil do backend
      await _loadUserProfile();
    }
  }

  Future<void> _navigateToEditComorbidities() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => EditComorbiditiesPage(currentComorbidities: _userComorbiditiesValue),
      ),
    );
    
    if (result != null && mounted) {
      // Recarrega perfil do backend
      await _loadUserProfile();
    }
  }

  Future<void> _navigateToEditPassword() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditPasswordPage(),
      ),
    );
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
          l10n.account,
          style: AppTypography.heading1Secondary,
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(_errorMessage!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadUserProfile,
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                )
              : SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              
              // Card - Informações Pessoais
              AppCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título da seção
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/settings/user-round.svg',
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.onSurface,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.personalInformation,
                          style: AppTypography.heading1Primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Campo Nome
                    _buildAccountField(
                      context: context,
                      label: l10n.name,
                      value: _userFullName,
                      onTap: _navigateToEditName,
                    ),
                    
                    // Divider
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(
                        height: 1,
                        color: AppColors.inputBackground,
                      ),
                    ),
                    
                    // Campo Data de Nascimento
                    _buildAccountField(
                      context: context,
                      label: l10n.birthdate,
                      value: _userBirthDate,
                      onTap: _navigateToEditBirthDate,
                    ),
                    
                    // Divider
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(
                        height: 1,
                        color: AppColors.inputBackground,
                      ),
                    ),
                    
                    // Campo Sexo
                    _buildAccountField(
                      context: context,
                      label: l10n.gender,
                      value: _userGender,
                      onTap: _navigateToEditGender,
                    ),
                    
                    // Divider
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(
                        height: 1,
                        color: AppColors.inputBackground,
                      ),
                    ),
                    
                    // Campo Telefone
                    _buildAccountField(
                      context: context,
                      label: l10n.phone,
                      value: _userPhone,
                      onTap: _navigateToEditPhone,
                    ),
                    
                    // Divider
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(
                        height: 1,
                        color: AppColors.inputBackground,
                      ),
                    ),
                    
                    // Campo E-mail
                    _buildAccountField(
                      context: context,
                      label: l10n.email,
                      value: _userEmail,
                      onTap: _navigateToEditEmail,
                      isLast: true,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Card - Dados de Saúde
              AppCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título da seção
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/forms/heart-pulse.svg',
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.onSurface,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.healthData,
                          style: AppTypography.heading1Primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Campo Diagnóstico Principal
                    _buildAccountField(
                      context: context,
                      label: l10n.primaryDiagnosis,
                      value: _userDiagnosisValue,
                      onTap: _navigateToEditDiagnosis,
                    ),
                    
                    // Divider
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(
                        height: 1,
                        color: AppColors.inputBackground,
                      ),
                    ),
                    
                    // Campo Comorbidades
                    _buildAccountField(
                      context: context,
                      label: l10n.comorbidities,
                      value: _userComorbiditiesValue,
                      onTap: _navigateToEditComorbidities,
                      isLast: true,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Card - Opções da Conta
              AppCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título da seção
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/settings/settings.svg',
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.onSurface,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.securityAndPrivacy,
                          style: AppTypography.heading1Primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Opção Alterar senha
                    _buildAccountField(
                      context: context,
                      label: l10n.changePassword,
                      onTap: _navigateToEditPassword,
                    ),
                    
                    // Divider
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(
                        height: 1,
                        color: AppColors.inputBackground,
                      ),
                    ),
                    
                    // Campo Excluir Conta (com texto em vermelho)
                    _buildAccountField(
                      context: context,
                      label: l10n.deleteMyAccount,
                      onTap: () => _showDeleteAccountDialog(context),
                      isLast: true,
                      isDestructive: true,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// Mostra dialog de confirmação para excluir conta
  void _showDeleteAccountDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            l10n.deleteMyAccount,
            style: AppTypography.heading1Primary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.accountDeletionWarning,
              style: AppTypography.textPrimary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Divider acima de Excluir
            Container(
              height: 1,
              color: AppColors.inputBackground,
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showPasswordConfirmationDialog(context);
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  l10n.deleteMyAccount,
                  style: AppTypography.heading2Primary.copyWith(
                    color: AppColors.stateError,
                  ),
                ),
              ),
            ),
            // Divider sutil
            Container(
              height: 1,
              color: AppColors.inputBackground,
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  l10n.cancel,
                  style: AppTypography.heading2Primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Mostra dialog para confirmar exclusão com senha
  void _showPasswordConfirmationDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final passwordController = TextEditingController();
    bool isLoading = false;
    bool obscurePassword = true;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            l10n.confirmWithPassword,
            style: AppTypography.heading2Primary,
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.enterPasswordToConfirm,
                style: AppTypography.textPrimary.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  labelText: l10n.password,
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                ),
                enabled: !isLoading,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(dialogContext),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      final senha = passwordController.text.trim();
                      
                      if (senha.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.passwordRequired),
                            backgroundColor: AppColors.stateError,
                          ),
                        );
                        return;
                      }

                      setState(() {
                        isLoading = true;
                      });

                      // Salva referências antes da operação async
                      final navigator = Navigator.of(context);
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      final dialogNavigator = Navigator.of(dialogContext);

                      try {
                        await _authService.deleteAccount(senha: senha);
                        
                        if (!mounted) return;
                        
                        dialogNavigator.pop();
                        
                        // Navega para tela de login
                        navigator.pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                          (route) => false,
                        );
                        
                        scaffoldMessenger.showSnackBar(
                          SnackBar(
                            content: Text(l10n.accountDeletedSuccessfully),
                            backgroundColor: AppColors.stateSuccess,
                          ),
                        );
                      } catch (e) {
                        setState(() {
                          isLoading = false;
                        });
                        
                        if (!mounted) return;
                        
                        scaffoldMessenger.showSnackBar(
                          SnackBar(
                            content: Text(e.toString().replaceAll('Exception: ', '')),
                            backgroundColor: AppColors.stateError,
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.stateError,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(l10n.deleteMyAccount),
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói um campo de informação pessoal clicável
  Widget _buildAccountField({
    required BuildContext context,
    required String label,
    required VoidCallback onTap,
    String? value,
    bool isLast = false,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTypography.textPrimary.copyWith(
                      color: isDestructive 
                          ? AppColors.stateError 
                          : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 11,
                    ),
                  ),
                  if (value != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: AppTypography.textPrimary.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.chevron_right,
              color: isDestructive ? AppColors.stateError : AppColors.textDisabled,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

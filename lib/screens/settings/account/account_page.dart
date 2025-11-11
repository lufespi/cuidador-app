import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_card.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  void _navigateToEditField(BuildContext context, String fieldName) {
    // TODO: Implementar navegação para telas de edição
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editar $fieldName - Em desenvolvimento'),
        backgroundColor: AppColors.buttonPrimary,
      ),
    );
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
          'Conta',
          style: AppTypography.heading1Secondary,
        ),
      ),
      body: SafeArea(
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
                          colorFilter: const ColorFilter.mode(
                            AppColors.textPrimary,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Informações Pessoais',
                          style: AppTypography.heading1Primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Campo Nome
                    _buildAccountField(
                      context: context,
                      label: 'Nome',
                      onTap: () => _navigateToEditField(context, 'Nome'),
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
                      label: 'Data de Nascimento',
                      onTap: () => _navigateToEditField(context, 'Data de Nascimento'),
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
                      label: 'Sexo',
                      onTap: () => _navigateToEditField(context, 'Sexo'),
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
                      label: 'Telefone',
                      onTap: () => _navigateToEditField(context, 'Telefone'),
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
                      label: 'E-mail',
                      onTap: () => _navigateToEditField(context, 'E-mail'),
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
                          colorFilter: const ColorFilter.mode(
                            AppColors.textPrimary,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Dados de Saúde',
                          style: AppTypography.heading1Primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Campo Diagnóstico Principal
                    _buildAccountField(
                      context: context,
                      label: 'Diagnóstico Principal',
                      onTap: () => _navigateToEditField(context, 'Diagnóstico Principal'),
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
                      label: 'Comorbidades',
                      onTap: () => _navigateToEditField(context, 'Comorbidades'),
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
                          colorFilter: const ColorFilter.mode(
                            AppColors.textPrimary,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Opções da Conta',
                          style: AppTypography.heading1Primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Campo Alterar Senha
                    _buildAccountField(
                      context: context,
                      label: 'Alterar senha',
                      onTap: () => _navigateToEditField(context, 'Alterar senha'),
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
                      label: 'Excluir minha conta',
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            'Excluir sua conta?',
            style: AppTypography.heading1Primary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Esta ação é irreversível. Todos os seus dados serão permanentemente excluídos.',
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
                  // TODO: Implementar exclusão de conta
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Função de exclusão em desenvolvimento'),
                      backgroundColor: AppColors.stateError,
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  'Excluir conta',
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
                  'Cancelar',
                  style: AppTypography.heading2Primary,
                ),
              ),
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
              child: Text(
                label,
                style: AppTypography.textPrimary.copyWith(
                  color: isDestructive ? AppColors.stateError : null,
                ),
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

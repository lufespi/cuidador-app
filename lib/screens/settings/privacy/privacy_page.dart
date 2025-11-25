import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_toggle.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/services/auth_service.dart';
import '../about/terms_page.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  final AuthService _authService = AuthService();
  bool _dataUsageConsent = false;
  bool _shareAnonymousData = false;
  String _dataSharePreference = 'none'; // 'none', 'full', 'diagnostic'
  
  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }
  
  Future<void> _loadPreferences() async {
    try {
      // Carrega preferências do perfil do usuário
      final user = await _authService.getProfile();
      
      setState(() {
        // Determina qual toggle ativar baseado na preferência salva
        if (user.dataSharePreference == 'full') {
          _dataUsageConsent = true;
          _shareAnonymousData = false;
          _dataSharePreference = 'full';
        } else if (user.dataSharePreference == 'diagnostic') {
          _dataUsageConsent = false;
          _shareAnonymousData = true;
          _dataSharePreference = 'diagnostic';
        } else {
          _dataUsageConsent = false;
          _shareAnonymousData = false;
          _dataSharePreference = 'none';
        }
      });
    } catch (e) {
      // Se falhar, usa valores padrão (não compartilhar)
      setState(() {
        _dataUsageConsent = false;
        _shareAnonymousData = false;
        _dataSharePreference = 'none';
      });
    }
  }

  void _viewPrivacyPolicy() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TermsPage(),
      ),
    );
  }

  Future<void> _saveChanges() async {
    final l10n = AppLocalizations.of(context)!;
    
    try {
      // Salva preferências de compartilhamento no backend
      await _authService.updateProfile(
        dataSharePreference: _dataSharePreference,
      );
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.successPreferencesSaved),
          backgroundColor: AppColors.stateSuccess,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar preferências: $e'),
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
          l10n.privacyAndSecurity,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                
                // Card 1 - Coleta de Dados
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.storage,
                            color: Theme.of(context).colorScheme.onSurface,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n.dataCollectionTitle,
                              style: AppTypography.heading1Primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.dataCollectionDescription,
                        style: AppTypography.textPrimary.copyWith(
                          color: AppColors.textDisabled,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Toggle 1 - Compartilhar minhas estatísticas
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.shareMyStatistics,
                                  style: AppTypography.textPrimary.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  l10n.shareMyStatisticsDesc,
                                  style: AppTypography.textPrimary.copyWith(
                                    color: AppColors.textDisabled,
                                    fontSize: 12,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          AppToggle(
                            value: _dataUsageConsent,
                            onChanged: (value) {
                              setState(() {
                                _dataUsageConsent = value;
                                if (value) {
                                  _shareAnonymousData = false; // Desabilita o outro
                                  _dataSharePreference = 'full';
                                } else {
                                  _dataSharePreference = 'none';
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Toggle 2 - Compartilhar somente dados de diagnóstico
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.shareDiagnosticDataOnly,
                                  style: AppTypography.textPrimary.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  l10n.shareDiagnosticDataOnlyDesc,
                                  style: AppTypography.textPrimary.copyWith(
                                    color: AppColors.textDisabled,
                                    fontSize: 12,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          AppToggle(
                            value: _shareAnonymousData,
                            onChanged: (value) {
                              setState(() {
                                _shareAnonymousData = value;
                                if (value) {
                                  _dataUsageConsent = false; // Desabilita o outro
                                  _dataSharePreference = 'diagnostic';
                                } else {
                                  _dataSharePreference = 'none';
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Botão Ver Política de Privacidade
                      InkWell(
                        onTap: _viewPrivacyPolicy,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.buttonPrimary,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.open_in_new,
                                color: AppColors.buttonPrimary,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                l10n.viewPrivacyPolicy,
                                style: AppTypography.textPrimary.copyWith(
                                  color: AppColors.buttonPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Card 2 - Preferências de E-mail
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            color: Theme.of(context).colorScheme.onSurface,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n.emailPreferences,
                              style: AppTypography.heading1Primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.emailPreferencesDesc,
                        style: AppTypography.textPrimary.copyWith(
                          color: AppColors.textDisabled,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Toggle único para ativar/desativar notificações por e-mail
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              l10n.receiveEmailNotifications,
                              style: AppTypography.textPrimary.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDisabled,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Funcionalidade estará disponível em breve'),
                                  backgroundColor: AppColors.stateWarning,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Opacity(
                              opacity: 0.5,
                              child: AppToggle(
                                value: false,
                                onChanged: null, // Desabilitado
                              ),
                            ),
                          ),
                        ],
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
            
            // Botão salvar na parte inferior
            Padding(
              padding: const EdgeInsets.all(16),
              child: AppButton(
                label: l10n.saveChanges,
                onPressed: _saveChanges,
                height: 52,
              ),
            ),
          ],
        ),
      ),
    );
  }


}

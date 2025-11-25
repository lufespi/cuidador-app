import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../data/services/admin_service.dart';
import '../../../../data/models/user_model.dart';
import 'user_detail_page.dart';

/// Página de listagem de usuários para administradores
class UsersListPage extends StatefulWidget {
  const UsersListPage({super.key});

  @override
  State<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  final AdminService _adminService = AdminService();
  final TextEditingController _searchController = TextEditingController();
  
  List<UserModel> _users = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers({String? search}) async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final users = await _adminService.getAllUsers(search: search);
      if (!mounted) return;
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String value) {
    if (value.isEmpty) {
      _loadUsers();
    } else {
      _loadUsers(search: value);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
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
          'Usuários',
          style: AppTypography.heading1Secondary,
        ),
      ),
      backgroundColor: isDark ? AppColorsDark.background : AppColorsLight.background,
      body: SafeArea(
        child: Column(
          children: [
            // Campo de busca
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Buscar usuário...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: isDark ? AppColorsDark.border : AppColorsLight.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: isDark ? AppColorsDark.border : AppColorsLight.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: isDark ? AppColorsDark.buttonPrimary : AppColorsLight.buttonPrimary, width: 2),
                  ),
                  filled: true,
                  fillColor: isDark ? AppColorsDark.surface : AppColorsLight.surface,
                ),
              ),
            ),
            
            // Lista de usuários
            Expanded(
              child: _isLoading
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
                                onPressed: () => _loadUsers(),
                                kind: AppButtonKind.buttonSecondary,
                                block: false,
                              ),
                            ],
                          ),
                        )
                      : _users.isEmpty
                          ? Center(
                              child: Text(
                                'Nenhum usuário encontrado.',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: isDark ? AppColorsDark.textDisabled : AppColorsLight.textDisabled,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: _users.length,
                              itemBuilder: (context, index) {
                                final user = _users[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => UserDetailPage(userId: int.parse(user.id)),
                                      ),
                                    );
                                  },
                                  child: AppCard(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    child: Row(
                                      children: [
                                        // Ícone de usuário à esquerda
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: (isDark ? AppColorsDark.buttonPrimary : AppColorsLight.buttonPrimary).withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            Icons.person_outline,
                                            size: 32,
                                            color: isDark ? AppColorsDark.buttonPrimary : AppColorsLight.buttonPrimary,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        // Informações do usuário
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                user.nome ?? 'Sem nome',
                                                style: AppTypography.heading2Primary,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                user.email,
                                                style: AppTypography.bodyMedium.copyWith(
                                                  color: isDark ? AppColorsDark.textDisabled : AppColorsLight.textDisabled,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Cadastrado em ${_formatDate(user.createdAt)}',
                                                style: AppTypography.labelSmall.copyWith(
                                                  color: isDark ? AppColorsDark.textDisabled : AppColorsLight.textDisabled,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Ícone de seta à direita
                                        Icon(
                                          Icons.chevron_right,
                                          color: isDark ? AppColorsDark.textDisabled : AppColorsLight.textDisabled,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}

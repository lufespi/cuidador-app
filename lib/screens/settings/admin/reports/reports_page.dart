import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../data/services/admin_service.dart';
import '../../../../data/models/user_model.dart';

/// Página de relatórios administrativos
class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final AdminService _adminService = AdminService();
  List<UserModel> _users = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final users = await _adminService.getAllUsers();
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

  Future<void> _exportUserReport(UserModel user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exportação'),
          content: Text('Deseja exportar os dados de ${user.nome ?? user.email}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Exportar'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      final result = await _adminService.exportUserReport(int.parse(user.id));
      final pdfBase64 = result['pdf_base64'];
      final filename = result['filename'];

      // Decodificar base64 para bytes
      final bytes = base64.decode(pdfBase64);

      // Salvar arquivo
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      await file.writeAsBytes(bytes);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Relatório exportado com sucesso!')),
        );

        // Abrir o arquivo
        await OpenFile.open(file.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao exportar: ${e.toString()}')),
        );
      }
    }
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
          'Relatórios',
          style: AppTypography.heading1Secondary,
        ),
      ),
      backgroundColor: isDark ? AppColorsDark.background : AppColorsLight.background,
      body: SafeArea(
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
                          onPressed: _loadUsers,
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
                        padding: const EdgeInsets.all(16),
                        itemCount: _users.length,
                        itemBuilder: (context, index) {
                          final user = _users[index];
                          return AppCard(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
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
                                    ],
                                  ),
                                ),
                                AppButton(
                                  label: 'Exportar',
                                  onPressed: () => _exportUserReport(user),
                                  kind: AppButtonKind.buttonSecondary,
                                  block: false,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  height: 36,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}

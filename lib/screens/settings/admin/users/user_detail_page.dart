import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_dropdown.dart';
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
  List<Map<String, dynamic>> _painRecords = [];
  List<Map<String, dynamic>> _painRecordsFiltered = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  
  // Paginação
  int _paginaAtual = 0;
  final int _itensPorPagina = 10;
  
  // Filtro de período
  String _periodoFiltro = '30'; // dias
  DateTime? _dataInicial;
  DateTime? _dataFinal;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final user = await _adminService.getUserById(widget.userId);
      final painRecords = await _adminService.getUserPainRecords(widget.userId);
      
      if (!mounted) return;
      setState(() {
        _user = user;
        _painRecords = painRecords;
        _aplicarFiltro();
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

  void _aplicarFiltro() {
    List<Map<String, dynamic>> registrosFiltrados = List.from(_painRecords);
    
    // Aplica filtro de período
    if (_periodoFiltro != 'all') {
      if (_periodoFiltro == 'custom' && _dataInicial != null && _dataFinal != null) {
        registrosFiltrados = registrosFiltrados.where((record) {
          try {
            final dataRegistro = _parseDateTime(record['data_registro']);
            if (dataRegistro != null) {
              return dataRegistro.isAfter(_dataInicial!) && dataRegistro.isBefore(_dataFinal!.add(const Duration(days: 1)));
            }
            return false;
          } catch (_) {
            return false;
          }
        }).toList();
      } else if (_periodoFiltro == 'today') {
        final now = DateTime.now();
        final startOfDay = DateTime(now.year, now.month, now.day);
        
        registrosFiltrados = registrosFiltrados.where((record) {
          try {
            final dataRegistro = _parseDateTime(record['data_registro']);
            if (dataRegistro != null) {
              return dataRegistro.isAfter(startOfDay);
            }
            return false;
          } catch (_) {
            return false;
          }
        }).toList();
      } else if (_periodoFiltro == 'yesterday') {
        final now = DateTime.now();
        final yesterday = now.subtract(const Duration(days: 1));
        final startOfYesterday = DateTime(yesterday.year, yesterday.month, yesterday.day);
        final endOfYesterday = DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);
        
        registrosFiltrados = registrosFiltrados.where((record) {
          try {
            final dataRegistro = _parseDateTime(record['data_registro']);
            if (dataRegistro != null) {
              return dataRegistro.isAfter(startOfYesterday) && dataRegistro.isBefore(endOfYesterday.add(const Duration(seconds: 1)));
            }
            return false;
          } catch (_) {
            return false;
          }
        }).toList();
      } else {
        final dias = int.parse(_periodoFiltro);
        final dataLimite = DateTime.now().subtract(Duration(days: dias));
        
        registrosFiltrados = registrosFiltrados.where((record) {
          try {
            final dataRegistro = _parseDateTime(record['data_registro']);
            if (dataRegistro != null) {
              return dataRegistro.isAfter(dataLimite);
            }
            return false;
          } catch (_) {
            return false;
          }
        }).toList();
      }
    }
    
    setState(() {
      _painRecordsFiltered = registrosFiltrados;
      _paginaAtual = 0; // Reset para primeira página ao filtrar
    });
  }

  DateTime? _parseDateTime(dynamic date) {
    if (date == null) return null;
    try {
      if (date is String) {
        return DateTime.parse(date);
      } else if (date is DateTime) {
        return date;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> _mostrarSeletorDataPersonalizada() async {
    final now = DateTime.now();
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDateRange: _dataInicial != null && _dataFinal != null
          ? DateTimeRange(start: _dataInicial!, end: _dataFinal!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _periodoFiltro = 'custom';
        _dataInicial = picked.start;
        _dataFinal = picked.end;
      });
      _aplicarFiltro();
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
                        // Card 1: Informações Pessoais
                        AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    color: isDark ? AppColorsDark.buttonPrimary : AppColorsLight.buttonPrimary,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Informações Pessoais',
                                    style: AppTypography.heading2Primary,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildInfoRow('Nome', _user!.nome ?? 'Não informado', isDark),
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
                        
                        // Card 2: Dados Médicos
                        AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.medical_information_outlined,
                                    color: isDark ? AppColorsDark.buttonPrimary : AppColorsLight.buttonPrimary,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Dados Médicos',
                                    style: AppTypography.heading2Primary,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              if (_user!.diagnostico != null && _user!.diagnostico!.isNotEmpty)
                                _buildInfoRow('Diagnóstico', _user!.diagnostico!, isDark)
                              else
                                Text(
                                  'Nenhum diagnóstico informado',
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: isDark ? AppColorsDark.textDisabled : AppColorsLight.textDisabled,
                                  ),
                                ),
                              if (_user!.comorbidades != null && _user!.comorbidades!.isNotEmpty)
                                _buildInfoRow('Comorbidades', _user!.comorbidades!, isDark)
                              else if (_user!.diagnostico == null || _user!.diagnostico!.isEmpty)
                                Text(
                                  'Nenhuma comorbidade informada',
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: isDark ? AppColorsDark.textDisabled : AppColorsLight.textDisabled,
                                  ),
                                ),
                              
                              const SizedBox(height: 12),
                              Divider(color: isDark ? AppColorsDark.border : AppColorsLight.border),
                              const SizedBox(height: 12),
                              
                              // Compartilhamento de dados
                              Row(
                                children: [
                                  Icon(
                                    Icons.share_outlined,
                                    color: isDark ? AppColorsDark.buttonPrimary : AppColorsLight.buttonPrimary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Compartilhamento de Dados',
                                    style: AppTypography.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _getDataSharePreferenceText(_user!.dataSharePreference),
                                style: AppTypography.bodyMedium.copyWith(
                                  color: _getDataSharePreferenceColor(_user!.dataSharePreference, isDark),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Card 3: Registros de Dor
                        AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.analytics_outlined,
                                        color: isDark ? AppColorsDark.buttonPrimary : AppColorsLight.buttonPrimary,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Registros',
                                        style: AppTypography.heading2Primary,
                                      ),
                                    ],
                                  ),
                                  // Filtro de período
                                  SizedBox(
                                    width: 130,
                                    child: _periodoFiltro == 'custom' && _dataInicial != null && _dataFinal != null
                                        ? Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: isDark ? AppColorsDark.border : AppColorsLight.border),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    '${DateFormat('dd/MM').format(_dataInicial!)} - ${DateFormat('dd/MM').format(_dataFinal!)}',
                                                    style: AppTypography.labelSmall,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _periodoFiltro = '30';
                                                      _dataInicial = null;
                                                      _dataFinal = null;
                                                    });
                                                    _aplicarFiltro();
                                                  },
                                                  child: Icon(
                                                    Icons.close,
                                                    size: 16,
                                                    color: isDark ? AppColorsDark.buttonPrimary : AppColorsLight.buttonPrimary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : AppDropdown<String>(
                                            value: _periodoFiltro,
                                            items: const [
                                              DropdownMenuItem(value: 'today', child: Text('Hoje')),
                                              DropdownMenuItem(value: 'yesterday', child: Text('Ontem')),
                                              DropdownMenuItem(value: '7', child: Text('7 dias')),
                                              DropdownMenuItem(value: '30', child: Text('30 dias')),
                                              DropdownMenuItem(value: '60', child: Text('60 dias')),
                                              DropdownMenuItem(value: '90', child: Text('90 dias')),
                                              DropdownMenuItem(value: 'all', child: Text('Todos')),
                                              DropdownMenuItem(value: 'custom', child: Text('Período')),
                                            ],
                                            onChanged: (value) {
                                              if (value == 'custom') {
                                                _mostrarSeletorDataPersonalizada();
                                              } else {
                                                setState(() {
                                                  _periodoFiltro = value!;
                                                  _dataInicial = null;
                                                  _dataFinal = null;
                                                });
                                                _aplicarFiltro();
                                              }
                                            },
                                          ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              if (_painRecordsFiltered.isEmpty)
                                Text(
                                  'Nenhum registro de dor encontrado',
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: isDark ? AppColorsDark.textDisabled : AppColorsLight.textDisabled,
                                  ),
                                )
                              else ...[
                                // Lista de registros paginados
                                ..._painRecordsFiltered
                                    .skip(_paginaAtual * _itensPorPagina)
                                    .take(_itensPorPagina)
                                    .map((record) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: (isDark ? AppColorsDark.border : AppColorsLight.border).withValues(alpha: 0.3),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.healing_outlined,
                                                  size: 16,
                                                  color: _getPainColor(record['intensidade'] ?? 0, isDark),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  'Intensidade: ${record['intensidade'] ?? 0}',
                                                  style: AppTypography.bodyMedium.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: _getPainColor(record['intensidade'] ?? 0, isDark),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              _formatDateTime(record['data_registro']),
                                              style: AppTypography.labelSmall.copyWith(
                                                color: isDark ? AppColorsDark.textDisabled : AppColorsLight.textDisabled,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (record['descricao'] != null && record['descricao'].toString().isNotEmpty) ...[
                                          const SizedBox(height: 8),
                                          Text(
                                            record['descricao'],
                                            style: AppTypography.labelSmall,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ],
                                    ),
                                  );
                                }),
                                
                                // Paginação
                                if (_painRecordsFiltered.length > _itensPorPagina) ...[
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Página ${_paginaAtual + 1} de ${(_painRecordsFiltered.length / _itensPorPagina).ceil()}',
                                        style: AppTypography.labelSmall.copyWith(
                                          color: isDark ? AppColorsDark.textDisabled : AppColorsLight.textDisabled,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.chevron_left),
                                            onPressed: _paginaAtual > 0
                                                ? () {
                                                    setState(() {
                                                      _paginaAtual--;
                                                    });
                                                  }
                                                : null,
                                            iconSize: 20,
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.chevron_right),
                                            onPressed: (_paginaAtual + 1) * _itensPorPagina < _painRecordsFiltered.length
                                                ? () {
                                                    setState(() {
                                                      _paginaAtual++;
                                                    });
                                                  }
                                                : null,
                                            iconSize: 20,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Botão de redefinir senha
                        Center(
                          child: SizedBox(
                            width: 200,
                            child: AppButton(
                              label: 'Redefinir Senha',
                              onPressed: _showResetPasswordDialog,
                              kind: AppButtonKind.buttonSecondary,
                              block: false,
                            ),
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

  String _formatDateTime(dynamic date) {
    if (date == null) return '';
    try {
      DateTime dt;
      if (date is String) {
        dt = DateTime.parse(date);
      } else if (date is DateTime) {
        dt = date;
      } else {
        return '';
      }
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return '';
    }
  }

  Color _getPainColor(int intensidade, bool isDark) {
    if (intensidade <= 3) {
      return Colors.green;
    } else if (intensidade <= 6) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
  
  String _getDataSharePreferenceText(String preference) {
    switch (preference) {
      case 'full':
        return '✓ Usuário permite compartilhar todas as estatísticas';
      case 'diagnostic':
        return '✓ Usuário compartilha apenas dados de diagnóstico';
      case 'none':
      default:
        return '✗ Usuário não permite compartilhamento de dados';
    }
  }
  
  Color _getDataSharePreferenceColor(String preference, bool isDark) {
    switch (preference) {
      case 'full':
        return isDark ? AppColorsDark.stateSuccess : AppColorsLight.stateSuccess;
      case 'diagnostic':
        return isDark ? AppColorsDark.stateWarning : AppColorsLight.stateWarning;
      case 'none':
      default:
        return isDark ? AppColorsDark.textDisabled : AppColorsLight.textDisabled;
    }
  }
}

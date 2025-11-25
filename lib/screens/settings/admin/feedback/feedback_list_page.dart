import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../data/services/feedback_service.dart';
import 'feedback_detail_page.dart';

/// Página de listagem de feedbacks para administradores
class FeedbackListPage extends StatefulWidget {
  const FeedbackListPage({super.key});

  @override
  State<FeedbackListPage> createState() => _FeedbackListPageState();
}

class _FeedbackListPageState extends State<FeedbackListPage> {
  final FeedbackService _feedbackService = FeedbackService();
  final TextEditingController _searchController = TextEditingController();
  
  List<Map<String, dynamic>> _feedbacks = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  String? _selectedType;
  int _total = 0;

  @override
  void initState() {
    super.initState();
    _loadFeedbacks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFeedbacks({String? search, String? type}) async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final result = await _feedbackService.getAllFeedback(
        search: search,
        type: type,
        limit: 100,
      );
      if (!mounted) return;
      setState(() {
        _feedbacks = result['feedbacks'];
        _total = result['total'];
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
    _loadFeedbacks(search: value.isEmpty ? null : value, type: _selectedType);
  }

  void _onTypeChanged(String? value) {
    setState(() {
      _selectedType = value;
    });
    _loadFeedbacks(
      search: _searchController.text.isEmpty ? null : _searchController.text,
      type: value,
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  String _getFeedbackTypeLabel(String type) {
    switch (type) {
      case 'suggestion':
        return 'Sugestão';
      case 'problem':
        return 'Problema';
      case 'compliment':
        return 'Elogio';
      case 'other':
        return 'Outro';
      default:
        return type;
    }
  }

  Color _getFeedbackTypeColor(String type, bool isDark) {
    switch (type) {
      case 'suggestion':
        return Colors.blue;
      case 'problem':
        return Colors.red;
      case 'compliment':
        return Colors.green;
      case 'other':
        return Colors.orange;
      default:
        return isDark ? AppColorsDark.textDisabled : AppColorsLight.textDisabled;
    }
  }

  IconData _getFeedbackTypeIcon(String type) {
    switch (type) {
      case 'suggestion':
        return Icons.lightbulb_outline;
      case 'problem':
        return Icons.error_outline;
      case 'compliment':
        return Icons.favorite_outline;
      case 'other':
        return Icons.help_outline;
      default:
        return Icons.feedback_outlined;
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
          'Feedback',
          style: AppTypography.heading1Secondary,
        ),
      ),
      backgroundColor: isDark ? AppColorsDark.background : AppColorsLight.background,
      body: SafeArea(
        child: Column(
          children: [
            // Filtros
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Campo de busca
                  TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Buscar por nome, email ou mensagem...',
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
                  const SizedBox(height: 12),
                  // Filtro por tipo
                  Row(
                    children: [
                      Text(
                        'Tipo:',
                        style: AppTypography.labelSmall,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedType,
                          hint: const Text('Todos'),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: isDark ? AppColorsDark.border : AppColorsLight.border),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: isDark ? AppColorsDark.border : AppColorsLight.border),
                            ),
                            filled: true,
                            fillColor: isDark ? AppColorsDark.surface : AppColorsLight.surface,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          items: const [
                            DropdownMenuItem(value: null, child: Text('Todos')),
                            DropdownMenuItem(value: 'suggestion', child: Text('Sugestão')),
                            DropdownMenuItem(value: 'problem', child: Text('Problema')),
                            DropdownMenuItem(value: 'compliment', child: Text('Elogio')),
                            DropdownMenuItem(value: 'other', child: Text('Outro')),
                          ],
                          onChanged: _onTypeChanged,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Total de feedbacks
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '$_total feedback(s) encontrado(s)',
                      style: AppTypography.labelSmall.copyWith(
                        color: isDark ? AppColorsDark.textDisabled : AppColorsLight.textDisabled,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Lista de feedbacks
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
                                onPressed: () => _loadFeedbacks(),
                                kind: AppButtonKind.buttonSecondary,
                                block: false,
                              ),
                            ],
                          ),
                        )
                      : _feedbacks.isEmpty
                          ? Center(
                              child: Text(
                                'Nenhum feedback encontrado.',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: isDark ? AppColorsDark.textDisabled : AppColorsLight.textDisabled,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: _feedbacks.length,
                              itemBuilder: (context, index) {
                                final feedback = _feedbacks[index];
                                final type = feedback['feedback_type'] ?? 'other';
                                
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => FeedbackDetailPage(
                                          feedbackId: feedback['id'],
                                        ),
                                      ),
                                    ).then((_) => _loadFeedbacks());
                                  },
                                  child: AppCard(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    child: Row(
                                      children: [
                                        // Ícone do tipo de feedback
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: _getFeedbackTypeColor(type, isDark).withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            _getFeedbackTypeIcon(type),
                                            size: 32,
                                            color: _getFeedbackTypeColor(type, isDark),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        // Informações do feedback
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: _getFeedbackTypeColor(type, isDark).withValues(alpha: 0.2),
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                    child: Text(
                                                      _getFeedbackTypeLabel(type),
                                                      style: AppTypography.labelSmall.copyWith(
                                                        color: _getFeedbackTypeColor(type, isDark),
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                feedback['user_name'] ?? feedback['name'] ?? 'Anônimo',
                                                style: AppTypography.heading2Primary,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                feedback['user_email'] ?? feedback['email'] ?? 'Email não informado',
                                                style: AppTypography.bodyMedium.copyWith(
                                                  color: isDark ? AppColorsDark.textDisabled : AppColorsLight.textDisabled,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                feedback['message'] ?? '',
                                                style: AppTypography.bodyMedium,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                _formatDate(feedback['created_at'] ?? ''),
                                                style: AppTypography.labelSmall.copyWith(
                                                  color: isDark ? AppColorsDark.textDisabled : AppColorsLight.textDisabled,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Ícone de seta
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

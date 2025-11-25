import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../data/services/feedback_service.dart';

/// Página de detalhes de um feedback específico
class FeedbackDetailPage extends StatefulWidget {
  final int feedbackId;

  const FeedbackDetailPage({
    super.key,
    required this.feedbackId,
  });

  @override
  State<FeedbackDetailPage> createState() => _FeedbackDetailPageState();
}

class _FeedbackDetailPageState extends State<FeedbackDetailPage> {
  final FeedbackService _feedbackService = FeedbackService();
  
  Map<String, dynamic>? _feedback;
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadFeedback();
  }

  Future<void> _loadFeedback() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final feedback = await _feedbackService.getFeedbackById(widget.feedbackId);
      if (!mounted) return;
      setState(() {
        _feedback = feedback;
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

  Future<void> _deleteFeedback() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Tem certeza que deseja excluir este feedback?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.stateError,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _feedbackService.deleteFeedback(widget.feedbackId);
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Feedback excluído com sucesso'),
            backgroundColor: AppColors.stateSuccess,
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao excluir feedback: ${e.toString()}'),
            backgroundColor: AppColors.stateError,
          ),
        );
      }
    }
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
          'Detalhes do Feedback',
          style: AppTypography.heading1Secondary,
        ),
        actions: [
          if (_feedback != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _deleteFeedback,
              color: AppColors.stateError,
            ),
        ],
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
                        onPressed: () => _loadFeedback(),
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
                        // Card - Tipo e Data
                        AppCard(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: _getFeedbackTypeColor(_feedback!['feedback_type'], isDark).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  _getFeedbackTypeIcon(_feedback!['feedback_type']),
                                  size: 48,
                                  color: _getFeedbackTypeColor(_feedback!['feedback_type'], isDark),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _getFeedbackTypeLabel(_feedback!['feedback_type']),
                                      style: AppTypography.heading1Primary,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Enviado em ${_formatDate(_feedback!['created_at'])}',
                                      style: AppTypography.labelSmall.copyWith(
                                        color: isDark ? AppColorsDark.textDisabled : AppColorsLight.textDisabled,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Card - Informações do Usuário
                        AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    color: isDark ? AppColorsDark.buttonPrimary : AppColorsLight.buttonPrimary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Informações do Usuário',
                                    style: AppTypography.heading2Primary,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildInfoRow('Nome', _feedback!['user_name'] ?? _feedback!['name'] ?? 'Não informado', isDark),
                              const SizedBox(height: 12),
                              _buildInfoRow('Email', _feedback!['user_email'] ?? _feedback!['email'] ?? 'Não informado', isDark),
                              if (_feedback!['user_phone'] != null) ...[
                                const SizedBox(height: 12),
                                _buildInfoRow('Telefone', _feedback!['user_phone'], isDark),
                              ],
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Card - Mensagem
                        AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.message_outlined,
                                    color: isDark ? AppColorsDark.buttonPrimary : AppColorsLight.buttonPrimary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Mensagem',
                                    style: AppTypography.heading2Primary,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: (isDark ? AppColorsDark.border : AppColorsLight.border).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _feedback!['message'] ?? '',
                                  style: AppTypography.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '$label:',
            style: AppTypography.labelSmall.copyWith(
              color: isDark ? AppColorsDark.textDisabled : AppColorsLight.textDisabled,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTypography.bodyMedium,
          ),
        ),
      ],
    );
  }
}

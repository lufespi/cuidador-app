import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config/api_config.dart';
import '../../core/network/token_storage.dart';

class FeedbackService {
  final String baseUrl = ApiConfig.apiUrl;
  final TokenStorage _tokenStorage = TokenStorage();

  /// Envia feedback do usuário
  Future<bool> sendFeedback({
    required String feedbackType,
    required String message,
    String? name,
    String? email,
  }) async {
    try {
      final token = await _tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('Usuário não autenticado');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/feedback'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'feedback_type': feedbackType,
          'message': message,
          if (name != null && name.isNotEmpty) 'name': name,
          if (email != null && email.isNotEmpty) 'email': email,
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 400) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        throw Exception(data['error'] ?? 'Erro ao enviar feedback');
      } else if (response.statusCode == 403) {
        throw Exception('Acesso negado.');
      } else {
        final errorBody = utf8.decode(response.bodyBytes);
        throw Exception('Erro ao enviar feedback: $errorBody');
      }
    } catch (e) {
      throw Exception('Erro ao enviar feedback: $e');
    }
  }

  /// Lista todos os feedbacks (apenas admin)
  Future<Map<String, dynamic>> getAllFeedback({
    String? search,
    String? type,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final token = await _tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('Usuário não autenticado');
      }

      final queryParams = <String, String>{
        'limit': limit.toString(),
        'offset': offset.toString(),
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      if (type != null && type.isNotEmpty) {
        queryParams['type'] = type;
      }

      final uri = Uri.parse('$baseUrl/admin/feedback').replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return {
          'feedbacks': List<Map<String, dynamic>>.from(data['feedbacks']),
          'total': data['total'],
          'limit': data['limit'],
          'offset': data['offset'],
        };
      } else if (response.statusCode == 403) {
        throw Exception('Acesso negado.');
      } else {
        throw Exception('Erro ao buscar feedbacks: ${utf8.decode(response.bodyBytes)}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar feedbacks: $e');
    }
  }

  /// Busca um feedback específico por ID (apenas admin)
  Future<Map<String, dynamic>> getFeedbackById(int feedbackId) async {
    try {
      final token = await _tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('Usuário não autenticado');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/admin/feedback/$feedbackId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      } else if (response.statusCode == 404) {
        throw Exception('Feedback não encontrado');
      } else if (response.statusCode == 403) {
        throw Exception('Acesso negado.');
      } else {
        throw Exception('Erro ao buscar feedback: ${utf8.decode(response.bodyBytes)}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar feedback: $e');
    }
  }

  /// Deleta um feedback (apenas admin)
  Future<bool> deleteFeedback(int feedbackId) async {
    try {
      final token = await _tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('Usuário não autenticado');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/admin/feedback/$feedbackId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 404) {
        throw Exception('Feedback não encontrado');
      } else if (response.statusCode == 403) {
        throw Exception('Acesso negado.');
      } else {
        throw Exception('Erro ao deletar feedback: ${utf8.decode(response.bodyBytes)}');
      }
    } catch (e) {
      throw Exception('Erro ao deletar feedback: $e');
    }
  }
}

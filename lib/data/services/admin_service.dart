import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../../core/network/token_storage.dart';
import '../../core/config/api_config.dart';

/// Serviço para operações de administração
class AdminService {
  final String baseUrl = ApiConfig.apiUrl;

  /// Obtém a lista de usuários (com busca opcional)
  Future<List<UserModel>> getAllUsers({String? search}) async {
    try {
      final tokenStorage = TokenStorage();
      final token = await tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('Token não encontrado');
      }

      String url = '$baseUrl/admin/users';
      if (search != null && search.isNotEmpty) {
        url += '?search=${Uri.encodeComponent(search)}';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> usersJson = data['users'];
        return usersJson.map((json) => UserModel.fromJson(json)).toList();
      } else if (response.statusCode == 403) {
        throw Exception('Acesso negado. Você não tem permissão de administrador.');
      } else {
        throw Exception('Erro ao carregar usuários: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao carregar usuários: $e');
    }
  }

  /// Obtém detalhes de um usuário específico
  Future<UserModel> getUserById(int userId) async {
    try {
      final tokenStorage = TokenStorage();
      final token = await tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('Token não encontrado');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/admin/users/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UserModel.fromJson(data['user']);
      } else if (response.statusCode == 403) {
        throw Exception('Acesso negado. Você não tem permissão de administrador.');
      } else if (response.statusCode == 404) {
        throw Exception('Usuário não encontrado.');
      } else {
        throw Exception('Erro ao carregar usuário: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao carregar usuário: $e');
    }
  }

  /// Redefine a senha de um usuário
  Future<void> resetUserPassword(int userId, String newPassword) async {
    try {
      final tokenStorage = TokenStorage();
      final token = await tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('Token não encontrado');
      }

      if (newPassword.length < 6) {
        throw Exception('A senha deve ter no mínimo 6 caracteres.');
      }

      final response = await http.put(
        Uri.parse('$baseUrl/admin/users/$userId/password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'new_password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 403) {
        throw Exception('Acesso negado. Você não tem permissão de administrador.');
      } else if (response.statusCode == 404) {
        throw Exception('Usuário não encontrado.');
      } else {
        final data = json.decode(response.body);
        throw Exception(data['error'] ?? 'Erro ao redefinir senha.');
      }
    } catch (e) {
      throw Exception('Erro ao redefinir senha: $e');
    }
  }

  /// Exporta relatório de usuário em PDF e retorna o caminho do arquivo
  Future<Map<String, dynamic>> exportUserReport(int userId) async {
    try {
      final tokenStorage = TokenStorage();
      final token = await tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('Token não encontrado');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/admin/users/$userId/export'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'pdf_base64': data['pdf_base64'],
          'filename': data['filename'],
        };
      } else if (response.statusCode == 403) {
        throw Exception('Acesso negado. Você não tem permissão de administrador.');
      } else if (response.statusCode == 404) {
        throw Exception('Usuário não encontrado.');
      } else {
        throw Exception('Erro ao exportar relatório: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao exportar relatório: $e');
    }
  }
}

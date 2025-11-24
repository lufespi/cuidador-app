import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/config/api_config.dart';
import 'services/auth_service.dart';
import 'services/pain_service.dart';

/// Serviço central de API - Refatorado para usar ApiConfig
class ApiService {
  // Serviços especializados
  final AuthService auth;
  final PainService pain;

  ApiService({
    AuthService? authService,
    PainService? painService,
  })  : auth = authService ?? AuthService(),
        pain = painService ?? PainService();

  // ==========================================
  // MÉTODOS DE AUTENTICAÇÃO (compatibilidade com backend atual)
  // ==========================================
  
  /// Registra novo usuário
  Future<bool> register(String email, String senha) async {
    final url = Uri.parse(ApiConfig.registerUrl);

    try {
      final response = await http.post(
        url,
        headers: ApiConfig.defaultHeaders,
        body: jsonEncode({
          'email': email,
          'senha': senha,
        }),
      ).timeout(ApiConfig.connectTimeout);

      return response.statusCode == 201;
    } catch (e) {
      // Use debugPrint em produção ao invés de print
      return false;
    }
  }

  /// Faz login
  Future<bool> login(String email, String senha) async {
    final url = Uri.parse(ApiConfig.loginUrl);

    try {
      final response = await http.post(
        url,
        headers: ApiConfig.defaultHeaders,
        body: jsonEncode({
          'email': email,
          'senha': senha,
        }),
      ).timeout(ApiConfig.connectTimeout);

      // Backend retorna status 200 em caso de sucesso
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ==========================================
  // NOVOS MÉTODOS (para usar quando backend suportar tokens)
  // ==========================================
  
  /// Registra usuário usando novo serviço (quando backend suportar tokens)
  Future<bool> registerWithAuth(String email, String senha) async {
    try {
      await auth.register(email: email, senha: senha);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Login usando novo serviço (quando backend suportar tokens)
  Future<bool> loginWithAuth(String email, String senha) async {
    try {
      await auth.login(email: email, senha: senha);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// Verifica se está autenticado
  Future<bool> isAuthenticated() async {
    return await auth.isAuthenticated();
  }
  
  /// Faz logout
  Future<void> logout() async {
    await auth.logout();
  }
}



import 'dart:convert';
import 'package:http/http.dart' as http;
import 'services/auth_service.dart';
import 'services/pain_service.dart';

/// Serviço central de API - Mantém compatibilidade com backend original
class ApiService {
  // URL da API do PythonAnywhere
  static const String baseUrl = 'https://KaueMuller.pythonanywhere.com';

  // Serviços especializados (para uso futuro)
  final AuthService auth;
  final PainService pain;

  ApiService({
    AuthService? authService,
    PainService? painService,
  })  : auth = authService ?? AuthService(),
        pain = painService ?? PainService();

  // ==========================================
  // MÉTODOS ORIGINAIS (funcionando)
  // ==========================================
  
  /// Registra novo usuário
  Future<bool> register(String email, String senha) async {
    final url = Uri.parse('$baseUrl/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'senha': senha,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Erro no register: $e');
      return false;
    }
  }

  /// Faz login
  Future<bool> login(String email, String senha) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'senha': senha,
        }),
      );

      if (response.statusCode != 200) return false;

      final data = jsonDecode(response.body);
      return data['success'] == true;
    } catch (e) {
      print('Erro no login: $e');
      return false;
    }
  }

  // ==========================================
  // NOVOS MÉTODOS (para usar quando backend estiver pronto)
  // ==========================================
  
  /// Registra usuário usando novo serviço (quando backend suportar tokens)
  Future<bool> registerWithAuth(String email, String senha) async {
    try {
      await auth.register(email: email, senha: senha);
      return true;
    } catch (e) {
      print('Erro no registerWithAuth: $e');
      return false;
    }
  }

  /// Login usando novo serviço (quando backend suportar tokens)
  Future<bool> loginWithAuth(String email, String senha) async {
    try {
      await auth.login(email: email, senha: senha);
      return true;
    } catch (e) {
      print('Erro no loginWithAuth: $e');
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


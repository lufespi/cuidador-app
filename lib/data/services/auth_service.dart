import '../../core/config/api_config.dart';
import '../../core/network/http_client.dart';
import '../../core/network/token_storage.dart';
import '../models/auth_response.dart';
import '../models/user_model.dart';

/// Serviço de autenticação
class AuthService {
  final HttpClient _httpClient;
  final TokenStorage _tokenStorage;

  AuthService({
    HttpClient? httpClient,
    TokenStorage? tokenStorage,
  })  : _httpClient = httpClient ?? HttpClient(),
        _tokenStorage = tokenStorage ?? TokenStorage();

  /// Registra novo usuário
  Future<AuthResponse> register({
    required String email,
    required String senha,
    String? nome,
    DateTime? dataNascimento,
    String? genero,
    String? telefone,
  }) async {
    final response = await _httpClient.post(
      ApiConfig.registerUrl,
      body: {
        'email': email,
        'senha': senha,
        if (nome != null) 'nome': nome,
        if (dataNascimento != null) 'data_nascimento': dataNascimento.toIso8601String(),
        if (genero != null) 'sexo': genero, // Backend espera 'sexo'
        if (telefone != null) 'telefone': telefone,
      },
    );

    final authResponse = AuthResponse.fromJson(response);
    
    // Salva tokens
    await _tokenStorage.saveTokens(
      accessToken: authResponse.accessToken,
      refreshToken: authResponse.refreshToken,
      userId: authResponse.userId,
    );

    return authResponse;
  }

  /// Faz login
  Future<AuthResponse> login({
    required String email,
    required String senha,
  }) async {
    final response = await _httpClient.post(
      ApiConfig.loginUrl,
      body: {
        'email': email,
        'senha': senha,
      },
    );

    final authResponse = AuthResponse.fromJson(response);
    
    // Salva tokens
    await _tokenStorage.saveTokens(
      accessToken: authResponse.accessToken,
      refreshToken: authResponse.refreshToken,
      userId: authResponse.userId,
    );
    
    return authResponse;
  }

  /// Faz logout
  Future<void> logout() async {
    try {
      await _httpClient.post(
        ApiConfig.logoutUrl,
        requiresAuth: true,
      );
    } finally {
      // Sempre limpa tokens localmente
      await _tokenStorage.clearTokens();
    }
  }

  /// Obtém perfil do usuário
  Future<UserModel> getProfile() async {
    final response = await _httpClient.get(
      ApiConfig.profileUrl,
      requiresAuth: true,
    );

    // Backend retorna: { user: { id, email, ... } }
    final userJson = response['user'] as Map<String, dynamic>;
    return UserModel.fromJson(userJson);
  }

  /// Atualiza perfil do usuário
  Future<UserModel> updateProfile({
    String? nome,
    DateTime? dataNascimento,
    String? genero,
    String? telefone,
    String? diagnostico,
    String? comorbidades,
  }) async {
    final response = await _httpClient.put(
      ApiConfig.profileUrl,
      body: {
        if (nome != null) 'nome': nome,
        if (dataNascimento != null) 'data_nascimento': dataNascimento.toIso8601String(),
        if (genero != null) 'sexo': genero, // Backend espera 'sexo'
        if (telefone != null) 'telefone': telefone,
        if (diagnostico != null) 'diagnostico': diagnostico,
        if (comorbidades != null) 'comorbidades': comorbidades,
      },
      requiresAuth: true,
    );

    // Backend retorna: { message, user: { id, email, ... } }
    final userJson = response['user'] as Map<String, dynamic>;
    return UserModel.fromJson(userJson);
  }

  /// Altera senha do usuário
  Future<void> changePassword({
    required String senhaAtual,
    required String novaSenha,
  }) async {
    await _httpClient.put(
      ApiConfig.passwordUrl,
      body: {
        'senha_atual': senhaAtual,
        'nova_senha': novaSenha,
      },
      requiresAuth: true,
    );
  }

  /// Reseta senha do usuário (esqueci minha senha)
  Future<void> resetPassword({
    required String email,
    required String novaSenha,
  }) async {
    await _httpClient.post(
      ApiConfig.resetPasswordUrl,
      body: {
        'email': email,
        'nova_senha': novaSenha,
      },
    );
  }

  /// Verifica se está autenticado
  Future<bool> isAuthenticated() async {
    return await _tokenStorage.isAuthenticated();
  }

  /// Refresh token
  Future<AuthResponse> refreshToken() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null) {
      throw Exception('Refresh token não encontrado');
    }

    final response = await _httpClient.post(
      ApiConfig.refreshTokenUrl,
      body: {'refresh_token': refreshToken},
    );

    final authResponse = AuthResponse.fromJson(response);
    
    // Salva novos tokens
    await _tokenStorage.saveTokens(
      accessToken: authResponse.accessToken,
      refreshToken: authResponse.refreshToken,
      userId: authResponse.userId,
    );

    return authResponse;
  }
}

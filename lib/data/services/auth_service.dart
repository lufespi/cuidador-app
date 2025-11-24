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
        if (genero != null) 'genero': genero,
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

    return UserModel.fromJson(response);
  }

  /// Atualiza perfil do usuário
  Future<UserModel> updateProfile({
    String? nome,
    DateTime? dataNascimento,
    String? genero,
    String? telefone,
  }) async {
    final response = await _httpClient.put(
      ApiConfig.profileUrl,
      body: {
        if (nome != null) 'nome': nome,
        if (dataNascimento != null) 'data_nascimento': dataNascimento.toIso8601String(),
        if (genero != null) 'genero': genero,
        if (telefone != null) 'telefone': telefone,
      },
      requiresAuth: true,
    );

    return UserModel.fromJson(response);
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

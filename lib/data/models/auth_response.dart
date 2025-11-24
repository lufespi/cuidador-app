/// Modelo de resposta de autenticação
class AuthResponse {
  final String accessToken;
  final String? refreshToken;
  final String userId;
  final String email;
  final Map<String, dynamic>? user;

  AuthResponse({
    required this.accessToken,
    this.refreshToken,
    required this.userId,
    required this.email,
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    // Backend retorna: { token, user: { id, email, ... } }
    final userObj = json['user'] as Map<String, dynamic>?;
    
    // Backend retorna 'token' ao invés de 'access_token'
    final token = json['token'] as String? ?? 
                  json['access_token'] as String? ?? 
                  '';
    
    return AuthResponse(
      accessToken: token,
      refreshToken: json['refresh_token'] as String?,
      userId: json['user_id']?.toString() ?? 
              userObj?['id']?.toString() ?? 
              json['id']?.toString() ?? '',
      email: json['email'] as String? ?? 
             userObj?['email'] as String? ?? '',
      user: userObj,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'user_id': userId,
      'email': email,
      'user': user,
    };
  }
}

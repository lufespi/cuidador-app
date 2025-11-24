import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../errors/api_exceptions.dart';
import 'token_storage.dart';

/// Cliente HTTP centralizado com interceptors
class HttpClient {
  final http.Client _client = http.Client();
  final TokenStorage _tokenStorage = TokenStorage();

  /// GET request
  Future<Map<String, dynamic>> get(
    String url, {
    Map<String, String>? headers,
    bool requiresAuth = false,
  }) async {
    try {
      final allHeaders = await _buildHeaders(headers, requiresAuth);
      
      final response = await _client
          .get(Uri.parse(url), headers: allHeaders)
          .timeout(ApiConfig.receiveTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException();
    } on TimeoutException {
      throw NetworkException(message: 'Tempo de conexão esgotado.');
    }
  }

  /// POST request
  Future<Map<String, dynamic>> post(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool requiresAuth = false,
  }) async {
    try {
      final allHeaders = await _buildHeaders(headers, requiresAuth);
      
      final response = await _client
          .post(
            Uri.parse(url),
            headers: allHeaders,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.receiveTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException();
    } on TimeoutException {
      throw NetworkException(message: 'Tempo de conexão esgotado.');
    }
  }

  /// PUT request
  Future<Map<String, dynamic>> put(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool requiresAuth = false,
  }) async {
    try {
      final allHeaders = await _buildHeaders(headers, requiresAuth);
      
      final response = await _client
          .put(
            Uri.parse(url),
            headers: allHeaders,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.receiveTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException();
    } on TimeoutException {
      throw NetworkException(message: 'Tempo de conexão esgotado.');
    }
  }

  /// DELETE request
  Future<Map<String, dynamic>> delete(
    String url, {
    Map<String, String>? headers,
    bool requiresAuth = false,
  }) async {
    try {
      final allHeaders = await _buildHeaders(headers, requiresAuth);
      
      final response = await _client
          .delete(Uri.parse(url), headers: allHeaders)
          .timeout(ApiConfig.receiveTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException();
    } on TimeoutException {
      throw NetworkException(message: 'Tempo de conexão esgotado.');
    }
  }

  /// Constrói headers com token se necessário
  Future<Map<String, String>> _buildHeaders(
    Map<String, String>? customHeaders,
    bool requiresAuth,
  ) async {
    final headers = Map<String, String>.from(ApiConfig.defaultHeaders);
    
    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }
    
    if (requiresAuth) {
      final token = await _tokenStorage.getAccessToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    
    return headers;
  }

  /// Trata resposta HTTP
  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    
    // Sucesso (200-299)
    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isEmpty) {
        return {'success': true};
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    
    // Tenta decodificar mensagem de erro
    String errorMessage = 'Erro desconhecido';
    dynamic errorData;
    
    try {
      final errorBody = jsonDecode(response.body);
      errorMessage = errorBody['message'] ?? errorBody['error'] ?? errorMessage;
      errorData = errorBody;
    } catch (_) {
      errorMessage = response.body.isNotEmpty ? response.body : errorMessage;
    }
    
    // Lança exceções específicas por código de status
    switch (statusCode) {
      case 400:
        throw BadRequestException(message: errorMessage, data: errorData);
      case 401:
        throw UnauthorizedException(message: errorMessage);
      case 404:
        throw NotFoundException(message: errorMessage);
      case 422:
        throw ValidationException(message: errorMessage, data: errorData);
      case >= 500:
        throw ServerException(message: errorMessage);
      default:
        throw ApiException(
          message: errorMessage,
          statusCode: statusCode,
          data: errorData,
        );
    }
  }

  /// Dispose do client
  void dispose() {
    _client.close();
  }
}

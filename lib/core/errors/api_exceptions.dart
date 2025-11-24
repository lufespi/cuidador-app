/// Exceções personalizadas para a API
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => 'ApiException: $message ${statusCode != null ? "(Status: $statusCode)" : ""}';
}

/// Erro de conexão/rede
class NetworkException extends ApiException {
  NetworkException({String? message})
      : super(
          message: message ?? 'Erro de conexão. Verifique sua internet.',
        );
}

/// Não autorizado (401)
class UnauthorizedException extends ApiException {
  UnauthorizedException({String? message})
      : super(
          message: message ?? 'Sessão expirada. Faça login novamente.',
          statusCode: 401,
        );
}

/// Não encontrado (404)
class NotFoundException extends ApiException {
  NotFoundException({String? message})
      : super(
          message: message ?? 'Recurso não encontrado.',
          statusCode: 404,
        );
}

/// Erro no servidor (500+)
class ServerException extends ApiException {
  ServerException({String? message})
      : super(
          message: message ?? 'Erro no servidor. Tente novamente mais tarde.',
          statusCode: 500,
        );
}

/// Dados inválidos (422)
class ValidationException extends ApiException {
  ValidationException({String? message, super.data})
      : super(
          message: message ?? 'Dados inválidos.',
          statusCode: 422,
        );
}

/// Bad Request (400)
class BadRequestException extends ApiException {
  BadRequestException({String? message, super.data})
      : super(
          message: message ?? 'Requisição inválida.',
          statusCode: 400,
        );
}

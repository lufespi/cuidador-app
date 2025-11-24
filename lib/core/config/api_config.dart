/// Configuração centralizada da API
/// Para produção, use flutter_dotenv ou --dart-define
class ApiConfig {
  // URLs base
  static const String _prodBaseUrl = 'https://KaueMuller.pythonanywhere.com';
  
  // Versão da API
  static const String apiVersion = 'v1';
  
  // Determina se está em produção
  static bool get isProduction => const bool.fromEnvironment('dart.vm.product');
  
  // URL base atual
  static String get baseUrl => isProduction ? _prodBaseUrl : _prodBaseUrl; // Sempre prod por enquanto
  
  // URL completa da API
  static String get apiUrl => '$baseUrl/api/$apiVersion';
  
  // Endpoints de autenticação
  static String get registerUrl => '$baseUrl/register';
  static String get loginUrl => '$baseUrl/login';
  static String get refreshTokenUrl => '$baseUrl/auth/refresh';
  static String get logoutUrl => '$baseUrl/auth/logout';
  static String get profileUrl => '$apiUrl/auth/profile';
  
  // Endpoints de dor
  static String get painRecordsUrl => '$apiUrl/pain/records';
  static String painRecordByIdUrl(String id) => '$apiUrl/pain/records/$id';
  
  // Endpoints de práticas
  static String get practicesUrl => '$apiUrl/practices';
  static String practiceByIdUrl(String id) => '$apiUrl/practices/$id';
  
  // Endpoints de lembretes
  static String get remindersUrl => '$apiUrl/reminders';
  static String reminderByIdUrl(String id) => '$apiUrl/reminders/$id';
  
  // Endpoints de educação
  static String get educationUrl => '$apiUrl/education';
  static String educationByIdUrl(String id) => '$apiUrl/education/$id';
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Headers padrão
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}

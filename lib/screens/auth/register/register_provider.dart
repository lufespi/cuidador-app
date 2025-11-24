import 'package:flutter/foundation.dart';
import '../../../data/services/auth_service.dart';
import '../../../core/errors/api_exceptions.dart';

/// Provider para gerenciar o estado do registro em múltiplas etapas
class RegisterProvider with ChangeNotifier {
  final AuthService _authService;

  RegisterProvider({AuthService? authService})
      : _authService = authService ?? AuthService();

  // Step 1 - Dados pessoais
  String? _email;
  String? _senha;
  String? _firstName;
  String? _lastName;
  DateTime? _birthDate;
  String? _gender;
  String? _phone;

  // Step 2 - Dados de saúde
  String? _diagnosis;
  List<String> _comorbidities = [];

  // Step 3 - Preferências
  double _fontSizeLevel = 3.0;
  bool _highContrast = false;
  bool _textToSpeech = false;
  bool _gdprConsent = false;
  bool _emailConsent = false;

  // Estado de carregamento e erro
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  String? get email => _email;
  String? get senha => _senha;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  DateTime? get birthDate => _birthDate;
  String? get gender => _gender;
  String? get phone => _phone;
  String? get diagnosis => _diagnosis;
  List<String> get comorbidities => _comorbidities;
  double get fontSizeLevel => _fontSizeLevel;
  bool get highContrast => _highContrast;
  bool get textToSpeech => _textToSpeech;
  bool get gdprConsent => _gdprConsent;
  bool get emailConsent => _emailConsent;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Nome completo
  String? get fullName {
    if (_firstName == null || _lastName == null) return null;
    return '$_firstName $_lastName';
  }

  /// Salva dados do Step 1
  void saveStep1Data({
    required String email,
    required String senha,
    required String firstName,
    required String lastName,
    DateTime? birthDate,
    String? gender,
    String? phone,
  }) {
    _email = email;
    _senha = senha;
    _firstName = firstName;
    _lastName = lastName;
    _birthDate = birthDate;
    _gender = gender;
    _phone = phone;
    notifyListeners();
  }

  /// Salva dados do Step 2
  void saveStep2Data({
    required String diagnosis,
    required List<String> comorbidities,
  }) {
    _diagnosis = diagnosis;
    _comorbidities = comorbidities;
    notifyListeners();
  }

  /// Salva dados do Step 3
  void saveStep3Data({
    required double fontSizeLevel,
    required bool highContrast,
    required bool textToSpeech,
    required bool gdprConsent,
    required bool emailConsent,
  }) {
    _fontSizeLevel = fontSizeLevel;
    _highContrast = highContrast;
    _textToSpeech = textToSpeech;
    _gdprConsent = gdprConsent;
    _emailConsent = emailConsent;
    notifyListeners();
  }

  /// Finaliza o registro enviando dados ao backend
  Future<bool> completeRegistration() async {
    if (_email == null || _senha == null) {
      _errorMessage = 'Dados de email e senha são obrigatórios';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.register(
        email: _email!,
        senha: _senha!,
        nome: fullName,
        dataNascimento: _birthDate,
        genero: _gender,
        telefone: _phone,
      );

      _isLoading = false;
      notifyListeners();
      
      // Limpa os dados após sucesso
      _clearData();
      
      return true;
    } on ValidationException catch (e) {
      _isLoading = false;
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } on NetworkException catch (e) {
      _isLoading = false;
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } on ApiException catch (e) {
      _isLoading = false;
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Erro inesperado ao criar conta: $e';
      notifyListeners();
      return false;
    }
  }

  /// Limpa todos os dados do registro
  void _clearData() {
    _email = null;
    _senha = null;
    _firstName = null;
    _lastName = null;
    _birthDate = null;
    _gender = null;
    _phone = null;
    _diagnosis = null;
    _comorbidities = [];
    _fontSizeLevel = 3.0;
    _highContrast = false;
    _textToSpeech = false;
    _gdprConsent = false;
    _emailConsent = false;
    _errorMessage = null;
    notifyListeners();
  }

  /// Limpa apenas a mensagem de erro
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

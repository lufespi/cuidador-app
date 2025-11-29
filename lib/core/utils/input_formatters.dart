import 'package:flutter/services.dart';

/// Formatador para campo de data no formato DD/MM/AAAA
class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    
    // Remove tudo que não é número
    final digitsOnly = text.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Limita a 8 dígitos (DDMMAAAA)
    final limitedDigits = digitsOnly.substring(0, digitsOnly.length > 8 ? 8 : digitsOnly.length);
    
    // Formata com barras
    String formatted = '';
    for (int i = 0; i < limitedDigits.length; i++) {
      if (i == 2 || i == 4) {
        formatted += '/';
      }
      formatted += limitedDigits[i];
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Formatador para campo de horário no formato HH:MM
class TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    
    // Remove tudo que não é número
    final digitsOnly = text.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Limita a 4 dígitos (HHMM)
    final limitedDigits = digitsOnly.substring(0, digitsOnly.length > 4 ? 4 : digitsOnly.length);
    
    // Formata com dois pontos
    String formatted = '';
    for (int i = 0; i < limitedDigits.length; i++) {
      if (i == 2) {
        formatted += ':';
      }
      formatted += limitedDigits[i];
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

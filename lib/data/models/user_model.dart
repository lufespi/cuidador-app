/// Modelo de usuário
class UserModel {
  final String id;
  final String email;
  final String? nome;
  final DateTime? dataNascimento;
  final String? genero;
  final String? telefone;
  final String? diagnostico;
  final String? comorbidades;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isAdmin;

  UserModel({
    required this.id,
    required this.email,
    this.nome,
    this.dataNascimento,
    this.genero,
    this.telefone,
    this.diagnostico,
    this.comorbidades,
    required this.createdAt,
    this.updatedAt,
    this.isAdmin = false,
  });

  /// Factory para criar do JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      email: json['email'] as String,
      nome: json['nome'] as String?,
      dataNascimento: _parseDate(json['data_nascimento']),
      genero: json['sexo'] as String? ?? json['genero'] as String?, // Backend usa 'sexo'
      telefone: json['telefone'] as String?,
      diagnostico: json['diagnostico'] as String?,
      comorbidades: json['comorbidades'] as String?,
      createdAt: _parseDate(json['created_at']) ?? DateTime.now(),
      updatedAt: _parseDate(json['updated_at']),
      isAdmin: json['is_admin'] == true || json['is_admin'] == 1,
    );
  }

  /// Parseia data de múltiplos formatos
  static DateTime? _parseDate(dynamic dateValue) {
    if (dateValue == null) return null;
    
    try {
      // Se já for DateTime
      if (dateValue is DateTime) return dateValue;
      
      final dateStr = dateValue.toString();
      
      // Ignora datas inválidas do MySQL (0000-00-00)
      if (dateStr.startsWith('0000-00-00')) return null;
      
      // Tenta parse ISO 8601 padrão
      try {
        return DateTime.parse(dateStr);
      } catch (_) {
        // Tenta outros formatos comuns
        // Formato: YYYY-MM-DD
        final dateRegex = RegExp(r'(\d{4})-(\d{2})-(\d{2})');
        final match = dateRegex.firstMatch(dateStr);
        if (match != null) {
          return DateTime(
            int.parse(match.group(1)!),
            int.parse(match.group(2)!),
            int.parse(match.group(3)!),
          );
        }
      }
      
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Converte para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nome': nome,
      'data_nascimento': dataNascimento?.toIso8601String(),
      'genero': genero,
      'telefone': telefone,
      'diagnostico': diagnostico,
      'comorbidades': comorbidades,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_admin': isAdmin,
    };
  }

  /// Cria cópia com modificações
  UserModel copyWith({
    String? id,
    String? email,
    String? nome,
    DateTime? dataNascimento,
    String? genero,
    String? telefone,
    String? diagnostico,
    String? comorbidades,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isAdmin,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      nome: nome ?? this.nome,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      genero: genero ?? this.genero,
      telefone: telefone ?? this.telefone,
      diagnostico: diagnostico ?? this.diagnostico,
      comorbidades: comorbidades ?? this.comorbidades,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}

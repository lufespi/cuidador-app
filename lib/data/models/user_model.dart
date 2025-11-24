/// Modelo de usuário
class UserModel {
  final String id;
  final String email;
  final String? nome;
  final DateTime? dataNascimento;
  final String? genero;
  final String? telefone;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.email,
    this.nome,
    this.dataNascimento,
    this.genero,
    this.telefone,
    required this.createdAt,
    this.updatedAt,
  });

  /// Factory para criar do JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      email: json['email'] as String,
      nome: json['nome'] as String?,
      dataNascimento: json['data_nascimento'] != null
          ? DateTime.parse(json['data_nascimento'] as String)
          : null,
      genero: json['genero'] as String?,
      telefone: json['telefone'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
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
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
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
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      nome: nome ?? this.nome,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      genero: genero ?? this.genero,
      telefone: telefone ?? this.telefone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

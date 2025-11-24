/// Modelo de registro de dor
class PainRecordModel {
  final String? id;
  final String userId;
  final List<String> bodyParts;
  final int intensidade;
  final String? descricao;
  final DateTime dataRegistro;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PainRecordModel({
    this.id,
    required this.userId,
    required this.bodyParts,
    required this.intensidade,
    this.descricao,
    required this.dataRegistro,
    this.createdAt,
    this.updatedAt,
  });

  factory PainRecordModel.fromJson(Map<String, dynamic> json) {
    return PainRecordModel(
      id: json['id']?.toString(),
      userId: json['user_id'].toString(),
      bodyParts: List<String>.from(json['body_parts'] ?? []),
      intensidade: json['intensidade'] as int,
      descricao: json['descricao'] as String?,
      dataRegistro: DateTime.parse(json['data_registro'] as String),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'body_parts': bodyParts,
      'intensidade': intensidade,
      'descricao': descricao,
      'data_registro': dataRegistro.toIso8601String(),
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}

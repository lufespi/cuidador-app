class ReminderModel {
  final int? id;
  final int? userId;
  final String type;
  final String title;
  final String description;
  final String frequency;
  final String time;
  final bool isActive;
  final Map<String, bool>? selectedDays;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ReminderModel({
    this.id,
    this.userId,
    required this.type,
    required this.title,
    this.description = '',
    this.frequency = 'Diário',
    required this.time,
    this.isActive = true,
    this.selectedDays,
    this.createdAt,
    this.updatedAt,
  });

  /// Cria uma instância a partir de JSON (do backend)
  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    Map<String, bool>? days;
    
    // Parse selectedDays se existir
    if (json['selected_days'] != null) {
      if (json['selected_days'] is Map) {
        days = Map<String, bool>.from(json['selected_days']);
      }
    }

    return ReminderModel(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      frequency: json['frequency'] as String? ?? 'Diário',
      time: json['time'] as String,
      isActive: json['is_active'] == 1 || json['is_active'] == true,
      selectedDays: days,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  /// Converte para JSON (para enviar ao backend)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      'type': type,
      'title': title,
      'description': description,
      'frequency': frequency,
      'time': time,
      'is_active': isActive,
      if (selectedDays != null) 'selected_days': selectedDays,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  /// Cria uma cópia com campos opcionalmente alterados
  ReminderModel copyWith({
    int? id,
    int? userId,
    String? type,
    String? title,
    String? description,
    String? frequency,
    String? time,
    bool? isActive,
    Map<String, bool>? selectedDays,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      frequency: frequency ?? this.frequency,
      time: time ?? this.time,
      isActive: isActive ?? this.isActive,
      selectedDays: selectedDays ?? this.selectedDays,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'ReminderModel(id: $id, type: $type, title: $title, time: $time, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReminderModel &&
        other.id == id &&
        other.userId == userId &&
        other.type == type &&
        other.title == title &&
        other.description == description &&
        other.frequency == frequency &&
        other.time == time &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        type.hashCode ^
        title.hashCode ^
        description.hashCode ^
        frequency.hashCode ^
        time.hashCode ^
        isActive.hashCode;
  }
}

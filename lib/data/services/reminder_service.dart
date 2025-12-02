import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reminder_model.dart';
import '../../core/network/http_client.dart';
import '../../core/config/api_config.dart';

class ReminderService {
  static const String _cacheKey = 'cached_reminders';
  final HttpClient _httpClient = HttpClient();

  /// Lista todos os lembretes do usuário
  Future<List<ReminderModel>> getReminders() async {
    try {
      final response = await _httpClient.get(
        '${ApiConfig.apiUrl}/reminders',
        requiresAuth: true,
      );

      // Response já é Map<String, dynamic>, mas pode conter uma lista
      final data = response is List ? response : (response['data'] as List? ?? []);
      final reminders = (data as List).map((json) => ReminderModel.fromJson(json as Map<String, dynamic>)).toList();
      
      // Salva no cache local
      await _cacheReminders(reminders);
      
      return reminders;
    } catch (e) {
      // Em caso de erro de conexão, carrega do cache
      return await _loadCachedReminders();
    }
  }

  /// Cria um novo lembrete
  Future<ReminderModel> createReminder(ReminderModel reminder) async {
    final response = await _httpClient.post(
      '${ApiConfig.apiUrl}/reminders',
      body: reminder.toJson(),
      requiresAuth: true,
    );

    final newReminder = ReminderModel.fromJson(response);
    
    // Atualiza cache
    await _addToCache(newReminder);
    
    return newReminder;
  }

  /// Atualiza um lembrete existente
  Future<ReminderModel> updateReminder(int id, ReminderModel reminder) async {
    final response = await _httpClient.put(
      '${ApiConfig.apiUrl}/reminders/$id',
      body: reminder.toJson(),
      requiresAuth: true,
    );

    final updatedReminder = ReminderModel.fromJson(response);
    
    // Atualiza cache
    await _updateInCache(updatedReminder);
    
    return updatedReminder;
  }

  /// Deleta um lembrete
  Future<void> deleteReminder(int id) async {
    await _httpClient.delete(
      '${ApiConfig.apiUrl}/reminders/$id',
      requiresAuth: true,
    );

    // Remove do cache
    await _removeFromCache(id);
  }

  /// Salva todos os lembretes no cache local
  Future<void> _cacheReminders(List<ReminderModel> reminders) async {
    final prefs = await SharedPreferences.getInstance();
    final remindersJson = reminders.map((r) => r.toJson()).toList();
    await prefs.setString(_cacheKey, jsonEncode(remindersJson));
  }

  /// Carrega lembretes do cache local
  Future<List<ReminderModel>> _loadCachedReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_cacheKey);
    
    if (cached == null) return [];
    
    final List<dynamic> data = jsonDecode(cached);
    return data.map((json) => ReminderModel.fromJson(json)).toList();
  }

  /// Adiciona um lembrete ao cache
  Future<void> _addToCache(ReminderModel reminder) async {
    final reminders = await _loadCachedReminders();
    reminders.add(reminder);
    await _cacheReminders(reminders);
  }

  /// Atualiza um lembrete no cache
  Future<void> _updateInCache(ReminderModel reminder) async {
    final reminders = await _loadCachedReminders();
    final index = reminders.indexWhere((r) => r.id == reminder.id);
    
    if (index != -1) {
      reminders[index] = reminder;
      await _cacheReminders(reminders);
    }
  }

  /// Remove um lembrete do cache
  Future<void> _removeFromCache(int id) async {
    final reminders = await _loadCachedReminders();
    reminders.removeWhere((r) => r.id == id);
    await _cacheReminders(reminders);
  }

  /// Limpa o cache de lembretes
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
  }

  /// Obtém preferências de notificação do usuário
  Future<Map<String, dynamic>> getNotificationPreferences() async {
    final response = await _httpClient.get(
      '${ApiConfig.apiUrl}/auth/notification-preferences',
      requiresAuth: true,
    );

    return response;
  }

  /// Atualiza preferências de notificação do usuário
  Future<void> updateNotificationPreferences(Map<String, dynamic> preferences) async {
    await _httpClient.put(
      '${ApiConfig.apiUrl}/auth/notification-preferences',
      body: preferences,
      requiresAuth: true,
    );
    
    // Salva no cache local também
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('notification_preferences', jsonEncode(preferences));
  }

  /// Carrega preferências de notificação do cache local
  Future<Map<String, dynamic>?> getCachedNotificationPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('notification_preferences');
    
    if (cached == null) return null;
    
    return jsonDecode(cached);
  }
}

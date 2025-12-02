import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reminder_model.dart';
import '../../core/network/http_client.dart';
import '../../core/network/token_storage.dart';

class ReminderService {
  static const String _cacheKey = 'cached_reminders';
  final HttpClient _httpClient = HttpClient();

  /// Lista todos os lembretes do usuário
  Future<List<ReminderModel>> getReminders() async {
    try {
      final token = await TokenStorage.getToken();
      
      if (token == null) {
        throw Exception('Token não encontrado');
      }

      final response = await _httpClient.get(
        '/reminders',
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final reminders = data.map((json) => ReminderModel.fromJson(json)).toList();
        
        // Salva no cache local
        await _cacheReminders(reminders);
        
        return reminders;
      } else {
        // Se falhar, tenta carregar do cache
        return await _loadCachedReminders();
      }
    } catch (e) {
      // Em caso de erro de conexão, carrega do cache
      return await _loadCachedReminders();
    }
  }

  /// Cria um novo lembrete
  Future<ReminderModel> createReminder(ReminderModel reminder) async {
    final token = await TokenStorage.getToken();
    
    if (token == null) {
      throw Exception('Token não encontrado');
    }

    final response = await _httpClient.post(
      '/reminders',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(reminder.toJson()),
    );

    if (response.statusCode == 201) {
      final reminderData = jsonDecode(response.body);
      final newReminder = ReminderModel.fromJson(reminderData);
      
      // Atualiza cache
      await _addToCache(newReminder);
      
      return newReminder;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Erro ao criar lembrete');
    }
  }

  /// Atualiza um lembrete existente
  Future<ReminderModel> updateReminder(int id, ReminderModel reminder) async {
    final token = await TokenStorage.getToken();
    
    if (token == null) {
      throw Exception('Token não encontrado');
    }

    final response = await _httpClient.put(
      '/reminders/$id',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(reminder.toJson()),
    );

    if (response.statusCode == 200) {
      final reminderData = jsonDecode(response.body);
      final updatedReminder = ReminderModel.fromJson(reminderData);
      
      // Atualiza cache
      await _updateInCache(updatedReminder);
      
      return updatedReminder;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Erro ao atualizar lembrete');
    }
  }

  /// Deleta um lembrete
  Future<void> deleteReminder(int id) async {
    final token = await TokenStorage.getToken();
    
    if (token == null) {
      throw Exception('Token não encontrado');
    }

    final response = await _httpClient.delete(
      '/reminders/$id',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      // Remove do cache
      await _removeFromCache(id);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Erro ao deletar lembrete');
    }
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
    final token = await TokenStorage.getToken();
    
    if (token == null) {
      throw Exception('Token não encontrado');
    }

    final response = await _httpClient.get(
      '/auth/notification-preferences',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Erro ao buscar preferências');
    }
  }

  /// Atualiza preferências de notificação do usuário
  Future<void> updateNotificationPreferences(Map<String, dynamic> preferences) async {
    final token = await TokenStorage.getToken();
    
    if (token == null) {
      throw Exception('Token não encontrado');
    }

    final response = await _httpClient.put(
      '/auth/notification-preferences',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(preferences),
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Erro ao atualizar preferências');
    }
    
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

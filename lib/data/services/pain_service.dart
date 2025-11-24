import '../../core/config/api_config.dart';
import '../../core/network/http_client.dart';
import '../models/pain_record_model.dart';

/// Serviço de registros de dor
class PainService {
  final HttpClient _httpClient;

  PainService({HttpClient? httpClient})
      : _httpClient = httpClient ?? HttpClient();

  /// Cria novo registro de dor
  Future<PainRecordModel> createPainRecord({
    required List<String> bodyParts,
    required int intensidade,
    String? descricao,
    DateTime? dataRegistro,
  }) async {
    final response = await _httpClient.post(
      ApiConfig.painRecordsUrl,
      body: {
        'body_parts': bodyParts,
        'intensidade': intensidade,
        if (descricao != null) 'descricao': descricao,
        'data_registro': (dataRegistro ?? DateTime.now()).toIso8601String(),
      },
      requiresAuth: true,
    );

    return PainRecordModel.fromJson(response);
  }

  /// Lista todos os registros de dor do usuário
  Future<List<PainRecordModel>> getPainRecords({
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    final queryParams = <String, String>{};
    
    if (startDate != null) {
      queryParams['start_date'] = startDate.toIso8601String();
    }
    if (endDate != null) {
      queryParams['end_date'] = endDate.toIso8601String();
    }
    if (limit != null) {
      queryParams['limit'] = limit.toString();
    }

    final uri = Uri.parse(ApiConfig.painRecordsUrl);
    final urlWithParams = uri.replace(queryParameters: queryParams).toString();

    final response = await _httpClient.get(
      urlWithParams,
      requiresAuth: true,
    );

    final records = response['records'] as List;
    return records.map((json) => PainRecordModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// Obtém registro específico por ID
  Future<PainRecordModel> getPainRecordById(String id) async {
    final response = await _httpClient.get(
      ApiConfig.painRecordByIdUrl(id),
      requiresAuth: true,
    );

    return PainRecordModel.fromJson(response);
  }

  /// Atualiza registro de dor
  Future<PainRecordModel> updatePainRecord({
    required String id,
    List<String>? bodyParts,
    int? intensidade,
    String? descricao,
  }) async {
    final response = await _httpClient.put(
      ApiConfig.painRecordByIdUrl(id),
      body: {
        if (bodyParts != null) 'body_parts': bodyParts,
        if (intensidade != null) 'intensidade': intensidade,
        if (descricao != null) 'descricao': descricao,
      },
      requiresAuth: true,
    );

    return PainRecordModel.fromJson(response);
  }

  /// Deleta registro de dor
  Future<void> deletePainRecord(String id) async {
    await _httpClient.delete(
      ApiConfig.painRecordByIdUrl(id),
      requiresAuth: true,
    );
  }

  /// Obtém estatísticas de dor
  Future<Map<String, dynamic>> getPainStatistics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParams = <String, String>{};
    
    if (startDate != null) {
      queryParams['start_date'] = startDate.toIso8601String();
    }
    if (endDate != null) {
      queryParams['end_date'] = endDate.toIso8601String();
    }

    final uri = Uri.parse('${ApiConfig.painRecordsUrl}/statistics');
    final urlWithParams = uri.replace(queryParameters: queryParams).toString();

    return await _httpClient.get(
      urlWithParams,
      requiresAuth: true,
    );
  }
}

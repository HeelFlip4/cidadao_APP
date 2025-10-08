import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../models/vaga_model.dart';
import '../models/telefone_model.dart';
import '../models/ocorrencia_model.dart';

class ApiService {
  static const String _baseUrl = AppConstants.baseUrl;
  static const Duration _timeout = Duration(seconds: 30);

  // Headers padrão
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Headers com autenticação
  static Map<String, String> _headersWithAuth(String token) => {
    ..._headers,
    'Authorization': 'Bearer $token',
  };

  // Método genérico para requisições GET
  static Future<Map<String, dynamic>> _get(
    String endpoint, {
    String? token,
    Map<String, String>? queryParams,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final uriWithParams = queryParams != null
          ? uri.replace(queryParameters: queryParams)
          : uri;

      final response = await http
          .get(
            uriWithParams,
            headers: token != null ? _headersWithAuth(token) : _headers,
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Método genérico para requisições POST
  static Future<Map<String, dynamic>> _post(
    String endpoint,
    Map<String, dynamic> data, {
    String? token,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl$endpoint'),
            headers: token != null ? _headersWithAuth(token) : _headers,
            body: jsonEncode(data),
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Método genérico para requisições PUT
  static Future<Map<String, dynamic>> _put(
    String endpoint,
    Map<String, dynamic> data, {
    String? token,
  }) async {
    try {
      final response = await http
          .put(
            Uri.parse('$_baseUrl$endpoint'),
            headers: token != null ? _headersWithAuth(token) : _headers,
            body: jsonEncode(data),
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Método genérico para requisições DELETE
  static Future<Map<String, dynamic>> _delete(
    String endpoint, {
    String? token,
  }) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$_baseUrl$endpoint'),
            headers: token != null ? _headersWithAuth(token) : _headers,
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Tratamento de resposta
  static Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body;

    if (statusCode >= 200 && statusCode < 300) {
      if (body.isEmpty) return {};
      return jsonDecode(body);
    } else {
      throw ApiException(
        statusCode: statusCode,
        message: _getErrorMessage(statusCode, body),
      );
    }
  }

  // Tratamento de erro
  static ApiException _handleError(dynamic error) {
    if (error is ApiException) return error;
    
    if (error is SocketException) {
      return ApiException(
        statusCode: 0,
        message: 'Sem conexão com a internet',
      );
    }
    
    if (error is http.ClientException) {
      return ApiException(
        statusCode: 0,
        message: 'Erro de conexão com o servidor',
      );
    }
    
    return ApiException(
      statusCode: 0,
      message: 'Erro inesperado: ${error.toString()}',
    );
  }

  // Obter mensagem de erro baseada no status code
  static String _getErrorMessage(int statusCode, String body) {
    try {
      final json = jsonDecode(body);
      if (json['message'] != null) return json['message'];
      if (json['error'] != null) return json['error'];
    } catch (e) {
      // Ignorar erro de parsing
    }

    switch (statusCode) {
      case 400:
        return 'Dados inválidos';
      case 401:
        return 'Não autorizado';
      case 403:
        return 'Acesso negado';
      case 404:
        return 'Recurso não encontrado';
      case 422:
        return 'Dados de entrada inválidos';
      case 500:
        return 'Erro interno do servidor';
      case 503:
        return 'Serviço indisponível';
      default:
        return 'Erro desconhecido (${statusCode})';
    }
  }

  // === MÉTODOS DE AUTENTICAÇÃO ===

  static Future<Map<String, dynamic>> login(String email, String password) async {
    return await _post(AppConstants.loginEndpoint, {
      'email': email,
      'password': password,
    });
  }

  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    return await _post(AppConstants.registerEndpoint, {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
    });
  }

  static Future<Map<String, dynamic>> verifyPhone(
    String phone,
    String code,
  ) async {
    return await _post('/auth/verify-phone', {
      'phone': phone,
      'code': code,
    });
  }

  // === MÉTODOS DE OCORRÊNCIAS ===

  static Future<List<Ocorrencia>> getOcorrencias({
    String? token,
    String? categoria,
    String? status,
  }) async {
    final queryParams = <String, String>{};
    if (categoria != null) queryParams['categoria'] = categoria;
    if (status != null) queryParams['status'] = status;

    final response = await _get(
      AppConstants.ocorrenciasEndpoint,
      token: token,
      queryParams: queryParams.isNotEmpty ? queryParams : null,
    );

    final List<dynamic> data = response['data'] ?? [];
    return data.map((json) => Ocorrencia.fromJson(json)).toList();
  }

  static Future<Ocorrencia> createOcorrencia(
    Ocorrencia ocorrencia,
    String token,
  ) async {
    final response = await _post(
      AppConstants.ocorrenciasEndpoint,
      ocorrencia.toJson(),
      token: token,
    );

    return Ocorrencia.fromJson(response['data']);
  }

  static Future<Ocorrencia> getOcorrencia(String id, String token) async {
    final response = await _get(
      '${AppConstants.ocorrenciasEndpoint}/$id',
      token: token,
    );

    return Ocorrencia.fromJson(response['data']);
  }

  // === MÉTODOS DE VAGAS ===

  static Future<List<Vaga>> getVagas({
    String? categoria,
    String? search,
  }) async {
    final queryParams = <String, String>{};
    if (categoria != null) queryParams['categoria'] = categoria;
    if (search != null) queryParams['search'] = search;

    final response = await _get(
      AppConstants.vagasEndpoint,
      queryParams: queryParams.isNotEmpty ? queryParams : null,
    );

    final List<dynamic> data = response['data'] ?? [];
    return data.map((json) => Vaga.fromJson(json)).toList();
  }

  static Future<Vaga> getVaga(String id) async {
    final response = await _get('${AppConstants.vagasEndpoint}/$id');
    return Vaga.fromJson(response['data']);
  }

  static Future<Map<String, dynamic>> candidatarVaga(
    String vagaId,
    String token,
  ) async {
    return await _post(
      '${AppConstants.vagasEndpoint}/$vagaId/candidatar',
      {},
      token: token,
    );
  }

  // === MÉTODOS DE TELEFONES ===

  static Future<List<TelefoneUtil>> getTelefones({
    String? categoria,
  }) async {
    final queryParams = <String, String>{};
    if (categoria != null) queryParams['categoria'] = categoria;

    final response = await _get(
      AppConstants.telefonesEndpoint,
      queryParams: queryParams.isNotEmpty ? queryParams : null,
    );

    final List<dynamic> data = response['data'] ?? [];
    return data.map((json) => TelefoneUtil.fromJson(json)).toList();
  }

  // === MÉTODOS DE NOTÍCIAS ===

  static Future<List<Map<String, dynamic>>> getNoticias({
    int? limit,
  }) async {
    final queryParams = <String, String>{};
    if (limit != null) queryParams['limit'] = limit.toString();

    final response = await _get(
      AppConstants.noticiasEndpoint,
      queryParams: queryParams.isNotEmpty ? queryParams : null,
    );

    return List<Map<String, dynamic>>.from(response['data'] ?? []);
  }

  // === MÉTODOS DE UPLOAD ===

  static Future<String> uploadImage(File imageFile, String token) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/upload/image'),
      );

      request.headers.addAll(_headersWithAuth(token));
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      final streamedResponse = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);

      final result = _handleResponse(response);
      return result['url'];
    } catch (e) {
      throw _handleError(e);
    }
  }
}

// Classe de exceção personalizada para API
class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException({
    required this.statusCode,
    required this.message,
  });

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

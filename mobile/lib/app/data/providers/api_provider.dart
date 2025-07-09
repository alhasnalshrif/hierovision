import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../services/storage_service.dart';

class ApiProvider {
  final String baseUrl = const String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:5000/api',
  );
  final StorageService _storageService = Get.find();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> get(String endpoint) async {
    final headers = await _getHeaders();
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      _logResponse('GET', endpoint, response);
      return response;
    } catch (e) {
      _logError('GET', endpoint, e);
      rethrow;
    }
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      );
      _logResponse('POST', endpoint, response);
      return response;
    } catch (e) {
      _logError('POST', endpoint, e);
      rethrow;
    }
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      );
      _logResponse('PUT', endpoint, response);
      return response;
    } catch (e) {
      _logError('PUT', endpoint, e);
      rethrow;
    }
  }

  Future<http.Response> delete(String endpoint) async {
    final headers = await _getHeaders();
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      _logResponse('DELETE', endpoint, response);
      return response;
    } catch (e) {
      _logError('DELETE', endpoint, e);
      rethrow;
    }
  }

  Future<http.Response> uploadFile(
    String endpoint,
    File file, {
    Map<String, String>? fields,
  }) async {
    final token = await _storageService.getToken();
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl$endpoint'),
    );

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    if (fields != null) {
      request.fields.addAll(fields);
    }

    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  // Logging methods for debugging
  void _logResponse(String method, String endpoint, http.Response response) {
    print('[$method] $baseUrl$endpoint -> ${response.statusCode}');
    if (response.statusCode >= 400) {
      print('Error response body: ${response.body}');
    }
  }

  void _logError(String method, String endpoint, Object error) {
    print('[$method] $baseUrl$endpoint -> ERROR: $error');
  }
}

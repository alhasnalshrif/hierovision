import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import '../models/scan.dart';
import '../providers/api_provider.dart';

class ScanRepository {
  final ApiProvider _apiProvider = Get.find();

  Future<Map<String, dynamic>> uploadImage(File imageFile) async {
    try {
      final response = await _apiProvider.uploadFile('/predict', imageFile);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'results': data, // Return the prediction data directly
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? error['error'] ?? 'Upload failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  Future<List<Scan>> getScanHistory() async {
    try {
      final response = await _apiProvider.get('/scans/user');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return (data['scans'] as List)
              .map((json) => Scan.fromJson(json))
              .toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to load scan history');
        }
      } else {
        throw Exception('Failed to load scan history');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Get user's scans - alias for getScanHistory to match React API
  Future<List<Scan>> getUserScans() async {
    return getScanHistory();
  }

  Future<List<Scan>> getRecentScans({int limit = 10}) async {
    try {
      final response = await _apiProvider.get('/scans/recent?limit=$limit');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['scans'] as List)
            .map((json) => Scan.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load recent scans');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<Scan> getScanById(int id) async {
    try {
      final response = await _apiProvider.get('/scan/$id');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Scan.fromJson(data);
      } else {
        throw Exception('Failed to load scan');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<void> deleteScan(int id) async {
    try {
      final response = await _apiProvider.delete('/scan/$id');

      if (response.statusCode != 200) {
        throw Exception('Failed to delete scan');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> translateEnglishToHieroglyphs(
    String englishText,
  ) async {
    try {
      final response = await _apiProvider.post(
        '/translate/english-to-hieroglyphs',
        {'text': englishText},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': data['success'] ?? true,
          'original_text': data['original_text'] ?? englishText,
          'hieroglyphs': data['hieroglyphs'] ?? '',
          'confidence_score': data['confidence_score'] ?? 0.0,
          'transliteration': data['transliteration'],
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'error': error['message'] ?? 'Translation failed',
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> saveTranslation(
    Map<String, dynamic> translationData,
  ) async {
    try {
      final response = await _apiProvider.post('/scans/save', translationData);

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'scan': data['scan'] != null ? Scan.fromJson(data['scan']) : null,
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Failed to save translation',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> getClassInfo(int classIndex) async {
    try {
      final response = await _apiProvider.get('/prediction/info/$classIndex');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': 'Failed to get class information'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> searchScans(String query) async {
    try {
      final response = await _apiProvider.get(
        '/scan/search?q=${Uri.encodeComponent(query)}',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'results': data['scans'] ?? []};
      } else {
        return {'success': false, 'message': 'Search failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  Future<List<Scan>> getAllClasses() async {
    try {
      final response = await _apiProvider.get('/prediction/classes');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['classes'] as List)
            .map((json) => Scan.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load classes');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> saveScanWithImage(
    File imageFile,
    String resultText,
    String description,
    double confidence,
  ) async {
    try {
      final response = await _apiProvider.uploadFile(
        '/scans/save',
        imageFile,
        fields: {
          'description': description,
          'result_text': resultText,
          'confidence_score': confidence.toString(),
          'type': 'hieroglyph',
          'location': 'Ancient Egypt',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'scan': data['scan'] != null ? Scan.fromJson(data['scan']) : null,
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Failed to save scan with image',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }
}

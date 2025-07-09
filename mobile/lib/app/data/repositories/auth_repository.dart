import 'dart:convert';
import 'package:get/get.dart';
import '../models/user.dart';
import '../providers/api_provider.dart';
import '../services/storage_service.dart';

class AuthRepository {
  final ApiProvider _apiProvider = Get.find();
  final StorageService _storageService = Get.find();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiProvider.post('/auth/login', {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          await _storageService.saveToken(data['token']);
          await _storageService.saveUser(jsonEncode(data['user']));
        }
        return {
          'success': true,
          'user': User.fromJson(data['user']),
          'token': data['token'],
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message':
              error['message'] ??
              error['msg'] ??
              error['error'] ??
              'Login failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> register(
    String fullName,
    String email,
    String password,
  ) async {
    try {
      final response = await _apiProvider.post('/auth/register', {
        'fullName': fullName,
        'email': email,
        'password': password,
      });

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          await _storageService.saveToken(data['token']);
          await _storageService.saveUser(jsonEncode(data['user']));
        }
        return {
          'success': true,
          'user': User.fromJson(data['user']),
          'token': data['token'],
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message':
              error['message'] ??
              error['msg'] ??
              error['error'] ??
              'Registration failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  Future<void> logout() async {
    try {
      // Call logout endpoint to invalidate token on server
      await _apiProvider.post('/auth/logout', {});
    } catch (e) {
      // Continue with local logout even if server request fails
      print('Error calling logout endpoint: $e');
    } finally {
      // Always clear local storage
      await _storageService.removeToken();
      await _storageService.removeUser();
    }
  }

  Future<User?> getCurrentUser() async {
    final userData = await _storageService.getUser();
    if (userData != null) {
      return User.fromJson(jsonDecode(userData));
    }
    return null;
  }

  Future<bool> isLoggedIn() async {
    final token = await _storageService.getToken();
    if (token == null) return false;

    // Verify token with server
    try {
      final response = await _apiProvider.get('/auth/verify');
      return response.statusCode == 200;
    } catch (e) {
      // If verification fails, remove invalid token
      await _storageService.removeToken();
      await _storageService.removeUser();
      return false;
    }
  }
}

import 'dart:convert';
import 'package:get/get.dart';
import '../models/user.dart';
import '../providers/api_provider.dart';
import '../services/storage_service.dart';

class UserRepository {
  final ApiProvider _apiProvider = Get.find();
  final StorageService _storageService = Get.find();

  // Get current user profile from API
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _apiProvider.get('/user/profile');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Update local storage with latest user data
        await _storageService.saveUser(jsonEncode(data['user']));
        
        return {
          'success': true,
          'user': User.fromJson(data['user']),
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? error['msg'] ?? error['error'] ?? 'Failed to fetch profile',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Update user profile
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> userData) async {
    try {
      final response = await _apiProvider.put('/user/profile', userData);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Update local storage with updated user data
        await _storageService.saveUser(jsonEncode(data['user']));
        
        return {
          'success': true,
          'user': User.fromJson(data['user']),
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? error['msg'] ?? error['error'] ?? 'Profile update failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }
  
  // Update specific user field
  Future<Map<String, dynamic>> updateUserField(String field, dynamic value) async {
    return await updateProfile({field: value});
  }
}

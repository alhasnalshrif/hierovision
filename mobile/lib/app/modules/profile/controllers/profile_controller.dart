import 'dart:convert';
import 'package:get/get.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/models/user.dart';

class ProfileController extends GetxController {
  final RxBool isLoading = false.obs;
  final StorageService _storageService = StorageService();
  final UserRepository _userRepository = Get.put(UserRepository());
  
  final Rx<User?> user = Rx<User?>(null);
  final RxString userName = 'Your Name'.obs;
  final RxString userEmail = 'your_gmail@gmail.com'.obs;
  final RxString phoneNumber = 'Add Number'.obs;
  final RxString language = 'English (eng)'.obs;
  final RxString currency = 'US Dollar (\$)'.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      // Try to fetch from API first
      final result = await _userRepository.getCurrentUser();
      
      if (result['success']) {
        // API fetch successful
        _updateUserState(result['user']);
      } else {
        // API fetch failed, fallback to local storage
        _loadFromLocalStorage();
        errorMessage.value = result['message'];
      }
    } catch (e) {
      // Error during API fetch, fallback to local storage
      _loadFromLocalStorage();
      errorMessage.value = 'Failed to connect to server';
      print('Error in loadUserData: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _loadFromLocalStorage() async {
    try {
      final userData = await _storageService.getUser();
      if (userData != null && userData.isNotEmpty) {
        final Map<String, dynamic> userMap = json.decode(userData);
        _updateUserState(User.fromJson(userMap));
      }
    } catch (e) {
      print('Error loading data from storage: $e');
    }
  }
  
  void _updateUserState(User userData) {
    user.value = userData;
    userName.value = userData.fullName;
    userEmail.value = userData.email;
    // Phone might not be in the standard User model, use fallback
    phoneNumber.value = 'Add Number'; // This would need to be extended if API provides phone
  }

  Future<void> updateUserName(String name) async {
    if (name.isEmpty) return;
    
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      final result = await _userRepository.updateUserField('full_name', name);
      
      if (result['success']) {
        // Update local state
        _updateUserState(result['user']);
        Get.snackbar('Success', 'Name updated successfully');
      } else {
        errorMessage.value = result['message'];
        Get.snackbar('Error', result['message']);
      }
    } catch (e) {
      errorMessage.value = 'Failed to update name';
      Get.snackbar('Error', 'Failed to update name');
      print('Error updating name: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUserEmail(String email) async {
    if (email.isEmpty) return;
    
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      final result = await _userRepository.updateUserField('email', email);
      
      if (result['success']) {
        // Update local state
        _updateUserState(result['user']);
        Get.snackbar('Success', 'Email updated successfully');
      } else {
        errorMessage.value = result['message'];
        Get.snackbar('Error', result['message']);
      }
    } catch (e) {
      errorMessage.value = 'Failed to update email';
      Get.snackbar('Error', 'Failed to update email');
      print('Error updating email: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePhoneNumber(String phone) async {
    if (phone.isEmpty) return;
    
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      final result = await _userRepository.updateUserField('phone', phone);
      
      if (result['success']) {
        // Update local state
        phoneNumber.value = phone;
        Get.snackbar('Success', 'Phone number updated successfully');
      } else {
        errorMessage.value = result['message'];
        Get.snackbar('Error', result['message']);
      }
    } catch (e) {
      errorMessage.value = 'Failed to update phone number';
      Get.snackbar('Error', 'Failed to update phone number');
      print('Error updating phone: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    try {
      await _storageService.removeToken();
      await _storageService.removeUser();
      // Navigate to login screen or handle logout accordingly
      Get.offAllNamed('/login');
    } catch (e) {
      print('Error during logout: $e');
      Get.snackbar('Error', 'Failed to logout properly');
    }
  }
}

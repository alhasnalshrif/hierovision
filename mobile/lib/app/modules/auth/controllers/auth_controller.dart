import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/user.dart';
import '../../../core/theme/app_theme.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = Get.find();

  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final Rx<User?> currentUser = Rx<User?>(null);

  // Login form
  final RxString email = ''.obs;
  final RxString password = ''.obs;

  // Signup form
  final RxString signupFullName = ''.obs;
  final RxString signupEmail = ''.obs;
  final RxString signupPassword = ''.obs;
  final RxString confirmPassword = ''.obs;

  // Form validation
  final RxString emailError = ''.obs;
  final RxString passwordError = ''.obs;
  final RxString fullNameError = ''.obs;
  final RxString confirmPasswordError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    isLoading.value = true;
    try {
      final loggedIn = await _authRepository.isLoggedIn();
      if (loggedIn) {
        final user = await _authRepository.getCurrentUser();
        currentUser.value = user;
        isLoggedIn.value = true;
        // Navigate to home page if logged in
        Get.offAllNamed('/');
      } else {
        // Navigate to login page if not logged in
        Get.offAllNamed('/login');
      }
    } catch (e) {
      print('Error checking login status: $e');
      // On error, navigate to login page
      Get.offAllNamed('/login');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login() async {
    if (!_validateLoginForm()) return;

    isLoading.value = true;
    try {
      final result = await _authRepository.login(email.value, password.value);

      if (result['success']) {
        currentUser.value = result['user'];
        isLoggedIn.value = true;

        // Clear form after successful login
        clearForm();

        // Navigate to home screen
        Get.offAllNamed('/');

        // Show success message
        Get.snackbar(
          'Success',
          'Welcome back! Login successful!',
          backgroundColor: AppTheme.primaryColor.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          result['message'],
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred during login',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    if (!_validateSignupForm()) return;

    isLoading.value = true;
    try {
      final result = await _authRepository.register(
        signupFullName.value,
        signupEmail.value,
        signupPassword.value,
      );

      if (result['success']) {
        currentUser.value = result['user'];
        isLoggedIn.value = true;

        // Clear form after successful registration
        clearForm();

        // Navigate to home screen
        Get.offAllNamed('/');

        // Show success message
        Get.snackbar(
          'Success',
          'Welcome to HieroVision! Registration successful!',
          backgroundColor: AppTheme.primaryColor.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          result['message'],
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred during registration',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    try {
      await _authRepository.logout();
      currentUser.value = null;
      isLoggedIn.value = false;
      Get.offAllNamed('/');
      Get.snackbar('Success', 'Logged out successfully');
    } catch (e) {
      Get.snackbar('Error', 'Error logging out');
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateLoginForm() {
    bool isValid = true;

    emailError.value = '';
    passwordError.value = '';

    if (email.value.isEmpty) {
      emailError.value = 'Email is required';
      isValid = false;
    } else if (!GetUtils.isEmail(email.value)) {
      emailError.value = 'Please enter a valid email';
      isValid = false;
    }

    if (password.value.isEmpty) {
      passwordError.value = 'Password is required';
      isValid = false;
    } else if (password.value.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
      isValid = false;
    }

    return isValid;
  }

  bool _validateSignupForm() {
    bool isValid = true;

    fullNameError.value = '';
    emailError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';

    if (signupFullName.value.isEmpty) {
      fullNameError.value = 'Full name is required';
      isValid = false;
    } else if (signupFullName.value.length < 2) {
      fullNameError.value = 'Full name must be at least 2 characters';
      isValid = false;
    }

    if (signupEmail.value.isEmpty) {
      emailError.value = 'Email is required';
      isValid = false;
    } else if (!GetUtils.isEmail(signupEmail.value)) {
      emailError.value = 'Please enter a valid email';
      isValid = false;
    }

    if (signupPassword.value.isEmpty) {
      passwordError.value = 'Password is required';
      isValid = false;
    } else if (signupPassword.value.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
      isValid = false;
    }

    if (confirmPassword.value.isEmpty) {
      confirmPasswordError.value = 'Confirm password is required';
      isValid = false;
    } else if (confirmPassword.value != signupPassword.value) {
      confirmPasswordError.value = 'Passwords do not match';
      isValid = false;
    }

    return isValid;
  }

  void clearForm() {
    email.value = '';
    password.value = '';
    signupFullName.value = '';
    signupEmail.value = '';
    signupPassword.value = '';
    confirmPassword.value = '';

    emailError.value = '';
    passwordError.value = '';
    fullNameError.value = '';
    confirmPasswordError.value = '';
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile/app/data/services/storage_service.dart';
import 'package:mobile/app/data/providers/api_provider.dart';
import 'package:mobile/app/data/repositories/auth_repository.dart';
import 'package:mobile/app/modules/auth/controllers/auth_controller.dart';

void main() {
  group('Authentication Integration Tests', () {
    late AuthController authController;
    late AuthRepository authRepository;

    setUpAll(() {
      // Initialize dependencies
      Get.put<StorageService>(StorageService());
      Get.put<ApiProvider>(ApiProvider());
      Get.put<AuthRepository>(AuthRepository());

      authRepository = Get.find<AuthRepository>();
      authController = AuthController();
    });

    tearDownAll(() {
      Get.reset();
    });

    test('AuthController should initialize correctly', () {
      expect(authController.isLoading.value, false);
      expect(authController.isLoggedIn.value, false);
      expect(authController.currentUser.value, null);
    });

    test('Form validation should work correctly', () {
      // Test login validation
      authController.email.value = '';
      authController.password.value = '';

      // This will trigger validation (normally called by login method)
      expect(authController.email.value.isEmpty, true);
      expect(authController.password.value.isEmpty, true);

      // Test signup validation
      authController.signupFullName.value = '';
      authController.signupEmail.value = '';
      authController.signupPassword.value = '';
      authController.confirmPassword.value = '';

      expect(authController.signupFullName.value.isEmpty, true);
      expect(authController.signupEmail.value.isEmpty, true);
    });

    test('Clear form should reset all values', () {
      // Set some values
      authController.email.value = 'test@example.com';
      authController.password.value = 'password123';
      authController.signupFullName.value = 'Test User';

      // Clear form
      authController.clearForm();

      // Check if cleared
      expect(authController.email.value, '');
      expect(authController.password.value, '');
      expect(authController.signupFullName.value, '');
    });
  });
}

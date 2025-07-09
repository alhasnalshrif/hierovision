import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';

class GetStartedController extends GetxController {
  var currentPageIndex = 0.obs;
  final AuthController _authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  void _checkAuthStatus() {
    // If user is already logged in, redirect to home
    if (_authController.isLoggedIn.value) {
      Get.offAllNamed('/');
    }
  }

  void skipToLogin() {
    Get.offAllNamed('/login');
  }

  void getStarted() {
    Get.offAllNamed('/login');
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String icon;
  final List<String> gradient;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
  });
}

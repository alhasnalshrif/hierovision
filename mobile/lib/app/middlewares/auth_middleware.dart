import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/auth/controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    // If user is not logged in and trying to access protected routes
    if (!authController.isLoggedIn.value && _isProtectedRoute(route)) {
      return RouteSettings(name: AppRoutes.LOGIN);
    }

    // If user is logged in and trying to access auth routes
    if (authController.isLoggedIn.value && _isAuthRoute(route)) {
      return RouteSettings(name: AppRoutes.HOME);
    }

    return null;
  }

  bool _isProtectedRoute(String? route) {
    final protectedRoutes = [
      AppRoutes.HOME,
      AppRoutes.UPLOAD,
      AppRoutes.RESULT,
      AppRoutes.LANDMARKS,
      AppRoutes.CHAT,
      AppRoutes.BOOKING,
      AppRoutes.PROFILE,
      AppRoutes.BOOKMARKS,
    ];
    return protectedRoutes.contains(route);
  }

  bool _isAuthRoute(String? route) {
    final authRoutes = [AppRoutes.LOGIN, AppRoutes.SIGNUP];
    return authRoutes.contains(route);
  }
}

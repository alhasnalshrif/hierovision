import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../core/theme/app_theme.dart';

class SignupView extends GetView<AuthController> {
  const SignupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/images/wallpaper.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),

                  // Decorative background elements
                  Stack(
                    children: [
                      // Main content card
                      Container(
                        // margin: const EdgeInsets.only(top: 60),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/profile.png'),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            children: [
                              // Decorative header with Egyptian motif
                              const SizedBox(height: 24),

                              const SizedBox(height: 8),

                              // Egyptian decorative divider
                              const SizedBox(height: 16),

                              const SizedBox(height: 32),
                              const SizedBox(height: 150),

                              // Signup Form
                              Column(
                                children: [
                                  // Full Name Field
                                  Obx(
                                    () => TextField(
                                      onChanged: (value) =>
                                          controller.signupFullName.value =
                                              value,
                                      style: const TextStyle(
                                        color: AppTheme.textColor,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: ' Full Name',
                                        labelStyle: const TextStyle(
                                          color: AppTheme.textColor,
                                          fontSize: 16,
                                        ),
                                        hintText: 'Enter your full name',
                                        hintStyle: TextStyle(
                                          color: AppTheme.textColor.withOpacity(
                                            0.6,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white.withOpacity(
                                          0.5,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: AppTheme.accentColor
                                                .withOpacity(0.3),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: const BorderSide(
                                            color: AppTheme.accentColor,
                                            width: 2,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: AppTheme.accentColor
                                                .withOpacity(0.3),
                                          ),
                                        ),
                                        errorText:
                                            controller
                                                .fullNameError
                                                .value
                                                .isEmpty
                                            ? null
                                            : controller.fullNameError.value,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // Email Field
                                  Obx(
                                    () => TextField(
                                      onChanged: (value) =>
                                          controller.signupEmail.value = value,
                                      keyboardType: TextInputType.emailAddress,
                                      style: const TextStyle(
                                        color: AppTheme.textColor,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: ' Email',
                                        labelStyle: const TextStyle(
                                          color: AppTheme.textColor,
                                          fontSize: 16,
                                        ),
                                        hintText: 'Enter your email',
                                        hintStyle: TextStyle(
                                          color: AppTheme.textColor.withOpacity(
                                            0.6,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white.withOpacity(
                                          0.5,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: AppTheme.accentColor
                                                .withOpacity(0.3),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: const BorderSide(
                                            color: AppTheme.accentColor,
                                            width: 2,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: AppTheme.accentColor
                                                .withOpacity(0.3),
                                          ),
                                        ),
                                        errorText:
                                            controller.emailError.value.isEmpty
                                            ? null
                                            : controller.emailError.value,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // Password Field
                                  Obx(
                                    () => TextField(
                                      onChanged: (value) =>
                                          controller.signupPassword.value =
                                              value,
                                      obscureText: true,
                                      style: const TextStyle(
                                        color: AppTheme.textColor,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: ' Password',
                                        labelStyle: const TextStyle(
                                          color: AppTheme.textColor,
                                          fontSize: 16,
                                        ),
                                        hintText: 'Create a password',
                                        hintStyle: TextStyle(
                                          color: AppTheme.textColor.withOpacity(
                                            0.6,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white.withOpacity(
                                          0.5,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: AppTheme.accentColor
                                                .withOpacity(0.3),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: const BorderSide(
                                            color: AppTheme.accentColor,
                                            width: 2,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: AppTheme.accentColor
                                                .withOpacity(0.3),
                                          ),
                                        ),
                                        errorText:
                                            controller
                                                .passwordError
                                                .value
                                                .isEmpty
                                            ? null
                                            : controller.passwordError.value,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // Confirm Password Field
                                  Obx(
                                    () => TextField(
                                      onChanged: (value) =>
                                          controller.confirmPassword.value =
                                              value,
                                      obscureText: true,
                                      style: const TextStyle(
                                        color: AppTheme.textColor,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: ' Confirm Password',
                                        labelStyle: const TextStyle(
                                          color: AppTheme.textColor,
                                          fontSize: 16,
                                        ),
                                        hintText: 'Confirm your password',
                                        hintStyle: TextStyle(
                                          color: AppTheme.textColor.withOpacity(
                                            0.6,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white.withOpacity(
                                          0.5,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: AppTheme.accentColor
                                                .withOpacity(0.3),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: const BorderSide(
                                            color: AppTheme.accentColor,
                                            width: 2,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: AppTheme.accentColor
                                                .withOpacity(0.3),
                                          ),
                                        ),
                                        errorText:
                                            controller
                                                .confirmPasswordError
                                                .value
                                                .isEmpty
                                            ? null
                                            : controller
                                                  .confirmPasswordError
                                                  .value,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 32),

                                  // Signup Button
                                  Obx(
                                    () => SizedBox(
                                      width: 200,
                                      child: ElevatedButton(
                                        onPressed: controller.isLoading.value
                                            ? null
                                            : controller.register,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppTheme.primaryColor,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          elevation: 4,
                                        ),
                                        child: controller.isLoading.value
                                            ? const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                          color: Colors.white,
                                                          strokeWidth: 2,
                                                        ),
                                                  ),
                                                  SizedBox(width: 12),
                                                  Text(
                                                    'Creating...',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Text(
                                                'Sign Up',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 24),

                                  // Divider
                                  Container(
                                    height: 1,
                                    color: AppTheme.accentColor.withOpacity(
                                      0.2,
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),

                                  // Login Link
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Already have an account? ',
                                        style: TextStyle(
                                          color: AppTheme.textColor.withOpacity(
                                            0.7,
                                          ),
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () => Get.toNamed('/login'),
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: Size.zero,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: const Text(
                                          'Enter the Temple',
                                          style: TextStyle(
                                            color: AppTheme.accentColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

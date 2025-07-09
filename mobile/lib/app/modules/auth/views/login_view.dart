import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../core/theme/app_theme.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
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
                        // Background hieroglyphs

                        // Main content card
                        Container(
                          margin: const EdgeInsets.only(top: 60),
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
                                // Egyptian decorative divider
                                const SizedBox(height: 170),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '𓈖',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppTheme.accentColor,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      '𓇳',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppTheme.accentColor,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      '𓊨',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppTheme.accentColor,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 32),

                                // Login Form
                                Column(
                                  children: [
                                    // Email Field
                                    Obx(
                                      () => TextField(
                                        onChanged: (value) =>
                                            controller.email.value = value,
                                        keyboardType:
                                            TextInputType.emailAddress,
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
                                            color: AppTheme.textColor
                                                .withOpacity(0.6),
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
                                                  .emailError
                                                  .value
                                                  .isEmpty
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
                                            controller.password.value = value,
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
                                          hintText: 'Enter your password',
                                          hintStyle: TextStyle(
                                            color: AppTheme.textColor
                                                .withOpacity(0.6),
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

                                    const SizedBox(height: 32),

                                    // Login Button
                                    Obx(
                                      () => SizedBox(
                                        width: 150,
                                        child: ElevatedButton(
                                          onPressed: controller.isLoading.value
                                              ? null
                                              : controller.login,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppTheme.primaryColor,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
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
                                                      'Entering...',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Login',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      ),
                                    ),

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

                                    // Sign Up Link
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'New to the realm? ',
                                          style: TextStyle(
                                            color: AppTheme.textColor
                                                .withOpacity(0.7),
                                            fontSize: 14,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Get.toNamed('/signup'),
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            minimumSize: Size.zero,
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                          ),
                                          child: const Text(
                                            'Begin Your Journey',
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

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

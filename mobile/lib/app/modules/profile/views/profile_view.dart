import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../core/theme/app_theme.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/wallpaper.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with back button and logo
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                color: AppTheme.primaryColor,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'HIEROVISION',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/images/pyramids_eye.png',
                      height: 32,
                      width: 32,
                    ),
                  ],
                ),
              ),

              // Profile Section
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryColor,
                      ),
                    );
                  }
                  
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        
                        // Error message if any
                        if (controller.errorMessage.value.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline, color: Colors.red),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      controller.errorMessage.value,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.refresh, color: Colors.red),
                                    onPressed: () => controller.loadUserData(),
                                    tooltip: 'Try again',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        
                        // Profile Image
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white.withOpacity(0.9),
                          child: CircleAvatar(
                            radius: 57,
                            backgroundColor: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // User Name
                        Obx(() => Text(
                          controller.userName.value,
                          style: TextStyle(
                            fontSize: 28,
                            color: AppTheme.secondaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                        const SizedBox(height: 5),

                        // User Email
                        Obx(() => Text(
                          controller.userEmail.value,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.primaryColor,
                          ),
                        )),
                        const SizedBox(height: 24),

                        // Settings Container
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 8, bottom: 16),
                                child: Text(
                                  'Profile Settings',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),

                              // Full Name
                              Obx(() => _buildSettingItem(
                                icon: Icons.edit,
                                title: 'Full Name',
                                value: controller.userName.value,
                                onTap: () => _showEditDialog(
                                  context,
                                  'Edit Name',
                                  controller.userName.value,
                                  (value) => controller.updateUserName(value),
                                ),
                              )),

                              // Phone Number
                              Obx(() => _buildSettingItem(
                                icon: Icons.phone,
                                title: 'Phone Number',
                                value: controller.phoneNumber.value,
                                valueColor: Colors.blue,
                                onTap: () => _showEditDialog(
                                  context,
                                  'Edit Phone Number',
                                  controller.phoneNumber.value == 'Add Number'
                                      ? ''
                                      : controller.phoneNumber.value,
                                  (value) =>
                                      controller.updatePhoneNumber(value),
                                ),
                              )),

                              // Email
                              Obx(() => _buildSettingItem(
                                icon: Icons.email,
                                title: 'Email',
                                value: controller.userEmail.value,
                                valueColor: Colors.blue,
                                onTap: () => _showEditDialog(
                                  context,
                                  'Edit Email',
                                  controller.userEmail.value,
                                  (value) => controller.updateUserEmail(value),
                                ),
                              )),

                              // Language
                              _buildSettingItem(
                                icon: Icons.language,
                                title: 'Language',
                                value: 'English (eng)',
                                valueColor: Colors.blue,
                                onTap: () {},
                              ),

                              // Currency
                              _buildSettingItem(
                                icon: Icons.attach_money,
                                title: 'Currency',
                                value: 'US Dollar (\$)',
                                valueColor: Colors.blue,
                                onTap: () {},
                              ),

                              // Logout
                              _buildSettingItem(
                                icon: Icons.logout,
                                title: 'Log out of account',
                                value: 'Log Out?',
                                valueColor: Colors.blue,
                                onTap: () {
                                  Get.dialog(
                                    AlertDialog(
                                      title: const Text('Logout'),
                                      content: const Text(
                                        'Are you sure you want to logout?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Get.back(),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Get.back();
                                            controller.logout();
                                          },
                                          child: const Text('Logout'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.grey[700]),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: valueColor ?? Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    String title,
    String initialValue,
    Function(String) onSave,
  ) {
    final TextEditingController textController = TextEditingController(
      text: initialValue,
    );

    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              onSave(textController.text.trim());
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

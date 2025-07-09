import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../core/theme/app_theme.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgorund image
      appBar: AppBar(
        title: const Text('HieroVision'),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        // add icnons to the app bar
        actions: [
          IconButton(
            // make it image
            // pyramids_eye_color
            icon: const Image(
              image: AssetImage('assets/images/pyramids_eye.png'),
              width: 50,
              height: 50,
            ),

            // icon:
            onPressed: () => Get.toNamed('/profile'),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/images/wallpaper.jpeg'),
            fit: BoxFit.cover,
          ),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.backgroundColor, AppTheme.backgroundSecondary],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Hero Section
                _buildHeroSection(),
                const SizedBox(height: 24),

                // Main Action Buttons
                _buildActionButtons(),
                const SizedBox(height: 24),

                // Quick Access Section
                _buildQuickAccessSection(),
                const SizedBox(height: 24),

                // Decorative Egyptian elements
                _buildEgyptianElements(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Column(
      children: [
        // image
        const Image(
          image: AssetImage('assets/images/eye_tree.png'),

          width: double.infinity,
          height: 200,
        ),

        const SizedBox(height: 16),
        const Text(
          'Unlock the Mysteries of Ancient Egypt',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w500,
            color: AppTheme.textColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.8,
      children: [
        _buildActionCard(
          image: 'assets/images/scan.png',
          onTap: () => Get.toNamed('/upload'),
        ),
        _buildActionCard(
          image: 'assets/images/explore_lanmark.png',
          onTap: () => Get.toNamed('/landmarks'),
        ),
        _buildActionCard(
          image: 'assets/images/human_ai.png',
          onTap: () => Get.toNamed('/chat'),
        ),
        _buildActionCard(
          image: 'assets/images/kids_mode.png',
          onTap: () => Get.toNamed('/upload'),
        ),
        _buildActionCard(
          image: 'assets/images/book_ticket.png',
          onTap: () => Get.toNamed('/booking'),
        ),
        _buildActionCard(
          image: 'assets/images/support.png',
          onTap: () => Get.toNamed('/about'),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String image,

    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: Image.asset(image, width: 64, height: 64),
      ),
    );
  }

  Widget _buildQuickAccessSection() {
    // Hieroglyphic Language Converter UI
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFe7d2b3).withOpacity(0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFa08e66).withOpacity(0.2),
          width: 6,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          Image.asset('assets/images/convert.png'),

          const SizedBox(height: 16),
          // Input label
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Enter English text to translate',
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 3, 88, 158),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 6),
          // Input box
          TextField(
            controller: controller.textController,
            onChanged: controller.updateEnglishText,
            maxLines: 2,
            maxLength: 100,
            decoration: InputDecoration(
              hintText: 'Type your English text here...',
              filled: true,
              fillColor: Color(0xFFe7d2b3).withOpacity(0.4),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFa08e66),
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFa08e66),
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFa08e66),
                  width: 2.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Action buttons
          Obx(
            () => SizedBox(
              width: 180,

              height: 70,
              child: ElevatedButton(
                onPressed:
                    controller.englishText.value.trim().isNotEmpty &&
                        !controller.isTranslating.value
                    ? controller.translateText
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: controller.isTranslating.value
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : SizedBox.expand(
                        child: Image.asset(
                          'assets/images/translate.png',
                          fit: BoxFit.fill,
                        ),
                      ),
              ),
            ),
          ),

          const SizedBox(height: 24),
          // Translation Results
          _buildTranslationResults(),
        ],
      ),
    );
  }

  Widget _buildTranslationResults() {
    return Obx(
      () => controller.translationResult.value != null
          ? Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/translation.png',
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.fill,
                ),
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 32),
                          padding: const EdgeInsets.all(8),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                controller.translationResult.value!.hieroglyphs,
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Color(0xFFa08e66),
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Confidence: ${(controller.translationResult.value!.confidenceScore * 100).round()}%',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFa08e66),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : controller.englishText.value.trim().isNotEmpty
          ? Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/translation.png',
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.fill,
                ),
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Ready for translation',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFa08e66),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          '"${controller.englishText.value}"',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFa08e66),
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/translation.png',
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.fill,
                ),
                const Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Enter text above to see translation',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFa08e66),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEgyptianElements() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('𓈖', style: TextStyle(fontSize: 32, color: AppTheme.accentColor)),
        Text('𓇳', style: TextStyle(fontSize: 32, color: AppTheme.accentColor)),
        Text('𓊨', style: TextStyle(fontSize: 32, color: AppTheme.accentColor)),
        Text('𓋹', style: TextStyle(fontSize: 32, color: AppTheme.accentColor)),
        Text('𓌻', style: TextStyle(fontSize: 32, color: AppTheme.accentColor)),
      ],
    );
  }
}

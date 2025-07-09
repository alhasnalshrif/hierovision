import 'package:flutter/material.dart';
import 'package:mobile/app/modules/get_started/controllers/get_started_controller.dart';
import '../../../core/theme/app_theme.dart';

class GetStartedView extends StatelessWidget {
  const GetStartedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
        image: AssetImage('assets/images/wallpaper2.jpeg'),
        fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top -
            MediaQuery.of(context).padding.bottom,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Page content (single page)
            _buildOnboardingPage(),

            // Bottom navigation (single button)
            _buildBottomNavigation(context),
          ],
          ),
        ),
        ),
      ),
      ),
    );
  }

  Widget _buildOnboardingPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Egyptian hieroglyph icon
          SizedBox(height: 50),
          SizedBox(
            width: 200,

            child: const Center(
              child: Image(
                image: AssetImage('assets/images/pyramids_eye_color.png'),
              ),
            ),
          ),

          const SizedBox(height: 60),

          // Title
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: [Color(0xFF956a24), Color(0xFFcabba5)],
              ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
            },
            child: const Text(
              'STEP INTO ANCIENT EGYPT',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white, // This will be replaced by the shader
                height: 1.2,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Egyptian decorative elements
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                '𓈖',
                style: TextStyle(fontSize: 20, color: AppTheme.accentColor),
              ),
              SizedBox(width: 16),
              Text(
                '𓇳',
                style: TextStyle(fontSize: 20, color: AppTheme.accentColor),
              ),
              SizedBox(width: 16),
              Text(
                '𓊨',
                style: TextStyle(fontSize: 20, color: AppTheme.accentColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 40.0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              // Implement get started logic or navigation here
              GetStartedController controller = GetStartedController();
              controller.skipToLogin();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(0),
              elevation: 0,
            ),
            child: Image(
              image: AssetImage('assets/images/started.png'),
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'HIEROVISION',
            style: TextStyle(fontSize: 24, color: Color(0xFF603c13)),
          ),
        ],
      ),
    );
  }
}

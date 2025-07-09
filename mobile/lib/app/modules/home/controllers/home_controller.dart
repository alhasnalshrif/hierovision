import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/scan_repository.dart';

class HomeController extends GetxController {
  final ScanRepository _scanRepository = Get.find();

  final RxInt currentIndex = 0.obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;

  // Text translation properties
  final RxBool isTranslating = false.obs;
  final RxString englishText = ''.obs;
  final Rx<TranslationResult?> translationResult = Rx<TranslationResult?>(null);
  late TextEditingController textController;

  final List<String> navItems = [
    'Home',
    'Landmarks',
    'Upload',
    'Scans',
    'Profile',
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeTextController();
    // Initialize any data needed for the home screen
  }

  void _initializeTextController() {
    textController = TextEditingController();
    textController.addListener(() {
      if (textController.text != englishText.value) {
        englishText.value = textController.text;
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    // Called after the widget is rendered
  }

  @override
  void onClose() {
    try {
      textController.dispose();
    } catch (e) {
      print('Error disposing textController: $e');
    }
    super.onClose();
  }

  Future<void> translateText() async {
    if (englishText.value.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter some English text first');
      return;
    }

    isTranslating.value = true;
    try {
      final result = await _scanRepository.translateEnglishToHieroglyphs(
        englishText.value,
      );

      if (result['success']) {
        translationResult.value = TranslationResult.fromJson(result);

        Get.snackbar(
          'Success',
          'Text translated to hieroglyphs!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Save translation to history
        await _saveTranslationToHistory(result);
      } else {
        Get.snackbar(
          'Translation Failed',
          result['error'] ?? 'Failed to translate text',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Translation failed: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isTranslating.value = false;
    }
  }

  Future<void> _saveTranslationToHistory(
    Map<String, dynamic> translationData,
  ) async {
    try {
      await _scanRepository.saveTranslation({
        'description':
            'English to Hieroglyphs: "${englishText.value.length > 50 ? '${englishText.value.substring(0, 50)}...' : englishText.value}"',
        'translation': translationData['hieroglyphs'],
        'confidence': (translationData['confidence_score'] * 100).round(),
        'image_path': 'text_translation',
      });
    } catch (e) {
      print('Failed to save translation to history: $e');
    }
  }

  void updateEnglishText(String text) {
    englishText.value = text;
    // The textController listener will handle the reverse direction
  }

  void clearTranslation() {
    englishText.value = '';
    try {
      textController.clear();
    } catch (e) {
      // Controller might be disposed, recreate it
      _initializeTextController();
    }
    translationResult.value = null;
  }

  void changeNavIndex(int index) {
    currentIndex.value = index;

    // Navigate to different pages based on index
    switch (index) {
      case 0:
        break; // Stay on home
      case 1:
        Get.toNamed('/landmarks');
        break;
      case 2:
        Get.toNamed('/upload');
        break;
      case 3:
        Get.toNamed('/upload');
        break;
      case 4:
        Get.toNamed('/profile');
        break;
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    // Implement search functionality
  }

  void navigateToUpload() {
    Get.toNamed('/upload');
  }

  void navigateToLandmarks() {
    Get.toNamed('/landmarks');
  }

  void navigateToChat() {
    Get.toNamed('/chat');
  }

  void navigateToKidsMode() {
    Get.toNamed('/kids');
  }

  void navigateToAbout() {
    Get.toNamed('/about');
  }
}

// Translation result model
class TranslationResult {
  final bool success;
  final String originalText;
  final String hieroglyphs;
  final double confidenceScore;
  final String? transliteration;
  final String? error;

  TranslationResult({
    required this.success,
    required this.originalText,
    required this.hieroglyphs,
    required this.confidenceScore,
    this.transliteration,
    this.error,
  });

  factory TranslationResult.fromJson(Map<String, dynamic> json) {
    return TranslationResult(
      success: json['success'] ?? false,
      originalText: json['original_text'] ?? '',
      hieroglyphs: json['hieroglyphs'] ?? '',
      confidenceScore: (json['confidence_score'] ?? 0).toDouble(),
      transliteration: json['transliteration'],
      error: json['error'],
    );
  }
}

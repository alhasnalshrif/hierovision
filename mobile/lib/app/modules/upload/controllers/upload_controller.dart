import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/repositories/scan_repository.dart';
import '../../../data/models/scan.dart';
import '../../auth/controllers/auth_controller.dart';

class UploadController extends GetxController {
  final ScanRepository _scanRepository = Get.find();
  final ImagePicker _picker = ImagePicker();
  final AuthController _authController = Get.find();

  final RxBool isLoading = false.obs;
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxList<Scan> recentScans = <Scan>[].obs;

  // History functionality
  final RxBool isHistoryLoading = false.obs;
  final RxList<Scan> historyItems = <Scan>[].obs;
  final RxString searchQuery = ''.obs;
  final RxList<Scan> filteredItems = <Scan>[].obs;
  final RxMap<String, dynamic> stats = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadRecentScans();
    // Load history when tab becomes active if user is logged in
    ever(_authController.isLoggedIn, (bool isLoggedIn) {
      if (isLoggedIn) {
        loadHistory();
      } else {
        historyItems.clear();
        filteredItems.clear();
        stats.clear();
      }
    });

    if (_authController.isLoggedIn.value) {
      loadHistory();
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> loadRecentScans() async {
    try {
      final scans = await _scanRepository.getRecentScans(limit: 5);
      recentScans.value = scans; // Already limited to 5 from backend
    } catch (e) {
      print('Error loading recent scans: $e');
    }
  }

  Future<void> selectImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
        Get.snackbar('Success', 'Image selected successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to select image');
    }
  }

  Future<void> selectImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
        Get.snackbar('Success', 'Image captured successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to capture image');
    }
  }

  Future<void> uploadImage() async {
    if (selectedImage.value == null) {
      Get.snackbar('Error', 'Please select an image first');
      return;
    }

    isLoading.value = true;
    try {
      final result = await _scanRepository.uploadImage(selectedImage.value!);

      if (result['success']) {
        // Save the scan result to history if user is logged in (before clearing image)
        if (_authController.isLoggedIn.value) {
          await _saveScanToHistory(result['results']);
        }

        // Navigate to result page with scan data
        Get.toNamed(
          '/result',
          arguments: {
            'results':
                result['results'] ?? result, // Use results or the whole result
            'type': 'image_scan',
          },
        );

        // Clear the selected image after successful upload and saving
        selectedImage.value = null;

        Get.snackbar(
          'Success',
          _authController.isLoggedIn.value
              ? 'Image processed and saved to history!'
              : 'Image processed successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Reload recent scans and history to include the new one
        loadRecentScans();
        if (_authController.isLoggedIn.value) {
          loadHistory();
        }
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? 'Failed to process image',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload image: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearSelectedImage() {
    selectedImage.value = null;
  }

  // Method to save scan results to history
  Future<void> _saveScanToHistory(Map<String, dynamic> scanResults) async {
    try {
      // Debug: Print the raw scan results to see structure
      print('Raw scan results: $scanResults');

      // If we have the original image file, save it with the scan
      if (selectedImage.value != null) {
        // Save scan with image file
        final result = await _scanRepository.saveScanWithImage(
          selectedImage.value!,
          _extractResultText(scanResults),
          _generateDescription(scanResults),
          _parseConfidence(scanResults),
        );

        if (result['success']) {
          print('Scan with image saved to history successfully');
        } else {
          print(
            'Failed to save scan with image to history: ${result['message']}',
          );
        }
      } else {
        // Fallback: Save translation data only (without image)
        final translationData = {
          'result_text': _extractResultText(scanResults),
          'confidence_score': _parseConfidence(scanResults),
          'description': _generateDescription(scanResults),
          'type': 'hieroglyph',
          'detected_objects': _extractDetectedObjects(scanResults),
          'location': 'Ancient Egypt', // Default location
          'timestamp': DateTime.now().toIso8601String(),
        };

        print('Translation data being saved: $translationData'); // Debug log

        final result = await _scanRepository.saveTranslation(translationData);

        if (result['success']) {
          print('Scan saved to history successfully');
        } else {
          print('Failed to save scan to history: ${result['message']}');
        }
      }
    } catch (e) {
      print('Error saving scan to history: $e');
    }
  }

  // Helper method to parse confidence score
  double _parseConfidence(Map<String, dynamic> scanResults) {
    final confidence =
        scanResults['confidence'] ??
        scanResults['confidence_score'] ??
        scanResults['score'] ??
        0.0;

    if (confidence is String) {
      return double.tryParse(confidence) ?? 0.0;
    } else if (confidence is num) {
      return confidence.toDouble();
    }
    return 0.0;
  }

  // Helper method to extract detected objects
  List<String> _extractDetectedObjects(Map<String, dynamic> scanResults) {
    final detectedObjects =
        scanResults['detected_objects'] ?? scanResults['predictions'] ?? [];

    if (detectedObjects is List) {
      return detectedObjects.map((e) => e.toString()).toList();
    }

    // If it's a single prediction, create a list
    final prediction =
        scanResults['prediction'] ??
        scanResults['class_name'] ??
        scanResults['detected_class'];

    return prediction != null ? [prediction.toString()] : [];
  }

  // Helper method to generate description based on scan results
  String _generateDescription(Map<String, dynamic> scanResults) {
    final confidence = _parseConfidence(scanResults);

    // Try the new format from Model.py backend
    final description = scanResults['description'];
    if (description != null && description is Map<String, dynamic>) {
      final code = description['code'];
      final desc = description['description'];
      if (code != null) {
        if (desc != null) {
          return 'Gardner code $code: $desc';
        } else {
          return 'Gardner code $code';
        }
      }
    }

    // Fallback to old format
    final prediction =
        scanResults['prediction'] ??
        scanResults['class_name'] ??
        scanResults['detected_class'] ??
        'Unknown';

    return 'Hieroglyph scan: $prediction (${(confidence * 100).round()}% confidence)';
  }

  // Helper method to extract result text from scan results
  String _extractResultText(Map<String, dynamic> scanResults) {
    // First try the old format keys for backwards compatibility
    String? resultText =
        scanResults['prediction'] ??
        scanResults['class_name'] ??
        scanResults['detected_class'];

    if (resultText != null) {
      return resultText;
    }

    // Try the new format from Model.py backend
    final description = scanResults['description'];
    if (description != null) {
      if (description is Map<String, dynamic>) {
        // Extract the Gardner code from the description object
        final code = description['code'];
        if (code != null) {
          return 'Hieroglyph $code';
        }
      } else if (description is String) {
        return description;
      }
    }

    // If we have a predicted_class_index, use that
    final classIndex = scanResults['predicted_class_index'];
    if (classIndex != null) {
      return 'Hieroglyph Class $classIndex';
    }

    return 'Unknown Hieroglyph';
  }

  // History functionality methods
  Future<void> loadHistory() async {
    try {
      isHistoryLoading.value = true;
      final scans = await _scanRepository.getUserScans();
      historyItems.value = scans;
      filteredItems.value = scans;
      _calculateStats();
    } catch (error) {
      print('Load history error: $error');
      Get.snackbar(
        'Error',
        'Failed to load history: ${error.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isHistoryLoading.value = false;
    }
  }

  void searchHistory(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredItems.value = historyItems;
    } else {
      filteredItems.value = historyItems.where((scan) {
        final searchLower = query.toLowerCase();
        return (scan.resultText?.toLowerCase().contains(searchLower) ??
                false) ||
            (scan.detectedObjects?.any(
                  (obj) => obj.toLowerCase().contains(searchLower),
                ) ??
                false);
      }).toList();
    }
  }

  Future<void> deleteScan(int scanId) async {
    try {
      await _scanRepository.deleteScan(scanId);
      historyItems.removeWhere((scan) => scan.id == scanId);
      filteredItems.removeWhere((scan) => scan.id == scanId);
      recentScans.removeWhere((scan) => scan.id == scanId);
      _calculateStats();
      Get.snackbar(
        'Success',
        'Scan deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      Get.snackbar(
        'Error',
        'Failed to delete scan: ${error.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _calculateStats() {
    if (historyItems.isEmpty) {
      stats.value = {
        'totalScans': 0,
        'averageConfidence': 0.0,
        'mostCommonObject': 'None',
      };
      return;
    }

    final totalScans = historyItems.length;
    final totalConfidence = historyItems
        .where((scan) => scan.confidence != null)
        .fold(0.0, (sum, scan) => sum + (scan.confidence ?? 0.0));
    final scansWithConfidence = historyItems
        .where((scan) => scan.confidence != null)
        .length;

    final averageConfidence = scansWithConfidence > 0
        ? totalConfidence / scansWithConfidence
        : 0.0;

    // Find most common object
    final objectCounts = <String, int>{};
    for (final scan in historyItems) {
      if (scan.detectedObjects != null) {
        for (final obj in scan.detectedObjects!) {
          objectCounts[obj] = (objectCounts[obj] ?? 0) + 1;
        }
      }
    }

    String mostCommonObject = 'None';
    int maxCount = 0;
    objectCounts.forEach((obj, count) {
      if (count > maxCount) {
        maxCount = count;
        mostCommonObject = obj;
      }
    });

    stats.value = {
      'totalScans': totalScans,
      'averageConfidence': averageConfidence,
      'mostCommonObject': mostCommonObject,
    };
  }

  void refreshHistory() {
    loadHistory();
  }

  // Helper methods from HistoryController
  int getConfidencePercentage(double? confidence) {
    if (confidence == null) return 0;
    return (confidence * 100).round();
  }

  String formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown date';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  String getIconForType(String? type) {
    switch (type?.toLowerCase()) {
      case 'hieroglyph':
      case 'hieroglyphics':
        return '𓈖';
      case 'artifact':
        return '🏺';
      case 'statue':
        return '🗿';
      case 'papyrus':
        return '📜';
      case 'tomb':
        return '⚱️';
      case 'temple':
        return '🏛️';
      default:
        return '📜';
    }
  }

  void showImageSourceDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Get.back();
                selectImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                selectImageFromCamera();
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:get/get.dart';
import '../../../data/models/scan.dart';
import '../../../data/repositories/scan_repository.dart';

class ResultController extends GetxController {
  final ScanRepository _scanRepository = Get.find();

  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool isRefreshing = false.obs;

  // Result data
  final Rx<Scan?> scanResult = Rx<Scan?>(null);
  final RxMap<String, dynamic> results = <String, dynamic>{}.obs;
  final RxString resultType = ''.obs; // 'image_scan' or 'text_translation'
  final RxString scanId = ''.obs; // For fetching specific scan data

  // Translation specific data
  final RxString originalText = ''.obs;
  final RxString hieroglyphs = ''.obs;
  final RxString transliteration = ''.obs;
  final RxDouble confidence = 0.0.obs;

  // Image scan specific data
  final RxString predictedClass = ''.obs;
  final RxString description = ''.obs;
  final RxString imageUrl = ''.obs;
  final RxList<String> detectedObjects = <String>[].obs;

  // Additional API data
  final RxList<Map<String, dynamic>> relatedResults =
      <Map<String, dynamic>>[].obs;
  final RxMap<String, dynamic> classInfo = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadResultData();
  }

  void _loadResultData() {
    final arguments = Get.arguments as Map<String, dynamic>?;

    if (arguments != null) {
      resultType.value = arguments['type'] ?? '';

      // Load scan data if available
      if (arguments['scan'] != null) {
        if (arguments['scan'] is Scan) {
          scanResult.value = arguments['scan'];
        } else if (arguments['scan'] is Map<String, dynamic>) {
          scanResult.value = Scan.fromJson(arguments['scan']);
        }
      }

      // Load results data
      if (arguments['results'] != null) {
        results.value = Map<String, dynamic>.from(arguments['results']);

        // Parse based on result type
        if (resultType.value == 'text_translation') {
          _parseTranslationResults();
        } else if (resultType.value == 'image_scan') {
          _parseImageScanResults();
        }
      }
    }
  }

  void _parseTranslationResults() {
    originalText.value = results['original_text'] ?? '';
    hieroglyphs.value = results['hieroglyphs'] ?? '';
    transliteration.value = results['transliteration'] ?? '';
    confidence.value = (results['confidence_score'] ?? 0.0).toDouble();
  }

  void _parseImageScanResults() {
    // Debug: Print the raw results to see structure
    print('Raw image scan results: $results');

    // Handle predicted_class which might be an integer or string
    final predictedClassValue =
        results['predicted_class_index'] ?? results['predicted_class'];
    if (predictedClassValue != null) {
      predictedClass.value = predictedClassValue.toString();
      print('Predicted class: ${predictedClass.value}'); // Debug log
    }

    // Handle description which might be a map or string
    final descriptionValue = results['description'];
    if (descriptionValue != null) {
      if (descriptionValue is Map<String, dynamic>) {
        // If description is a map with Gardner code format
        final code = descriptionValue['code'];
        final desc = descriptionValue['description'];

        if (code != null && desc != null) {
          description.value = 'Gardner $code: $desc';
        } else if (code != null) {
          description.value = 'Gardner code $code';
        } else {
          // Fallback to any available text
          description.value =
              descriptionValue['description'] ??
              descriptionValue['text'] ??
              descriptionValue.toString();
        }
      } else {
        description.value = descriptionValue.toString();
      }
      print('Description: ${description.value}'); // Debug log
    }

    confidence.value = (results['confidence_score'] ?? 0.0).toDouble();
    print('Confidence: ${confidence.value}'); // Debug log

    // Handle image URL - might come from scan result or need to be constructed
    if (scanResult.value != null) {
      imageUrl.value = scanResult.value!.properImageUrl ?? '';
      if (scanResult.value!.detectedObjects != null) {
        detectedObjects.value = scanResult.value!.detectedObjects!;
      }
    } else {
      // If no scan result, try to get image path from results and construct proper URL
      final rawImageUrl = results['image_url'] ?? results['image_path'] ?? '';
      imageUrl.value = _constructProperImageUrl(rawImageUrl);
    }

    // Fetch additional data from API if we have a predicted class
    if (predictedClass.value.isNotEmpty) {
      _fetchClassInfo();
    }
  }

  // Helper method to construct proper image URLs
  String _constructProperImageUrl(String rawUrl) {
    if (rawUrl.isEmpty) return '';

    print('Constructing URL from: $rawUrl'); // Debug log

    // If it's already a full URL, return as is
    if (rawUrl.startsWith('http://') || rawUrl.startsWith('https://')) {
      print('Already full URL, returning: $rawUrl'); // Debug log
      return rawUrl;
    }

    // If it's a file:// URI or local path, construct a proper URL
    const String baseUrl = 'http://10.0.2.2:5000';

    // Remove file:// prefix if present (handle both file:// and file:///)
    String cleanPath = rawUrl;
    if (cleanPath.startsWith('file:///')) {
      cleanPath = cleanPath.substring(8);
    } else if (cleanPath.startsWith('file://')) {
      cleanPath = cleanPath.substring(7);
    }

    // Remove leading slash if present since we'll add it
    if (cleanPath.startsWith('/')) {
      cleanPath = cleanPath.substring(1);
    }

    // If the path doesn't start with 'uploads' or 'static', add it
    if (!cleanPath.startsWith('uploads/') && !cleanPath.startsWith('static/')) {
      cleanPath = 'uploads/scans/$cleanPath';
    }

    final finalUrl = '$baseUrl/$cleanPath';
    print('Final constructed URL: $finalUrl'); // Debug log
    return finalUrl;
  }

  // Fetch additional information about the detected class from API
  Future<void> _fetchClassInfo() async {
    if (predictedClass.value.isEmpty) return;

    try {
      isRefreshing.value = true;

      // Try to parse as integer first, then use as string
      int? classIndex;
      try {
        classIndex = int.parse(predictedClass.value);
      } catch (e) {
        // Use predictedClass.value as string
      }

      if (classIndex != null) {
        final response = await _scanRepository.getClassInfo(classIndex);
        if (response['success']) {
          classInfo.value = response['data'] ?? {};
          // Update description with more detailed information
          if (classInfo['description'] != null) {
            description.value = classInfo['description'];
          }
        }
      }
    } catch (e) {
      print('Error fetching class info: $e');
    } finally {
      isRefreshing.value = false;
    }
  }

  // Fetch scan data by ID from API
  Future<void> fetchScanById(int scanId) async {
    try {
      isLoading.value = true;

      final scan = await _scanRepository.getScanById(scanId);
      scanResult.value = scan;

      // Update UI with scan data
      imageUrl.value = scan.properImageUrl ?? '';
      description.value =
          scan.resultText ?? ''; // Use resultText instead of description
      confidence.value = scan.confidence ?? 0.0;

      if (scan.detectedObjects != null) {
        detectedObjects.value = scan.detectedObjects!;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load scan data: ${e.toString()}',
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh current data from API
  Future<void> refreshData() async {
    if (scanResult.value?.id != null) {
      await fetchScanById(scanResult.value!.id!);
    } else if (predictedClass.value.isNotEmpty) {
      await _fetchClassInfo();
    }
  }

  // Fetch related/similar results from API
  Future<void> fetchRelatedResults() async {
    if (predictedClass.value.isEmpty) return;

    try {
      isRefreshing.value = true;

      // This would fetch similar hieroglyphs or related results
      final response = await _scanRepository.searchScans(predictedClass.value);
      if (response['success']) {
        relatedResults.value = List<Map<String, dynamic>>.from(
          response['results'] ?? [],
        );
      }
    } catch (e) {
      print('Error fetching related results: $e');
    } finally {
      isRefreshing.value = false;
    }
  }

  void shareResult() {
    // TODO: Implement sharing functionality
    Get.snackbar(
      'Share',
      'Sharing functionality will be implemented soon',
      duration: const Duration(seconds: 2),
    );
  }

  void saveToFavorites() {
    // TODO: Implement save to favorites
    Get.snackbar(
      'Saved',
      'Result saved to favorites',
      duration: const Duration(seconds: 2),
    );
  }

  void goBack() {
    Get.back();
  }

  void newScan() {
    Get.offAllNamed('/upload');
  }
}

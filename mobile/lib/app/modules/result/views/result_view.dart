import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/result_controller.dart';
import '../../../core/theme/app_theme.dart';

class ResultView extends GetView<ResultController> {
  const ResultView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.resultType.value == 'text_translation'
                ? 'Translation Result'
                : 'Scan Result',
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/wallpaper.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.primaryColor,
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.refreshData,
            color: AppTheme.primaryColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Result Header
                    _buildResultHeader(),

                    const SizedBox(height: 24),

                    // Main Result Content
                    if (controller.resultType.value == 'text_translation')
                      _buildTranslationResult()
                    else
                      _buildImageScanResult(),

                    const SizedBox(height: 24),

                    // Additional Information Section
                    _buildAdditionalInfo(),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildResultHeader() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.accentColor.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(
              controller.resultType.value == 'text_translation' ? '📜' : '🔍',
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 12),
            Text(
              controller.resultType.value == 'text_translation'
                  ? 'Translation Complete!'
                  : 'Scan Analysis Complete!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              controller.resultType.value == 'text_translation'
                  ? 'Your English text has been translated to hieroglyphs'
                  : 'Your hieroglyph image has been analyzed',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textColor.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTranslationResult() {
    return Obx(
      () => Column(
        children: [
          // Original Text
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentColor.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.text_fields, color: AppTheme.accentColor),
                    SizedBox(width: 8),
                    Text(
                      'Original English Text',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '"${controller.originalText.value}"',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.textColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Hieroglyphic Translation
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.accentColor.withOpacity(0.4),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('𓂀', style: TextStyle(fontSize: 24)),
                    SizedBox(width: 8),
                    Text(
                      'Hieroglyphic Translation',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    controller.hieroglyphs.value,
                    style: const TextStyle(
                      fontSize: 36,
                      color: AppTheme.textColor,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (controller.transliteration.value.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Transliteration: ${controller.transliteration.value}',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textColor.withOpacity(0.7),
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Confidence Score
          _buildConfidenceScore(),
        ],
      ),
    );
  }

  Widget _buildImageScanResult() {
    return Obx(
      () => Column(
        children: [
          // Scanned Image
          if (controller.imageUrl.value.isNotEmpty)
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.accentColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Builder(
                  builder: (context) {
                    print(
                      'Displaying image with URL: ${controller.imageUrl.value}',
                    ); // Debug log
                    return Image.network(
                      controller.imageUrl.value,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        print('Image failed to load: $error'); // Debug log
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 8),
                                Text('Image not available'),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),

          const SizedBox(height: 20),

          // Analysis Results
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentColor.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.analytics, color: AppTheme.accentColor),
                    SizedBox(width: 8),
                    Text(
                      'Analysis Results',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                if (controller.predictedClass.value.isNotEmpty) ...[
                  _buildResultItem(
                    'Detected Class',
                    controller.predictedClass.value,
                  ),
                  const SizedBox(height: 12),
                ],

                if (controller.description.value.isNotEmpty) ...[
                  _buildResultItem('Description', controller.description.value),
                  const SizedBox(height: 12),
                ],

                if (controller.detectedObjects.isNotEmpty) ...[
                  const Text(
                    'Detected Objects:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: controller.detectedObjects
                        .map(
                          (object) => Chip(
                            label: Text(object),
                            backgroundColor: AppTheme.accentColor.withOpacity(
                              0.2,
                            ),
                            labelStyle: const TextStyle(
                              color: AppTheme.textColor,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Confidence Score
          _buildConfidenceScore(),
        ],
      ),
    );
  }

  Widget _buildResultItem(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textColor.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: AppTheme.textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildConfidenceScore() {
    return Obx(
      () => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.accentColor.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.psychology, color: AppTheme.accentColor),
                SizedBox(width: 8),
                Text(
                  'AI Confidence',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: controller.confidence.value,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      controller.confidence.value > 0.7
                          ? Colors.green
                          : controller.confidence.value > 0.4
                          ? Colors.orange
                          : Colors.red,
                    ),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${(controller.confidence.value * 100).round()}%',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              controller.confidence.value > 0.7
                  ? 'High confidence - Very reliable result'
                  : controller.confidence.value > 0.4
                  ? 'Medium confidence - Good result'
                  : 'Low confidence - Result may be uncertain',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textColor.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Obx(() {
      if (controller.classInfo.isEmpty && !controller.isRefreshing.value) {
        return const SizedBox.shrink();
      }

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.accentColor.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info_outline, color: AppTheme.accentColor),
                const SizedBox(width: 8),
                const Text(
                  'Additional Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
                const Spacer(),
                if (controller.isRefreshing.value)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            if (controller.classInfo.isNotEmpty) ...[
              if (controller.classInfo['code'] != null)
                _buildInfoItem('Code', controller.classInfo['code']),
              if (controller.classInfo['meaning'] != null)
                _buildInfoItem('Meaning', controller.classInfo['meaning']),
              if (controller.classInfo['historical_context'] != null)
                _buildInfoItem(
                  'Historical Context',
                  controller.classInfo['historical_context'],
                ),
              if (controller.classInfo['usage'] != null)
                _buildInfoItem('Usage', controller.classInfo['usage']),
            ] else if (!controller.isRefreshing.value) ...[
              const Text(
                'No additional information available',
                style: TextStyle(
                  color: AppTheme.textColor,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildInfoItem(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textColor.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.toString(),
            style: const TextStyle(fontSize: 14, color: AppTheme.textColor),
          ),
        ],
      ),
    );
  }
}

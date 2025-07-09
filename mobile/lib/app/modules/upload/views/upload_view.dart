import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/upload_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/scan.dart';
import '../../auth/controllers/auth_controller.dart';

class UploadView extends GetView<UploadController> {
  const UploadView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hieroglyphs'),
          backgroundColor: AppTheme.primaryColor,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.camera_alt), text: 'Scan'),
              Tab(icon: Icon(Icons.history), text: 'History'),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/wallpaper.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: TabBarView(children: [_UploadTab(), _HistoryTab()]),
        ),
      ),
    );
  }
}

class _UploadTab extends GetView<UploadController> {
  const _UploadTab();

  @override
  Widget build(BuildContext context) {
    return _buildImageScanTab();
  }

  Widget _buildImageScanTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            // Title Section
            const Column(
              children: [
                Text('📜', style: TextStyle(fontSize: 64)),
                SizedBox(height: 16),
                Text(
                  'Scan Hieroglyph Image',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Take a photo or select from gallery to decode ancient Egyptian hieroglyphs',
                  style: TextStyle(fontSize: 16, color: AppTheme.textColor),
                  textAlign: TextAlign.center,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Image Display Section
            Obx(
              () => controller.selectedImage.value != null
                  ? _buildImagePreview()
                  : _buildImagePlaceholder(),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            _buildImageActionButtons(),

            const SizedBox(height: 32),

            // Recent Scans Section
            _buildRecentScansSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Image.file(
              controller.selectedImage.value!,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                onPressed: controller.clearSelectedImage,
                icon: const Icon(Icons.close),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return GestureDetector(
      onTap: controller.showImageSourceDialog,
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.accentColor.withOpacity(0.3),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate,
              size: 64,
              color: AppTheme.accentColor,
            ),
            SizedBox(height: 16),
            Text(
              'Tap to select image',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Choose from gallery or take a photo',
              style: TextStyle(fontSize: 14, color: AppTheme.textColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageActionButtons() {
    return Column(
      children: [
        const SizedBox(height: 16),

        // Upload Button
        Obx(
          () => ElevatedButton.icon(
            onPressed:
                controller.selectedImage.value != null &&
                    !controller.isLoading.value
                ? controller.uploadImage
                : null,
            icon: controller.isLoading.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.cloud_upload),
            label: Text(
              controller.isLoading.value
                  ? 'Processing...'
                  : 'Decode Hieroglyph',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentScansSection() {
    return Obx(
      () => controller.recentScans.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent Scans',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.recentScans.length,
                    itemBuilder: (context, index) {
                      final scan = controller.recentScans[index];
                      return Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.accentColor.withOpacity(0.2),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: scan.properImageUrl != null
                              ? Image.network(
                                  scan.properImageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.image,
                                      size: 40,
                                      color: AppTheme.accentColor,
                                    );
                                  },
                                )
                              : const Icon(
                                  Icons.image,
                                  size: 40,
                                  color: AppTheme.accentColor,
                                ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }
}

class _HistoryTab extends GetView<UploadController> {
  const _HistoryTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    return Obx(() {
      if (!authController.isLoggedIn.value) {
        return _buildLoginRequiredView();
      }

      if (controller.isHistoryLoading.value) {
        return _buildLoadingView();
      }

      return RefreshIndicator(
        onRefresh: controller.loadHistory,
        child: controller.historyItems.isEmpty
            ? _buildEmptyView()
            : _buildHistoryView(),
      );
    });
  }

  Widget _buildLoginRequiredView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppTheme.cardColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.secondaryColor.withOpacity(0.2),
                ),
              ),
              child: const Column(
                children: [
                  Text('🔒', style: TextStyle(fontSize: 64)),
                  SizedBox(height: 24),
                  Text(
                    'Login Required',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Please login to view your translation history.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textColor,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Get.toNamed('/login'),
              icon: const Icon(Icons.login),
              label: const Text('Login Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppTheme.primaryColor),
          SizedBox(height: 16),
          Text(
            'Loading History...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppTheme.cardColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.secondaryColor.withOpacity(0.2),
                ),
              ),
              child: const Column(
                children: [
                  Text('📜', style: TextStyle(fontSize: 64)),
                  SizedBox(height: 24),
                  Text(
                    'No Translations Yet',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Start your journey into ancient Egyptian wisdom by uploading your first hieroglyph image.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textColor,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // Switch to upload tab
                DefaultTabController.of(Get.context!).animateTo(0);
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Upload First Image'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryView() {
    return Column(
      children: [
        SizedBox(height: 16),
        _buildStatsCards(),
        Expanded(child: _buildHistoryList()),
      ],
    );
  }

  Widget _buildStatsCards() {
    return Obx(() {
      if (controller.historyItems.isEmpty) return const SizedBox.shrink();

      final stats = controller.stats;
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: _buildStatCard(
                '📊',
                stats['totalScans']?.toString() ?? '0',
                'Total Translations',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildStatCard(
                '🎯',
                '${(stats['averageConfidence'] ?? 0.0).round()}%',
                'Average Accuracy',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildStatCard(
                '🏛️',
                stats['mostCommonObject'] ?? 'None',
                'Most Common',
                isSmallText: true,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatCard(
    String emoji,
    String value,
    String label, {
    bool isSmallText = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.secondaryColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: isSmallText ? 12 : 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: AppTheme.textColor.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return Obx(() {
      final items = controller.filteredItems;
      return Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final scan = items[index];
            return _buildScanCard(scan);
          },
        ),
      );
    });
  }

  Widget _buildScanCard(Scan scan) {
    final confidence = controller.getConfidencePercentage(
      scan.actualConfidence,
    );
    final formattedDate = controller.formatDate(scan.actualTimestamp);
    final icon = controller.getIconForType(scan.type);

    return GestureDetector(
      onTap: () => _showScanDetails(scan),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.secondaryColor.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and date
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(icon, style: const TextStyle(fontSize: 24)),
                  Expanded(
                    child: Text(
                      formattedDate,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppTheme.textColor,
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),

            // Hieroglyph preview
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              height: 60,
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.secondaryColor.withOpacity(0.2),
                ),
              ),
              child: Center(
                child: Text(
                  scan.resultText?.isNotEmpty == true
                      ? scan.resultText!.length > 10
                            ? '${scan.resultText!.substring(0, 10)}...'
                            : scan.resultText!
                      : '𓊪 𓏏 𓇯',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // Description
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scan.description ?? 'Hieroglyph Translation',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '📍 ${scan.location ?? 'Ancient Egypt'}',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppTheme.textColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Confidence indicator
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Confidence',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.textColor,
                        ),
                      ),
                      Text(
                        '$confidence%',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: confidence / 100,
                    backgroundColor: AppTheme.textColor.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppTheme.secondaryColor,
                    ),
                  ),
                ],
              ),
            ),

            // Action buttons
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showScanDetails(scan),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('View', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _showDeleteConfirmation(scan),
                    icon: const Icon(Icons.delete, size: 16),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.1),
                      foregroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showScanDetails(Scan scan) {
    final confidence = controller.getConfidencePercentage(
      scan.actualConfidence,
    );
    final formattedDate = controller.formatDate(scan.actualTimestamp);

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppTheme.backgroundColor, AppTheme.backgroundSecondary],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.secondaryColor.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Translation Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.textColor.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.secondaryColor.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      controller.getIconForType(scan.type),
                      style: const TextStyle(fontSize: 48),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      scan.resultText ?? '𓊪 𓏏 𓇯',
                      style: const TextStyle(
                        fontSize: 24,
                        color: AppTheme.textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${scan.location ?? 'Ancient Egypt'} • $formattedDate',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textColor.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Confidence: $confidence%',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '"${scan.description ?? 'Ancient hieroglyphic translation'}"',
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: AppTheme.textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Get.back();
                  Get.snackbar(
                    'Feature Coming Soon',
                    'Share functionality will be available soon!',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                icon: const Icon(Icons.share),
                label: const Text('Share Translation'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Scan scan) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Translation'),
        content: const Text(
          'Are you sure you want to delete this translation? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              if (scan.id != null) {
                controller.deleteScan(scan.id!);
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

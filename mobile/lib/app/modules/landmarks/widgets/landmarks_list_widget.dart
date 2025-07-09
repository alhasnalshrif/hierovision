import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/landmarks_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/landmark.dart';
import 'landmark_card.dart';

class LandmarksListWidget extends GetView<LandmarksController> {
  final Function(Landmark, BuildContext) onLandmarkTap;

  const LandmarksListWidget({Key? key, required this.onLandmarkTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
              ),
              SizedBox(height: 16),
              Text(
                'Loading ancient wonders...',
                style: TextStyle(color: AppTheme.textColor, fontSize: 16),
              ),
            ],
          ),
        );
      }

      if (controller.error.value.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error Loading Landmarks',
                style: Theme.of(
                  Get.context!,
                ).textTheme.displaySmall?.copyWith(color: AppTheme.textColor),
              ),
              const SizedBox(height: 8),
              Text(
                controller.error.value,
                style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textColor.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.refresh,
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      if (controller.filteredLandmarks.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.search_off,
                size: 64,
                color: AppTheme.accentColor,
              ),
              const SizedBox(height: 16),
              Text(
                'No landmarks found',
                style: Theme.of(
                  Get.context!,
                ).textTheme.displaySmall?.copyWith(color: AppTheme.textColor),
              ),
              const SizedBox(height: 8),
              Text(
                'Try adjusting your search or filter criteria',
                style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textColor.withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refresh,
        color: AppTheme.accentColor,
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: controller.filteredLandmarks.length,
          itemBuilder: (context, index) {
            final landmark = controller.filteredLandmarks[index];
            return LandmarkCard(
              landmark: landmark,
              onTap: () => onLandmarkTap(landmark, context),
            );
          },
        ),
      );
    });
  }
}

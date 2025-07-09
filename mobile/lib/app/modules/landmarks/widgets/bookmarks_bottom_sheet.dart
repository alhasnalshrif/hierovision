import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/landmarks_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/landmark.dart';
import '../../../components/star_rating.dart';

class BookmarksBottomSheet extends GetView<LandmarksController> {
  final Function(Landmark, BuildContext) onLandmarkTap;

  const BookmarksBottomSheet({Key? key, required this.onLandmarkTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.bookmark, color: AppTheme.accentColor),
                    const SizedBox(width: 8),
                    const Text(
                      'Bookmarked Landmarks',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                      ),
                    ),
                  ],
                ),
              ),
              // Bookmarked landmarks list
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.accentColor,
                        ),
                      ),
                    );
                  }

                  if (controller.bookmarkedLandmarks.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bookmark_border,
                            size: 64,
                            color: AppTheme.accentColor,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No bookmarked landmarks',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppTheme.textColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Start exploring and bookmark landmarks for later!',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: controller.bookmarkedLandmarks.length,
                    itemBuilder: (context, index) {
                      final landmark = controller.bookmarkedLandmarks[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: _buildBookmarkListItem(landmark, context),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBookmarkListItem(Landmark landmark, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back(); // Close bookmarks modal
        onLandmarkTap(landmark, context);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.accentColor.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            // Image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(landmark.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    landmark.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    landmark.location,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textColor.withOpacity(0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (landmark.averageRating != null)
                        StarRatingDisplay(
                          rating: landmark.averageRating!,
                          size: 12,
                          showRating: true,
                        ),
                      const Spacer(),
                      Text(
                        '\$${landmark.price.toStringAsFixed(0)}/person',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Remove bookmark button
            IconButton(
              icon: const Icon(
                Icons.bookmark,
                color: AppTheme.accentColor,
                size: 20,
              ),
              onPressed: () => controller.toggleBookmark(landmark),
            ),
          ],
        ),
      ),
    );
  }
}

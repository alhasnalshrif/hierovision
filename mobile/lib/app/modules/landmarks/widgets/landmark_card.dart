import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/landmarks_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/landmark.dart';
import '../../../components/star_rating.dart';

class LandmarkCard extends GetView<LandmarksController> {
  final Landmark landmark;
  final VoidCallback onTap;

  const LandmarkCard({Key? key, required this.landmark, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.accentColor.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with bookmark button
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  // Egyptian frame decoration
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Text(
                      '𓍝',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.accentColor.withOpacity(0.4),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Row(
                      children: [
                        // Favorite button

                        // Bookmark button
                        IconButton(
                          icon: Icon(
                            landmark.isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: landmark.isBookmarked
                                ? Colors.amber
                                : Colors.white,
                            size: 20,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                            padding: const EdgeInsets.all(6),
                          ),
                          onPressed: () => controller.toggleBookmark(landmark),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: landmark.imageUrl.isNotEmpty
                            ? NetworkImage(landmark.imageUrl)
                            : const AssetImage(
                                "assets/images/pyramids_eye_color.jpeg",
                              ),
                        fit: BoxFit.cover,
                        onError: (error, stackTrace) {
                          // Handle image load error
                        },
                      ),
                    ),
                    child: landmark.imageUrl.isEmpty
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppTheme.accentColor.withOpacity(0.3),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.image,
                                size: 40,
                                color: AppTheme.accentColor,
                              ),
                            ),
                          )
                        : null,
                  ),
                  // Hieroglyph overlay
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.textColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        landmark.hieroglyphName,
                        style: const TextStyle(
                          color: AppTheme.accentColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: AppTheme.accentColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            landmark.location,
                            style: TextStyle(
                              fontSize: 10,
                              color: AppTheme.textColor.withOpacity(0.7),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        landmark.type.capitalizeFirst!,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppTheme.textColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (landmark.averageRating != null) ...[
                      StarRatingDisplay(
                        rating: landmark.averageRating!,
                        size: 12,
                        showRating: true,
                        reviewCount: landmark.reviewCount,
                      ),
                    ],
                    const SizedBox(height: 4),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

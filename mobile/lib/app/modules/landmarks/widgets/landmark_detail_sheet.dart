import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/landmarks_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/landmark.dart';
import '../../../data/models/review.dart';
import '../../../components/star_rating.dart';
import '../../../components/review_widget.dart' hide AddReviewWidget;
import '../../../components/add_review_widget.dart';

class LandmarkDetailSheet extends GetView<LandmarksController> {
  final Landmark landmark;

  const LandmarkDetailSheet({super.key, required this.landmark});

  // Get the current landmark from the controller's reactive lists
  Landmark get currentLandmark {
    final found = controller.landmarks.firstWhereOrNull(
      (l) => l.id == landmark.id,
    );
    return found ?? landmark;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
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
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: _buildLandmarkDetailContent(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLandmarkDetailContent() {
    // Load reviews when landmark detail is opened
    controller.loadLandmarkReviews(landmark.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: landmark.imageUrl.isNotEmpty
                  ? NetworkImage(landmark.imageUrl)
                  : const AssetImage('assets/images/pyramids_eye.jpeg')
                        as ImageProvider,
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              // Favorite and Bookmark buttons
              Positioned(
                top: 12,
                right: 12,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(
                      () => IconButton(
                        icon: Icon(
                          currentLandmark.isBookmarked
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: currentLandmark.isBookmarked
                              ? Colors.amber
                              : Colors.white,
                          size: 22,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black45,
                          minimumSize: const Size(32, 32),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          controller.toggleBookmark(currentLandmark);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Hieroglyph name
        Center(
          child: Text(
            landmark.hieroglyphName,
            style: const TextStyle(fontSize: 32, color: AppTheme.accentColor),
          ),
        ),
        const SizedBox(height: 8),

        // Name and location
        Text(
          landmark.name,
          style: Theme.of(Get.context!).textTheme.displayMedium?.copyWith(
            color: AppTheme.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.location_on, size: 16, color: AppTheme.accentColor),
            const SizedBox(width: 4),
            Text(
              landmark.location,
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.accentColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Rating and Price
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.accentColor.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (landmark.averageRating != null) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StarRatingDisplay(
                      rating: landmark.averageRating!,
                      size: 20,
                      showRating: true,
                      reviewCount: landmark.reviewCount,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${landmark.totalReviews} review${landmark.totalReviews != 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${landmark.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentColor,
                    ),
                  ),
                  const Text(
                    'per person',
                    style: TextStyle(fontSize: 12, color: AppTheme.textColor),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Description
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.accentColor.withOpacity(0.2)),
          ),
          child: Text(
            landmark.description,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textColor,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Tours (if available)
        if (landmark.tours != null && landmark.tours!.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentColor.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.group, size: 16, color: AppTheme.accentColor),
                    const SizedBox(width: 8),
                    const Text(
                      'Available Tours',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: landmark.tours!.map((tour) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.accentColor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tour,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textColor,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Reviews Section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.accentColor.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.rate_review,
                    size: 20,
                    color: AppTheme.accentColor,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Reviews',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => _showAllReviews(),
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Add Review Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showAddReviewDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('Write a Review'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.textColor,
                    side: const BorderSide(color: AppTheme.accentColor),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Recent Reviews
              Obx(() {
                final reviews = controller.selectedLandmarkReviews
                    .take(3)
                    .toList();
                if (reviews.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'No reviews yet. Be the first to review!',
                        style: TextStyle(
                          color: AppTheme.textColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }

                return Column(
                  children: reviews.map((review) {
                    return ReviewWidget(
                      review: review,
                      canEdit:
                          review.userId ==
                          'local_user', // TODO: Get actual user ID
                      onEdit: (reviewObj) => _showEditReviewDialog(reviewObj),
                      onDelete: (reviewObj) =>
                          controller.deleteReview(reviewObj.id),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),

        const SizedBox(height: 20),
        // Action buttons
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Get.toNamed('/booking', arguments: currentLandmark);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Book Visit',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  void _showAllReviews() {
    controller.loadLandmarkReviews(landmark.id);
    // Implementation for showing all reviews modal
  }

  void _showAddReviewDialog() {
    showDialog(
      context: Get.context!,
      builder: (context) => Dialog(
        backgroundColor: AppTheme.backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: AddReviewWidget(
            onSubmit: (rating, comment) {
              Navigator.pop(context);
              controller.addReviewToLandmark(landmark.id, rating, comment);
            },
          ),
        ),
      ),
    );
  }

  void _showEditReviewDialog(Review review) {
    showDialog(
      context: Get.context!,
      builder: (context) => Dialog(
        backgroundColor: AppTheme.backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: AddReviewWidget(
            initialRating: review.rating,
            initialComment: review.comment,
            isEditing: true,
            onSubmit: (rating, comment) {
              Navigator.pop(context);
              controller.updateReview(review.id, rating, comment);
            },
          ),
        ),
      ),
    );
  }
}

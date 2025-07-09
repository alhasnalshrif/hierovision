import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../data/models/review.dart';
import 'star_rating.dart';

class ReviewWidget extends StatelessWidget {
  final Review review;
  final bool canEdit;
  final Function(Review)? onEdit;
  final Function(Review)? onDelete;

  const ReviewWidget({
    Key? key,
    required this.review,
    this.canEdit = false,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accentColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info and rating
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.accentColor.withOpacity(0.3),
                backgroundImage: review.userAvatar != null
                    ? NetworkImage(review.userAvatar!)
                    : null,
                child: review.userAvatar == null
                    ? Text(
                        review.userName.isNotEmpty
                            ? review.userName[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          color: AppTheme.textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        StarRatingDisplay(rating: review.rating, size: 14),
                        const SizedBox(width: 8),
                        Text(
                          review.formattedDate,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (canEdit) ...[
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: AppTheme.textColor.withOpacity(0.7),
                  ),
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit?.call(review);
                    } else if (value == 'delete') {
                      _showDeleteConfirmation(context);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 16),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 16, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          // Review comment
          Text(
            review.comment,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Review'),
        content: const Text('Are you sure you want to delete this review?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete?.call(review);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class AddReviewWidget extends StatefulWidget {
  final Function(double rating, String comment) onSubmit;
  final Review? existingReview;

  const AddReviewWidget({Key? key, required this.onSubmit, this.existingReview})
    : super(key: key);

  @override
  _AddReviewWidgetState createState() => _AddReviewWidgetState();
}

class _AddReviewWidgetState extends State<AddReviewWidget> {
  late double _rating;
  late TextEditingController _commentController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _rating = widget.existingReview?.rating ?? 5.0;
    _commentController = TextEditingController(
      text: widget.existingReview?.comment ?? '',
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accentColor.withOpacity(0.2)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.existingReview != null
                  ? 'Edit Your Review'
                  : 'Add Your Review',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 16),
            // Rating
            Row(
              children: [
                const Text(
                  'Rating: ',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                StarRating(
                  rating: _rating,
                  onRatingChanged: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  _rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Comment
            TextFormField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Your review',
                hintText: 'Share your experience with this landmark...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppTheme.accentColor.withOpacity(0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppTheme.accentColor),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.5),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your review';
                }
                if (value.trim().length < 10) {
                  return 'Review must be at least 10 characters long';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  widget.existingReview != null
                      ? 'Update Review'
                      : 'Submit Review',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitReview() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(_rating, _commentController.text.trim());
    }
  }
}

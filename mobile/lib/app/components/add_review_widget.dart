import 'package:flutter/material.dart';
import 'star_rating.dart';
import '../core/theme/app_theme.dart';

class AddReviewWidget extends StatefulWidget {
  final Function(double rating, String comment) onSubmit;
  final double? initialRating;
  final String? initialComment;
  final bool isEditing;

  const AddReviewWidget({
    Key? key,
    required this.onSubmit,
    this.initialRating,
    this.initialComment,
    this.isEditing = false,
  }) : super(key: key);

  @override
  State<AddReviewWidget> createState() => _AddReviewWidgetState();
}

class _AddReviewWidgetState extends State<AddReviewWidget> {
  late double _rating;
  late TextEditingController _commentController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating ?? 5.0;
    _commentController = TextEditingController(text: widget.initialComment ?? '');
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Text(
                  widget.isEditing ? 'Edit Review' : 'Add Review',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close,
                    color: AppTheme.textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Rating Section
            Text(
              'Rating',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            StarRating(
              rating: _rating,
              size: 32,
              onRatingChanged: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            const SizedBox(height: 20),

            // Comment Section
            Text(
              'Comment',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Share your experience...',
                hintStyle: TextStyle(color: AppTheme.textColor.withOpacity(0.6)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.backgroundSecondary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
                ),
                filled: true,
                fillColor: AppTheme.cardColor,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a comment';
                }
                if (value.trim().length < 10) {
                  return 'Comment must be at least 10 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  widget.isEditing ? 'Update Review' : 'Submit Review',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            // Bottom spacing for keyboard
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  void _submitReview() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit(_rating, _commentController.text.trim());
      Navigator.of(context).pop();
    }
  }
}

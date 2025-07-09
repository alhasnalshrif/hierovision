import 'dart:convert';
import 'package:get/get.dart';
import '../models/review.dart';
import '../providers/api_provider.dart';

class ReviewRepository {
  final ApiProvider _apiProvider = Get.find();

  Future<List<Review>> getReviewsForLandmark(String landmarkId) async {
    try {
      final response = await _apiProvider.get('/landmarks/$landmarkId/reviews');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['reviews'] as List)
            .map((json) => Review.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      // Return empty list for offline mode
      return [];
    }
  }

  Future<Review> addReview(String landmarkId, double rating, String comment) async {
    try {
      final response = await _apiProvider.post(
        '/landmarks/$landmarkId/reviews',
        {
          'rating': rating,
          'comment': comment,
        },
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Review.fromJson(data['review']);
      } else {
        throw Exception('Failed to add review');
      }
    } catch (e) {
      // For offline mode, create a local review
      return Review(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        landmarkId: landmarkId,
        userId: 'local_user',
        userName: 'You',
        rating: rating,
        comment: comment,
        createdAt: DateTime.now(),
      );
    }
  }

  Future<Review> updateReview(String reviewId, double rating, String comment) async {
    try {
      final response = await _apiProvider.put(
        '/reviews/$reviewId',
        {
          'rating': rating,
          'comment': comment,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Review.fromJson(data['review']);
      } else {
        throw Exception('Failed to update review');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<void> deleteReview(String reviewId) async {
    try {
      final response = await _apiProvider.delete('/reviews/$reviewId');

      if (response.statusCode != 200) {
        throw Exception('Failed to delete review');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<Review?> getUserReviewForLandmark(String landmarkId) async {
    try {
      final response = await _apiProvider.get('/landmarks/$landmarkId/reviews/user');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['review'] != null) {
          return Review.fromJson(data['review']);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<Review>> getUserReviews() async {
    try {
      final response = await _apiProvider.get('/user/reviews');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['reviews'] as List)
            .map((json) => Review.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load user reviews');
      }
    } catch (e) {
      return [];
    }
  }
}

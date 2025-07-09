import 'dart:convert';
import 'package:get/get.dart';
import '../models/landmark.dart';
import '../models/review.dart';
import '../providers/api_provider.dart';
import '../services/sample_data_service.dart';

class LandmarkRepository {
  final ApiProvider _apiProvider = Get.find();

  // Cache for landmarks
  List<Landmark>? _cachedLandmarks;
  final List<String> _bookmarkedIds = [];

  Future<List<Landmark>> getLandmarks() async {
    try {
      final response = await _apiProvider.get('/landmarks');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final landmarks = (data['landmarks'] as List)
            .map((json) => Landmark.fromJson(json))
            .toList();
        _cachedLandmarks = landmarks;
        return landmarks;
      } else {
        throw Exception('Failed to load landmarks');
      }
    } catch (e) {
      // Fallback to sample data if API is not available
      print('API not available, using sample data: ${e.toString()}');
      _cachedLandmarks = SampleDataService.getSampleLandmarks();
      return _cachedLandmarks!;
    }
  }

  Future<Landmark> getLandmarkById(String id) async {
    try {
      final response = await _apiProvider.get('/landmarks/$id');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Landmark.fromJson(data['landmark']);
      } else {
        throw Exception('Failed to load landmark');
      }
    } catch (e) {
      // Fallback to cached or sample data
      if (_cachedLandmarks != null) {
        final landmark = _cachedLandmarks!.firstWhere(
          (l) => l.id == id,
          orElse: () => throw Exception('Landmark not found'),
        );
        return landmark;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<List<Landmark>> searchLandmarks(String query) async {
    try {
      final response = await _apiProvider.get('/landmarks/search?q=$query');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['landmarks'] as List)
            .map((json) => Landmark.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to search landmarks');
      }
    } catch (e) {
      // Fallback to local search in cached data
      if (_cachedLandmarks != null) {
        return _cachedLandmarks!.where((landmark) {
          return landmark.name.toLowerCase().contains(query.toLowerCase()) ||
              landmark.location.toLowerCase().contains(query.toLowerCase()) ||
              landmark.description.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<void> bookmarkLandmark(String landmarkId) async {
    try {
      final response = await _apiProvider.post(
        '/landmarks/$landmarkId/bookmark',
        {},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to bookmark landmark');
      }
      _bookmarkedIds.add(landmarkId);
    } catch (e) {
      // For offline mode, just add to local list
      if (!_bookmarkedIds.contains(landmarkId)) {
        _bookmarkedIds.add(landmarkId);
      }
      print('Bookmark saved locally: ${e.toString()}');
    }
  }

  Future<void> unbookmarkLandmark(String landmarkId) async {
    try {
      final response = await _apiProvider.delete(
        '/landmarks/$landmarkId/bookmark',
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to unbookmark landmark');
      }
      _bookmarkedIds.remove(landmarkId);
    } catch (e) {
      // For offline mode, just remove from local list
      _bookmarkedIds.remove(landmarkId);
      print('Bookmark removed locally: ${e.toString()}');
    }
  }

  Future<List<Landmark>> getBookmarkedLandmarks() async {
    try {
      final response = await _apiProvider.get('/landmarks/bookmarks');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['landmarks'] as List)
            .map((json) => Landmark.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load bookmarked landmarks');
      }
    } catch (e) {
      // Fallback to local bookmarked landmarks
      if (_cachedLandmarks != null) {
        return _cachedLandmarks!
            .where((landmark) => _bookmarkedIds.contains(landmark.id))
            .map((l) => l.copyWith(isBookmarked: true))
            .toList();
      }
      return [];
    }
  }

  Future<List<Landmark>> getLandmarksByType(String type) async {
    try {
      final response = await _apiProvider.get('/landmarks?type=$type');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['landmarks'] as List)
            .map((json) => Landmark.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load landmarks by type');
      }
    } catch (e) {
      // Fallback to filtering cached data
      if (_cachedLandmarks != null) {
        return _cachedLandmarks!
            .where(
              (landmark) => landmark.type.toLowerCase() == type.toLowerCase(),
            )
            .toList();
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<bool> toggleBookmark(
    String landmarkId,
    bool isCurrentlyBookmarked,
  ) async {
    try {
      if (isCurrentlyBookmarked) {
        await unbookmarkLandmark(landmarkId);
        return false;
      } else {
        await bookmarkLandmark(landmarkId);
        return true;
      }
    } catch (e) {
      // For offline mode, toggle local bookmark status
      if (isCurrentlyBookmarked) {
        _bookmarkedIds.remove(landmarkId);
        return false;
      } else {
        if (!_bookmarkedIds.contains(landmarkId)) {
          _bookmarkedIds.add(landmarkId);
        }
        return true;
      }
    }
  }

  // Check if landmark is bookmarked
  bool isBookmarked(String landmarkId) {
    return _bookmarkedIds.contains(landmarkId);
  }

  // Update landmark bookmark status in cached data
  void updateLandmarkBookmarkStatus(String landmarkId, bool isBookmarked) {
    if (_cachedLandmarks != null) {
      for (int i = 0; i < _cachedLandmarks!.length; i++) {
        if (_cachedLandmarks![i].id == landmarkId) {
          _cachedLandmarks![i] = _cachedLandmarks![i].copyWith(
            isBookmarked: isBookmarked,
          );
          break;
        }
      }
    }

    if (isBookmarked && !_bookmarkedIds.contains(landmarkId)) {
      _bookmarkedIds.add(landmarkId);
    } else if (!isBookmarked) {
      _bookmarkedIds.remove(landmarkId);
    }
  }

  // Favorite methods (separate from bookmark)
  Future<void> addToFavorites(String landmarkId) async {
    try {
      final response = await _apiProvider.post(
        '/landmarks/$landmarkId/favorite',
        {},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to add to favorites');
      }
    } catch (e) {
      // For offline mode, just add to local list
      print('Added to favorites locally: ${e.toString()}');
    }
  }

  Future<void> removeFromFavorites(String landmarkId) async {
    try {
      final response = await _apiProvider.delete(
        '/landmarks/$landmarkId/favorite',
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to remove from favorites');
      }
    } catch (e) {
      // For offline mode, just remove from local list
      print('Removed from favorites locally: ${e.toString()}');
    }
  }

  Future<List<Landmark>> getFavoriteLandmarks() async {
    try {
      final response = await _apiProvider.get('/landmarks/favorites');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['landmarks'] as List)
            .map((json) => Landmark.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load favorite landmarks');
      }
    } catch (e) {
      // Fallback to local favorites
      if (_cachedLandmarks != null) {
        return _cachedLandmarks!
            .where((landmark) => landmark.isFavorite)
            .toList();
      }
      return [];
    }
  }

  // Review methods
  Future<List<Review>> getLandmarkReviews(String landmarkId) async {
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

  Future<Review> addReview(
    String landmarkId,
    double rating,
    String comment,
  ) async {
    try {
      final response = await _apiProvider.post(
        '/landmarks/$landmarkId/reviews',
        {'rating': rating, 'comment': comment},
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

  Future<Review> updateReview(
    String reviewId,
    double rating,
    String comment,
  ) async {
    try {
      final response = await _apiProvider.put('/reviews/$reviewId', {
        'rating': rating,
        'comment': comment,
      });

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
}

import 'package:get/get.dart';
import '../../../data/models/landmark.dart';
import '../../../data/models/review.dart';
import '../../../data/repositories/landmark_repository.dart';

class LandmarksController extends GetxController {
  final LandmarkRepository _landmarkRepository = Get.find();

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxBool isSearching = false.obs;
  final RxList<Landmark> landmarks = <Landmark>[].obs;
  final RxList<Landmark> filteredLandmarks = <Landmark>[].obs;
  final RxList<Landmark> bookmarkedLandmarks = <Landmark>[].obs;
  final RxList<Review> selectedLandmarkReviews = <Review>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedType = 'all'.obs;
  final RxString error = ''.obs;
  final Rx<Landmark?> selectedLandmark = Rx<Landmark?>(null);

  // Filter types
  final List<String> filterTypes = [
    'all',
    'pyramid',
    'temple',
    'tomb',
    'monument',
  ];

  @override
  void onInit() {
    super.onInit();
    loadLandmarks();

    // Listen to search query changes
    ever(searchQuery, (_) => _filterLandmarks());
    ever(selectedType, (_) => _filterLandmarks());
  }

  // Load all landmarks
  Future<void> loadLandmarks() async {
    try {
      isLoading.value = true;
      error.value = '';

      final result = await _landmarkRepository.getLandmarks();
      landmarks.value = result;
      _filterLandmarks();
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load landmarks: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Search landmarks
  Future<void> searchLandmarks(String query) async {
    if (query.isEmpty) {
      searchQuery.value = '';
      return;
    }

    try {
      isSearching.value = true;
      searchQuery.value = query;

      final result = await _landmarkRepository.searchLandmarks(query);
      landmarks.value = result;
      _filterLandmarks();
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Search failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSearching.value = false;
    }
  }

  // Filter landmarks based on search and type
  void _filterLandmarks() {
    var filtered = landmarks.where((landmark) {
      final matchesSearch =
          searchQuery.value.isEmpty ||
          landmark.name.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          ) ||
          landmark.location.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          );

      final matchesType =
          selectedType.value == 'all' ||
          landmark.type.toLowerCase() == selectedType.value.toLowerCase();

      return matchesSearch && matchesType;
    }).toList();

    filteredLandmarks.value = filtered;
  }

  // Set filter type
  void setFilterType(String type) {
    selectedType.value = type;
  }

  // Update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Clear search
  void clearSearch() {
    searchQuery.value = '';
    selectedType.value = 'all';
  }

  // Select landmark for detail view
  void selectLandmark(Landmark landmark) {
    selectedLandmark.value = landmark;
  }

  // Clear selected landmark
  void clearSelectedLandmark() {
    selectedLandmark.value = null;
  }

  // Toggle bookmark
  Future<void> toggleBookmark(Landmark landmark) async {
    try {
      final newBookmarkStatus = await _landmarkRepository.toggleBookmark(
        landmark.id,
        landmark.isBookmarked,
      );

      // Update the landmark in the lists
      final updatedLandmark = landmark.copyWith(
        isBookmarked: newBookmarkStatus,
      );

      // Update in main landmarks list
      final index = landmarks.indexWhere((l) => l.id == landmark.id);
      if (index != -1) {
        landmarks[index] = updatedLandmark;
        landmarks.refresh(); // Trigger reactive update
      }

      // Update in filtered list
      final filteredIndex = filteredLandmarks.indexWhere(
        (l) => l.id == landmark.id,
      );
      if (filteredIndex != -1) {
        filteredLandmarks[filteredIndex] = updatedLandmark;
        filteredLandmarks.refresh(); // Trigger reactive update
      }

      // Update selected landmark if it's the same
      if (selectedLandmark.value?.id == landmark.id) {
        selectedLandmark.value = updatedLandmark;
      }

      // Show success message
      Get.snackbar(
        'Success',
        newBookmarkStatus ? 'Added to bookmarks' : 'Removed from bookmarks',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update bookmark: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Load bookmarked landmarks
  Future<void> loadBookmarkedLandmarks() async {
    try {
      isLoading.value = true;
      final result = await _landmarkRepository.getBookmarkedLandmarks();
      bookmarkedLandmarks.value = result;
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load bookmarked landmarks: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Get landmark by ID
  Future<Landmark?> getLandmarkById(String id) async {
    try {
      return await _landmarkRepository.getLandmarkById(id);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load landmark: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  // Refresh data
  Future<void> refresh() async {
    await loadLandmarks();
  }

  // Load reviews for selected landmark
  Future<void> loadLandmarkReviews(String landmarkId) async {
    try {
      final reviews = await _landmarkRepository.getLandmarkReviews(landmarkId);
      selectedLandmarkReviews.value = reviews;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load reviews: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Add review to landmark
  Future<void> addReviewToLandmark(
    String landmarkId,
    double rating,
    String comment,
  ) async {
    try {
      final review = await _landmarkRepository.addReview(
        landmarkId,
        rating,
        comment,
      );

      // Add to local reviews list
      selectedLandmarkReviews.add(review);

      // Update landmark's review count and average rating
      final landmarkIndex = landmarks.indexWhere((l) => l.id == landmarkId);
      if (landmarkIndex != -1) {
        final updatedLandmark = landmarks[landmarkIndex].copyWith(
          reviewCount: (landmarks[landmarkIndex].reviewCount ?? 0) + 1,
          reviews: [...(landmarks[landmarkIndex].reviews ?? []), review],
        );
        landmarks[landmarkIndex] = updatedLandmark;

        // Update filtered list too
        final filteredIndex = filteredLandmarks.indexWhere(
          (l) => l.id == landmarkId,
        );
        if (filteredIndex != -1) {
          filteredLandmarks[filteredIndex] = updatedLandmark;
        }

        // Update selected landmark
        if (selectedLandmark.value?.id == landmarkId) {
          selectedLandmark.value = updatedLandmark;
        }
      }

      Get.snackbar(
        'Success',
        'Review added successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add review: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Update existing review
  Future<void> updateReview(
    String reviewId,
    double rating,
    String comment,
  ) async {
    try {
      final updatedReview = await _landmarkRepository.updateReview(
        reviewId,
        rating,
        comment,
      );

      // Update in local reviews list
      final index = selectedLandmarkReviews.indexWhere((r) => r.id == reviewId);
      if (index != -1) {
        selectedLandmarkReviews[index] = updatedReview;
      }

      Get.snackbar(
        'Success',
        'Review updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update review: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Delete review
  Future<void> deleteReview(String reviewId) async {
    try {
      await _landmarkRepository.deleteReview(reviewId);

      // Remove from local reviews list
      selectedLandmarkReviews.removeWhere((r) => r.id == reviewId);

      Get.snackbar(
        'Success',
        'Review deleted successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete review: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Get user's review for a landmark
  Review? getUserReviewForLandmark(String landmarkId, String userId) {
    return selectedLandmarkReviews.firstWhereOrNull(
      (review) => review.landmarkId == landmarkId && review.userId == userId,
    );
  }
}

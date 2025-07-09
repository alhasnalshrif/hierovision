import 'review.dart';


class Landmark {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String location;
  final String type;
  final String hieroglyphName;
  final double price;
  final double? averageRating;
  final int? reviewCount;
  final List<String>? tours;
  final bool isBookmarked;
  final bool isFavorite; // Additional favorite field
  final List<Review>? reviews; // Reviews list
  final DateTime? createdAt;

  Landmark({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.type,
    required this.hieroglyphName,
    required this.price,
    this.averageRating,
    this.reviewCount,
    this.tours,
    this.isBookmarked = false,
    this.isFavorite = false, // Default value for isFavorite
    this.reviews, // Initialize reviews list
    this.createdAt,
  });

  factory Landmark.fromJson(Map<String, dynamic> json) {
    return Landmark(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? json['image'] ?? '',
      location: json['location'] ?? '',
      type: json['type'] ?? 'monument',
      hieroglyphName: json['hieroglyph_name'] ?? '𓉴',
      price: (json['price'] ?? 0).toDouble(),
      averageRating: json['average_rating']?.toDouble(),
      reviewCount: json['review_count']?.toInt(),
      tours: json['tours'] != null ? List<String>.from(json['tours']) : null,
      isBookmarked: json['is_bookmarked'] ?? false,
      isFavorite: json['is_favorite'] ?? false, // Parse isFavorite from JSON
      reviews: json['reviews'] != null
          ? List<Review>.from(json['reviews'].map((review) => Review.fromJson(review)))
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'location': location,
      'type': type,
      'hieroglyph_name': hieroglyphName,
      'price': price,
      'average_rating': averageRating,
      'review_count': reviewCount,
      'tours': tours,
      'is_bookmarked': isBookmarked,
      'is_favorite': isFavorite, // Serialize isFavorite to JSON
      'reviews': reviews != null
          ? List<dynamic>.from(reviews!.map((review) => review.toJson()))
          : null,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  Landmark copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? location,
    String? type,
    String? hieroglyphName,
    double? price,
    double? averageRating,
    int? reviewCount,
    List<String>? tours,
    bool? isBookmarked,
    bool? isFavorite, // Add isFavorite to copyWith
    List<Review>? reviews, // Add reviews to copyWith
    DateTime? createdAt,
  }) {
    return Landmark(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      type: type ?? this.type,
      hieroglyphName: hieroglyphName ?? this.hieroglyphName,
      price: price ?? this.price,
      averageRating: averageRating ?? this.averageRating,
      reviewCount: reviewCount ?? this.reviewCount,
      tours: tours ?? this.tours,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isFavorite: isFavorite ?? this.isFavorite, // Copy isFavorite
      reviews: reviews ?? this.reviews, // Copy reviews
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Helper methods for favorites and reviews
  bool get hasFavorites => isFavorite || isBookmarked;
  
  bool get hasReviews => reviews != null && reviews!.isNotEmpty;
  
  int get totalReviews => reviews?.length ?? reviewCount ?? 0;
  
  double get calculatedAverageRating {
    if (reviews != null && reviews!.isNotEmpty) {
      double sum = reviews!.fold(0, (sum, review) => sum + review.rating);
      return sum / reviews!.length;
    }
    return averageRating ?? 0.0;
  }
  
  // Get recent reviews (last 5)
  List<Review> get recentReviews {
    if (reviews == null || reviews!.isEmpty) return [];
    List<Review> sortedReviews = List.from(reviews!)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sortedReviews.take(5).toList();
  }
  
  // Get user's review if exists
  Review? getUserReview(String userId) {
    if (reviews == null) return null;
    try {
      return reviews!.firstWhere((review) => review.userId == userId);
    } catch (e) {
      return null;
    }
  }
  
  // Check if user has reviewed this landmark
  bool hasUserReviewed(String userId) {
    return getUserReview(userId) != null;
  }
}



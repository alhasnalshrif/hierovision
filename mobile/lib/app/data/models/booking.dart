class Booking {
  final String id;
  final String landmarkId;
  final String landmarkName;
  final String userId;
  final DateTime bookingDate;
  final int numberOfPeople;
  final String selectedTour;
  final double totalPrice;
  final BookingStatus status;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Booking({
    required this.id,
    required this.landmarkId,
    required this.landmarkName,
    required this.userId,
    required this.bookingDate,
    required this.numberOfPeople,
    required this.selectedTour,
    required this.totalPrice,
    required this.status,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id']?.toString() ?? '',
      landmarkId: json['landmark_id']?.toString() ?? '',
      landmarkName: json['landmark_name'] ?? '',
      userId: json['user_id']?.toString() ?? '',
      bookingDate: DateTime.parse(json['date']),
      numberOfPeople: json['visitors'] ?? 1,
      selectedTour: json['tour_type'] ?? '',
      totalPrice: (json['total_price'] ?? 0.0).toDouble(),
      status: BookingStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => BookingStatus.pending,
      ),
      notes: json['contact_phone'], // Use contact_phone as notes field
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'landmark_id': landmarkId,
      'landmark_name': landmarkName,
      'user_id': userId,
      'date': bookingDate.toIso8601String(),
      'visitors': numberOfPeople,
      'tour_type': selectedTour,
      'total_price': totalPrice,
      'status': status.toString().split('.').last,
      'contact_phone': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Booking copyWith({
    String? id,
    String? landmarkId,
    String? landmarkName,
    String? userId,
    DateTime? bookingDate,
    int? numberOfPeople,
    String? selectedTour,
    double? totalPrice,
    BookingStatus? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Booking(
      id: id ?? this.id,
      landmarkId: landmarkId ?? this.landmarkId,
      landmarkName: landmarkName ?? this.landmarkName,
      userId: userId ?? this.userId,
      bookingDate: bookingDate ?? this.bookingDate,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
      selectedTour: selectedTour ?? this.selectedTour,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get formattedDate {
    return '${bookingDate.day}/${bookingDate.month}/${bookingDate.year}';
  }

  String get formattedPrice {
    return '\$${totalPrice.toStringAsFixed(2)}';
  }

  bool get canBeCancelled {
    return status == BookingStatus.pending || status == BookingStatus.confirmed;
  }

  bool get isUpcoming {
    return bookingDate.isAfter(DateTime.now()) &&
        (status == BookingStatus.pending || status == BookingStatus.confirmed);
  }
}

enum BookingStatus { pending, confirmed, cancelled, completed }

extension BookingStatusExtension on BookingStatus {
  String get displayName {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.completed:
        return 'Completed';
    }
  }

  String get description {
    switch (this) {
      case BookingStatus.pending:
        return 'Waiting for confirmation';
      case BookingStatus.confirmed:
        return 'Your booking is confirmed';
      case BookingStatus.cancelled:
        return 'Booking has been cancelled';
      case BookingStatus.completed:
        return 'Visit completed';
    }
  }
}

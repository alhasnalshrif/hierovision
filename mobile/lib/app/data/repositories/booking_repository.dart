import 'dart:convert';
import 'package:get/get.dart';
import '../models/booking.dart';
import '../providers/api_provider.dart';

class BookingRepository {
  final ApiProvider _apiProvider = Get.find();

  Future<List<Booking>> getUserBookings() async {
    try {
      final response = await _apiProvider.get('/bookings');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final bookings = (data['bookings'] as List)
            .map((json) => Booking.fromJson(json))
            .toList();
        return bookings;
      } else {
        throw Exception('Failed to load bookings: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading bookings: $e');
      // Return empty list instead of throwing to handle gracefully
      return [];
    }
  }

  Future<Booking> createBooking(Map<String, dynamic> bookingData) async {
    try {
      final response = await _apiProvider.post('/bookings', bookingData);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Booking.fromJson(data['booking']);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to create booking');
      }
    } catch (e) {
      print('Error creating booking: $e');
      rethrow;
    }
  }

  Future<Booking> updateBookingStatus(
    String bookingId,
    BookingStatus status,
  ) async {
    try {
      final response = await _apiProvider.put('/bookings/$bookingId', {
        'status': status.toString().split('.').last,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Booking.fromJson(data['booking']);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          errorData['message'] ?? 'Failed to update booking status',
        );
      }
    } catch (e) {
      print('Error updating booking status: $e');
      rethrow;
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
      final response = await _apiProvider.put('/bookings/$bookingId', {
        'status': 'cancelled',
      });

      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to cancel booking');
      }
    } catch (e) {
      print('Error cancelling booking: $e');
      rethrow;
    }
  }

  Future<Booking> getBooking(String bookingId) async {
    try {
      final response = await _apiProvider.get('/bookings/$bookingId');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Booking.fromJson(data['booking']);
      } else {
        throw Exception('Failed to load booking: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading booking: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> processPayment(
    String bookingId,
    Map<String, dynamic> paymentData,
  ) async {
    try {
      final response = await _apiProvider.post(
        '/bookings/$bookingId/payment',
        paymentData,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Payment processing failed');
      }
    } catch (e) {
      print('Error processing payment: $e');
      rethrow;
    }
  }
}

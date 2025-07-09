import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/booking.dart';
import '../../../data/models/landmark.dart';
import '../../../data/repositories/booking_repository.dart';
import '../../auth/controllers/auth_controller.dart';

class BookingController extends GetxController {
  final BookingRepository _bookingRepository = BookingRepository();
  final RxBool isLoading = false.obs;
  final RxList<Booking> userBookings = <Booking>[].obs;
  final RxString selectedTour = ''.obs;
  final RxInt numberOfPeople = 1.obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final RxDouble totalPrice = 0.0.obs;
  final RxString notes = ''.obs;

  // Current booking form data
  Landmark? currentLandmark;
  final Rx<Booking?> currentBooking = Rx<Booking?>(null);

  @override
  void onInit() {
    super.onInit();
    loadUserBookings();
  }

  // Method to refresh bookings list
  Future<void> refreshBookings() async {
    await loadUserBookings();
  }

  void initializeBooking(Landmark landmark) {
    currentLandmark = landmark;
    selectedTour.value = landmark.tours?.first ?? 'Standard Tour';
    numberOfPeople.value = 1;
    selectedDate.value = null;
    notes.value = '';
    calculateTotalPrice();
  }

  void calculateTotalPrice() {
    if (currentLandmark != null) {
      totalPrice.value = currentLandmark!.price * numberOfPeople.value;
    }
  }

  void updateNumberOfPeople(int count) {
    numberOfPeople.value = count;
    calculateTotalPrice();
  }

  void updateSelectedTour(String tour) {
    selectedTour.value = tour;
    // You could adjust pricing based on tour type here
    calculateTotalPrice();
  }

  void updateSelectedDate(DateTime? date) {
    selectedDate.value = date;
  }

  void updateNotes(String newNotes) {
    notes.value = newNotes;
  }

  bool isDateAvailable(DateTime date) {
    // Check if the date is not in the past
    if (date.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      return false;
    }

    // Add any other business logic for date availability
    // For example, check if the landmark is closed on certain days
    return true;
  }

  Future<void> createBooking() async {
    if (!validateBookingForm()) return;

    isLoading.value = true;

    try {
      // Get current user information
      final authController = Get.find<AuthController>();
      final currentUser = authController.currentUser.value;

      // Prepare booking data for API
      final bookingData = {
        'landmark_id': currentLandmark!.id,
        'date': selectedDate.value!.toIso8601String(),
        'visitors': numberOfPeople.value,
        'tour_type': selectedTour.value,
        'total_price': totalPrice.value,
        'contact_name': currentUser?.fullName ?? 'User',
        'contact_email': currentUser?.email ?? 'user@example.com',
        'contact_phone': notes.value.isEmpty
            ? ''
            : notes.value, // Use notes as contact phone
      };

      // Create booking via API
      final booking = await _bookingRepository.createBooking(bookingData);

      // Set current booking for payment flow
      currentBooking.value = booking;

      // Navigate to payment details
      Get.toNamed('/payment-details');
    } catch (e) {
      Get.snackbar(
        'Booking Failed',
        'Failed to create booking. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> processPayment() async {
    if (currentBooking.value == null) return;

    try {
      // Process payment via API
      final paymentData = {
        'payment_method':
            'credit_card', // Updated to match backend expectations
        'amount': currentBooking.value!.totalPrice,
      };

      await _bookingRepository.processPayment(
        currentBooking.value!.id,
        paymentData,
      );

      // Update booking status to confirmed via API
      final confirmedBooking = await _bookingRepository.updateBookingStatus(
        currentBooking.value!.id,
        BookingStatus.confirmed,
      );

      // Update current booking
      currentBooking.value = confirmedBooking;

      // Refresh bookings list
      await loadUserBookings();
    } catch (e) {
      print('Error processing payment: $e');
      Get.snackbar(
        'Payment Failed',
        'Payment processing failed. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  bool validateBookingForm() {
    if (currentLandmark == null) {
      Get.snackbar(
        'Error',
        'No landmark selected for booking',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (selectedDate.value == null) {
      Get.snackbar(
        'Date Required',
        'Please select a date for your visit',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (!isDateAvailable(selectedDate.value!)) {
      Get.snackbar(
        'Invalid Date',
        'Please select a valid future date',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (numberOfPeople.value <= 0) {
      Get.snackbar(
        'Invalid Group Size',
        'Number of people must be at least 1',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }

  Future<void> loadUserBookings() async {
    isLoading.value = true;

    try {
      // Load bookings from API
      final bookings = await _bookingRepository.getUserBookings();
      userBookings.value = bookings;

      print('Loaded ${userBookings.length} bookings from API');
    } catch (e) {
      print('Error loading bookings: $e');
      Get.snackbar(
        'Error',
        'Failed to load bookings. Please check your connection.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      // Don't clear existing bookings on error
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
      // Cancel booking via API
      await _bookingRepository.cancelBooking(bookingId);

      // Refresh bookings list to get updated data
      await loadUserBookings();

      Get.snackbar(
        'Booking Cancelled',
        'Your booking has been cancelled',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error cancelling booking: $e');
      Get.snackbar(
        'Error',
        'Failed to cancel booking. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  List<Booking> get upcomingBookings {
    return userBookings.where((booking) => booking.isUpcoming).toList();
  }

  List<Booking> get pastBookings {
    return userBookings.where((booking) => !booking.isUpcoming).toList();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/booking_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/landmark.dart';
import '../../../data/models/booking.dart';

class BookingView extends GetView<BookingController> {
  const BookingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Landmark? landmark = Get.arguments as Landmark?;

    if (landmark != null) {
      controller.initializeBooking(landmark);
      return _buildBookingForm(landmark);
    } else {
      return _buildBookingsList();
    }
  }

  Widget _buildBookingForm(Landmark landmark) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Visit'),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/images/wallpaper.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLandmarkCard(landmark),
              const SizedBox(height: 24),
              _buildDateSelector(),
              const SizedBox(height: 24),
              _buildTourSelector(landmark),
              const SizedBox(height: 24),
              _buildPeopleSelector(),
              const SizedBox(height: 24),
              _buildNotesField(),
              const SizedBox(height: 24),
              _buildPriceSummary(),
              const SizedBox(height: 32),
              _buildBookButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLandmarkCard(Landmark landmark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              landmark.imageUrl.isNotEmpty
                  ? landmark.imageUrl
                  : 'https://via.placeholder.com/80',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  landmark.hieroglyphName,
                  style: const TextStyle(
                    fontSize: 24,
                    color: AppTheme.accentColor,
                  ),
                ),
                Text(
                  landmark.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppTheme.accentColor,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        landmark.location,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Date',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            () => InkWell(
              onTap: () => _selectDate(),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.accentColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: AppTheme.accentColor,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      controller.selectedDate.value != null
                          ? '${controller.selectedDate.value!.day}/${controller.selectedDate.value!.month}/${controller.selectedDate.value!.year}'
                          : 'Select a date',
                      style: TextStyle(
                        fontSize: 16,
                        color: controller.selectedDate.value != null
                            ? AppTheme.textColor
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTourSelector(Landmark landmark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Tour',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 12),
          if (landmark.tours != null && landmark.tours!.isNotEmpty)
            Obx(
              () => Column(
                children: landmark.tours!.map((tour) {
                  return RadioListTile<String>(
                    title: Text(tour),
                    value: tour,
                    groupValue: controller.selectedTour.value,
                    onChanged: (value) {
                      if (value != null) {
                        controller.updateSelectedTour(value);
                      }
                    },
                    activeColor: AppTheme.accentColor,
                  );
                }).toList(),
              ),
            )
          else
            const Text(
              'Standard Tour',
              style: TextStyle(fontSize: 16, color: AppTheme.textColor),
            ),
        ],
      ),
    );
  }

  Widget _buildPeopleSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Number of People',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            () => Row(
              children: [
                IconButton(
                  onPressed: controller.numberOfPeople.value > 1
                      ? () => controller.updateNumberOfPeople(
                          controller.numberOfPeople.value - 1,
                        )
                      : null,
                  icon: const Icon(Icons.remove),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.accentColor.withOpacity(0.1),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '${controller.numberOfPeople.value}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: controller.numberOfPeople.value < 20
                      ? () => controller.updateNumberOfPeople(
                          controller.numberOfPeople.value + 1,
                        )
                      : null,
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.accentColor.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact Phone (Optional)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: controller.updateNotes,
            maxLines: 1,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'Enter your phone number...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.accentColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppTheme.accentColor,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Price Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            () => Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Price per person:',
                      style: const TextStyle(color: AppTheme.textColor),
                    ),
                    Text(
                      '\$${controller.currentLandmark?.price.toStringAsFixed(2) ?? '0.00'}',
                      style: const TextStyle(color: AppTheme.textColor),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Number of people:',
                      style: const TextStyle(color: AppTheme.textColor),
                    ),
                    Text(
                      '${controller.numberOfPeople.value}',
                      style: const TextStyle(color: AppTheme.textColor),
                    ),
                  ],
                ),
                const Divider(color: AppTheme.accentColor),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                      ),
                    ),
                    Text(
                      '\$${controller.totalPrice.value.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accentColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : controller.createBooking,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: controller.isLoading.value
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'Continue to Payment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildBookingsList() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/images/wallpaper.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.userBookings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.bookmark_border,
                    size: 64,
                    color: AppTheme.accentColor,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No bookings yet',
                    style: TextStyle(fontSize: 18, color: AppTheme.textColor),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Start exploring landmarks to make your first booking!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: AppTheme.textColor),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.refreshBookings,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.upcomingBookings.isNotEmpty) ...[
                    const Text(
                      'Upcoming Bookings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...controller.upcomingBookings.map(
                      (booking) => _buildBookingCard(booking),
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (controller.pastBookings.isNotEmpty) ...[
                    const Text(
                      'Past Bookings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...controller.pastBookings.map(
                      (booking) => _buildBookingCard(booking),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  booking.landmarkName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(booking.status),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  booking.status.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Date: ${booking.formattedDate}',
            style: const TextStyle(color: AppTheme.textColor),
          ),
          Text(
            'People: ${booking.numberOfPeople}',
            style: const TextStyle(color: AppTheme.textColor),
          ),
          Text(
            'Tour: ${booking.selectedTour}',
            style: const TextStyle(color: AppTheme.textColor),
          ),
          Text(
            'Total: ${booking.formattedPrice}',
            style: const TextStyle(
              color: AppTheme.accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (booking.canBeCancelled) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _showCancelDialog(booking),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                ),
                child: const Text(
                  'Cancel Booking',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.confirmed:
        return Colors.green;
      case BookingStatus.cancelled:
        return Colors.red;
      case BookingStatus.completed:
        return Colors.blue;
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      controller.updateSelectedDate(picked);
    }
  }

  void _showCancelDialog(Booking booking) {
    Get.dialog(
      AlertDialog(
        title: const Text('Cancel Booking'),
        content: Text(
          'Are you sure you want to cancel your booking for ${booking.landmarkName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Keep Booking'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.cancelBooking(booking.id);
            },
            child: const Text(
              'Cancel Booking',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

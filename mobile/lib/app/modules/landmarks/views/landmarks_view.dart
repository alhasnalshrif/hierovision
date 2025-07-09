import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/landmarks_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/landmark.dart';
import '../widgets/landmarks_list_widget.dart';
import '../widgets/landmark_detail_sheet.dart';
import '../widgets/bookmarks_bottom_sheet.dart';

class LandmarksView extends GetView<LandmarksController> {
  const LandmarksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ancient Egyptian Landmarks',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: _showBookmarkedLandmarks,
            tooltip: 'Bookmarks',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/wallpaper.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: LandmarksListWidget(onLandmarkTap: _showLandmarkDetail),
            ),
          ],
        ),
      ),
    );
  }

  void _showLandmarkDetail(Landmark landmark, BuildContext context) {
    controller.selectLandmark(landmark);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LandmarkDetailSheet(landmark: landmark),
    );
  }

  void _showBookmarkedLandmarks() {
    controller.loadBookmarkedLandmarks();

    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          BookmarksBottomSheet(onLandmarkTap: _showLandmarkDetail),
    );
  }
}

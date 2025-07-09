import 'package:get/get.dart';
import '../controllers/landmarks_controller.dart';
import '../../../data/repositories/landmark_repository.dart';

class LandmarksBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LandmarkRepository>(
      () => LandmarkRepository(),
    );
    Get.lazyPut<LandmarksController>(
      () => LandmarksController(),
    );
  }
}

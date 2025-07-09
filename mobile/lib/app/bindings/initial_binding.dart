import 'package:get/get.dart';
import '../data/providers/api_provider.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/landmark_repository.dart';
import '../data/repositories/scan_repository.dart';
import '../data/services/storage_service.dart';
import '../modules/auth/controllers/auth_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core services
    Get.lazyPut<StorageService>(() => StorageService(), fenix: true);

    // API Provider
    Get.lazyPut<ApiProvider>(() => ApiProvider(), fenix: true);

    // Repositories
    Get.lazyPut<AuthRepository>(() => AuthRepository(), fenix: true);

    Get.lazyPut<LandmarkRepository>(() => LandmarkRepository(), fenix: true);

    Get.lazyPut<ScanRepository>(() => ScanRepository(), fenix: true);

    // Controllers that need to be available globally
    Get.put<AuthController>(AuthController(), permanent: true);
  }
}

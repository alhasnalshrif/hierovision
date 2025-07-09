import 'package:get/get.dart';
import 'app_routes.dart';
import '../modules/get_started/bindings/get_started_binding.dart';
import '../modules/get_started/views/get_started_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/signup_view.dart';
import '../modules/upload/bindings/upload_binding.dart';
import '../modules/upload/views/upload_view.dart';
import '../modules/result/bindings/result_binding.dart';
import '../modules/result/views/result_view.dart';
import '../modules/landmarks/bindings/landmarks_binding.dart';
import '../modules/landmarks/views/landmarks_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
// import '../modules/kids_mode/bindings/kids_mode_binding.dart';
// import '../modules/kids_mode/views/kids_mode_view.dart';
import '../modules/booking/bindings/booking_binding.dart';
import '../modules/booking/views/booking_view.dart';
import '../modules/booking/views/payment_details_view.dart';
import '../modules/booking/views/payment_success_view.dart';
import '../modules/about/bindings/about_binding.dart';
import '../modules/about/views/about_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/bookmarks/bindings/bookmarks_binding.dart';
import '../modules/bookmarks/views/bookmarks_view.dart';

class AppPages {
  static const INITIAL = AppRoutes.GET_STARTED;

  static final routes = [
    GetPage(
      name: AppRoutes.GET_STARTED,
      page: () => const GetStartedView(),
      binding: GetStartedBinding(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.SIGNUP,
      page: () => const SignupView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.UPLOAD,
      page: () => const UploadView(),
      binding: UploadBinding(),
    ),
    GetPage(
      name: AppRoutes.RESULT,
      page: () => const ResultView(),
      binding: ResultBinding(),
    ),
    GetPage(
      name: AppRoutes.LANDMARKS,
      page: () => const LandmarksView(),
      binding: LandmarksBinding(),
    ),
    GetPage(
      name: AppRoutes.CHAT,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.KIDS_MODE,
    //   page: () => const KidsModeView(),
    //   binding: KidsModeBinding(),
    // ),
    GetPage(
      name: AppRoutes.BOOKING,
      page: () => const BookingView(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: AppRoutes.BOOKINGS,
      page: () => const BookingView(), // Will show list when no arguments
      binding: BookingBinding(),
    ),
    GetPage(
      name: AppRoutes.PAYMENT_DETAILS,
      page: () => const PaymentDetailsView(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: AppRoutes.PAYMENT_SUCCESS,
      page: () => const PaymentSuccessView(),
    ),
    GetPage(
      name: AppRoutes.ABOUT,
      page: () => const AboutView(),
      binding: AboutBinding(),
    ),
    GetPage(
      name: AppRoutes.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.BOOKMARKS,
      page: () => const BookmarksView(),
      binding: BookmarksBinding(),
    ),
  ];
}

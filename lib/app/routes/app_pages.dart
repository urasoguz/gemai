import 'package:gemai/app/core/network/api_client.dart';
import 'package:gemai/app/modules/home/controller/home_binding.dart';
import 'package:gemai/app/modules/home/view/home_view.dart';
import 'package:gemai/app/modules/legal_warning/legal_warning_binding.dart';
import 'package:gemai/app/modules/legal_warning/view/legal_warning_view.dart';
import 'package:gemai/app/modules/settings/settings_binding.dart';
import 'package:gemai/app/modules/settings/view/settings_view.dart';
import 'package:gemai/app/modules/settings/view/language_view.dart';
import 'package:gemai/app/modules/settings/view/account_view.dart';
import 'package:gemai/app/modules/skin_analysis/skin_analysis_binding.dart';
import 'package:gemai/app/modules/splash/controller/splash_controller.dart';
import 'package:gemai/app/modules/splash/view/splash_view.dart';
import 'package:get/get.dart';
import 'package:gemai/app/routes/app_routes.dart';
import 'package:gemai/app/modules/premium/view/premium_view.dart';
import 'package:gemai/app/modules/premium/binding/premium_binding.dart';
import 'package:gemai/app/modules/onboarding/view/onboarding_view.dart';
import 'package:gemai/app/modules/onboarding/onboarding_binding.dart';
import 'package:gemai/app/modules/result/view/result_view.dart';
import 'package:gemai/app/modules/result/result_binding.dart';
import 'package:gemai/app/modules/camera/view/camera_view.dart';
import 'package:gemai/app/modules/camera/camera_binding.dart';
import 'package:gemai/app/modules/skin_analysis/view/skin_analysis_view.dart';
import 'package:gemai/app/modules/pages/pages_binding.dart';
import 'package:gemai/app/modules/pages/view/pages_list_view.dart';
import 'package:gemai/app/modules/pages/view/page_detail_view.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: BindingsBuilder(() {
        Get.put(SplashController(apiClient: Get.find<ApiClient>()));
      }),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.legalWarning,
      page: () => const LegalWarningView(),
      binding: LegalWarningBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.language,
      page: () => LanguageView(),
      binding: SettingsBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.account,
      page: () => const AccountView(),
      binding: SettingsBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.premium,
      page: () => const PremiumView(),
      binding: PremiumBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.result,
      page: () => ResultView(),
      binding: ResultBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.camera,
      page: () => const CameraView(),
      binding: CameraBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.skinAnalysis,
      page: () => const SkinAnalysisView(),
      binding: SkinAnalysisBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.pages,
      page: () => const PagesListView(),
      binding: PagesBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.pageDetail,
      page: () => const PageDetailView(),
      binding: PagesBinding(),
      transition: Transition.cupertino,
    ),
  ];
}

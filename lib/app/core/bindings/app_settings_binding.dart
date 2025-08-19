import 'package:get/get.dart';
import 'package:dermai/app/data/api/settings_api_service.dart';
import 'package:dermai/app/core/services/app_settings_service.dart';
import 'package:dermai/app/shared/controllers/app_settings_controller.dart';

/// Uygulama ayarları binding'i - Dependency injection
///
/// KULLANIM ÖRNEĞİ:
/// ```dart
/// // main.dart'ta
/// Get.put(AppSettingsBinding());
///
/// // Veya route'larda
/// GetPage(
///   binding: AppSettingsBinding(),
///   page: () => SomePage(),
/// )
/// ```
class AppSettingsBinding extends Bindings {
  @override
  void dependencies() {
    // API Service - Permanent (uygulama boyunca kalır)
    Get.lazyPut<SettingsApiService>(() => SettingsApiService(), fenix: true);

    // App Settings Service - Permanent (uygulama boyunca kalır)
    Get.lazyPut<AppSettingsService>(() => AppSettingsService(), fenix: true);

    // App Settings Controller - Permanent (uygulama boyunca kalır)
    Get.lazyPut<AppSettingsController>(
      () => AppSettingsController(),
      fenix: true,
    );
  }
}

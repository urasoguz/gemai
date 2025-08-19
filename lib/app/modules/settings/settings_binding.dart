import 'package:get/get.dart';
import 'package:dermai/app/core/network/api_client.dart';
import 'package:dermai/app/modules/auth/controller/user_controller.dart';
import 'package:dermai/app/shared/controllers/lang_controller.dart';
import 'controller/settings_controller.dart';
import 'controller/account_controller.dart';
import 'controller/contact_mail_controller.dart';
import 'controller/device_info_controller.dart';
import 'package:dermai/app/core/bindings/restore_premium_binding.dart';
import 'package:dermai/app/core/bindings/app_settings_binding.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    // RestorePremiumService'i kaydet
    RestorePremiumBinding().dependencies();

    // AppSettingsService'i kaydet
    AppSettingsBinding().dependencies();

    // UserController'ı register et
    Get.lazyPut<UserController>(
      () => UserController(apiClient: Get.find<ApiClient>()),
    );
    Get.lazyPut<SettingsController>(() => SettingsController());
    Get.lazyPut<LangController>(() => LangController());
    Get.lazyPut<AccountController>(() => AccountController());
    Get.lazyPut<ContactMailController>(() => ContactMailController());
    Get.lazyPut<DeviceInfoController>(() => DeviceInfoController());
  }
}

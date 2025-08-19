import 'package:get/get.dart';
import 'package:dermai/app/modules/premium/controller/premium_controller.dart';
import 'package:dermai/app/shared/paywall/premium_config_service.dart';
import 'package:dermai/app/core/bindings/restore_premium_binding.dart';
import 'package:dermai/app/modules/auth/controller/user_controller.dart';
import 'package:dermai/app/core/network/api_client.dart';

class PremiumBinding extends Bindings {
  @override
  void dependencies() {
    // RestorePremiumService'i kaydet
    RestorePremiumBinding().dependencies();

    // UserController'ı kaydet (RestorePremiumService için gerekli)
    Get.lazyPut<UserController>(
      () => UserController(apiClient: Get.find<ApiClient>()),
    );

    Get.lazyPut<PremiumController>(() => PremiumController());
    // PremiumConfigService'i global olarak ekle
    Get.put<PremiumConfigService>(PremiumConfigService(), permanent: true);
  }
}

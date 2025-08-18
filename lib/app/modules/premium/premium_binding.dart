import 'package:get/get.dart';
import 'package:gemai/app/modules/premium/controller/premium_controller.dart';
import 'package:gemai/app/shared/paywall/premium_config_service.dart';

class PremiumBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PremiumController>(() => PremiumController());
    // PremiumConfigService'i global olarak ekle
    Get.put<PremiumConfigService>(PremiumConfigService(), permanent: true);
  }
}

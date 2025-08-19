import 'package:dermai/app/core/network/api_client.dart';
import 'package:dermai/app/core/services/restore_premium_service.dart';
import 'package:get/get.dart';

/// RestorePremiumService için dependency injection
class RestorePremiumBinding extends Bindings {
  @override
  void dependencies() {
    // RestorePremiumService'i kaydet
    Get.lazyPut<RestorePremiumService>(
      () => RestorePremiumService(apiClient: Get.find<ApiClient>()),
    );
  }
}

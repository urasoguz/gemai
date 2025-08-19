import 'package:get/get.dart';
import 'package:gemai/app/modules/onboarding/controller/onboarding_controller.dart';
import 'package:gemai/app/core/network/api_client.dart';
import 'package:gemai/app/shared/paywall/paywall_service.dart';
import 'package:flutter/foundation.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    if (kDebugMode) {
      print('🔧 OnboardingBinding başlatılıyor...');
    }

    Get.lazyPut<OnboardingController>(
      () => OnboardingController(apiClient: Get.find<ApiClient>()),
    );

    // PaywallService'i global olarak ekle
    Get.put<PaywallService>(PaywallService(), permanent: true);

    if (kDebugMode) {
      print('✅ OnboardingBinding tamamlandı');
    }
  }
}

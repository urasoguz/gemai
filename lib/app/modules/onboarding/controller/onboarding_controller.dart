import 'package:gemai/app/core/network/api_client.dart';
import 'package:gemai/app/modules/auth/controller/user_controller.dart';
import 'package:gemai/app/shared/paywall/paywall_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gemai/app/routes/app_routes.dart';
import 'package:gemai/app/shared/helpers/my_helper.dart';
import 'package:flutter/foundation.dart';

class OnboardingController extends GetxController {
  late final UserController userController;
  final RxInt pageIndex = 0.obs;
  final int pageCount = 3; // Tekrar 3'e döndürüldü
  final box = GetStorage();

  final ApiClient apiClient;

  OnboardingController({required this.apiClient}) {
    userController = Get.put(UserController(apiClient: apiClient));
  }

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      print('🎯 OnboardingController onInit başlatıldı');
      print('📊 Sayfa sayısı: $pageCount');
      print('📄 Başlangıç sayfa indeksi: ${pageIndex.value}');
    }
  }

  /// Sonraki sayfaya geç
  void nextPage() {
    if (pageIndex.value < 2) {
      // Tekrar 2'ye döndürüldü
      // Sayfa geçişini animasyonlu yap
      pageIndex.value++;
      print('Onboarding: Sayfa ${pageIndex.value + 1} açıldı');
    } else {
      // Son sayfada paywall'a geç - onboarding'den geldiğini belirt
      Get.offAllNamed('/premium', arguments: {'fromOnboarding': true});
    }
  }

  /// Önceki sayfaya dön
  void previousPage() {
    if (pageIndex.value > 0) {
      // Sayfa geçişini animasyonlu yap
      pageIndex.value--;
      print('Onboarding: Sayfa ${pageIndex.value + 1} açıldı');
    }
  }

  void completeOnboarding() async {
    try {
      if (kDebugMode) {
        print('🚀 Onboarding tamamlanmaya başlanıyor...');
      }

      // Onboarding'i tamamlandı olarak kaydet
      await box.write(MyHelper.isOnboardingCompleted, true);

      if (kDebugMode) {
        print('✅ Onboarding tamamlandı ve kaydedildi');
        print('💎 Premium ekranına yönlendiriliyor (seamless transition)...');
      }

      // Legal warning kontrolü kaldırıldı - direkt ana sayfaya yönlendir
      if (kDebugMode) {
        print('📋 Legal warning kontrolü devre dışı bırakıldı');
      }

      // Paywall kontrolü
      if (_shouldShowPaywallBasedOnSettings()) {
        if (kDebugMode) {
          print('💎 Premium ekranına yönlendiriliyor...');
        }
        Get.offAllNamed(AppRoutes.premium, arguments: {'fromOnboarding': true});
        return;
      }

      if (kDebugMode) {
        print('🏠 Ana ekrana yönlendiriliyor...');
      }
      // Şimdilik direkt ana sayfaya yönlendir (paywall'u atla)
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Onboarding tamamlanırken hata: $e');
      }
      // Hata durumunda ana sayfaya yönlendir
      Get.offAllNamed(AppRoutes.home);
    }
  }

  /// App Settings'e göre paywall gösterilip gösterilmeyeceğini kontrol eder
  bool _shouldShowPaywallBasedOnSettings() {
    try {
      final paywallService = Get.find<PaywallService>();

      if (kDebugMode) {
        print('🎯 Legal Warning - Paywall kontrolü:');
        print('   - Paywall Service: ${paywallService.shouldShowPaywall()}');
      }

      final shouldShow = paywallService.shouldShowPaywall();
      if (kDebugMode) {
        print('✅ Paywall gösterilecek: $shouldShow');
      }
      return shouldShow;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Paywall kontrolü yapılırken hata: $e');
      }
      return false;
    }
  }
}

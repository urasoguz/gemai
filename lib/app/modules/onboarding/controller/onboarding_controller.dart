import 'package:gemai/app/core/network/api_client.dart';
import 'package:gemai/app/modules/auth/controller/user_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gemai/app/routes/app_routes.dart';
import 'package:gemai/app/shared/helpers/my_helper.dart';
import 'package:flutter/foundation.dart';

class OnboardingController extends GetxController {
  late final UserController userController;
  final RxInt pageIndex = 0.obs;
  final int pageCount = 3;
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

  void nextPage() {
    if (pageIndex.value < pageCount - 1) {
      pageIndex.value++;
    }
  }

  void skip() {
    completeOnboarding();
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
      }

      // Yasal uyarı kontrolü
      final isLegalWarningAccepted =
          box.read(MyHelper.isLegalWarningAccepted) ?? false;

      if (kDebugMode) {
        print('📋 Yasal uyarı durumu: $isLegalWarningAccepted');
      }

      if (!isLegalWarningAccepted) {
        // Yasal uyarı gösterilmemişse göster
        if (kDebugMode) {
          print('📋 Yasal uyarı ekranına yönlendiriliyor...');
        }
        Get.offAllNamed(AppRoutes.legalWarning);
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
}

import 'package:dermai/app/core/services/shrine_dialog_service.dart';
import 'package:dermai/app/core/theme/app_theme_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dermai/app/shared/helpers/my_helper.dart';
import 'package:dermai/app/routes/app_routes.dart';
import 'package:dermai/app/shared/paywall/paywall_service.dart';

/// Yasal uyarı sayfası controller'ı
class LegalWarningController extends GetxController {
  final GetStorage _storage = GetStorage();

  // Checkbox durumu
  final RxBool isAccepted = true.obs;

  // Loading durumu
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      print('📋 Legal Warning Controller başlatıldı');
    }
  }

  /// Checkbox durumunu değiştirir
  void toggleAcceptance() {
    isAccepted.value = !isAccepted.value;
    if (kDebugMode) {
      print('✅ Kabul durumu: ${isAccepted.value}');
    }
  }

  /// Yasal uyarıyı kabul eder ve kaydeder
  Future<void> acceptLegalWarning() async {
    final colors =
        Theme.of(Get.context!).brightness == Brightness.light
            ? AppThemeConfig.lightColors
            : AppThemeConfig.darkColors;

    if (!isAccepted.value) {
      // Checkbox işaretli değilse uyarı göster
      ShrineDialogService.showWarning(
        'legal_warning_checkbox_text_error'.tr,
        colors,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    try {
      isLoading.value = true;

      // Yasal uyarıyı kabul edildi olarak kaydet
      await _storage.write(MyHelper.isLegalWarningAccepted, true);

      if (kDebugMode) {
        print('✅ Yasal uyarı kabul edildi ve kaydedildi');
      }

      // Paywall kontrolü
      if (_shouldShowPaywallBasedOnSettings()) {
        if (kDebugMode) {
          print('💎 Premium ekranına yönlendiriliyor...');
        }
        Get.offAllNamed(AppRoutes.premium);
        return;
      }

      // Ana sayfaya yönlendir
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Yasal uyarı kaydedilirken hata: $e');
      }
      ShrineDialogService.showError(
        'legal_warning_error'.tr,
        colors,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
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

  /// Gizlilik politikası linkini açar
  Future<void> openPrivacyPolicy() async {
    final colors =
        Theme.of(Get.context!).brightness == Brightness.light
            ? AppThemeConfig.lightColors
            : AppThemeConfig.darkColors;
    try {
      Get.toNamed(AppRoutes.pageDetail, arguments: {'slug': 'privacy'});
    } catch (e) {
      if (kDebugMode) {
        print('❌ Gizlilik politikası açılamadı: $e');
      }
      ShrineDialogService.showError(
        'legal_warning_error_no_settings'.tr,
        colors,
        duration: const Duration(seconds: 3),
      );
    }
  }

  /// Kullanım şartları linkini açar
  Future<void> openTermsOfService() async {
    final colors =
        Theme.of(Get.context!).brightness == Brightness.light
            ? AppThemeConfig.lightColors
            : AppThemeConfig.darkColors;
    try {
      Get.toNamed(AppRoutes.pageDetail, arguments: {'slug': 'terms'});
    } catch (e) {
      if (kDebugMode) {
        print('❌ Kullanım şartları açılamadı: $e');
      }
      ShrineDialogService.showError(
        'legal_warning_error_no_settings'.tr,
        colors,
        duration: const Duration(seconds: 3),
      );
    }
  }
}

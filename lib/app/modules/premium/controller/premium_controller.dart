import 'package:dermai/app/core/services/shrine_dialog_service.dart';
import 'package:dermai/app/core/theme/app_theme_config.dart';
import 'package:dermai/app/modules/auth/controller/user_controller.dart';
import 'package:dermai/app/shared/controllers/lang_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:dermai/app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dermai/app/shared/paywall/premium_config_service.dart';
import 'package:dermai/app/core/services/app_settings_service.dart';
import 'package:dermai/app/core/services/restore_premium_service.dart';

/// Premium Controller - Premium ekranı işlemlerini yönetir
///
/// KULLANIM ÖRNEĞİ:
/// ```dart
/// // Paywall ayarlarını kontrol et
/// final shouldShowCloseButton = controller.delayedCloseButton;
/// final closeDelay = controller.closeButtonDelaySeconds;
/// ```
class PremiumController extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController timerController;
  final RxBool showXIcon = false.obs;
  final RxInt selectedPlan = 1.obs; // 0: Annual, 1: Trial
  final RxBool isPurchasing = false.obs;
  final RxBool isRestoring = false.obs;
  final RxDouble discountPercent = 0.0.obs;
  final RxString annualPrice = ''.obs;
  final RxString weeklyPrice = ''.obs;
  final RxBool hasTrial = true.obs;
  final RxList<Package> packages = <Package>[].obs;
  // Basit premium özellikler listesi
  final List<Map<String, dynamic>> features = [
    {
      'icon': Icons.search,
      'title': 'premium_desc_1'.tr,
      'color': const Color(0xFF4CAF50),
    },
    {
      'icon': Icons.auto_awesome,
      'title': 'premium_desc_2'.tr,
      'color': const Color(0xFF4CAF50),
    },
    {
      'icon': Icons.lock_open,
      'title': 'premium_desc_3'.tr,
      'color': const Color(0xFF4CAF50),
    },
  ];
  late final PremiumConfigService premiumConfig;
  late final AppSettingsService _appSettings;
  final LangController langController = Get.find<LangController>();
  final UserController userController = Get.find<UserController>();

  /// Paywall kapatma butonu gecikmeli mi?
  bool get delayedCloseButton =>
      _appSettings.paywallSettings?.paywallDelayedCloseButton ?? false;

  /// Paywall kapatma butonu gecikmesi (saniye)
  int get closeButtonDelaySeconds => _appSettings.paywallCloseButtonDelay;

  /// Paywall kapatma butonu gösterilsin mi?
  bool get showCloseButton =>
      _appSettings.paywallSettings?.paywallCloseButton ?? true;

  // Periyot kodunu locale string'e çeviren yardımcı fonksiyon
  String getLocalizedPeriod(String? periodCode) {
    if (periodCode == null) return '';
    if (periodCode.contains('D')) return 'per_day'.tr;
    if (periodCode.contains('W')) return 'per_week'.tr;
    if (periodCode.contains('M')) return 'per_month'.tr;
    if (periodCode.contains('Y')) return 'per_year'.tr;
    return '';
  }

  // Paket bilgilerini ve tipini döndüren yardımcı fonksiyon
  Map<String, dynamic> getPackageDisplayInfo(Package package) {
    final intro = package.storeProduct.introductoryPrice;
    final isTrial =
        intro != null && intro.price == 0 && intro.period.isNotEmpty;

    // Trial süresi (örn. '3 Gün Ücretsiz')
    String? trialTitle;
    if (isTrial) {
      final period = intro.period;
      if (period.contains('D')) {
        final days =
            int.tryParse(period.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        trialTitle =
            days > 0
                ? 'trial_title_days'.tr.replaceAll('{days}', days.toString())
                : 'trial_title_days'.tr.replaceAll('{days}', '1');
      } else if (period.contains('W')) {
        final weeks =
            int.tryParse(period.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        trialTitle = weeks > 0 ? 'trial_title_week'.tr : 'trial_title_week'.tr;
      } else if (period.contains('M')) {
        final months =
            int.tryParse(period.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        trialTitle =
            months > 0 ? 'trial_title_month'.tr : 'trial_title_month'.tr;
      } else if (period.contains('Y')) {
        final years =
            int.tryParse(period.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        trialTitle =
            years > 0
                ? '$years ${'per_year'.tr} ${'trial_title_days'.tr.replaceAll('{days}', 'free')}'
                : 'trial_title_days'.tr.replaceAll('{days}', '1');
      }
    }

    // Periyot bilgisi (örn. 'per week')
    String? periodText;

    // Lifetime paketleri için özel periyot bilgisi
    if (package.packageType == PackageType.lifetime) {
      periodText = 'per_lifetime'.tr;
    } else {
      final subPeriod = package.storeProduct.subscriptionPeriod;
      if (subPeriod != null && subPeriod.isNotEmpty) {
        periodText = getLocalizedPeriod(subPeriod);
      }
    }

    // Plan başlığı localization - Dinamik olarak tüm plan tiplerini destekle
    String planTitle = '';
    switch (package.packageType) {
      case PackageType.lifetime:
        planTitle = 'plan_title_lifetime'.tr;
        break;
      case PackageType.annual:
        planTitle = 'plan_title_yearly'.tr;
        break;
      case PackageType.monthly:
        planTitle = 'plan_title_monthly'.tr;
        break;
      case PackageType.weekly:
        planTitle = 'plan_title_weekly'.tr;
        break;
      default:
        planTitle = package.storeProduct.title;
        break;
    }

    // Badge ve renk belirleme - Dinamik olarak plan tipine göre
    String badgeText = '';
    Color badgeColor = Colors.transparent;

    if (isTrial) {
      // Trial planları için
      badgeText = 'free'.tr;
      badgeColor = Colors.white;
    } else {
      // Normal planlar için plan tipine göre badge belirle
      switch (package.packageType) {
        case PackageType.lifetime:
          // Ömür boyu plan için "Best Value" badge'i
          badgeText = 'best_value'.tr;
          badgeColor = const Color(0xFFFF3B30); // Kırmızı
          break;
        case PackageType.annual:
          // Yıllık plan için indirim badge'i (eğer indirim varsa)
          if (discountPercent.value > 0) {
            badgeText = 'save_percent'.tr.replaceAll(
              '{percent}',
              discountPercent.value.toStringAsFixed(0),
            );
            badgeColor = const Color(0xFFFF3B30); // Kırmızı
          }
          break;
        case PackageType.monthly:
          // Aylık plan için badge yok (opsiyonel)
          badgeText = '';
          badgeColor = Colors.transparent;
          break;
        case PackageType.weekly:
          // Haftalık plan için badge yok (opsiyonel)
          badgeText = '';
          badgeColor = Colors.transparent;
          break;
        default:
          // Diğer plan tipleri için badge yok
          badgeText = '';
          badgeColor = Colors.transparent;
          break;
      }
    }

    return {
      'isTrial': isTrial,
      'badgeText': badgeText,
      'badgeColor': badgeColor,
      'trialTitle': trialTitle ?? planTitle,
      'periodText': periodText,
      'planTitle': planTitle,
    };
  }

  @override
  void onInit() {
    super.onInit();

    // Önce servisleri başlat
    premiumConfig = Get.find<PremiumConfigService>();
    _appSettings = Get.find<AppSettingsService>();

    // Premium özellikleri zaten tanımlı

    // Timer animasyonu için controller
    timerController = AnimationController(
      duration: Duration(seconds: closeButtonDelaySeconds),
      vsync: this,
    );

    // Paketleri yükle
    fetchDiscount();

    // Gecikmeli kapatma butonu
    if (delayedCloseButton) {
      timerController.forward();
      timerController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          showXIcon.value = true;
        }
      });
    } else {
      showXIcon.value = true;
    }
  }

  Future<void> fetchDiscount() async {
    try {
      final offerings = await Purchases.getOfferings();
      final offering = offerings.current;
      if (offering == null) return;

      // Paketleri topla ve sırala
      final allPackages = <Package>[];

      // Önce ömür boyu planı ekle (varsa)
      final lifetime = offering.availablePackages.firstWhereOrNull(
        (p) => p.packageType == PackageType.lifetime,
      );
      if (lifetime != null) allPackages.add(lifetime);

      // Sonra yıllık planı ekle (varsa)
      if (offering.annual != null) allPackages.add(offering.annual!);

      // Sonra aylık planı ekle (varsa)
      final monthly = offering.availablePackages.firstWhereOrNull(
        (p) => p.packageType == PackageType.monthly,
      );
      if (monthly != null) allPackages.add(monthly);

      // En son haftalık planı ekle (varsa)
      if (offering.weekly != null) allPackages.add(offering.weekly!);

      // Diğer paketleri de ekle (eğer yukarıda eklenmemişse)
      for (final p in offering.availablePackages) {
        if (!allPackages.contains(p)) allPackages.add(p);
      }

      packages.assignAll(allPackages);

      // Ücretsiz deneme olan planı bul ve seçili yap
      int trialIndex = -1;
      for (int i = 0; i < packages.length; i++) {
        final package = packages[i];
        final intro = package.storeProduct.introductoryPrice;
        final isTrial =
            intro != null && intro.price == 0 && intro.period.isNotEmpty;

        if (isTrial) {
          trialIndex = i;
          break;
        }
      }

      // Eğer ücretsiz deneme varsa onu seç, yoksa ilk planı seç
      if (trialIndex >= 0) {
        selectedPlan.value = trialIndex;
      } else {
        selectedPlan.value = 0; // İlk planı seç
      }

      // İndirim hesaplama (yıllık vs haftalık)
      final annual = offering.annual;
      final weekly =
          offering.weekly ??
          offering.availablePackages.firstWhereOrNull(
            (p) => p.packageType == PackageType.weekly,
          );

      hasTrial.value = offering.weekly != null;

      if (annual != null && weekly != null) {
        final annualPriceDouble = annual.storeProduct.price;
        final weeklyPriceDouble = weekly.storeProduct.price;
        final yearlyFromWeekly = weeklyPriceDouble * 52;

        if (yearlyFromWeekly > 0 && annualPriceDouble > 0) {
          discountPercent.value =
              100 * ((yearlyFromWeekly - annualPriceDouble) / yearlyFromWeekly);
          if (discountPercent.value < 0) discountPercent.value = 0;
        }

        annualPrice.value = annual.storeProduct.priceString;
        weeklyPrice.value = weekly.storeProduct.priceString;
      }

      if (kDebugMode) {
        print('📦 Paketler yüklendi:');
        for (int i = 0; i < packages.length; i++) {
          final package = packages[i];
          final intro = package.storeProduct.introductoryPrice;
          final isTrial =
              intro != null && intro.price == 0 && intro.period.isNotEmpty;
          print(
            '   ${i + 1}. ${package.packageType} - ${package.storeProduct.title} ${isTrial ? '(TRIAL)' : ''}',
          );
        }
        print('🎯 Seçili plan indeksi: ${selectedPlan.value}');
      }
    } catch (e) {
      debugPrint('❌ Paket yükleme hatası: $e');
    }
  }

  @override
  void onClose() {
    timerController.dispose();
    super.onClose();
  }

  // Seçili planı değiştirir
  void selectPlan(int index) {
    selectedPlan.value = index;
  }

  // Ücretsiz deneme anahtarını değiştirir
  void toggleFreeTrial() {
    // This function is no longer used, but keeping it as per instructions
    // freeTrialEnabled.value = !freeTrialEnabled.value;
  }

  // Ekranı kapatır, geri gidilecek sayfa yoksa Home'a yönlendirir
  void closeScreen() {
    if (Get.key.currentState?.canPop() == true) {
      Get.back();
    } else {
      Get.offAllNamed(AppRoutes.home);
    }
  }

  // Trial başlatma fonksiyonu - Dinamik paket seçimi
  Future<void> startTrial() async {
    isPurchasing.value = true;
    try {
      // RevenueCat'ten offerings al
      final offerings = await Purchases.getOfferings();
      final offering = offerings.current;

      if (offering == null) {
        final colors =
            Theme.of(Get.context!).brightness == Brightness.light
                ? AppThemeConfig.primary
                : AppThemeConfig.primary;
        ShrineDialogService.showError(
          'premium_no_packages'.tr,
          colors,
          duration: const Duration(seconds: 3),
        );
        return;
      }

      // Seçili plan indeksini al
      final selectedIndex = selectedPlan.value;
      Package? package;

      // Paketleri kontrol et ve seçili paketi al
      if (packages.isNotEmpty && selectedIndex < packages.length) {
        // Kullanıcının seçtiği paketi al
        package = packages[selectedIndex];
      } else if (packages.isNotEmpty) {
        // Eğer seçili indeks geçersizse ilk paketi al
        package = packages.first;
      }

      if (package == null) {
        final colors =
            Theme.of(Get.context!).brightness == Brightness.light
                ? AppThemeConfig.primary
                : AppThemeConfig.primary;
        ShrineDialogService.showError(
          'premium_no_selected_package'.tr,
          colors,
          duration: const Duration(seconds: 3),
        );
        return;
      }

      // Seçili paketi satın al
      await Purchases.purchasePackage(package);

      // ✅ Başarılı satın alma sonrası - Ana sayfaya yönlendir ve verileri yenile
      await _handleSuccessfulPurchase();
    } catch (e) {
      debugPrint('🔥 Trial başlatma hatası: $e');

      if (e.toString().contains('cancelled')) {
        final colors =
            Theme.of(Get.context!).brightness == Brightness.light
                ? AppThemeConfig.primary
                : AppThemeConfig.primary;
        ShrineDialogService.showInfo(
          'premium_purchase_cancelled'.tr,
          colors,
          duration: const Duration(seconds: 3),
        );
      } else {
        final colors =
            Theme.of(Get.context!).brightness == Brightness.light
                ? AppThemeConfig.primary
                : AppThemeConfig.primary;
        ShrineDialogService.showError(
          'premium_purchase_failed'.tr,
          colors,
          duration: const Duration(seconds: 3),
        );
      }
    } finally {
      isPurchasing.value = false;
    }
  }

  /// Başarılı satın alma sonrası yapılacak işlemler
  Future<void> _handleSuccessfulPurchase() async {
    try {
      if (kDebugMode) {
        print('🔄 Satın alma başarılı - Ana sayfaya yönlendiriliyor...');
      }

      // Kullanıcıya başarı mesajı göster
      final colors =
          Theme.of(Get.context!).brightness == Brightness.light
              ? AppThemeConfig.primary
              : AppThemeConfig.primary;
      ShrineDialogService.showSuccess(
        'premium_activated'.tr,
        colors,
        duration: const Duration(seconds: 3),
      );

      // Önce kullanıcı verilerini güncelle
      if (Get.isRegistered<UserController>()) {
        await userController.getUsers();
        if (kDebugMode) {
          print('✅ Kullanıcı verileri satın alma sonrası güncellendi');
        }
      }

      // Sonra ana sayfaya yönlendir
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Satın alma sonrası işlemlerde hata: $e');
      }
    }
  }

  // Restore işlemini başlatır (Merkezi servis ile)
  Future<void> restorePurchases() async {
    isRestoring.value = true;
    try {
      if (kDebugMode) {
        print('🔄 Premium ekranı restore işlemi başlatılıyor...');
      }

      // Merkezi restore servisi kullan
      final restoreService = Get.find<RestorePremiumService>();
      final success = await restoreService.performCompleteRestore();

      if (!success) {
        // Hata mesajı servis tarafından gösterildi
        if (kDebugMode) {
          print('❌ Premium ekranı restore başarısız');
        }
      } else {
        if (kDebugMode) {
          print('✅ Premium ekranı restore başarılı');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Premium ekranı restore exception: $e');
      }
      final colors =
          Theme.of(Get.context!).brightness == Brightness.light
              ? AppThemeConfig.primary
              : AppThemeConfig.primary;
      ShrineDialogService.showError(
        'premium_restore_error'.tr,
        colors,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isRestoring.value = false;
    }
  }

  /// Şartlar ve koşullar sayfasını açar
  void openTerms() {
    Get.toNamed(AppRoutes.pageDetail, arguments: {'slug': 'terms'});
  }

  /// Gizlilik politikası sayfasını açar
  void openPrivacy() {
    Get.toNamed(AppRoutes.pageDetail, arguments: {'slug': 'privacy'});
  }
}

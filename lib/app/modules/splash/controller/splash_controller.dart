import 'dart:io';

import 'package:gemai/app/core/network/api_client.dart';
import 'package:gemai/app/core/services/app_settings_service.dart';
import 'package:gemai/app/data/api/pages_api_service.dart';
import 'package:gemai/app/modules/auth/controller/user_controller.dart';
import 'package:gemai/app/modules/pages/controller/pages_controller.dart';
import 'package:gemai/app/shared/helpers/my_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:gemai/app/routes/app_routes.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gemai/app/shared/paywall/paywall_service.dart';
import 'package:gemai/app/core/services/revenuecat_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Splash Controller - Uygulama başlangıç işlemlerini yönetir
///
/// KULLANIM ÖRNEĞİ:
/// ```dart
/// // App Settings yükleme
/// await _loadAppSettings();
///
/// // Paywall kontrolü
/// if (_shouldShowPaywallBasedOnSettings()) {
///   Get.offAllNamed(AppRoutes.premium);
/// }
/// ```
class SplashController extends GetxController {
  late final UserController userController;
  final ApiClient apiClient;

  SplashController({required this.apiClient}) {
    userController = Get.put(UserController(apiClient: apiClient));
    // PaywallService'i global olarak ekle (splash için)
    if (!Get.isRegistered<PaywallService>()) {
      Get.put<PaywallService>(PaywallService(), permanent: true);
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Uygulama başlatılırken gerekli tüm işlemleri başlat
    initializeApp();
  }

  /// Uygulama başlangıç işlemlerini yapar
  Future<void> initializeApp() async {
    try {
      if (kDebugMode) {
        print('🚀 Uygulama başlatılıyor...');
      }

      // 1. Uygulama versiyonunu al ve kaydet
      await _loadAppVersion();

      // 2. App Settings'i yükle (öncelikli)
      await _loadAppSettings();

      // 3. Kullanıcı verisini yükle
      await _loadUserData();

      // 4. RevenueCat'i başlat
      await _initializeRevenueCat();

      // 5. Paywall servisini yükle
      await _loadPaywallService();

      // 6. Pages servisini yükle
      await _loadPagesService();

      // 7. Yönlendirme kararı ver
      await _handleNavigation();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Splash initialization error: $e');
      }
      // Hata durumunda fallback yönlendirme
      Get.offAllNamed(AppRoutes.home);
    }
  }

  /// Uygulama versiyonunu alır ve GetStorage'a kaydeder
  Future<void> _loadAppVersion() async {
    try {
      if (kDebugMode) {
        print('📱 Uygulama versiyonu alınıyor...');
      }

      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final String version = packageInfo.version;
      final String buildNumber = packageInfo.buildNumber;
      final String fullVersion = '$version+$buildNumber';

      // GetStorage'a kaydet
      final storage = GetStorage();
      await storage.write(MyHelper.appVersion, fullVersion);

      if (kDebugMode) {
        print('✅ Uygulama versiyonu kaydedildi: $fullVersion');
        print('📋 Version: $version');
        print('🔢 Build Number: $buildNumber');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Uygulama versiyonu alınırken hata: $e');
      }
      // Hata durumunda default versiyon kaydet
      final storage = GetStorage();
      await storage.write(MyHelper.appVersion, '1.0.0+1');
    }
  }

  /// App Settings'i yükler
  Future<void> _loadAppSettings() async {
    try {
      if (kDebugMode) {
        print('📱 App Settings yükleniyor...');
      }
      final appSettingsService = Get.find<AppSettingsService>();
      final success = await appSettingsService.loadSettings();

      if (success) {
        if (kDebugMode) {
          print('✅ App settings başarıyla yüklendi');
          print(
            '📊 Paywall every launch: ${appSettingsService.shouldShowPaywallOnLaunch}',
          );
        }
        if (kDebugMode) {
          print('📧 Contact email: ${appSettingsService.contactEmail}');
          print(
            '⏱️ Close button delay: ${appSettingsService.paywallCloseButtonDelay}s',
          );
        }
      } else {
        if (kDebugMode) {
          print('⚠️ App settings yüklenemedi, default değerler kullanılacak');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ App settings yüklenirken hata: $e');
      }
    }
  }

  /// Kullanıcı verisini yükler
  Future<void> _loadUserData() async {
    try {
      if (kDebugMode) {
        print('👤 Kullanıcı verisi yükleniyor...');
      }

      // Debug: Başlangıçta token'ı kontrol et
      final initialToken = userController.userData.read(MyHelper.bToken);
      if (kDebugMode) {
        print('🔍 Başlangıç token: $initialToken');
      }

      await userController.getUsers();

      // Debug: getUsers() sonrası token'ı kontrol et
      final afterGetUsersToken = userController.userData.read(MyHelper.bToken);
      if (kDebugMode) {
        print('🔍 getUsers() sonrası token: $afterGetUsersToken');
      }

      final token = userController.userData.read(MyHelper.bToken);

      if (token == null || token.isEmpty) {
        if (kDebugMode) {
          print('🆕 Yeni kullanıcı kaydı yapılıyor...');
        }

        // doRegisterAsGuest öncesi token kontrolü
        final beforeRegisterToken = userController.userData.read(
          MyHelper.bToken,
        );
        if (kDebugMode) {
          print('🔍 doRegisterAsGuest öncesi token: $beforeRegisterToken');
        }

        await userController.doRegisterAsGuest();

        // doRegisterAsGuest sonrası token kontrolü
        final afterRegisterToken = userController.userData.read(
          MyHelper.bToken,
        );
        if (kDebugMode) {
          print('🔍 doRegisterAsGuest sonrası token: $afterRegisterToken');
        }

        if (kDebugMode) {
          print('✅ Kullanıcı kaydı tamamlandı');
        }
      } else {
        if (kDebugMode) {
          print('✅ Mevcut kullanıcı bulundu');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Kullanıcı verisi yüklenirken hata: $e');
      }
    }
  }

  /// RevenueCat'i başlatır
  Future<void> _initializeRevenueCat() async {
    try {
      if (kDebugMode) {
        print('💰 RevenueCat başlatılıyor...');
      }
      Get.put(RevenueCatService());

      // Platforma göre doğru API key'i MyHelper'dan çek
      final apiKey =
          Platform.isIOS
              ? MyHelper.revenuecatApiKeyIOS
              : MyHelper.revenuecatApiKeyAndroid;

      final userId = userController.user.value?.id;
      if (userId != null) {
        // RevenueCat SDK başlatılır ve kullanıcı ID'si atanır
        await Get.find<RevenueCatService>().initRevenueCat(
          apiKey: apiKey,
          appUserId: userId.toString(),
        );
        if (kDebugMode) {
          print('✅ RevenueCat başlatıldı $userId');
        }
      } else {
        if (kDebugMode) {
          print('⚠️ User ID bulunamadı, RevenueCat başlatılamadı');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ RevenueCat başlatılırken hata: $e');
      }
    }
  }

  /// Paywall servisini yükler
  Future<void> _loadPaywallService() async {
    try {
      if (kDebugMode) {
        print('🎯 Paywall servisi yükleniyor...');
      }
      final paywallService = Get.find<PaywallService>();
      await paywallService.fetchPaywallConfigFromBackend();
      if (kDebugMode) {
        print('✅ Paywall servisi yüklendi');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Paywall servisi yüklenirken hata: $e');
      }
    }
  }

  /// Yönlendirme kararını verir
  Future<void> _handleNavigation() async {
    if (kDebugMode) {
      print('🚨 _handleNavigation metodu çağrıldı!');
    }
    try {
      if (kDebugMode) {
        print('🧭 Yönlendirme kararı veriliyor...');
        print('🔍 _handleNavigation metodu başladı');
      }

      // Onboarding kontrolü
      final box = GetStorage();
      final completed = box.read(MyHelper.isOnboardingCompleted) ?? false;
      // Legal warning kontrolü kaldırıldı

      if (kDebugMode) {
        print('📊 Onboarding durumu kontrol ediliyor:');
        print(
          '   - MyHelper.isOnboardingCompleted key: ${MyHelper.isOnboardingCompleted}',
        );
        print('   - Okunan değer: $completed');
      }

      await Future.delayed(const Duration(seconds: 4));
      if (!completed) {
        if (kDebugMode) {
          print('📚 Onboarding ekranına yönlendiriliyor...');
        }
        Get.offAllNamed(AppRoutes.onboarding);
        return;
      }

      // Legal warning kontrolü kaldırıldı - direkt paywall kontrolüne geç

      // Paywall kontrolü
      if (_shouldShowPaywallBasedOnSettings()) {
        if (kDebugMode) {
          print('💎 Premium ekranına yönlendiriliyor...');
        }
        Get.offAllNamed(AppRoutes.premium);
        return;
      }

      // Ana ekrana yönlendir
      if (kDebugMode) {
        print('🏠 Ana ekrana yönlendiriliyor...');
      }
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Yönlendirme kararı verilirken hata: $e');
      }
      Get.offAllNamed(AppRoutes.home);
    }
  }

  /// Pages servisini yükler
  Future<void> _loadPagesService() async {
    try {
      if (kDebugMode) {
        print('📄 Pages servisi yükleniyor...');
      }

      // PagesApiService'i global olarak ekle
      if (!Get.isRegistered<PagesApiService>()) {
        Get.put<PagesApiService>(PagesApiService(), permanent: true);
      }

      // PagesController'ı global olarak ekle
      if (!Get.isRegistered<PagesController>()) {
        Get.put<PagesController>(PagesController(), permanent: true);
      }

      if (kDebugMode) {
        print('✅ Pages servisi yüklendi');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Pages servisi yüklenirken hata: $e');
      }
    }
  }

  /// App Settings'e göre paywall gösterilip gösterilmeyeceğini kontrol eder
  bool _shouldShowPaywallBasedOnSettings() {
    try {
      final appSettingsService = Get.find<AppSettingsService>();
      final paywallService = Get.find<PaywallService>();

      // App Settings'den paywall ayarını kontrol et
      final shouldShowFromSettings =
          appSettingsService.shouldShowPaywallOnLaunch;

      // ✅ PREMIUM KONTROLÜ - Premium kullanıcılar için paywall gösterme
      final isPremium = userController.user.value?.isPremium ?? false;
      if (isPremium) {
        if (kDebugMode) {
          print('💎 Premium kullanıcı - Paywall gösterilmeyecek');
        }
        return false;
      }

      if (kDebugMode) {
        print('🎯 Paywall kontrolü:');
        print('   - App Settings: $shouldShowFromSettings');
        print('   - Paywall Service: ${paywallService.shouldShowPaywall()}');
      }

      // Eğer app settings'de her başlangıçta göster denmişse
      if (shouldShowFromSettings) {
        if (kDebugMode) {
          print('✅ Paywall gösterilecek (App Settings)');
        }
        return true;
      }

      // Eğer app settings'de her başlangıçta gösterilmeyecekse,
      // mevcut paywall service mantığını kullan
      final shouldShowFromService = paywallService.shouldShowPaywall();
      if (kDebugMode) {
        print(
          '✅ Paywall gösterilecek (Paywall Service): $shouldShowFromService',
        );
      }
      return shouldShowFromService;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Paywall kontrolü yapılırken hata: $e');
      }
      // Hata durumunda mevcut paywall service mantığını kullan
      final paywallService = Get.find<PaywallService>();
      return paywallService.shouldShowPaywall();
    }
  }
}

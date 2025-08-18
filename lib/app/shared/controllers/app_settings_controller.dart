import 'package:get/get.dart';
import 'package:gemai/app/core/services/app_settings_service.dart';
import 'package:gemai/app/shared/models/app_settings_model.dart';

/// Uygulama ayarları controller'ı - GetX reactive state management
///
/// KULLANIM ÖRNEĞİ:
/// ```dart
/// final controller = Get.find<AppSettingsController>();
///
/// // UI'da reactive kullanım
/// Obx(() {
///   if (controller.isLoading.value) {
///     return CircularProgressIndicator();
///   }
///
///   final settings = controller.settings.value;
///   return Text('Paywall: ${settings?.paywall?.paywallEveryLaunch}');
/// });
/// ```
class AppSettingsController extends GetxController {
  final AppSettingsService _settingsService = Get.find<AppSettingsService>();

  // Reactive state variables
  final RxBool _isLoading = false.obs;
  final RxBool _isLoaded = false.obs;
  final RxString _errorMessage = ''.obs;

  /// Yükleme durumu
  RxBool get isLoading => _isLoading;

  /// Yüklenme durumu
  RxBool get isLoaded => _isLoaded;

  /// Hata mesajı
  RxString get errorMessage => _errorMessage;

  /// Mevcut ayarlar
  Rx<AppSettingsModel?> get settings => _settingsService.settings.obs;

  /// Ayarların yüklenip yüklenmediği
  bool get hasSettings => _settingsService.isLoaded;

  /// Son güncelleme zamanı
  DateTime? get lastUpdate => _settingsService.lastUpdate;

  @override
  void onInit() {
    super.onInit();
    _initializeSettings();
  }

  /// Ayarları başlangıçta yükler
  Future<void> _initializeSettings() async {
    if (!_settingsService.isLoaded) {
      await loadSettings();
    } else {
      _isLoaded.value = true;
    }
  }

  /// Ayarları yükler
  ///
  /// Args:
  /// - forceRefresh: Cache'i bypass eder
  /// - showLoading: Loading indicator gösterir
  ///
  /// Returns:
  /// - bool: Başarılı olup olmadığı
  Future<bool> loadSettings({
    bool forceRefresh = false,
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) {
        _isLoading.value = true;
        _errorMessage.value = '';
      }

      final success = await _settingsService.loadSettings(
        forceRefresh: forceRefresh,
      );

      if (success) {
        _isLoaded.value = true;
        _errorMessage.value = '';
        return true;
      } else {
        _errorMessage.value = 'Ayarlar yüklenemedi';
        return false;
      }
    } catch (e) {
      _errorMessage.value = 'Ayarlar yüklenirken hata: $e';
      return false;
    } finally {
      if (showLoading) {
        _isLoading.value = false;
      }
    }
  }

  /// Ayarları yeniler (force refresh)
  Future<bool> refreshSettings() async {
    return await loadSettings(forceRefresh: true, showLoading: true);
  }

  /// Ayarları temizler
  void clearSettings() {
    _settingsService.clearSettings();
    _isLoaded.value = false;
    _errorMessage.value = '';
  }

  /// Hata mesajını temizler
  void clearError() {
    _errorMessage.value = '';
  }

  // Helper getter'lar - Service'den direkt erişim

  /// Paywall ayarları
  PaywallSettings? get paywallSettings => _settingsService.paywallSettings;

  /// UI ayarları
  UiSettings? get uiSettings => _settingsService.uiSettings;

  /// Reklam ayarları
  AdsSettings? get adsSettings => _settingsService.adsSettings;

  /// Paywall her başlangıçta gösterilsin mi?
  bool get shouldShowPaywallOnLaunch =>
      _settingsService.shouldShowPaywallOnLaunch;

  /// Paywall kapatma butonu gecikmesi (saniye)
  int get paywallCloseButtonDelay => _settingsService.paywallCloseButtonDelay;

  /// İletişim e-posta adresi
  String? get contactEmail => _settingsService.contactEmail;

  /// Reklam sağlayıcısı
  int? get adsProvider => _settingsService.adsProvider;

  /// Belirli bir URL'in geçerli olup olmadığını kontrol eder
  bool isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }

  /// Paywall ayarlarının yüklenip yüklenmediği
  bool get hasPaywallSettings => paywallSettings != null;

  /// UI ayarlarının yüklenip yüklenmediği
  bool get hasUiSettings => uiSettings != null;

  /// Reklam ayarlarının yüklenip yüklenmediği
  bool get hasAdsSettings => adsSettings != null;
}

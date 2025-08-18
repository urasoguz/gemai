import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gemai/app/data/api/settings_api_service.dart';
import 'package:gemai/app/shared/models/app_settings_model.dart';

/// Uygulama ayarları servisi - Ayarları çeker, saklar ve yönetir
///
/// KULLANIM ÖRNEĞİ:
/// ```dart
/// final settingsService = Get.find<AppSettingsService>();
///
/// // Ayarları yükle
/// await settingsService.loadSettings();
///
/// // Ayarlara erişim
/// final settings = settingsService.settings;
/// print('Paywall: ${settings?.paywall?.paywallEveryLaunch}');
/// ```
class AppSettingsService extends GetxService {
  static const String _storageKey = 'app_settings';
  static const String _lastUpdateKey = 'app_settings_last_update';

  final SettingsApiService _apiService = Get.find<SettingsApiService>();
  final GetStorage _storage = GetStorage();

  // Ayarları tutan reactive değişken
  final Rx<AppSettingsModel?> _settings = Rx<AppSettingsModel?>(null);

  /// Mevcut ayarları döner
  AppSettingsModel? get settings => _settings.value;

  /// Ayarların yüklenip yüklenmediğini kontrol eder
  bool get isLoaded => _settings.value != null;

  /// Son güncelleme zamanını döner
  DateTime? get lastUpdate {
    final timestamp = _storage.read(_lastUpdateKey);
    return timestamp != null ? DateTime.parse(timestamp) : null;
  }

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
  }

  /// Local storage'dan ayarları yükler
  void _loadFromStorage() {
    try {
      final data = _storage.read(_storageKey);
      if (data != null) {
        _settings.value = AppSettingsModel.fromJson(data);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Local storage\'dan ayarlar yüklenemedi: $e');
      }
    }
  }

  /// Ayarları local storage'a kaydeder
  void _saveToStorage(AppSettingsModel settings) {
    try {
      _storage.write(_storageKey, settings.toJson());
      _storage.write(_lastUpdateKey, DateTime.now().toIso8601String());
    } catch (e) {
      if (kDebugMode) {
        print('Ayarlar local storage\'a kaydedilemedi: $e');
      }
    }
  }

  /// API'den ayarları çeker ve günceller
  ///
  /// Args:
  /// - forceRefresh: Cache'i bypass eder ve API'den yeniden çeker
  ///
  /// Returns:
  /// - bool: Başarılı olup olmadığı
  Future<bool> loadSettings({bool forceRefresh = false}) async {
    try {
      // Cache kontrolü (1 saat)
      if (!forceRefresh && _isCacheValid()) {
        return true;
      }

      // API'den ayarları çek
      final response = await _apiService.getAppSettings();

      if (response.isSuccess && response.data != null) {
        _settings.value = response.data;
        _saveToStorage(response.data!);
        if (kDebugMode) {
          print('Ayarlar API\'den başarıyla yüklendi');
        }
        return true;
      } else {
        if (kDebugMode) {
          print('Ayarlar API\'den çekilemedi: ${response.message}');
        }
        // API'den veri gelmezse default değerlerle devam et
        _loadDefaultSettings();
        return true; // Default değerlerle devam ettiği için true döner
      }
    } catch (e) {
      if (kDebugMode) {
        print('Ayarlar yüklenirken hata: $e');
      }
      // Hata durumunda da default değerlerle devam et
      _loadDefaultSettings();
      return true; // Default değerlerle devam ettiği için true döner
    }
  }

  /// Default ayarları yükler (API'den veri gelmezse)
  void _loadDefaultSettings() {
    if (kDebugMode) {
      print('Default ayarlar yükleniyor...');
    }
    // Boş bir AppSettingsModel oluştur (default değerler getter'larda kullanılır)
    _settings.value = AppSettingsModel.empty();
  }

  /// Cache'in geçerli olup olmadığını kontrol eder
  bool _isCacheValid() {
    final lastUpdate = this.lastUpdate;
    if (lastUpdate == null) return false;

    // 1 saat cache süresi
    final cacheDuration = Duration(hours: 1);
    final now = DateTime.now();

    return now.difference(lastUpdate) < cacheDuration;
  }

  /// Ayarları temizler (logout durumunda)
  void clearSettings() {
    _settings.value = null;
    _storage.remove(_storageKey);
    _storage.remove(_lastUpdateKey);
  }

  /// Belirli bir ayar grubuna erişim için helper metodlar

  /// Paywall ayarlarını döner
  PaywallSettings? get paywallSettings => _settings.value?.paywall;

  /// UI ayarlarını döner
  UiSettings? get uiSettings => _settings.value?.ui;

  /// Reklam ayarlarını döner
  AdsSettings? get adsSettings => _settings.value?.ads;

  /// Paywall her başlangıçta gösterilsin mi?
  bool get shouldShowPaywallOnLaunch {
    final value =
        paywallSettings?.paywallEveryLaunch ?? _defaultPaywallEveryLaunch;
    if (kDebugMode) {
      print('🔍 AppSettingsService.shouldShowPaywallOnLaunch: $value');
      print(
        '   - paywallSettings?.paywallEveryLaunch: ${paywallSettings?.paywallEveryLaunch}',
      );
      print('   - _defaultPaywallEveryLaunch: $_defaultPaywallEveryLaunch');
    }
    return value;
  }

  /// Paywall kapatma butonu gecikmesi (saniye)
  int get paywallCloseButtonDelay =>
      paywallSettings?.paywallCloseButtonDelay ??
      _defaultPaywallCloseButtonDelay;

  /// İletişim e-posta adresi
  String? get contactEmail => uiSettings?.mail ?? _defaultContactEmail;

  /// Reklam sağlayıcısı
  int? get adsProvider => adsSettings?.adsProvider ?? _defaultAdsProvider;

  // Default değerler - API'den veri gelmezse kullanılır
  static const bool _defaultPaywallEveryLaunch = false;
  static const int _defaultPaywallCloseButtonDelay = 5;
  static const String _defaultContactEmail = 'contact@zyntecllc.com';
  static const int _defaultAdsProvider = 1;
}

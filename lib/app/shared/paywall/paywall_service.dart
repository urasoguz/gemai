import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gemai/app/core/services/app_settings_service.dart';
import 'package:gemai/app/shared/helpers/my_helper.dart';

class PaywallService extends GetxService {
  final box = GetStorage();
  final AppSettingsService _appSettings = Get.find<AppSettingsService>();

  // Backend'den gelen ayarlar (AppSettingsService'den) // Her açılışta gösterilsin mi?
  bool get showOnEveryLaunch {
    final value = _appSettings.shouldShowPaywallOnLaunch;
    if (kDebugMode) {
      print('🔍 PaywallService.showOnEveryLaunch: $value');
    }
    return value;
  }

  // Paywall kapatma butonu gecikmesi (saniye)
  int get closeButtonDelay => _appSettings.paywallCloseButtonDelay;

  // Sadece ilk açılışta gösterilsin mi? (local ayar - değişmeyebilir)
  bool get showOnlyOnFirstLaunch =>
      box.read(MyHelper.paywallFirstLaunch) ?? true;

  // İlk açılışta gösterildi mi? (local ayar)
  bool get firstLaunchShown => box.read(MyHelper.paywallFirstShown) ?? false;
  void markFirstLaunchShown() => box.write(MyHelper.paywallFirstShown, true);

  // Kullanıcı pro mu? (örnek, gerçek kontrol backend'den veya user servisten alınabilir)
  bool get isPro => box.read(MyHelper.isAccountPremium) ?? false;

  /// Paywall gösterilmeli mi?
  /// - Kullanıcı pro ise asla gösterilmez.
  /// - showOnEveryLaunch true ise her açılışta gösterilir (backend'den).
  /// - showOnlyOnFirstLaunch true ise ve ilk açılışsa gösterilir (local).
  bool shouldShowPaywall() {
    if (kDebugMode) {
      print('🔍 PaywallService.shouldShowPaywall() çağrıldı:');
      print('   - isPro: $isPro');
      print('   - showOnEveryLaunch: $showOnEveryLaunch');
      print('   - showOnlyOnFirstLaunch: $showOnlyOnFirstLaunch');
      print('   - firstLaunchShown: $firstLaunchShown');
    }

    if (isPro) {
      if (kDebugMode) {
        print('❌ Kullanıcı pro, paywall gösterilmeyecek');
      }
      return false;
    }

    // Backend'den gelen ayar öncelikli
    if (showOnEveryLaunch) {
      if (kDebugMode) {
        print('✅ Backend ayarı: her açılışta göster');
      }
      return true;
    }

    // Local ayar (fallback)
    if (showOnlyOnFirstLaunch && !firstLaunchShown) {
      if (kDebugMode) {
        print('✅ Local ayar: ilk açılışta göster');
      }
      return true;
    }

    if (kDebugMode) {
      print('❌ Paywall gösterilmeyecek');
    }
    return false;
  }

  /// Ayarları backend'den çekip güncellemek için fonksiyon
  /// Artık AppSettingsService kullanıyor
  Future<void> fetchPaywallConfigFromBackend() async {
    try {
      // AppSettingsService'den ayarları yenile
      final success = await _appSettings.loadSettings(forceRefresh: true);

      if (success) {
        if (kDebugMode) {
          print('Paywall config updated from backend');
          print('Show on every launch: $showOnEveryLaunch');
          print('Close button delay: $closeButtonDelay');
        }
      } else {
        if (kDebugMode) {
          print('Failed to update paywall config from backend');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating paywall config: $e');
      }
    }
  }

  /// Local paywall ayarlarını güncelle (sadece local ayarlar için)
  void updateLocalPaywallSettings({bool? showOnlyOnFirstLaunch}) {
    if (showOnlyOnFirstLaunch != null) {
      box.write(MyHelper.paywallFirstLaunch, showOnlyOnFirstLaunch);
    }
  }

  /// Tüm paywall ayarlarını temizle (logout durumunda)
  void clearPaywallSettings() {
    box.remove(MyHelper.paywallFirstLaunch);
    box.remove(MyHelper.paywallFirstShown);
    box.remove(MyHelper.isAccountPremium);
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ad_service.dart';

class AdShowcaseExample {
  // Reklam gösterim sayaçları ve zaman damgası
  int _interstitialCounter = 0;
  DateTime? _lastInterstitialTime;

  /// Gelişmiş interstitial reklam gösterim fonksiyonu
  /// [every]: Kaç işlemde bir reklam gösterilsin (ör: 2 ise her 2'de 1)
  /// [minInterval]: Reklamlar arası minimum süre (ör: 30sn)
  /// [force]: Tüm kontrolleri atla, reklamı zorla göster
  /// [customCondition]: Ekstra özel bir koşul (örn. premium kullanıcıya gösterme)
  Future<void> showInterstitial({
    int every = 2,
    Duration minInterval = const Duration(seconds: 30),
    bool force = false,
    bool Function()? customCondition,
  }) async {
    // Eğer force true ise veya customCondition sağlanıyorsa reklam göster
    if (force || (customCondition?.call() ?? true)) {
      _interstitialCounter++;
      final now = DateTime.now();
      // Sıklık ve zaman kontrolü
      if (_interstitialCounter % every == 0 &&
          (_lastInterstitialTime == null ||
              now.difference(_lastInterstitialTime!) > minInterval)) {
        _lastInterstitialTime = now;
        try {
          // Aktif sağlayıcıdan reklam göster
          await Get.find<AdService>().activeProvider.showInterstitial();
        } catch (e) {
          // Eğer aktif sağlayıcıda hata olursa fallback sağlayıcıdan göster
          debugPrint('Aktif sağlayıcıda hata: $e, fallback ile deneniyor.');
          await Get.find<AdService>().fallbackProvider.showInterstitial();
        }
      } else {
        // Şartlar sağlanmazsa reklam gösterilmez
        debugPrint('Interstitial atlandı: Sıklık veya zaman limiti.');
      }
    } else {
      // Custom condition sağlanmazsa reklam gösterilmez
      debugPrint('Interstitial atlandı: Custom condition sağlanmadı.');
    }
  }

  /// Örnek kullanım senaryoları
  void exampleUsages() async {
    // Her 3 işlemde bir, 1 dakikadan sık olmamak kaydıyla reklam göster
    await showInterstitial(every: 3, minInterval: Duration(minutes: 1));

    // Premium kullanıcıya reklam gösterme
    bool isPremium = false; // Burada gerçek premium kontrolü yapılmalı
    await showInterstitial(customCondition: () => !isPremium);

    // Reklamı zorla göster (tüm kontrolleri atla)
    await showInterstitial(force: true);
  }
}

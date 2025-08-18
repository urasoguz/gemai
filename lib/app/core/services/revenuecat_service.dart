import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

/// RevenueCat ile ilgili tüm işlemleri yöneten servis sınıfı
/// - Offering (paywall) çekme
/// - Satın alma işlemleri
/// - Restore işlemleri
/// - Listener yönetimi
class RevenueCatService extends GetxService {
  /// RevenueCat SDK başlatılır ve kullanıcı ID'si atanır
  /// [apiKey]: RevenueCat API anahtarı
  /// [appUserId]: Backend'den alınan kullanıcı ID'si
  Future<void> initRevenueCat({
    required String apiKey,
    required String appUserId,
  }) async {
    // RevenueCat SDK başlatılır ve kullanıcıya özel ID atanır
    await Purchases.configure(
      PurchasesConfiguration(apiKey)..appUserID = appUserId,
    );
  }

  /// Tüm offering/paywall'ları çeker
  Future<Offerings?> fetchOfferings() async {
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      return null;
    }
  }

  /// Satın alma işlemi başlatır
  /// [package]: Satın alınacak paket
  /// Dönüş: Satın alma sonrası müşteri bilgisi (CustomerInfo)
  Future<CustomerInfo?> purchasePackage(Package package) async {
    try {
      // Satın alma işlemi başlatılır
      final result = await Purchases.purchasePackage(package);
      return result.customerInfo;
    } catch (e) {
      return null;
    }
  }

  /// Satın alma geçmişini/abonelikleri geri yükler
  Future<CustomerInfo?> restorePurchases() async {
    try {
      return await Purchases.restorePurchases();
    } catch (e) {
      return null;
    }
  }

  /// Abonelik durumunu kontrol eder
  Future<CustomerInfo?> getCustomerInfo() async {
    try {
      return await Purchases.getCustomerInfo();
    } catch (e) {
      return null;
    }
  }

  /// RevenueCat paywall'ı açar (UI olarak)
  /// RevenueCat paywall'ı açar (UI olarak)
  /// Not: RevenueCat Flutter SDK'da doğrudan bir paywall UI fonksiyonu yoktur.
  /// Bu fonksiyon, paywall'ı göstermek için uygun bir navigasyon veya custom widget kullanılmasını önerir.
  static Future<void> showRevenueCatPaywall({required String paywallId}) async {
    try {
      await RevenueCatUI.presentPaywall(
        displayCloseButton: true, // X kapatma butonu göster
        // offeringId: 'default',        // Belirtmek istersen
      );
    } catch (e) {
      if (kDebugMode) {
        print('Paywall açılırken hata: $e');
      }
    }
  }
}

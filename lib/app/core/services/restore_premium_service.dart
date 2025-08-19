import 'package:dermai/app/core/network/api_client.dart';
import 'package:dermai/app/core/services/shrine_dialog_service.dart';
import 'package:dermai/app/core/theme/app_theme_config.dart';
import 'package:dermai/app/data/api/api_endpoints.dart';
import 'package:dermai/app/modules/auth/controller/user_controller.dart';
import 'package:dermai/app/routes/app_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// Merkezi restore premium işlemi servisi
/// Her yerden çağırılabilir ve tüm restore işlemlerini yönetir
class RestorePremiumService {
  final ApiClient _apiClient;

  RestorePremiumService({required ApiClient apiClient})
    : _apiClient = apiClient;

  /// Backend'e restore premium isteği gönderir
  ///
  /// [premiumExpiryDate] - Premium süresinin bitiş tarihi (ISO 8601 format)
  /// [userId] - Bizim kullanıcı ID'miz
  /// [appUserId] - RevenueCat'den gelen app user ID
  /// Returns [bool] - İşlem başarılı mı?
  Future<bool> sendRestoreRequest({
    required String premiumExpiryDate,
    required int userId,
    required String appUserId,
    required dynamic colors,
  }) async {
    try {
      if (kDebugMode) {
        print('🔄 Backend\'e restore isteği gönderiliyor...');
        print('📅 Premium Expiry Date: $premiumExpiryDate');
        print('🆔 User ID: $userId');
        print('👤 App User ID: $appUserId');
      }

      // Backend'e POST isteği gönder
      final response = await _apiClient.postData(ApiEndpoints.restorePurchase, {
        'premium_expiry_date':
            premiumExpiryDate.isNotEmpty == true
                ? premiumExpiryDate
                : '2099-12-31T23:59:59.000Z',
        'user_id': userId,
        'app_user_id': appUserId,
      });

      if (kDebugMode) {
        print('📡 Response Status: ${response.statusCode}');
        print('📋 Response Body: ${response.body}');
      }

      // Backend'den başarılı yanıt geldi mi?
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (kDebugMode) {
          print('✅ Backend restore işlemi başarılı!');
        }

        // Kullanıcı bilgilerini güncelle
        await _updateUserData();

        return true;
      } else {
        if (kDebugMode) {
          print('❌ Backend restore işlemi başarısız: ${response.statusCode}');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Restore service exception: $e');
      }
      return false;
    }
  }

  /// Restore başarılı olduğunda yapılacak işlemler
  Future<void> _handleSuccessfulRestore() async {
    final colors =
        Theme.of(Get.context!).brightness == Brightness.light
            ? AppThemeConfig.primary
            : AppThemeConfig.primary;
    try {
      if (kDebugMode) {
        print('🔄 Restore başarılı - Ana sayfaya yönlendiriliyor...');
      }

      // Kullanıcıya başarı mesajı göster
      ShrineDialogService.showSuccess(
        'restore_purchases_success'.tr,
        colors,
        duration: const Duration(seconds: 3),
      );

      // Ana sayfaya yönlendir
      Get.offAllNamed(AppRoutes.home);

      // Kısa gecikme sonrası kullanıcı verilerini yenile
      Future.delayed(const Duration(milliseconds: 300), () {
        if (Get.isRegistered<UserController>()) {
          Get.find<UserController>().getUsers();
          if (kDebugMode) {
            print('✅ Kullanıcı verileri restore sonrası yenilendi');
          }
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('❌ Restore sonrası işlemlerde hata: $e');
      }
    }
  }

  /// Kullanıcı verilerini günceller
  Future<void> _updateUserData() async {
    try {
      if (kDebugMode) {
        print('🔄 Kullanıcı verileri güncelleniyor...');
      }

      // UserController'ı güvenli şekilde bul
      if (Get.isRegistered<UserController>()) {
        final userController = Get.find<UserController>();
        await userController.getUsers();

        if (kDebugMode) {
          print('✅ Kullanıcı verileri güncellendi');
        }
      } else {
        if (kDebugMode) {
          print(
            '⚠️ UserController kayıtlı değil, kullanıcı güncelleme atlanıyor',
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Kullanıcı verileri güncellenirken hata: $e');
      }
    }
  }

  /// Merkezi restore işlemi - Her yerden çağırılabilir
  ///
  /// RevenueCat restore yapar, backend'e gönderir, kullanıcıyı günceller
  /// Returns [bool] - İşlem başarılı mı?
  Future<bool> performCompleteRestore() async {
    final colors =
        Theme.of(Get.context!).brightness == Brightness.light
            ? AppThemeConfig.primary
            : AppThemeConfig.primary;
    try {
      if (kDebugMode) {
        print('🔄 Merkezi restore işlemi başlatılıyor...');
      }

      // 1. RevenueCat restore işlemi
      final info = await Purchases.restorePurchases();
      final appUserID = await Purchases.appUserID;

      if (kDebugMode) {
        print('📱 RevenueCat restore tamamlandı');
        print('👤 App User ID: $appUserID');
        print('📊 Active entitlements: ${info.entitlements.active.length}');
      }

      // 2. Premium aktif mi kontrol et
      if (info.entitlements.active.isEmpty) {
        if (kDebugMode) {
          print('❌ Aktif premium abonelik bulunamadı');
        }
        ShrineDialogService.showInfo(
          'restore_purchases_info'.tr,
          colors,
          duration: const Duration(seconds: 3),
        );
        return false;
      }

      // 3. Premium expiry date'i al
      final activeEntitlement = info.entitlements.active.values.first;
      final String? premiumExpiryDate = activeEntitlement.expirationDate;
      final String productId = activeEntitlement.productIdentifier;

      // Lifetime aboneliklerde expirationDate null olabilir
      if (premiumExpiryDate == null || premiumExpiryDate.isEmpty) {
        // Lifetime abonelik kontrolü
        if (productId.contains('lifetime') || productId.contains('ömür')) {
          if (kDebugMode) {
            print(
              '✅ Lifetime abonelik tespit edildi - expirationDate null olabilir',
            );
          }
          // Lifetime abonelik için özel işlem
        } else {
          if (kDebugMode) {
            print('❌ Premium expiry date bulunamadı ve lifetime değil');
          }
          ShrineDialogService.showError(
            'restore_purchases_error_premium_expiry_date'.tr,
            colors,
            duration: const Duration(seconds: 3),
          );
          return false;
        }
      }

      // 4. Kullanıcı ID'sini al
      int? userId;

      if (Get.isRegistered<UserController>()) {
        final userController = Get.find<UserController>();
        userId = userController.user.value?.id;
      } else {
        if (kDebugMode) {
          print('⚠️ UserController kayıtlı değil, User ID alınamıyor');
        }
      }

      if (userId == null) {
        if (kDebugMode) {
          print('❌ User ID bulunamadı');
        }
        ShrineDialogService.showError(
          'restore_purchases_error_user_id'.tr,
          colors,
          duration: const Duration(seconds: 3),
        );
        return false;
      }

      if (kDebugMode) {
        print('📅 Premium Expiry Date: $premiumExpiryDate');
        print('🆔 User ID: $userId');
        print('👤 App User ID: $appUserID');
      }

      // 5. Backend'e restore bilgilerini gönder
      final backendSuccess = await sendRestoreRequest(
        colors: colors,
        premiumExpiryDate: premiumExpiryDate ?? '',
        userId: userId,
        appUserId: appUserID,
      );

      if (backendSuccess) {
        // ✅ Restore başarılı - Ana sayfaya yönlendir ve verileri yenile
        await _handleSuccessfulRestore();
        if (kDebugMode) {
          print('✅ Merkezi restore işlemi başarılı');
        }
        return true;
      } else {
        ShrineDialogService.showError(
          'restore_purchases_error_backend'.tr,
          colors,
          duration: const Duration(seconds: 3),
        );
        if (kDebugMode) {
          print('❌ Backend restore işlemi başarısız');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Merkezi restore exception: $e');
      }
      ShrineDialogService.showError(
        'restore_purchases_error_unknown'.tr,
        colors,
        duration: const Duration(seconds: 3),
      );
      return false;
    }
  }
}

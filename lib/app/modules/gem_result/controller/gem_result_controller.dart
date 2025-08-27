import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gemai/app/core/services/sembast_service.dart';
import 'package:gemai/app/data/model/response/scan_result_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gemai/app/shared/helpers/my_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:gemai/app/modules/history/controller/history_controller.dart';
import 'package:gemai/app/modules/home/controller/home_controller.dart';
import 'package:screenshot/screenshot.dart';
import 'package:gemai/app/modules/auth/controller/user_controller.dart';

/// GemAI sonuc sayfası controller'i
/// - Favori/premium/diğer durumları saklar
class GemResultController extends GetxController {
  // Screenshot controller
  final ScreenshotController screenshotController = ScreenshotController();

  // Sekme başlıkları (sıraları sayfadaki bölüm sırası ile eşleşir)
  final List<String> sectionTitles = <String>[
    'Temel',
    'Fiyat',
    'Kimyasal',
    'Astrolojik',
  ];

  /// Aktif sekme index'i
  final RxInt activeTabIndex = 0.obs;

  /// Favori durumu
  final RxBool isFavorite = false.obs;

  /// Kullanıcı premium mu?
  final RxBool isPremium = false.obs;

  /// Yüklenen kayıt
  final Rx<ScanResultModel?> result = Rx<ScanResultModel?>(null);
  final RxBool isLoading = false.obs;
  final SembastService _db = SembastService();

  /// Favori durumunu değiştir
  Future<void> toggleFavorite() async {
    try {
      if (result.value != null) {
        final currentFavorite = isFavorite.value;
        final newFavorite = !currentFavorite;

        if (kDebugMode) {
          print(
            '🔄 GemResult toggleFavorite başladı - ID: ${result.value!.id}, Mevcut: $currentFavorite, Yeni: $newFavorite',
          );
        }

        // Controller'da güncelle
        isFavorite.value = newFavorite;

        // Veritabanında güncelle
        final SembastService db = SembastService();
        await db.updateFavoriteStatus(result.value!.id!, newFavorite);

        // Sonucu güncelle - bu ever listener'ı tetikleyecek
        final updatedResult = result.value!.copyWith(isFavorite: newFavorite);
        result.value = updatedResult;

        // HistoryController'ı da güncelle (eğer mevcut ise)
        try {
          if (Get.isRegistered<HistoryController>()) {
            final historyController = Get.find<HistoryController>();
            // Favorileri yeniden yükle
            await historyController.loadFavorites();
            // Ana listeyi de yeniden yükle
            await historyController.refreshHistory();
            if (kDebugMode) {
              print('✅ HistoryController tamamen güncellendi');
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print('⚠️ HistoryController güncellenemedi: $e');
          }
        }

        // HomeController'ı da güncelle (eğer mevcut ise)
        try {
          if (Get.isRegistered<HomeController>()) {
            final homeController = Get.find<HomeController>();
            // Son işlemleri yeniden yükle
            await homeController.loadRecentItems();
            if (kDebugMode) {
              print('✅ HomeController güncellendi');
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print('⚠️ HomeController güncellenemedi: $e');
          }
        }

        if (kDebugMode) {
          print('✅ Favori durumu güncellendi: $newFavorite');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Favori toggle hatası: $e');
      }
      // Hata durumunda eski duruma geri dön
      isFavorite.value = !isFavorite.value;
    }
  }

  /// ID ile veritabanından kaydı yükler
  Future<void> loadById() async {
    try {
      isLoading.value = true;
      final Object? args = Get.arguments;
      if (kDebugMode) {
        print('🔍 loadById başladı - args: $args');
      }
      if (args is int) {
        final item = await _db.getResult(args);
        if (kDebugMode) {
          print('🔍 Veritabanından yüklenen item: ${item?.type}');
          print('🔍 Item isFavorite: ${item?.isFavorite}');
          print(
            '🔍 Item imagePath: ${item?.imagePath != null ? "Mevcut (${item!.imagePath!.length} karakter)" : "Yok"}',
          );
          print('🔍 Item valuePerCarat: ${item?.valuePerCarat}');
          print(
            '🔍 Item processedValuePerCarat: ${item?.processedValuePerCarat}',
          );
          print('🔍 Item rawValuePerKg: ${item?.rawValuePerKg}');
          if (item?.imagePath != null) {
            print(
              '🔍 ImagePath başlangıcı: ${item!.imagePath!.substring(0, 50)}...',
            );
          }
        }
        result.value = item;
        // isFavorite değeri artık ever listener ile otomatik güncelleniyor
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();

    // Premium durumu storage'dan
    try {
      final premiumStatus = GetStorage().read(MyHelper.isAccountPremium);
      isPremium.value = premiumStatus ?? false;

      if (kDebugMode) {
        print('🔍 Premium durumu kontrol ediliyor...');
        print('🔍 Storage\'dan okunan değer: $premiumStatus');
        print('🔍 isPremium.value: ${isPremium.value}');
        print('🔍 GetStorage instance: ${GetStorage().runtimeType}');
      }

      // UserController'dan da premium durumunu kontrol et
      try {
        if (Get.isRegistered<UserController>()) {
          final userController = Get.find<UserController>();
          final userPremiumStatus =
              userController.user.value?.isPremium ?? false;

          if (kDebugMode) {
            print('🔍 UserController\'dan premium durumu: $userPremiumStatus');
          }

          // Eğer UserController'da premium ise, onu kullan
          if (userPremiumStatus) {
            isPremium.value = true;
            if (kDebugMode) {
              print('✅ UserController\'dan premium durumu güncellendi: true');
            }
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('⚠️ UserController premium kontrolü hatası: $e');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Premium durumu okunamadı: $e');
      }
      isPremium.value = false;
    }

    // result değiştiğinde isFavorite'i güncelle
    ever(result, (ScanResultModel? newResult) {
      if (newResult != null) {
        isFavorite.value = newResult.isFavorite ?? false;
        if (kDebugMode) {
          print('✅ GemResult yüklendi - Favori: ${isFavorite.value}');
        }
      }
    });

    loadById();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:gemai/app/core/services/sembast_service.dart';
import 'package:gemai/app/modules/history/controller/history_controller.dart';

class HomeController extends GetxController {
  /// Seçili sekme (0: Home, 1: History)
  final RxInt selectedTab = 0.obs;

  /// Son işlemler listesi (ana sayfa için)
  final RxList<HistoryItem> recentItems = <HistoryItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadRecentItems();

    // recentItems değiştiğinde debug print
    ever(recentItems, (List<HistoryItem> newItems) {
      if (kDebugMode) {
        print(
          '🔄 HomeController recentItems değişti - Yeni öğe sayısı: ${newItems.length}',
        );
        for (var item in newItems) {
          print(
            '🔄 ID: ${item.id}, Type: ${item.model.type}, isFavorite: ${item.model.isFavorite}',
          );
        }
      }
    });
  }

  /// Son işlemleri yükler
  Future<void> loadRecentItems() async {
    try {
      if (kDebugMode) {
        print('🔄 HomeController loadRecentItems başladı');
      }

      final allItems = await SembastService().getAllResults();

      if (kDebugMode) {
        print('📊 Tüm öğe sayısı: ${allItems.length}');
        if (allItems.isNotEmpty) {
          print('📊 İlk öğe tarihi: ${allItems.first.model.createdAt}');
          print('📊 Son öğe tarihi: ${allItems.last.model.createdAt}');
        }
      }

      // En yeni 5 işlemi al (SembastService zaten yeni → eski sıralamasında döndürüyor)
      final newItems = allItems.take(5).toList();

      if (kDebugMode) {
        print('📊 Yeni öğe sayısı: ${newItems.length}');
        print(
          '📊 Sıralama: En yeni → En eski (SembastService tarafından sağlanıyor)',
        );
        for (var item in newItems) {
          print(
            '📊 ID: ${item.id}, Type: ${item.model.type}, isFavorite: ${item.model.isFavorite}, Tarih: ${item.model.createdAt}',
          );
        }
      }

      // Mevcut listeyi güncelle
      recentItems.assignAll(newItems);

      // UI'ı yeniden build et
      recentItems.refresh();

      // GetBuilder'ı yeniden build et
      update();

      if (kDebugMode) {
        print('✅ HomeController recentItems güncellendi');
        print('✅ Son işlemler sıralaması: En yeni → En eski');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Son işlemler yüklenemedi: $e');
      }
    }
  }

  /// Yeni kayıt eklendiğinde son işlemleri günceller
  void addNewItem(HistoryItem newItem) {
    // Sıralama artık doğru (yeni → eski), sadece listeyi yenile
    loadRecentItems();
  }

  /// Geçmişi yeniden yükler
  Future<void> refreshHistory() async {
    await loadRecentItems();
    // History controller'ı da güncelle
    if (Get.isRegistered<HistoryController>()) {
      final historyController = Get.find<HistoryController>();
      await historyController.refreshHistory();
      await historyController.loadFavorites();
    }
  }

  /// Sekme değiştir
  void changeTab(int index) {
    selectedTab.value = index;
  }

  /// Favori durumu değiştiğinde güncelleme yapar
  Future<void> onFavoriteChanged() async {
    try {
      if (kDebugMode) {
        print('🔄 HomeController favori değişikliği algılandı');
      }

      // Son işlemleri yeniden yükle
      await loadRecentItems();

      // History controller'ı da güncelle
      if (Get.isRegistered<HistoryController>()) {
        final historyController = Get.find<HistoryController>();
        await historyController.loadFavorites();
        if (kDebugMode) {
          print('✅ HomeController güncelleme tamamlandı');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ HomeController güncelleme hatası: $e');
      }
    }
  }
}

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
  }

  /// Son işlemleri yükler
  Future<void> loadRecentItems() async {
    try {
      final allItems = await SembastService().getAllResults();
      // Son 5 işlemi al
      recentItems.value = allItems.take(5).toList();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Son işlemler yüklenemedi: $e');
      }
    }
  }

  /// Yeni kayıt eklendiğinde son işlemleri günceller
  void addNewItem(HistoryItem newItem) {
    recentItems.insert(0, newItem); // En üste ekle
    // 5'ten fazla olursa sonuncuyu kaldır
    if (recentItems.length > 5) {
      recentItems.removeLast();
    }
  }

  /// Geçmişi yeniden yükler
  Future<void> refreshHistory() async {
    await loadRecentItems();
    // History controller'ı da güncelle
    if (Get.isRegistered<HistoryController>()) {
      final historyController = Get.find<HistoryController>();
      await historyController.refreshHistory();
    }
  }

  /// Sekme değiştir
  void changeTab(int index) {
    selectedTab.value = index;
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gemai/app/core/services/sembast_service.dart';

class HistoryController extends GetxController {
  final RxList<HistoryItem> items = <HistoryItem>[].obs;
  final RxList<HistoryItem> favoriteItems = <HistoryItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasMore = true.obs;
  final RxInt selectedTab = 0.obs; // 0: Tümü, 1: Favoriler
  int page = 0;
  final int pageSize = 20;

  // Kaydırma ile sekme değişimi için PageController kullanılır
  final PageController pageController = PageController(initialPage: 0);

  @override
  void onInit() {
    super.onInit();
    fetchNextPage();
    loadFavorites();
  }

  @override
  void onClose() {
    // PageController kaynağını serbest bırakır
    pageController.dispose();
    super.onClose();
  }

  /// Sembast'tan bir sonraki sayfa verileri çeker ve listeye ekler
  /// Veri zaten yeni → eski sıralamasında geldiği için sıralamayı koruyoruz
  Future<void> fetchNextPage() async {
    if (isLoading.value || !hasMore.value) return;
    isLoading.value = true;

    try {
      // SembastService ile tüm veriyi çek (zaten yeni → eski sıralamasında)
      final allItems = await SembastService().getAllResults();

      if (kDebugMode) {
        print('🔍 fetchNextPage - Toplam kayıt sayısı: ${allItems.length}');
        print('🔍 fetchNextPage - Mevcut sayfa: $page');
        print('🔍 fetchNextPage - Sayfa boyutu: $pageSize');
      }

      // Sayfalama işlemini yap - sıralamayı koru
      final int start = page * pageSize;
      final int end = (start + pageSize).clamp(0, allItems.length);

      if (start >= allItems.length) {
        hasMore.value = false;
        isLoading.value = false;
        return;
      }

      final List<HistoryItem> newItems = allItems.sublist(start, end);

      if (kDebugMode) {
        print('🔍 fetchNextPage - Yeni öğe sayısı: ${newItems.length}');
        print(
          '🔍 fetchNextPage - Başlangıç indeksi: $start, Bitiş indeksi: $end',
        );
        if (newItems.isNotEmpty) {
          print(
            '🔍 fetchNextPage - İlk öğe tarihi: ${newItems.first.model.createdAt}',
          );
          print(
            '🔍 fetchNextPage - Son öğe tarihi: ${newItems.last.model.createdAt}',
          );
        }
      }

      // Yeni öğeleri listeye ekle
      items.addAll(newItems);
      page++;

      // Daha fazla veri var mı kontrol et
      if (newItems.length < pageSize) {
        hasMore.value = false;
        if (kDebugMode) {
          print('🔍 fetchNextPage - Daha fazla veri yok, hasMore: false');
        }
      }

      if (kDebugMode) {
        print('🔍 fetchNextPage - Toplam liste boyutu: ${items.length}');
        print('🔍 fetchNextPage - Sonraki sayfa: $page');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ fetchNextPage hatası: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Geçmişi yeniden yükler (yeni kayıt eklendiğinde çağrılır)
  Future<void> refreshHistory() async {
    if (kDebugMode) {
      print('🔄 refreshHistory başladı');
    }

    page = 0;
    hasMore.value = true;
    items.clear();
    await fetchNextPage();

    if (kDebugMode) {
      print('✅ refreshHistory tamamlandı');
    }
  }

  /// Favori öğeleri yükler
  Future<void> loadFavorites() async {
    try {
      if (kDebugMode) {
        print('🔄 loadFavorites başladı');
      }

      final List<HistoryItem> favorites =
          await SembastService().getFavoriteResults();

      if (kDebugMode) {
        print('🔍 loadFavorites - Favori kayıt sayısı: ${favorites.length}');
        if (favorites.isNotEmpty) {
          print(
            '🔍 loadFavorites - İlk favori tarihi: ${favorites.first.model.createdAt}',
          );
          print(
            '🔍 loadFavorites - Son favori tarihi: ${favorites.last.model.createdAt}',
          );
        }
      }

      favoriteItems.value = favorites;

      if (kDebugMode) {
        print('✅ loadFavorites tamamlandı');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Favoriler yüklenemedi: $e');
      }
    }
  }

  /// Favori durumunu değiştirir ve listeleri yeniler
  Future<void> toggleFavorite(int key) async {
    try {
      if (kDebugMode) {
        print('🔄 toggleFavorite başladı - ID: $key');
      }

      await SembastService().toggleFavorite(key);

      if (kDebugMode) {
        print('✅ Veritabanında favori durumu güncellendi');
      }

      // Listeleri tamamen yeniden yükle
      await loadFavorites();

      // Tüm geçmişi yeniden yükle (sayfalama sıfırla)
      page = 0;
      hasMore.value = true;
      items.clear();
      await fetchNextPage();

      if (kDebugMode) {
        print('✅ Listeler yeniden yüklendi');
        print('📊 Toplam öğe sayısı: ${items.length}');
        print('❤️ Favori öğe sayısı: ${favoriteItems.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Favori durumu değiştirilemedi: $e');
      }
    }
  }

  /// Sekme değiştirir ve PageView'a animasyonlu geçiş yapar
  void changeTab(int index) {
    // Seçili sekmeyi güncelle
    selectedTab.value = index;
    // Sayfayı animasyonla değiştir
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// Yeni kayıt eklendiğinde geçmişi günceller
  void addNewItem(HistoryItem newItem) {
    // Sıralama artık doğru (yeni → eski), sadece listeyi yenile
    refreshHistory();
  }
}

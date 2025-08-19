import 'package:get/get.dart';
import 'package:gemai/app/core/services/sembast_service.dart';

class HistoryController extends GetxController {
  final RxList<HistoryItem> items = <HistoryItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasMore = true.obs;
  int page = 0;
  final int pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    fetchNextPage();
  }

  /// Sembast'tan bir sonraki sayfa verileri çeker ve listeye ekler
  Future<void> fetchNextPage() async {
    if (isLoading.value || !hasMore.value) return;
    isLoading.value = true;
    // SembastService ile tüm veriyi çek
    final allItems = await SembastService().getAllResults();
    // Sayfalama işlemini burada yap
    final start = page * pageSize;
    final end = (start + pageSize).clamp(0, allItems.length);
    final newItems =
        start < allItems.length
            ? allItems.sublist(start, end)
            : <HistoryItem>[];
    if (newItems.length < pageSize) hasMore.value = false;
    items.addAll(newItems);
    page++;
    isLoading.value = false;
  }

  /// Geçmişi yeniden yükler (yeni kayıt eklendiğinde çağrılır)
  Future<void> refreshHistory() async {
    page = 0;
    hasMore.value = true;
    items.clear();
    await fetchNextPage();
  }

  /// Yeni kayıt eklendiğinde geçmişi günceller
  void addNewItem(HistoryItem newItem) {
    items.insert(0, newItem); // En üste ekle
  }
}

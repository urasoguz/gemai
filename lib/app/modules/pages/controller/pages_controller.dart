import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:dermai/app/data/api/pages_api_service.dart';
import 'package:dermai/app/data/model/pages/page_model.dart';
import 'package:dermai/app/shared/controllers/lang_controller.dart';

/// Pages controller - Sayfa listesi yönetimi
class PagesController extends GetxController {
  final PagesApiService _pagesApiService = Get.find<PagesApiService>();
  final LangController _langController = Get.find<LangController>();

  // State variables
  final RxList<PageModel> pages = <PageModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      print('📄 PagesController başlatıldı');
    }

    // Dil değişikliğini dinle
    ever(_langController.currentLanguage, (_) {
      if (kDebugMode) {
        print('🌍 Dil değişti, sayfalar yeniden yükleniyor...');
      }
      loadPages();
    });

    // İlk yükleme
    loadPages();
  }

  /// Sayfaları yükler
  Future<void> loadPages() async {
    try {
      if (kDebugMode) {
        print('📄 Sayfalar yükleniyor...');
      }

      isLoading.value = true;
      errorMessage.value = '';

      final response = await _pagesApiService.getPagesListWithCurrentLanguage();

      if (response.success) {
        pages.value = response.data;
        if (kDebugMode) {
          print('✅ ${pages.length} sayfa yüklendi');
          for (final page in pages) {
            print('   - ${page.translation.title} (${page.slug})');
          }
        }
      } else {
        errorMessage.value = 'Sayfalar yüklenemedi';
        if (kDebugMode) {
          print('❌ Sayfalar yüklenemedi');
        }
      }
    } catch (error) {
      errorMessage.value = error.toString();
      if (kDebugMode) {
        print('❌ PagesController.loadPages hatası: $error');
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Sayfaları yeniler
  void refreshPages() => loadPages();

  /// Belirli bir sayfayı bulur
  PageModel? findPageBySlug(String slug) {
    try {
      return pages.firstWhere((page) => page.slug == slug);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Sayfa bulunamadı: $slug');
      }
      return null;
    }
  }

  /// Sayfa var mı kontrol eder
  bool hasPage(String slug) {
    return findPageBySlug(slug) != null;
  }

  @override
  void onClose() {
    if (kDebugMode) {
      print('📄 PagesController kapatıldı');
    }
    super.onClose();
  }
}

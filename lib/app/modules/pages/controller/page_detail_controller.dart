import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:gemai/app/data/api/pages_api_service.dart';
import 'package:gemai/app/data/model/pages/page_detail_model.dart';

/// Page Detail controller - Sayfa detayı yönetimi
class PageDetailController extends GetxController {
  final PagesApiService _pagesApiService = Get.find<PagesApiService>();

  // State variables
  final Rx<PageDetailDataModel?> pageDetail = Rx<PageDetailDataModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString currentSlug = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      print('📄 PageDetailController başlatıldı');
    }
  }

  /// Arguments'dan slug'ı alır ve sayfayı yükler
  void loadPageFromArguments() {
    final arguments = Get.arguments as Map<String, dynamic>?;
    final slug = arguments?['slug'] as String?;

    if (kDebugMode) {
      print('📄 Arguments kontrol ediliyor:');
      print('   - Arguments: $arguments');
      print('   - Slug: $slug');
    }

    if (slug != null && slug.isNotEmpty) {
      loadPageDetail(slug);
    } else {
      if (kDebugMode) {
        print('❌ Slug bulunamadı veya boş');
      }
      errorMessage.value = 'Sayfa bulunamadı';
    }
  }

  /// Sayfa detayını yükler
  Future<void> loadPageDetail(String slug) async {
    try {
      if (kDebugMode) {
        print('📄 Sayfa detayı yükleniyor: $slug');
      }

      isLoading.value = true;
      errorMessage.value = '';
      currentSlug.value = slug;

      final response = await _pagesApiService.getPageDetailWithCurrentLanguage(
        slug: slug,
      );

      if (response.success) {
        pageDetail.value = response.data;
        if (kDebugMode) {
          print('✅ Sayfa detayı yüklendi: ${response.data.page.title}');
        }
      } else {
        errorMessage.value = 'Sayfa detayı yüklenemedi';
        if (kDebugMode) {
          print('❌ Sayfa detayı yüklenemedi');
        }
      }
    } catch (error) {
      errorMessage.value = error.toString();
      if (kDebugMode) {
        print('❌ PageDetailController.loadPageDetail hatası: $error');
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Sayfa detayını yeniler
  void refreshPageDetail() {
    if (currentSlug.value.isNotEmpty) {
      loadPageDetail(currentSlug.value);
    }
  }

  /// Sayfa başlığını alır
  String get pageTitle {
    return pageDetail.value?.translation.title ??
        pageDetail.value?.page.title ??
        'Sayfa';
  }

  /// Sayfa içeriğini alır
  String get pageContent {
    return pageDetail.value?.translation.content ?? '';
  }

  /// Sayfa aktif mi kontrol eder
  bool get isPageActive {
    return pageDetail.value?.page.isActive ?? false;
  }

  @override
  void onClose() {
    if (kDebugMode) {
      print('📄 PageDetailController kapatıldı');
    }
    super.onClose();
  }
}

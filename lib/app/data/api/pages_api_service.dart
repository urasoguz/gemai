import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:gemai/app/data/api/api_endpoints.dart';
import 'package:gemai/app/data/api/base_api_service.dart';
import 'package:gemai/app/data/model/pages/page_model.dart';
import 'package:gemai/app/data/model/pages/page_detail_model.dart';
import 'package:gemai/app/shared/controllers/lang_controller.dart';

/// Pages API servisi
class PagesApiService extends BaseApiService {
  /// Tüm sayfaları getirir
  Future<PagesListResponseModel> getPagesList({String? language}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (language != null) {
        queryParams['lang'] = language;
      }

      final response = await get<Map<String, dynamic>>(
        ApiEndpoints.pages,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
        fromJson: (json) => json,
      );

      if (response.isSuccess && response.data != null) {
        return PagesListResponseModel.fromJson(response.data!);
      }

      throw Exception('Sayfa listesi alınamadı');
    } catch (error) {
      if (kDebugMode) {
        print('❌ PagesApiService.getPagesList hatası: $error');
      }
      rethrow;
    }
  }

  /// Belirli bir sayfanın detayını getirir
  Future<PageDetailResponseModel> getPageDetail({
    required String slug,
    String? language,
  }) async {
    try {
      if (kDebugMode) {
        print('📄 PagesApiService.getPageDetail çağrıldı:');
        print('   - Slug: $slug');
        print('   - Language: $language');
        print('   - Endpoint: ${ApiEndpoints.getPageBySlug(slug)}');
      }

      final queryParams = <String, dynamic>{};
      if (language != null) {
        queryParams['lang'] = language;
      }

      if (kDebugMode) {
        print('   - Query params: $queryParams');
      }

      final response = await get<Map<String, dynamic>>(
        ApiEndpoints.getPageBySlug(slug),
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
        fromJson: (json) => json,
      );

      if (kDebugMode) {
        print('📄 API Response:');
        print('   - Success: ${response.isSuccess}');
        print('   - Status Code: ${response.statusCode}');
        print('   - Message: ${response.message}');
        print('   - Data: ${response.data}');
      }

      if (response.isSuccess && response.data != null) {
        final result = PageDetailResponseModel.fromJson(response.data!);
        if (kDebugMode) {
          print('✅ Sayfa detayı başarıyla parse edildi');
          print('   - Page Title: ${result.data.page.title}');
          print('   - Translation Title: ${result.data.translation.title}');
          print(
            '   - Content Length: ${result.data.translation.content.length}',
          );
        }
        return result;
      }

      throw Exception('Sayfa detayı alınamadı');
    } catch (error) {
      if (kDebugMode) {
        print('❌ PagesApiService.getPageDetail hatası: $error');
      }
      rethrow;
    }
  }

  /// Mevcut dil kodunu alır
  String _getCurrentLanguage() {
    final langController = Get.find<LangController>();
    return langController.currentLanguage.value;
  }

  /// Tüm sayfaları mevcut dil ile getirir
  Future<PagesListResponseModel> getPagesListWithCurrentLanguage() async {
    final language = _getCurrentLanguage();
    return await getPagesList(language: language);
  }

  /// Sayfa detayını mevcut dil ile getirir
  Future<PageDetailResponseModel> getPageDetailWithCurrentLanguage({
    required String slug,
  }) async {
    final language = _getCurrentLanguage();
    return await getPageDetail(slug: slug, language: language);
  }
}

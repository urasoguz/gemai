import 'package:gemai/app/data/api/base_api_service.dart';
import 'package:gemai/app/data/api/api_endpoints.dart';
import 'package:gemai/app/data/model/response/response_model.dart';
import 'package:gemai/app/data/model/gem_analysis/gem_analysis_request_model.dart';
import 'package:gemai/app/data/model/response/scan_result_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// Gem analysis API servisi
///
/// KULLANIM ÖRNEĞİ:
/// ```dart
/// final apiService = Get.find<GemAnalysisApiService>();
///
/// final request = GemAnalysisRequestModel(
///   imageBase64: 'base64_encoded_image_string',
///   language: 'Türkçe',
/// );
///
/// final response = await apiService.analyzeGem(request);
///
/// if (response.isSuccess) {
///   final result = response.data;
///   print('Gem analiz sonucu: ${result?.type}');
/// } else {
///   print('Hata: ${response.message}');
/// }
/// ```
class GemAnalysisApiService extends BaseApiService {
  /// Gem analysis yapar
  ///
  /// Args:
  /// - request: Gem analysis isteği modeli
  ///
  /// Returns:
  /// - ResponseModel<ScanResultModel>: Analiz sonucu veya hata
  Future<ResponseModel<ScanResultModel>> analyzeGem(
    GemAnalysisRequestModel request,
  ) async {
    try {
      if (kDebugMode) {
        print('🔍 Gem Analysis API çağrısı başlatılıyor...');
        print('📊 Request: ${request.toJson()}');
        print('🌐 Endpoint: ${ApiEndpoints.analyze}');
      }

      final response = await post<ScanResultModel>(
        ApiEndpoints.analyze,
        request.toJson(),
        fromJson: (json) {
          if (kDebugMode) {
            print('🔍 Gem Analysis API Response: $json');
          }

          // Başarılı response kontrolü
          if (json is Map<String, dynamic>) {
            if (json['success'] == false) {
              // Hata response'u
              if (kDebugMode) {
                print('❌ Gem Analysis Error Response: $json');
              }
              // Hata durumunda boş ScanResultModel döndür
              return ScanResultModel(type: '', description: '', imagePath: '');
            }

            // Başarılı response - ScanResultModel parse et
            if (json['data'] != null) {
              return ScanResultModel.fromMap(json['data']);
            }
          }

          // Direkt ScanResultModel
          return ScanResultModel.fromMap(json);
        },
      );

      if (response.isSuccess) {
        if (kDebugMode) {
          print('✅ Gem Analysis başarılı');
        }
        return response;
      } else {
        if (kDebugMode) {
          print('❌ Gem Analysis başarısız: ${response.message}');
        }
        return response;
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Gem Analysis API Error: $e');
      }
      return ResponseModel<ScanResultModel>.error(
        message: 'Gem analizi sırasında hata oluştu: $e',
        statusCode: 0,
        code: 0,
      );
    }
  }
}

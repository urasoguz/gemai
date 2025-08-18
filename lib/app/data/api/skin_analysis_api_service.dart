import 'package:gemai/app/data/api/base_api_service.dart';
import 'package:gemai/app/data/api/api_endpoints.dart';
import 'package:gemai/app/data/model/response/response_model.dart';
import 'package:gemai/app/data/model/skin_analysis/skin_analysis_request_model.dart';
import 'package:gemai/app/data/model/response/scan_result_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// Cilt analizi API servisi
///
/// KULLANIM ÖRNEĞİ:
/// ```dart
/// final apiService = Get.find<SkinAnalysisApiService>();
///
/// final request = SkinAnalysisRequestModel(
///   imagePath: '/path/to/image.jpg',
///   age: 25,
///   bodyParts: ['Yüz'],
///   complaints: 'Kaşıntı var',
/// );
///
/// final response = await apiService.analyzeSkin(request);
///
/// if (response.isSuccess) {
///   final result = response.data;
///   print('Analiz sonucu: ${result?.name}');
/// } else {
///   final error = SkinAnalysisErrorModel.fromJson(response.body);
///   print('Hata: ${error.userFriendlyMessage}');
/// }
/// ```
class SkinAnalysisApiService extends BaseApiService {
  /// Cilt analizi yapar
  ///
  /// Args:
  /// - request: Analiz isteği modeli
  ///
  /// Returns:
  // - ResponseModel<ScanResultModel>: Analiz sonucu veya hata
  Future<ResponseModel<ScanResultModel>> analyzeSkin(
    SkinAnalysisRequestModel request,
  ) async {
    try {
      if (kDebugMode) {
        print('🔍 Skin Analysis API çağrısı başlatılıyor...');
        print('📊 Request: ${request.toJson()}');
      }

      final response = await post<ScanResultModel>(
        ApiEndpoints.analyze,
        request.toJson(),
        fromJson: (json) {
          if (kDebugMode) {
            print('🔍 Skin Analysis API Response: $json');
          }

          // Başarılı response kontrolü
          if (json is Map<String, dynamic>) {
            if (json['success'] == false) {
              // Hata response'u - exception fırlatma, ScanResultModel döndür
              if (kDebugMode) {
                print('❌ Skin Analysis Error Response: $json');
              }
              // Hata durumunda boş ScanResultModel döndür
              return ScanResultModel(
                name: '',
                altName: '',
                description: '',
                symptoms: [],
                treatment: [],
                severityRatio: '',
                category: '',
                contagious: '',
                bodyParts: [],
                riskFactors: [],
                prevention: [],
                recoveryTime: '',
                alternativeTreatments: [],
                imagePath: '',
              );
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
          print('✅ Skin Analysis başarılı');
        }
        return response;
      } else {
        if (kDebugMode) {
          print('❌ Skin Analysis başarısız: ${response.message}');
        }
        return response;
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Skin Analysis API Error: $e');
      }
      return ResponseModel<ScanResultModel>.error(
        message: 'scan_dialog_500'.tr,
        statusCode: 0,
        code: 0,
      );
    }
  }
}

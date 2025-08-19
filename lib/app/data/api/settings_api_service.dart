import 'package:dermai/app/data/api/base_api_service.dart';
import 'package:dermai/app/data/api/api_endpoints.dart';
import 'package:dermai/app/data/model/response/response_model.dart';
import 'package:dermai/app/shared/models/app_settings_model.dart';
import 'package:flutter/foundation.dart';

// Ayarlar API servisi - Uygulama ayarlarını çeker
//
// KULLANIM ÖRNEĞİ:
// ```dart
// final settingsService = Get.find<SettingsApiService>();
//
// // Ayarları çek
// final response = await settingsService.getAppSettings();
//
// if (response.isSuccess) {
//   final settings = response.data;
//   print('Paywall: ${settings?.paywall?.paywallEveryLaunch}');
//   print('Contact: ${settings?.ui?.mail}');
// }
// ```
class SettingsApiService extends BaseApiService {
  // Uygulama ayarlarını çeker
  //
  // Backend'den tüm ayarları alır ve AppSettingsModel olarak döner
  //
  // Returns:
  // - ResponseModel<AppSettingsModel>: Ayarlar yanıtı
  Future<ResponseModel<AppSettingsModel>> getAppSettings() async {
    try {
      // API key header'ı ekle
      final headers = {
        'X-API-Key': ApiEndpoints.appApiKey,
        'Content-Type': 'application/json',
      };

      final response = await get<AppSettingsModel>(
        ApiEndpoints.appSettings,
        headers: headers,
        fromJson: (json) {
          if (kDebugMode) {
            print('🔍 SettingsApiService - Raw JSON: $json');
          }

          // API response'unda data kısmını al
          Map<String, dynamic> dataJson;
          if (json is Map<String, dynamic> && json.containsKey('data')) {
            dataJson = json['data'];
            if (kDebugMode) {
              print('🔍 SettingsApiService - Data JSON: $dataJson');
            }
          } else {
            dataJson = json;
            if (kDebugMode) {
              print('🔍 SettingsApiService - No data wrapper, using raw JSON');
            }
          }

          // JSON'ı parse et
          final settings = AppSettingsModel.fromJson(dataJson);

          if (kDebugMode) {
            print('🔍 SettingsApiService - Parsed Settings:');
            print('   - Paywall: ${settings.paywall}');
            print(
              '   - Paywall Every Launch: ${settings.paywall?.paywallEveryLaunch}',
            );
            print('   - UI: ${settings.ui}');
            print('   - Ads: ${settings.ads}');
          }

          return settings;
        },
      );

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('❌ SettingsApiService Error: $e');
      }
      return ResponseModel<AppSettingsModel>.error(
        message: 'Ayarlar çekilemedi: $e',
        statusCode: 0,
      );
    }
  }
}

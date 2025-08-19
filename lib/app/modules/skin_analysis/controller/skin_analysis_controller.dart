import 'package:dermai/app/core/theme/app_theme_config.dart';
import 'package:dermai/app/routes/app_routes.dart';
import 'package:dermai/app/shared/helpers/my_helper.dart';
import 'package:dermai/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dermai/app/data/api/skin_analysis_api_service.dart';
import 'package:dermai/app/data/model/skin_analysis/skin_analysis_request_model.dart';
import 'package:dermai/app/data/model/response/scan_result_model.dart';
import 'package:dermai/app/core/services/sembast_service.dart';
import 'package:dermai/app/data/api/api_endpoints.dart';
import 'package:dermai/app/core/services/image_processing_service.dart';
import 'package:dermai/app/modules/home/controller/home_controller.dart';
import 'package:dermai/app/modules/history/controller/history_controller.dart';
import 'package:dermai/app/core/services/shrine_dialog_service.dart';
//import 'package:dermai/app/modules/auth/controller/user_controller.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dermai/app/core/localization/languages.dart';

/// Cilt analizi controller'ı
/// Yaş, etkilenen bölgeler ve şikayetler yönetimi
class SkinAnalysisController extends GetxController {
  // API Service
  final SkinAnalysisApiService _apiService = Get.find<SkinAnalysisApiService>();
  final SembastService _sembastService = Get.find<SembastService>();
  final ImageProcessingService _imageService = ImageProcessingService();
  final GetStorage userData = GetStorage();

  // Seçilen yaş
  final RxInt selectedAge = 25.obs;

  // Seçilen etkilenen bölgeler
  final RxList<String> selectedBodyParts = <String>[].obs;

  // Şikayetler metni
  final RxString complaints = ''.obs;

  // Görsel yolu
  final RxString imagePath = ''.obs;

  // Loading durumu
  final RxBool isLoading = false.obs;

  // UI durumu - analiz sırasında tüm widget'ları disable etmek için
  final RxBool isAnalyzing = false.obs;

  // Hata durumu
  final RxString errorMessage = ''.obs;

  // Yaş listesi
  final List<int> ageList = List.generate(100, (index) => index + 1);

  // Vücut bölgeleri
  final List<String> bodyParts = [
    'skin_analysis_body_parts_face'.tr,
    'skin_analysis_body_parts_hair'.tr,
    'skin_analysis_body_parts_ear'.tr,
    'skin_analysis_body_parts_neck'.tr,
    'skin_analysis_body_parts_hand'.tr,
    'skin_analysis_body_parts_leg'.tr,
    'skin_analysis_body_parts_chest'.tr,
    'skin_analysis_body_parts_breast'.tr,
    'skin_analysis_body_parts_back'.tr,
    'skin_analysis_body_parts_leg_foot'.tr,
    'skin_analysis_body_parts_foot'.tr,
    'skin_analysis_body_parts_sex'.tr,
  ];

  @override
  void onInit() {
    super.onInit();
    // Argümanlardan görsel yolunu al
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null && arguments['imagePath'] != null) {
      imagePath.value = arguments['imagePath'] as String;
    }
    if (kDebugMode) {
      print('📸 Skin Analysis başlatıldı - Görsel: ${imagePath.value}');
    }
  }

  /// Yaş seçer
  void selectAge(int age) {
    if (!isAnalyzing.value) {
      // 0 değerini 1'e çevir
      selectedAge.value = age == 0 ? 1 : age;
      if (kDebugMode) {
        print('👤 Yaş seçildi: ${selectedAge.value}');
      }
    }
  }

  /// Vücut bölgesi seçer/kaldırır
  void toggleBodyPart(String bodyPart) {
    if (isAnalyzing.value) return;

    if (selectedBodyParts.contains(bodyPart)) {
      selectedBodyParts.remove(bodyPart);
      if (kDebugMode) {
        print('❌ Bölge kaldırıldı: $bodyPart');
      }
    } else {
      selectedBodyParts.add(bodyPart);
      if (kDebugMode) {
        print('✅ Bölge eklendi: $bodyPart');
      }
    }
  }

  /// Şikayetleri günceller
  void updateComplaints(String text) {
    if (!isAnalyzing.value) {
      complaints.value = text;
    }
  }

  /// Local token'ı düşürür
  void _decrementLocalToken() {
    try {
      final isPremium = userData.read(MyHelper.isAccountPremium) ?? false;
      final currentToken = userData.read(MyHelper.accountRemainingToken) ?? 0;
      if (currentToken > 0 && !isPremium) {
        // Premium olmayan kullanıcılar için token düşürülür
        final newToken = currentToken - 1;
        userData.write(MyHelper.accountRemainingToken, newToken);
        if (kDebugMode) {
          print('📉 Local token düşürüldü: $currentToken → $newToken');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Token düşürme hatası: $e');
      }
    }
  }

  /// Token ve premium durumunu kontrol eder
  bool _checkTokenAndPremiumStatus() {
    final colors =
        Theme.of(Get.context!).brightness == Brightness.light
            ? AppThemeConfig.colors
            : AppThemeConfig.colors;
    try {
      // GetStorage'dan direkt oku
      final remainingToken = userData.read(MyHelper.accountRemainingToken) ?? 0;
      final isPremium = userData.read(MyHelper.isAccountPremium) ?? false;

      if (remainingToken <= 0) {
        if (isPremium) {
          // Premium kullanıcı ama token bitti
          ShrineDialogService.showWarning(
            'skin_analysis_token_error_premium'.tr,
            colors,
          );
        } else {
          // Premium olmayan kullanıcı, token bitti
          // ShrineDialogService.showInfo(
          //   'Analiz yapmak için premium üyeliğe geçmeniz gerekiyor.',
          // );
          Get.toNamed(AppRoutes.premium); // Geri dönebilir şekilde
          // Future.delayed(const Duration(seconds: 2), () {
          //   Get.toNamed(AppRoutes.premium); // Geri dönebilir şekilde
          // });
        }
        return false;
      }

      return true; // Token yeterli
    } catch (e) {
      if (kDebugMode) {
        print('❌ Token kontrol hatası: $e');
      }
      ShrineDialogService.showError('skin_analysis_token_error'.tr, colors);
      return false;
    }
  }

  /// Analizi başlatır
  Future<void> startAnalysis() async {
    final colors =
        Theme.of(Get.context!).brightness == Brightness.light
            ? AppThemeConfig.colors
            : AppThemeConfig.colors;
    // Validasyon
    if (selectedBodyParts.isEmpty) {
      ShrineDialogService.showError(
        'skin_analysis_body_parts_error'.tr,
        colors,
      );
      return;
    }

    if (complaints.value.trim().isEmpty) {
      ShrineDialogService.showError(
        'skin_analysis_complaints_error'.tr,
        colors,
      );
      return;
    }

    if (imagePath.value.isEmpty) {
      ShrineDialogService.showError('skin_analysis_image_error'.tr, colors);
      return;
    }

    // Token kontrolü - Analiz başlamadan önce
    if (!_checkTokenAndPremiumStatus()) {
      return; // Token yetersizse analiz başlatma
    }

    try {
      // UI'ı analiz moduna geçir
      isAnalyzing.value = true;
      isLoading.value = true;
      errorMessage.value = '';

      if (kDebugMode) {
        print('🔍 Cilt analizi başlatılıyor...');
        print('📊 Veriler:');
        print('  - Yaş: ${selectedAge.value}');
        print('  - Bölgeler: ${selectedBodyParts.join(', ')}');
        print('  - Şikayetler: ${complaints.value}');
        print('  - Görsel: ${imagePath.value}');
      }
      // Görseli Base64'e dönüştür (API için - sıkıştırılmamış)
      final String imageBase64 = await _imageService.convertToBase64(
        imagePath.value,
      );

      // Görseli sıkıştır ve Base64'e dönüştür (Sembast için)
      final String compressedBase64 = await _imageService
          .compressAndConvertToBase64(
            imagePath.value,
            maxWidth: 800,
            quality: 80,
          );

      // API isteği oluştur
      final request = SkinAnalysisRequestModel(
        imageBase64: imageBase64,
        age: selectedAge.value,
        bodyParts: selectedBodyParts.toList(),
        complaints: complaints.value.trim(),
        language:
            Languages.getLanguageName(langController.currentLanguage.value) ??
            'English',
      );

      // API çağrısı yap
      if (kDebugMode) {
        print('🔍 API çağrısı yapılıyor...');
        print('📊 Request JSON: ${request.toJson()}');
        print('🔑 API Key: ${ApiEndpoints.appApiKey}');
        print('🌐 Endpoint: ${ApiEndpoints.analyze}');
      }

      final response = await _apiService.analyzeSkin(request);

      if (kDebugMode) {
        print('🔍 API Response:');
        print('  - Success: ${response.isSuccess}');
        print('  - Status Code: ${response.statusCode}');
        print('  - Backend Code: ${response.code}');
        print('  - Message: ${response.message}');
        print('  - Data: ${response.data}');
      }

      if (response.isSuccess && response.data != null) {
        if (kDebugMode) {
          print('✅ Analiz başarılı');
        }

        // API başarılı olduğunda token'ı düşür
        _decrementLocalToken();

        // Sonucu veritabanına kaydet
        final int savedId = await _saveAnalysisResult(
          response.data!,
          compressedBase64,
        );

        // Geçmişi güncelle (reactif olarak)
        _updateHistoryAfterSuccess(savedId, response.data!, compressedBase64);

        // Result sayfasına git (ID ile)
        Get.offNamed(AppRoutes.result, arguments: savedId);
      } else {
        if (kDebugMode) {
          print('❌ Analiz başarısız: ${response.message}');
        }

        // Yeni API response yapısına uygun hata handling
        if (response.code != null) {
          // Backend'den gelen hata kodu
          ShrineDialogService.handleError(response.code!, response.message);
        } else {
          // HTTP status code kullan
          ShrineDialogService.handleError(
            response.statusCode,
            response.message,
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Analiz hatası: $e');
        print('🔍 Hata mesajı analizi:');
        print('  - Tip: ${e.runtimeType}');
        print('  - String: ${e.toString()}');
        print(
          '  - Contains Token?: ${e.toString().contains('Token hakkınız kalmamış')}',
        );
        print(
          '  - Contains token (lower)?: ${e.toString().toLowerCase().contains('token hakkınız kalmamış')}',
        );
      }

      // Bilinmeyen hata
      ShrineDialogService.showError('skin_analysis_error'.tr, colors);
    } finally {
      // UI'ı normal moda geçir
      isAnalyzing.value = false;
      isLoading.value = false;
    }
  }

  /// Analiz sonucunu veritabanına kaydeder
  ///
  /// Args:
  /// - result: ScanResultModel
  /// - base64Image: Base64 encoded görsel
  ///
  /// Returns:
  /// - int: Kaydedilen kaydın ID'si
  Future<int> _saveAnalysisResult(
    ScanResultModel result,
    String base64Image,
  ) async {
    try {
      // createdAt alanını ekle
      final resultWithDate = ScanResultModel(
        name: result.name,
        altName: result.altName,
        description: result.description,
        symptoms: result.symptoms,
        treatment: result.treatment,
        severityRatio: result.severityRatio,
        category: result.category,
        contagious: result.contagious,
        bodyParts: result.bodyParts,
        riskFactors: result.riskFactors,
        prevention: result.prevention,
        recoveryTime: result.recoveryTime,
        alternativeTreatments: result.alternativeTreatments,
        imagePath: result.imagePath,
        createdAt: DateTime.now(), // Şu anki tarih/saat
        optimizationInfo: result.optimizationInfo, // Yeni field
        reference: result.reference, // Reference field eklendi
      );

      final int id = await _sembastService.addScanResult(
        resultWithDate,
        base64Image: base64Image,
      );
      if (kDebugMode) {
        print('💾 Analiz sonucu kaydedildi - ID: $id');
      }
      return id;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Analiz sonucu kaydedilemedi: $e');
      }
      rethrow;
    }
  }

  /// Başarılı analiz sonrası geçmişi günceller
  void _updateHistoryAfterSuccess(
    int id,
    ScanResultModel result,
    String base64Image,
  ) {
    try {
      // createdAt alanını ve base64 görseli ekle
      final resultWithDate = ScanResultModel(
        name: result.name,
        altName: result.altName,
        description: result.description,
        symptoms: result.symptoms,
        treatment: result.treatment,
        severityRatio: result.severityRatio,
        category: result.category,
        contagious: result.contagious,
        bodyParts: result.bodyParts,
        riskFactors: result.riskFactors,
        prevention: result.prevention,
        recoveryTime: result.recoveryTime,
        alternativeTreatments: result.alternativeTreatments,
        imagePath: base64Image, // BASE64 GÖRSELİ BURADA KULLAN
        createdAt: DateTime.now(), // Şu anki tarih/saat
        optimizationInfo: result.optimizationInfo, // Yeni field
        reference: result.reference, // Reference field eklendi
      );

      // HistoryItem oluştur
      final newItem = HistoryItem(id, resultWithDate);

      // Home controller'ı güncelle (ana sayfa son işlemler)
      if (Get.isRegistered<HomeController>()) {
        final homeController = Get.find<HomeController>();
        homeController.addNewItem(newItem);
      }

      // History controller'ı güncelle (geçmiş sayfası)
      if (Get.isRegistered<HistoryController>()) {
        final historyController = Get.find<HistoryController>();
        historyController.addNewItem(newItem);
      }

      if (kDebugMode) {
        print('🔄 Geçmiş güncellendi - Yeni kayıt ID: $id');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Geçmiş güncellenirken hata: $e');
      }
    }
  }

  /// Hata mesajını temizler
  void clearError() {
    errorMessage.value = '';
  }

  @override
  void onClose() {
    if (kDebugMode) {
      print('📱 Skin Analysis controller kapatıldı');
    }
    super.onClose();
  }
}

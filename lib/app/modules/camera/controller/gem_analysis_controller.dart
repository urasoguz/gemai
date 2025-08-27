// lib/app/modules/camera/controller/gem_analysis_controller.dart
// GemAI analiz işlemleri için controller
//
// KULLANIM ÖRNEĞİ:
// ```dart
// final analysisController = Get.find<GemAnalysisController>();
// await analysisController.performGemAnalysis(imagePath);
// ```

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gemai/app/data/api/gem_analysis_api_service.dart';
import 'package:gemai/app/data/model/gem_analysis/gem_analysis_request_model.dart';
import 'package:gemai/app/data/model/response/scan_result_model.dart';
import 'package:gemai/app/data/model/response/response_model.dart';
import 'package:gemai/app/core/services/image_processing_service.dart';
import 'package:gemai/app/core/services/shrine_dialog_service.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:gemai/app/core/localization/languages.dart';
import 'package:gemai/app/shared/controllers/lang_controller.dart';
import 'package:gemai/app/shared/helpers/my_helper.dart';
import 'package:gemai/app/core/services/sembast_service.dart';
import 'package:gemai/app/routes/app_routes.dart';
import 'package:gemai/app/modules/home/controller/home_controller.dart';
import 'package:gemai/app/modules/history/controller/history_controller.dart';

/// GemAI analiz işlemleri için controller
/// Hata yönetimi, API çağrıları ve sonuç işleme
class GemAnalysisController extends GetxController {
  // Dependencies
  final GemAnalysisApiService _apiService = Get.find<GemAnalysisApiService>();
  final ImageProcessingService _imageService =
      Get.find<ImageProcessingService>();

  // State variables
  final RxBool isAnalyzing = false.obs;
  final RxDouble scanProgress = 0.0.obs;
  final RxString errorMessage = ''.obs;

  // Son kullanılan görsel yolu (retake sheet için)
  final RxString lastImagePath = ''.obs;

  // Analysis result
  final Rx<ScanResultModel?> analysisResult = Rx<ScanResultModel?>(null);

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      print('🔍 GemAnalysisController başlatıldı');
    }
  }

  /// Gem analizi yapar
  ///
  /// Args:
  /// - imagePath: Analiz edilecek görsel dosya yolu
  ///
  /// Returns:
  /// - bool: Analiz başarılı mı?
  Future<bool> performGemAnalysis(String imagePath) async {
    try {
      if (kDebugMode) {
        print('🔍 GemAI analizi başlatılıyor...');
      }

      lastImagePath.value = imagePath;

      // UI'ı analiz moduna geçir
      isAnalyzing.value = true;
      scanProgress.value = 0.0;
      errorMessage.value = '';
      analysisResult.value = null;

      // Progress animasyonunu başlat
      _startProgressAnimation();

      // Gerçek API çağrısını yap
      final success = await _performGemAnalysis(imagePath);

      if (success) {
        scanProgress.value = 1.0;
        await Future.delayed(const Duration(milliseconds: 500));

        // 🚨 YENİ: Başarılı analiz sonrası token düşür
        _decrementLocalToken();

        // Başarılı analiz sonrası veritabanına kaydet ve result sayfasına git
        await _handleSuccessfulAnalysis(imagePath);

        if (kDebugMode) {
          print('✅ Gem Analysis tamamlandı');
        }

        return true;
      } else {
        if (kDebugMode) {
          print('❌ Gem Analysis başarısız');
        }
        return false;
      }
    } catch (error) {
      if (kDebugMode) {
        print('❌ Gem Analysis exception: $error');
      }
      _handleAnalysisError(error);
      return false;
    } finally {
      isAnalyzing.value = false;
    }
  }

  /// Local token'ı düşürür
  void _decrementLocalToken() {
    try {
      final userData = GetStorage();
      final isPremium = userData.read(MyHelper.isAccountPremium) ?? false;
      final currentToken = userData.read(MyHelper.accountRemainingToken) ?? 0;

      if (currentToken > 0 && !isPremium) {
        // Premium olmayan kullanıcılar için token düşürülür
        final newToken = currentToken - 1;
        userData.write(MyHelper.accountRemainingToken, newToken);

        if (kDebugMode) {
          print('📉 Local token düşürüldü: $currentToken → $newToken');
        }
      } else if (isPremium) {
        if (kDebugMode) {
          print('💎 Premium kullanıcı - token düşürülmedi');
        }
      } else {
        if (kDebugMode) {
          print('⚠️ Token zaten 0 - düşürülemedi');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Token düşürme hatası: $e');
      }
    }
  }

  /// Gerçek API çağrısını yapar
  Future<bool> _performGemAnalysis(String imagePath) async {
    try {
      // Görseli Base64'e çevir
      final base64Image = await _imageService.convertToBase64(imagePath);

      // Dil bilgisini al
      final langController = Get.find<LangController>();
      final language =
          Languages.getLanguageName(langController.currentLanguage.value) ??
          'English';

      // API isteği için model oluştur
      final request = GemAnalysisRequestModel(
        imageBase64: base64Image,
        language: language,
      );

      if (kDebugMode) {
        print('📤 API isteği gönderiliyor...');
        print('🌐 Dil: $language');
        print('📷 Görsel boyutu: ${base64Image.length} karakter');
      }

      // API çağrısını yap
      final response = await _apiService.analyzeGem(request);

      if (response.isSuccess) {
        _handleAnalysisResults(response.data);
        return true;
      } else {
        // 1001-1004 retake sheet
        final int? backendCode = response.code;
        if (backendCode != null) {
          final RetakeReason? reason = _mapBackendCodeToReason(backendCode);
          if (reason != null) {
            await ShrineDialogService.showRetakeGuide(
              imagePath: imagePath,
              reason: reason,
            );
          }
        }
        _handleApiResponseError(response);
        return false;
      }
    } catch (error) {
      if (kDebugMode) {
        print('❌ API çağrısı hatası: $error');
      }
      _handleAnalysisError(error);
      return false;
    }
  }

  /// Başarılı analiz sonrası veritabanına kaydet ve result sayfasına git
  Future<void> _handleSuccessfulAnalysis(String imagePath) async {
    try {
      if (kDebugMode) {
        print('🔍 _handleSuccessfulAnalysis başladı - imagePath: $imagePath');
      }

      // Görseli sıkıştır ve Base64'e dönüştür (Sembast için)
      final String compressedBase64 = await _imageService
          .compressAndConvertToBase64(imagePath, maxWidth: 800, quality: 80);

      if (kDebugMode) {
        print(
          '🔍 Görsel sıkıştırıldı - Boyut: ${compressedBase64.length} karakter',
        );
      }

      // Sonucu veritabanına kaydet
      final int savedId = await _saveAnalysisResult(
        analysisResult.value!,
        compressedBase64,
      );

      if (kDebugMode) {
        print('🔍 Analiz sonucu kaydedildi - ID: $savedId');
      }

      // Geçmişi güncelle (reactif olarak)
      _updateHistoryAfterSuccess(
        savedId,
        analysisResult.value!,
        compressedBase64,
      );

      if (kDebugMode) {
        print('🔍 Geçmiş güncellendi, gem_result sayfasına yönlendiriliyor...');
      }

      // Result sayfasına git (ID ile)
      Get.offNamed(AppRoutes.gemResult, arguments: savedId);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Başarılı analiz sonrası işlem hatası: $e');
      }
      // Hata durumunda mevcut akışa devam et (RAM'de tut)
    }
  }

  /// Analiz sonucunu veritabanına kaydeder
  Future<int> _saveAnalysisResult(
    ScanResultModel result,
    String base64Image,
  ) async {
    try {
      // SembastService'in register edilip edilmediğini kontrol et
      if (!Get.isRegistered<SembastService>()) {
        if (kDebugMode) {
          print('❌ SembastService henüz register edilmemiş');
        }
        throw Exception('SembastService not registered');
      }

      final sembastService = Get.find<SembastService>();

      if (kDebugMode) {
        print(
          '🔍 _saveAnalysisResult - Base64 görsel boyutu: ${base64Image.length} karakter',
        );
        print(
          '🔍 _saveAnalysisResult - Base64 görsel başlangıcı: ${base64Image.substring(0, 50)}...',
        );
      }

      // Şu anki tarihi al
      final now = DateTime.now();
      if (kDebugMode) {
        print('🔍 _saveAnalysisResult - Şu anki tarih: $now');
        print('🔍 _saveAnalysisResult - ISO string: ${now.toIso8601String()}');
      }

      // Model'i toMap ile JSON'a çevir, createdAt ekle, tekrar model'e çevir
      final resultMap = result.toMap();
      resultMap['createdAt'] = now.toIso8601String(); // ISO formatında tarih
      resultMap['created_at'] = now.toIso8601String(); // Eski key'i de ekle
      resultMap['imagePath'] = base64Image; // imagePath field'ına da ekle

      if (kDebugMode) {
        print(
          '🔍 _saveAnalysisResult - resultMap createdAt: ${resultMap['createdAt']}',
        );
        print(
          '🔍 _saveAnalysisResult - resultMap imagePath: ${resultMap['imagePath'] != null ? "Mevcut (${resultMap['imagePath'].length} karakter)" : "Yok"}',
        );
      }

      final resultWithDate = ScanResultModel.fromMap(resultMap);

      if (kDebugMode) {
        print(
          '🔍 _saveAnalysisResult - resultWithDate createdAt: ${resultWithDate.createdAt}',
        );
        print(
          '🔍 _saveAnalysisResult - resultWithDate imagePath: ${resultWithDate.imagePath != null ? "Mevcut (${resultWithDate.imagePath!.length} karakter)" : "Yok"}',
        );
      }

      final int id = await sembastService.addScanResult(
        resultWithDate,
        base64Image: base64Image,
      );
      if (kDebugMode) {
        print('💾 GemAI analiz sonucu kaydedildi - ID: $id');
        print('💾 Base64 görsel boyutu: ${base64Image.length} karakter');
      }
      return id;
    } catch (e) {
      if (kDebugMode) {
        print('❌ GemAI analiz sonucu kaydedilemedi: $e');
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
      // Şu anki tarihi al
      final now = DateTime.now();
      if (kDebugMode) {
        print('🔍 _updateHistoryAfterSuccess - Şu anki tarih: $now');
      }

      // Model'i toMap ile JSON'a çevir, createdAt ve base64 görseli ekle, tekrar model'e çevir
      final resultMap = result.toMap();
      final resultWithDateMap = Map<String, dynamic>.from(resultMap);
      resultWithDateMap['createdAt'] =
          now.toIso8601String(); // ISO formatında tarih
      resultWithDateMap['created_at'] =
          now.toIso8601String(); // Eski key'i de ekle
      resultWithDateMap['imagePath'] =
          base64Image; // BASE64 GÖRSELİ BURADA KULLAN

      if (kDebugMode) {
        print(
          '🔍 _updateHistoryAfterSuccess - resultWithDateMap createdAt: ${resultWithDateMap['createdAt']}',
        );
      }

      final resultWithDate = ScanResultModel.fromMap(resultWithDateMap);

      // HistoryItem oluştur
      final newItem = HistoryItem(id, resultWithDate);

      // Home controller'ı güncelle (ana sayfa son işlemler)
      if (Get.isRegistered<HomeController>()) {
        try {
          final homeController = Get.find<HomeController>();
          homeController.addNewItem(newItem);
        } catch (e) {
          if (kDebugMode) {
            print('❌ HomeController güncellenirken hata: $e');
          }
        }
      }

      if (Get.isRegistered<HistoryController>()) {
        try {
          final historyController = Get.find<HistoryController>();
          historyController.addNewItem(newItem);
        } catch (e) {
          if (kDebugMode) {
            print('❌ HistoryController güncellenirken hata: $e');
          }
        }
      }

      if (kDebugMode) {
        print('✅ Geçmiş güncellendi');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Geçmiş güncellenirken hata: $e');
      }
    }
  }

  RetakeReason? _mapBackendCodeToReason(int code) {
    switch (code) {
      case 1001:
        return RetakeReason.notFound;
      case 1002:
        return RetakeReason.notStone;
      case 1003:
        return RetakeReason.tooFarOrClose;
      case 1004:
        return RetakeReason.notRecognized;
      default:
        return null;
    }
  }

  /// Progress animasyonunu başlatır
  void _startProgressAnimation() {
    scanProgress.value = 0.0;

    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!isAnalyzing.value || scanProgress.value >= 0.95) {
        timer.cancel();
        return;
      }

      // Progress'i kademeli olarak artır
      scanProgress.value += 0.02;
    });
  }

  /// Başarılı analiz sonuçlarını işler
  void _handleAnalysisResults(ScanResultModel? data) {
    try {
      if (kDebugMode) {
        print('✅ Analiz sonuçları alındı: $data');
      }

      analysisResult.value = data;
      errorMessage.value = '';
    } catch (e) {
      if (kDebugMode) {
        print('❌ Analiz sonuçları işlenirken hata: $e');
      }

      // JSON parsing hatası durumunda kullanıcıya bilgi ver
      errorMessage.value = 'analysis_error'.tr;

      ShrineDialogService.showWarning(
        'analysis_error'.tr,
        AppThemeConfig.primary,
        duration: const Duration(seconds: 4),
      );
    }
  }

  /// Genel analiz hatalarını işler
  void _handleAnalysisError(dynamic error) {
    final colors = AppThemeConfig.primary;

    if (kDebugMode) {
      print('❌ Analiz hatası: $error');
      print('🔍 Hata tipi: ${error.runtimeType}');
      print('🔍 Hata mesajı: ${error.toString()}');
    }

    // Hata durumunda progress'i durdur
    scanProgress.value = 0.0;

    // Timeout hatası için özel mesaj
    if (error.toString().contains('TimeoutException')) {
      ShrineDialogService.showWarning(
        'scan_dialog_0'.tr,
        colors,
        duration: const Duration(seconds: 5),
      );
    } else {
      // Genel hata mesajı
      ShrineDialogService.showError('analysis_error'.tr, colors);
    }
  }

  /// API response hatalarını işler
  void _handleApiResponseError(ResponseModel<ScanResultModel> response) {
    if (kDebugMode) {
      print('❌ API response hatası: ${response.message}');
      print('🔍 Status code: ${response.statusCode}');
      print('🔍 Backend code: ${response.code}');
    }

    // Progress'i durdur
    scanProgress.value = 0.0;

    // Yeni API response yapısına uygun hata handling
    if (response.code != null) {
      // Backend'den gelen hata kodu
      ShrineDialogService.handleError(response.code!, response.message);
    } else {
      // HTTP status code kullan
      ShrineDialogService.handleError(response.statusCode, response.message);
    }
  }

  /// Analizi tekrar dener
  void retryAnalysis() {
    if (kDebugMode) {
      print('🔄 Analiz tekrar deneniyor...');
    }

    // State'i temizle
    errorMessage.value = '';
    analysisResult.value = null;
    scanProgress.value = 0.0;
  }

  /// Hata mesajını temizler
  void clearError() {
    errorMessage.value = '';
  }

  @override
  void onClose() {
    if (kDebugMode) {
      print('🔍 GemAnalysisController kapatıldı');
    }
    super.onClose();
  }
}

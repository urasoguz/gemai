// lib/app/modules/camera/controller/camera_controller.dart
// GemAI için kamera controller'ı
// Fotoğraf çekimi ve galeri seçimi işlevlerini yönetir

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:gemai/app/modules/camera/controller/gem_analysis_controller.dart';
import 'package:gemai/app/shared/helpers/my_helper.dart';
import 'package:gemai/app/routes/app_routes.dart';
import 'package:gemai/app/core/services/shrine_dialog_service.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:flutter/foundation.dart';
import 'dart:async'; // Added for Timer

/// GemAI için kamera controller'ı
/// Fotoğraf çekimi, galeri seçimi ve gem analiz sürecini yönetir
class CameraController extends GetxController {
  // Dependencies
  final GemAnalysisController _analysisController =
      Get.find<GemAnalysisController>();

  // Kamera durumları
  final RxString capturedImagePath = ''.obs;
  final RxBool isAnalyzing = false.obs;
  final RxDouble scanProgress = 0.0.obs;
  // Retake sonrası siyah ekranı önlemek için rebuild anahtarı
  final RxInt cameraRebuildKey = 0.obs;

  // Foto çekme koruması
  final RxBool isPhotoTaken = false.obs;
  final RxBool isPhotoButtonEnabled = true.obs;

  // Flash mode state
  final Rx<FlashMode> flashMode = FlashMode.auto.obs;

  @override
  void onInit() {
    super.onInit();
    _setupAnalysisListener();
  }

  /// Fotoğraf çektikten sonra token ve premium kontrolü yapar
  /// Eğer analiz yapılamazsa uygun sayfaya yönlendirir
  Future<bool> checkAnalysisPermission() async {
    try {
      // Token ve premium durumunu kontrol et
      final remainingToken =
          GetStorage().read(MyHelper.accountRemainingToken) ?? 0;
      final isPremium = GetStorage().read(MyHelper.isAccountPremium) ?? false;

      if (remainingToken <= 0) {
        if (isPremium) {
          // Premium kullanıcı ama token bitti
          ShrineDialogService.showNativeAlert(
            title: 'scan_dialog_title_info'.tr,
            message: 'scan_dialog_premium_no_limit'.tr,
            okButtonText: 'scan_dialog_ok'.tr,
            onOkPressed: () {},
          );
          return false;
        } else {
          // Premium olmayan kullanıcı, token bitti -> direkt premium sayfasına yönlendir
          Get.toNamed(AppRoutes.premium);
          return false;
        }
      }

      // Token yeterli, analiz yapılabilir
      return true;
    } catch (e) {
      ShrineDialogService.showError(
        'camera_permission_error'.tr,
        AppThemeConfig.textLink,
      );
      if (kDebugMode) {
        print('❌ Analiz izni kontrol hatası: $e');
      }
      return false;
    }
  }

  /// Analiz sürecini başlatır
  /// Önce token ve premium kontrolü yapar
  Future<void> startAnalysis() async {
    // 🚨 YENİ: Analiz öncesi izin kontrolü
    final hasPermission = await checkAnalysisPermission();
    if (!hasPermission) {
      return; // İzin yoksa analiz başlatma
    }

    // UI state'ini güncelle
    isAnalyzing.value = true;
    scanProgress.value = 0.0;

    // GemAnalysisController'ı kullanarak analiz yap
    final success = await _analysisController.performGemAnalysis(
      capturedImagePath.value,
    );

    // Analiz tamamlandı - isAnalyzing false olacak
    // Başarılı analiz sonrası direkt gem_result sayfasına yönlendirilecek
    if (kDebugMode) {
      print('🔍 Analiz tamamlandı - Başarı: $success');
    }
  }

  /// Foto çekme işlemi - koruma ile
  Future<void> takePhoto() async {
    if (!isPhotoButtonEnabled.value) {
      if (kDebugMode) {
        print('🚫 Foto çekme butonu devre dışı - koruma aktif');
      }
      return;
    }

    try {
      if (kDebugMode) {
        print('📸 Foto çekme başlatılıyor...');
      }

      // Foto çekme butonunu devre dışı bırak
      isPhotoButtonEnabled.value = false;
      isPhotoTaken.value = true;

      // Foto çekme işlemi burada yapılacak
      // Bu metod kamera widget'ından çağrılacak

      if (kDebugMode) {
        print('✅ Foto çekme tamamlandı');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Foto çekme hatası: $e');
      }

      // Hata durumunda butonu tekrar aktif et
      isPhotoButtonEnabled.value = true;
      isPhotoTaken.value = false;
    }
  }

  /// Foto çekme korumasını sıfırla (retake için)
  void resetPhotoProtection() {
    isPhotoButtonEnabled.value = true;
    isPhotoTaken.value = false;

    if (kDebugMode) {
      print('🔄 Foto çekme koruması sıfırlandı');
    }
  }

  /// Progress ve analiz durumunu takip eder
  void _setupAnalysisListener() {
    // GemAnalysisController'dan progress'i dinle
    ever(_analysisController.scanProgress, (double progress) {
      scanProgress.value = progress;
    });

    // Analiz durumunu dinle
    ever(_analysisController.isAnalyzing, (bool analyzing) {
      isAnalyzing.value = analyzing;
    });
  }

  /// Flash modunu değiştirir
  void toggleFlashMode() {
    switch (flashMode.value) {
      case FlashMode.auto:
        flashMode.value = FlashMode.always;
        break;
      case FlashMode.always:
        flashMode.value = FlashMode.none;
        break;
      case FlashMode.none:
        flashMode.value = FlashMode.on;
        break;
      case FlashMode.on:
        flashMode.value = FlashMode.auto;
        break;
    }
  }

  /// Çekilen fotoğrafı ayarlar
  void setCapturedImage(String imagePath) {
    capturedImagePath.value = imagePath;
  }

  /// Analiz sonucunu temizler
  void clearAnalysisResult() {
    scanProgress.value = 0.0;
  }

  /// Kamerayı yeniden başlatmak için anahtarı artır
  void rebuildCamera() {
    cameraRebuildKey.value++;
  }

  /// Çekilen fotoğrafı temizler
  void clearPhoto() {
    capturedImagePath.value = '';
  }

  /// Analizi tekrar dener
  void retryAnalysis() {
    _analysisController.retryAnalysis();
  }

  /// Hata mesajını temizler
  void clearError() {
    _analysisController.clearError();
  }
}

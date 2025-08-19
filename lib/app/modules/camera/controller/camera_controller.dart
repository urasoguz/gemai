import 'package:dermai/app/routes/app_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:camerawesome/camerawesome_plugin.dart';

/// DermAI için kamera controller'ı
/// Fotoğraf çekimi, galeri seçimi ve analiz sürecini yönetir
class CameraController extends GetxController {
  // Kamera durumları
  final RxString capturedImagePath = ''.obs;
  final RxBool isAnalyzing = false.obs;
  final RxDouble scanProgress = 0.0.obs; // Tarama ilerlemesi (0.0 - 1.0)

  // Flash mode state
  final Rx<FlashMode> flashMode = FlashMode.auto.obs;

  /// Fotoğraf çekildiğinde çağrılır
  /// [path]: Çekilen fotoğrafın dosya yolu
  void onPhotoCaptured(String path) {
    if (kDebugMode) {
      print('📸 Fotoğraf çekildi: $path');
    }
    capturedImagePath.value = path;
    startAnalysis();
  }

  /// Analiz sürecini başlatır
  /// Yukarıdan aşağıya tarama efekti ile modern analiz deneyimi
  Future<void> startAnalysis() async {
    isAnalyzing.value = true;
    scanProgress.value = 0.0;
    if (kDebugMode) {
      print('🔍 DermAI analizi başlatılıyor...');
    }

    // Yukarıdan aşağıya tarama efekti (3 saniye)
    const totalDuration = Duration(seconds: 3);
    const updateInterval = Duration(milliseconds: 50);
    final totalSteps =
        totalDuration.inMilliseconds ~/ updateInterval.inMilliseconds;

    for (int i = 0; i <= totalSteps; i++) {
      scanProgress.value = i / totalSteps;
      await Future.delayed(updateInterval);
    }

    isAnalyzing.value = false;
    scanProgress.value = 0.0;
    if (kDebugMode) {
      print('✅ Analiz tamamlandı');
    }

    // Analiz sayfasına git
    Get.offNamed(
      AppRoutes.skinAnalysis,
      arguments: {'imagePath': capturedImagePath.value},
    );
  }

  /// Fotoğrafı temizler
  void clearPhoto() {
    capturedImagePath.value = '';
    scanProgress.value = 0.0;
    if (kDebugMode) {
      print('🗑️ Fotoğraf temizlendi');
    }
  }

  void toggleFlashMode() {
    // Sadece aktif/pasif toggle - auto modu yok
    if (flashMode.value == FlashMode.always) {
      flashMode.value = FlashMode.none;
    } else {
      flashMode.value = FlashMode.always;
    }

    if (kDebugMode) {
      print('FLASH MODE:  [32m${flashMode.value} [0m');
    }
  }

  @override
  void onClose() {
    if (kDebugMode) {
      print('📱 DermAI Kamera controller kapatıldı');
    }
    super.onClose();
  }
}

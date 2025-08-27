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
import 'package:gemai/app/core/services/sembast_service.dart';
import 'package:gemai/app/data/model/response/scan_result_model.dart';
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
          ShrineDialogService.showWarning(
            'Premium kullanıcı olmanıza rağmen analiz hakkınız bitti. Lütfen daha sonra tekrar deneyin.',
            AppThemeConfig.primary,
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
        'Analiz izni kontrol edilirken hata oluştu. Lütfen tekrar deneyin.',
        AppThemeConfig.primary,
      );
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

  /// 🧪 TEST: Analiz ekranı UI'ını simüle eder (gerçek API çağrısı yapmaz)
  void debugSimulateAnalysisUI() {
    try {
      isAnalyzing.value = true;
      scanProgress.value = 0.0;

      Timer.periodic(const Duration(milliseconds: 120), (timer) {
        if (!isAnalyzing.value) {
          timer.cancel();
          return;
        }
        if (scanProgress.value >= 1.0) {
          timer.cancel();
          Future.delayed(const Duration(milliseconds: 400), () {
            isAnalyzing.value = false; // UI test bittiğinde kapanır
            scanProgress.value = 0.0;
          });
        } else {
          scanProgress.value = (scanProgress.value + 0.03).clamp(0.0, 1.0);
        }
      });
    } catch (_) {
      isAnalyzing.value = false;
    }
  }

  /// 🧪 TEST: iOS tarzı native alert gösterir
  void showTestNativeAlert() {
    ShrineDialogService.showNativeAlert(
      title: 'Test Başlık',
      message: 'Bu bir test mesajıdır. iOS tarzı native alert gösteriliyor.',
      okButtonText: 'Anladım',
      onOkPressed: () {
        if (kDebugMode) {
          print('✅ Test alert onaylandı');
        }
      },
    );
  }

  /// 🧪 TEST: iOS tarzı native confirmation gösterir
  void showTestNativeConfirm() {
    ShrineDialogService.showNativeConfirm(
      title: 'Test Onay',
      message: 'Bu işlemi gerçekleştirmek istediğinizden emin misiniz?',
      confirmText: 'Evet',
      cancelText: 'Hayır',
      onConfirm: () {
        if (kDebugMode) {
          print('✅ Test confirmation onaylandı');
        }
      },
      onCancel: () {
        if (kDebugMode) {
          print('❌ Test confirmation iptal edildi');
        }
      },
    );
  }

  /// 🧪 TEST: Sahte bir sonuc kaydi olustur ve yeni GemResult sayfasini ac
  Future<void> debugCreateFakeResultAndOpen() async {
    try {
      final SembastService db = SembastService();
      final ScanResultModel model = ScanResultModel(
        createdAt: DateTime.now(),
        isFavorite: false, // Test için favori olmayan olarak ayarla
        type: "Safir (Pembeden Moraya Doğru Renk Tonları)",
        chemicalFormula: "Al₂O₃",
        mohsHardness: 9,
        colorSpectrum: "Mavi, Pembe, Mor",
        description:
            "Safir, korund mineralinin alüminyum oksit (Al₂O₃) yapısındaki krom ve demir gibi eser elementlerin neden olduğu renklere sahip değerli bir çeşididir. Bu numuneler, büyüme bantları ve ışık oyunları sergileyen, doğal, kesilmemiş hallerindedir.",
        rawValuePerKg: "Yüksek (Değişken)",
        processedValuePerCarat: "Çok Yüksek (Değişken)",
        collectorMarketValue: "Yüksek",
        marketReferenceYear: "2024",
        valuePerCarat: 5000.0,
        rarityScore: 8,
        possibleFakeIndicators: [
          "Çok homojen renk dağılımı",
          "Sentetik görünümde parlaklık",
          "Düşük sertlik hissi",
        ],
        crystalSystem: "Trigonal (Triklinik)",
        estimatedRefractiveIndex: "1.762-1.770",
        processingDifficulty: 8,
        foundRegions: [
          "Sri Lanka",
          "Myanmar",
          "Madagaskar",
          "Tayland",
          "Avustralya",
          "ABD (Montana)",
        ],
        imitationWarning:
            "Doğal safirlerin yerine, sentetik safirler veya cam ve spinel gibi başka taşlar kullanılabilir. Renk, berraklık ve kapanımlar dikkatlice incelenmelidir.",
        radioactivity: "Yok",
        legalRestrictions: [],
        cleaningMaintenanceTips: [
          "Hafif sabunlu ılık su ile temizlenebilir. Ultrasonik temizleyiciler ve buhar temizleyiciler bazı durumlarda kullanılabilir ancak dikkatli olunmalıdır. Sert kimyasallardan kaçının.",
        ],
        transparency: ["Şeffaf", "Yarı Şeffaf"],
        luster: ["Camsı"],
        inclusions:
            "Genellikle iğnemsi kapanımlar (rutil iğneleri), büyüme bantları ve diğer mineraller görülebilir.",
        similarStones: [
          "İndigolit (Turmalin)",
          "Kabaşon Kesim Safir",
          "Sentetik Safir",
        ],
        astrologicalMythologicalMeaning:
            "Genellikle bilgeliği, ruhsal aydınlanmayı, sadakati ve huzuru temsil ettiğine inanılır. Eylül ayının taşıdır.",
        extendedColorSpectrum: [
          "Mavi (en bilinen)",
          "Pembe",
          "Mor",
          "Sarı",
          "Yeşil",
          "Turuncu",
          "Renksiz",
          "Siyah",
        ],
        magnetism: "Manyetik değil",
        tenacity: "Sert ama Kırılgan",
        cleavage: "Yok (Sıkça görülen yontulmuş yüzeyler)",
        fracture: "Düzensiz, Sıkça Musluklu",
        density: "3.95 - 4.03 g/cm³",
        chemicalClassification: "Oksitler",
        elements: ["Al", "O"],
        commonImpurities: ["Fe", "Ti", "V", "Cr", "Mg", "Si", "Ni"],
        formation:
            "Safirler, magmatik kayaçların oluşumu sırasında yüksek sıcaklık ve basınç altında kristalleşir veya metamorfik kayaçlarda, genellikle mermerlerde veya pegmatitlerde bulunurlar.",
        ageRange: "Milyonlarca - Milyarlarca yıl",
        ageDescription:
            "Safirlerin oluşumu genellikle Dünya'nın erken jeolojik dönemlerine dayanır, ancak daha genç jeolojik olaylarla da ilişkili olabilirler.",
        uses:
            "Takı yapımı, endüstriyel uygulamalar (pencere, lensler, saat camları) ve bilimsel araştırmalarda kullanılır.",
        culturalSignificance:
            "Tarih boyunca kraliyet aileleri, soylular ve dini liderler tarafından güç, koruma ve ruhsal bağlantı sembolü olarak kullanılmıştır. Antik Yunanlılar safirin savaşı önlediğine inanırlardı.",
      );

      if (kDebugMode) {
        print('🧪 Test kaydı oluşturuluyor - isFavorite: ${model.isFavorite}');
      }

      final int id = await db.addScanResult(model);

      if (kDebugMode) {
        print('🧪 Test kaydı oluşturuldu - ID: $id');
      }

      Get.toNamed(AppRoutes.gemResult, arguments: id);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Test kaydı oluşturulamadı: $e');
      }
    }
  }
}

import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:dermai/app/core/services/sembast_service.dart';
import 'package:dermai/app/core/services/in_app_review_service.dart';
import 'package:dermai/app/data/model/response/scan_result_model.dart';

class ResultController extends GetxController {
  final Rx<ScanResultModel?> result = Rx<ScanResultModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final InAppReviewService _inAppReviewService = Get.find<InAppReviewService>();

  @override
  void onInit() {
    super.onInit();
    fetchResult();
  }

  Future<void> fetchResult() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final int id = Get.arguments as int;
      //final Map<String, dynamic> args = Get.arguments as Map<String, dynamic>;
      //final int id = args['scanResultId'] as int;
      final item = await SembastService().getResult(id);
      if (item == null) {
        hasError.value = true;
      } else {
        result.value = item;

        // Analiz başarılı olduğunda in-app review göster
        _showInAppReviewIfNeeded();
      }
    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  /// In-app review'i gerekirse gösterir
  Future<void> _showInAppReviewIfNeeded() async {
    try {
      // 3 saniye bekle (kullanıcı sonucu görsün)
      await Future.delayed(const Duration(seconds: 3));

      if (kDebugMode) {
        print('⭐ Result sayfasında in-app review kontrol ediliyor...');
        print('   - shouldShowReview: ${_inAppReviewService.shouldShowReview}');
      }

      // Review gösterilip gösterilmediğini kontrol et
      if (_inAppReviewService.shouldShowReview) {
        if (kDebugMode) {
          print('⭐ In-app review gösteriliyor...');
        }

        // In-app review'i göster
        await _inAppReviewService.showInAppReview();
      } else {
        if (kDebugMode) {
          print('⭐ In-app review daha önce gösterilmiş, atlanıyor');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ In-app review gösterilirken hata: $e');
      }
    }
  }
}

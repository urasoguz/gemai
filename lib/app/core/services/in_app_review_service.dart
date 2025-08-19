import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:gemai/app/shared/helpers/my_helper.dart';

/// In-app review servisi
class InAppReviewService extends GetxService {
  final GetStorage _storage = GetStorage();
  final InAppReview _inAppReview = InAppReview.instance;

  /// Review gösterilip gösterilmediğini kontrol eder
  bool get hasShownReview =>
      _storage.read(MyHelper.hasShownInAppReview) ?? false;

  /// Review gösterildi olarak işaretler
  void _markReviewAsShown() {
    _storage.write(MyHelper.hasShownInAppReview, true);
    if (kDebugMode) {
      print('⭐ In-app review gösterildi olarak işaretlendi');
    }
  }

  /// In-app review'i gösterir
  Future<bool> showInAppReview() async {
    try {
      if (kDebugMode) {
        print('⭐ In-app review başlatılıyor...');
      }

      // Daha önce gösterildiyse gösterme
      if (hasShownReview) {
        if (kDebugMode) {
          print('⭐ In-app review daha önce gösterilmiş, atlanıyor');
        }
        return false;
      }

      // In-app review'in mevcut olup olmadığını kontrol et
      if (await _inAppReview.isAvailable()) {
        if (kDebugMode) {
          print('✅ In-app review mevcut, gösteriliyor...');
        }

        // In-app review'i göster
        await _inAppReview.requestReview();

        // Gösterildi olarak işaretle
        _markReviewAsShown();

        if (kDebugMode) {
          print('✅ In-app review başarıyla gösterildi');
        }

        return true;
      } else {
        if (kDebugMode) {
          print('❌ In-app review mevcut değil');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ In-app review hatası: $e');
      }
      return false;
    }
  }

  /// Review gösterimini sıfırlar (test için)
  void resetReviewShown() {
    _storage.remove(MyHelper.hasShownInAppReview);
    if (kDebugMode) {
      print('⭐ In-app review gösterim durumu sıfırlandı');
    }
  }

  /// Review gösterilip gösterilmediğini kontrol eder
  bool get shouldShowReview => !hasShownReview;
}

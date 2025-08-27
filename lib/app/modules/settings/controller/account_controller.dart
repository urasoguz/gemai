import 'dart:io';
import 'package:gemai/app/core/services/shrine_dialog_service.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:gemai/app/routes/app_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gemai/app/modules/auth/controller/user_controller.dart';
import 'package:gemai/app/core/services/restore_premium_service.dart';

class AccountController extends GetxController {
  final UserController userController = Get.find<UserController>();

  Future<void> restorePurchases() async {
    try {
      if (kDebugMode) {
        print('🔄 Account settings restore işlemi başlatılıyor...');
      }

      // Merkezi restore servisi kullan
      final restoreService = Get.find<RestorePremiumService>();
      final success = await restoreService.performCompleteRestore();

      if (!success) {
        // Hata mesajı servis tarafından gösterildi
        if (kDebugMode) {
          print('❌ Account settings restore başarısız');
        }
      } else {
        if (kDebugMode) {
          print('✅ Account settings restore başarılı');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Account settings restore exception: $e');
      }
      final colors = AppThemeConfig.textHint;
      ShrineDialogService.showError(
        'settings_restore_purchases_error'.tr,
        colors,
        duration: const Duration(seconds: 3),
      );
    }
  }

  void cancelSubscription() async {
    try {
      final colors = AppThemeConfig.textHint;
      final url =
          Platform.isIOS
              ? 'https://apps.apple.com/account/subscriptions'
              : 'https://play.google.com/store/account/subscriptions';

      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ShrineDialogService.showError(
          'settings_cancel_subscription_error'.tr,
          colors,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void goToPremium() {
    Get.toNamed(AppRoutes.premium);
  }

  String shortenWithMiddleEllipsis(String text, {int visibleLength = 4}) {
    if (text.length <= visibleLength * 2) return text;
    final start = text.substring(0, visibleLength);
    final end = text.substring(text.length - visibleLength);
    return '$start...$end';
  }

  int getRemainingDays() {
    final user = userController.user.value;
    if (user?.premiumExpiryDate == null) return 0;

    final now = DateTime.now();
    final difference = user!.premiumExpiryDate!.difference(now);
    return difference.inDays;
  }
}

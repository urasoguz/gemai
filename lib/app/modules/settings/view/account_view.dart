import 'package:gemai/app/core/services/shrine_dialog_service.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:gemai/app/core/services/app_settings_service.dart';
import 'package:gemai/app/shared/helpers/my_helper.dart';
import 'package:gemai/app/shared/widgets/modular_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gemai/app/modules/settings/controller/account_controller.dart';
import 'package:get_storage/get_storage.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    // Üst bardaki sistem metinlerini siyah yap (account için)
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppThemeConfig.transparent, // Status bar şeffaf
        statusBarIconBrightness: Brightness.dark, // Status bar ikonları siyah
        statusBarBrightness: Brightness.light, // iOS için status bar açık tema
        systemNavigationBarColor:
            AppThemeConfig.transparent, // Alt navigasyon şeffaf
        systemNavigationBarIconBrightness:
            Brightness.dark, // Alt navigasyon ikonları koyu
      ),
    );

    final colors = AppThemeConfig.primary;
    return Scaffold(
      appBar: ModularAppBar(
        title: 'account_title'.tr,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, size: 30),
          onPressed: () => Get.back(),
          splashColor: AppThemeConfig.transparent,
          highlightColor: AppThemeConfig.transparent,
          hoverColor: AppThemeConfig.transparent,
          focusColor: AppThemeConfig.transparent,
          splashRadius: 0.1,
          enableFeedback: false,
        ),
      ),
      backgroundColor: AppThemeConfig.background,
      body: Column(
        children: [
          const SizedBox(height: 24),
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppThemeConfig.primary, AppThemeConfig.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.person,
                size: 40,
                color: AppThemeConfig.buttonIcon,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Kullanıcı adı
          Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            child: Text(
              'account_anonymous'.tr,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: AppThemeConfig.textPrimary,
                fontSize: 18,
              ),
            ),
          ),

          Divider(thickness: 1, color: AppThemeConfig.divider),

          // Kullanıcı bilgileri
          ListTile(
            title: Text('account_user_id'.tr),
            trailing: Obx(
              () => Text(
                controller.userController.user.value?.id?.toString() ?? 'N/A',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),

          ListTile(
            title: Text('account_device_id'.tr),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => Text(
                    controller.shortenWithMiddleEllipsis(
                      controller.userController.user.value?.deviceId ?? 'N/A',
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    final deviceId =
                        controller.userController.user.value?.deviceId ?? '';
                    if (deviceId.isNotEmpty) {
                      Clipboard.setData(ClipboardData(text: deviceId));
                      ShrineDialogService.showInfo(
                        'account_snackbar_copy'.tr,
                        colors,
                        duration: const Duration(seconds: 3),
                      );
                    }
                  },
                  child: Icon(
                    Icons.copy,
                    size: 20,
                    color: AppThemeConfig.textLink,
                  ),
                ),
              ],
            ),
          ),

          ListTile(
            title: Text('account_type'.tr),
            trailing: Obx(() {
              final isPremium = controller.userController.isSubscribed.value;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isPremium)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppThemeConfig.primary.withOpacity(0.1),
                        border: Border.all(
                          color: AppThemeConfig.primary.withOpacity(0.3),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppThemeConfig.primary.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: AppThemeConfig.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'account_type_premium'.tr,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppThemeConfig.primary,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppThemeConfig.textSecondary.withOpacity(0.1),
                        border: Border.all(
                          color: AppThemeConfig.textSecondary.withOpacity(0.3),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 14,
                            color: AppThemeConfig.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'account_type_basic'.tr,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppThemeConfig.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            }),
          ),

          // Premium kullanıcılar için kalan gün
          Obx(() {
            final isPremium = controller.userController.isSubscribed.value;
            if (!isPremium) return const SizedBox.shrink();

            return ListTile(
              title: Text('account_remaining_days'.tr),
              trailing: Text(
                '${controller.getRemainingDays()} ${'account_remaining_days_info'.tr}',
                style: const TextStyle(fontSize: 16),
              ),
            );
          }),

          // Satın almaları geri yükle
          if (GetStorage().read(MyHelper.isAccountPremium) == false)
            ListTile(
              title: Text('account_restore_purchases'.tr),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: controller.restorePurchases,
              splashColor: AppThemeConfig.transparent,
            ),

          // Aboneliği iptal et - Sadece inceleme modunda göster (normal modda gizle)
          Obx(() {
            final appSettings = Get.find<AppSettingsService>();
            final isReviewMode = appSettings.isAppReviewMode;

            // Normal modda ise gösterme (sadece inceleme modunda göster)
            if (!isReviewMode) return const SizedBox.shrink();

            return ListTile(
              title: Text('account_cancel_subscription'.tr),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: controller.cancelSubscription,
              splashColor: AppThemeConfig.transparent,
            );
          }),

          // Premium olmayan kullanıcılar için premium butonu
          // Obx(() {
          //   final isPremium = controller.userController.isSubscribed.value;
          //   if (isPremium) return const SizedBox.shrink();

          //   return Padding(
          //     padding: const EdgeInsets.all(30.0),
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: <Widget>[
          //         Text(
          //           'Reklamsız deneyim için Premium\'a geçin',
          //           style: TextStyle(color: Colors.grey[600]),
          //         ),
          //         const SizedBox(height: 12),
          //         SizedBox(
          //           width: double.infinity,
          //           child: Container(
          //             decoration: BoxDecoration(
          //               gradient: const LinearGradient(
          //                 colors: [Colors.blue, Colors.purple],
          //                 begin: Alignment.centerLeft,
          //                 end: Alignment.centerRight,
          //               ),
          //               borderRadius: BorderRadius.circular(16),
          //             ),
          //             child: ElevatedButton(
          //               onPressed: controller.goToPremium,
          //               style: ElevatedButton.styleFrom(
          //                 backgroundColor: Colors.transparent,
          //                 foregroundColor: Colors.white,
          //                 padding: const EdgeInsets.symmetric(vertical: 16),
          //                 shadowColor: Colors.transparent,
          //                 shape: RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.circular(16),
          //                 ),
          //                 minimumSize: const Size.fromHeight(50),
          //               ),
          //               child: const Text(
          //                 'Premium\'a Geç',
          //                 style: TextStyle(
          //                   fontSize: 16,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   );
          // }),
        ],
      ),
    );
  }
}

import 'package:dermai/app/core/services/shrine_dialog_service.dart';
import 'package:dermai/app/core/theme/app_theme_config.dart';
import 'package:dermai/app/shared/helpers/my_helper.dart';
import 'package:dermai/app/shared/widgets/modular_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dermai/app/modules/settings/controller/account_controller.dart';
import 'package:get_storage/get_storage.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors =
        AppThemeConfig.colors;
    return Scaffold(
      appBar: ModularAppBar(
        title: 'account_title'.tr,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, size: 30),
          onPressed: () => Get.back(),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          splashRadius: 0.1,
          enableFeedback: false,
        ),
      ),
      backgroundColor: colors.background,
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
                colors: [colors.primary, colors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Icon(Icons.person, size: 40, color: colors.buttonIcon),
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
                color: colors.textPrimary,
                fontSize: 18,
              ),
            ),
          ),

          Divider(thickness: 1, color: colors.divider),

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
                  child: Icon(Icons.copy, size: 20, color: colors.textLink),
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
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [colors.warning, colors.error],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'account_type_premium'.tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colors.surface,
                        ),
                      ),
                    )
                  else
                    Text(
                      'account_type_basic'.tr,
                      style: TextStyle(fontSize: 16),
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
              splashColor: Colors.transparent,
            ),

          // Aboneliği iptal et
          ListTile(
            title: Text('account_cancel_subscription'.tr),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: controller.cancelSubscription,
            splashColor: Colors.transparent,
          ),

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

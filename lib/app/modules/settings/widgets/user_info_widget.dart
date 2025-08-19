import 'package:dermai/app/core/theme/app_theme_config.dart';
import 'package:dermai/app/routes/app_routes.dart';
import 'package:dermai/app/shared/helpers/my_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dermai/app/modules/auth/controller/user_controller.dart';
import 'package:get_storage/get_storage.dart';

class UserInfoWidget extends GetView<UserController> {
  const UserInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).brightness == Brightness.light
            ? AppThemeConfig.lightColors
            : AppThemeConfig.darkColors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onTap: () {
          Get.toNamed(AppRoutes.account);
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          constraints: const BoxConstraints(minHeight: 60),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      controller.user.value?.name ?? 'account_anonymous'.tr,
                      style: TextStyle(color: colors.textPrimary, fontSize: 18),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        // User model'dan direkt premium durumunu al
                        if (GetStorage().read(MyHelper.isAccountPremium) ==
                            true)
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
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: colors.surface,
                              ),
                            ),
                          ),
                        if (GetStorage().read(MyHelper.isAccountPremium) ==
                            false)
                          Text(
                            'account_type_basic'.tr,
                            style: TextStyle(color: colors.error, fontSize: 12),
                          ),

                        Obx(() {
                          if (_shouldShowPremiumDays()) {
                            return Row(
                              children: [
                                const SizedBox(width: 5),
                                Container(
                                  width: 3,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: colors.textSecondary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  _getRemainingDays(
                                    controller.user.value!.premiumExpiryDate!,
                                  ),
                                  style: TextStyle(
                                    color: colors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: colors.textPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Premium günleri gösterilip gösterilmeyeceğini kontrol eder
  bool _shouldShowPremiumDays() {
    // User'dan direkt kontrol et - storage yerine user model'i kullan
    final user = controller.user.value;
    final isPremium = user?.isPremium == true;
    final hasExpiryDate = user?.premiumExpiryDate != null;
    final result = isPremium && hasExpiryDate;

    return result;
  }

  String _getRemainingDays(DateTime expiryDate) {
    final now = DateTime.now();
    final difference = expiryDate.difference(now);

    return '${difference.inDays} ${'account_remaining_days_info'.tr}';
  }
}

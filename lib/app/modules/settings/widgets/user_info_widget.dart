import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:gemai/app/routes/app_routes.dart';
import 'package:gemai/app/shared/helpers/my_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gemai/app/modules/auth/controller/user_controller.dart';
import 'package:get_storage/get_storage.dart';

class UserInfoWidget extends GetView<UserController> {
  const UserInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
                      style: TextStyle(
                        color: AppThemeConfig.textPrimary,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        // User model'dan direkt premium durumunu al
                        if (GetStorage().read(MyHelper.isAccountPremium) ==
                            true)
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
                                  color: AppThemeConfig.primary.withOpacity(
                                    0.1,
                                  ),
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
                          ),
                        if (GetStorage().read(MyHelper.isAccountPremium) ==
                            false)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppThemeConfig.textSecondary.withOpacity(
                                0.1,
                              ),
                              border: Border.all(
                                color: AppThemeConfig.textSecondary.withOpacity(
                                  0.3,
                                ),
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

                        Obx(() {
                          if (_shouldShowPremiumDays()) {
                            return Row(
                              children: [
                                const SizedBox(width: 5),
                                Container(
                                  width: 3,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: AppThemeConfig.textSecondary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  _getRemainingDays(
                                    controller.user.value!.premiumExpiryDate!,
                                  ),
                                  style: TextStyle(
                                    color: AppThemeConfig.textSecondary,
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
                color: AppThemeConfig.textPrimary,
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

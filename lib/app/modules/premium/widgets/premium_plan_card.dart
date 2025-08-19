import 'package:flutter/material.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:gemai/app/core/services/app_settings_service.dart';
import 'package:get/get.dart';

// Premium plan kartı widgetı
class PremiumPlanCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String badgeText;
  final Color badgeColor;
  final bool selected;
  final VoidCallback onTap;
  final Color checkColor;
  final bool isTrial;
  final String? trialTitle;
  final String? periodText;

  const PremiumPlanCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.badgeColor,
    required this.selected,
    required this.onTap,
    required this.checkColor,
    this.isTrial = false,
    this.trialTitle,
    this.periodText,
  });

  @override
  Widget build(BuildContext context) {
    // Paywall ayarlarını al
    final appSettingsService = Get.find<AppSettingsService>();
    final paywallDelayedCloseButton =
        appSettingsService.settings?.paywall?.paywallDelayedCloseButton ??
        false;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(bottom: isTrial ? 0 : 16),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: AppThemeConfig.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
                selected
                    ? checkColor
                    : AppThemeConfig.divider.withValues(alpha: 0.3),
            width: selected ? 1 : 1,
          ),
          boxShadow: [
            if (selected)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 32,
                spreadRadius: 2,
                offset: const Offset(0, 12),
              )
            else
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                spreadRadius: 0.5,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trialTitle?.isNotEmpty == true ? trialTitle! : title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppThemeConfig.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppThemeConfig.textSecondary,
                        ),
                      ),
                      if (periodText != null && periodText!.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        Text(
                          periodText!,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppThemeConfig.textHint,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            if (badgeText.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isTrial ? 10 : 12,
                  vertical: isTrial ? 8 : 6,
                ),
                decoration: BoxDecoration(
                  color: isTrial ? badgeColor : badgeColor,
                  borderRadius: BorderRadius.circular(isTrial ? 8 : 5),
                  border:
                      isTrial
                          ? Border.all(
                            color: AppThemeConfig.primary.withValues(
                              alpha: 0.3,
                            ),
                            width: 1,
                          )
                          : null,
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    color: isTrial ? AppThemeConfig.textPrimary : Colors.white,
                    fontSize:
                        isTrial ? (paywallDelayedCloseButton ? 16 : 12) : 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            SizedBox(width: isTrial ? 0 : 10),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      selected
                          ? checkColor
                          : AppThemeConfig.divider.withValues(alpha: 0.5),
                  width: 2,
                ),
                color: selected ? checkColor : Colors.transparent,
              ),
              child:
                  selected
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : null,
            ),

            // isTrial
            //     ? const Icon(
            //       Icons.check_circle,
            //       color: Color(0xFF34C759),
            //       size: 24,
            //     )
            //     : Container(
            //       width: 24,
            //       height: 24,
            //       decoration: BoxDecoration(
            //         shape: BoxShape.circle,
            //         border: Border.all(
            //           color: selected ? checkColor : Colors.grey.shade400,
            //           width: 2,
            //         ),
            //         color: selected ? checkColor : Colors.transparent,
            //       ),
            //       child:
            //           selected
            //               ? const Icon(
            //                 Icons.check,
            //                 color: Colors.white,
            //                 size: 16,
            //               )
            //               : null,
            //     ),
          ],
        ),
      ),
    );
  }
}

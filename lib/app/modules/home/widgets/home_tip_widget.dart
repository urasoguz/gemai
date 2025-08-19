import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeTipWidget extends StatelessWidget {
  const HomeTipWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Tema renklerini al

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppThemeConfig.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppThemeConfig.divider, width: 0.7),
        ),
        child: Row(
          children: [
            Icon(
              Icons.lightbulb_outline,
              color: AppThemeConfig.warning,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'home_tip_title'.tr,
                style: TextStyle(
                  fontSize: 14,
                  color: AppThemeConfig.textTertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResultFooterNote extends StatelessWidget {
  const ResultFooterNote({super.key});

  @override
  Widget build(BuildContext context) {
    // iOS tarzı, ultra sade ve modern footer notu
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: AppThemeConfig.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppThemeConfig.divider,
          width: 0.7,
        ), // Çok soft border
        boxShadow: [
          BoxShadow(
            color: AppThemeConfig.buttonShadow.withValues(alpha: 0.01),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 15,
            color: AppThemeConfig.textSecondary,
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              'result_footer_note'.tr,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: AppThemeConfig.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

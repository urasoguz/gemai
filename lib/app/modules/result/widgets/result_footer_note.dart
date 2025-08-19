import 'package:dermai/app/core/theme/app_theme_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResultFooterNote extends StatelessWidget {
  const ResultFooterNote({super.key});

  @override
  Widget build(BuildContext context) {
    final colors =
        AppThemeConfig.primary;
    // iOS tarzı, ultra sade ve modern footer notu
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.divider,
          width: 0.7,
        ), // Çok soft border
        boxShadow: [
          BoxShadow(
            color: colors.buttonShadow.withValues(alpha: 0.01),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 15, color: colors.textSecondary),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              'result_footer_note'.tr,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

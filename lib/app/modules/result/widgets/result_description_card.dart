import 'package:dermai/app/core/theme/app_theme_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResultDescriptionCard extends StatelessWidget {
  final String description;
  const ResultDescriptionCard({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    final colors =
        AppThemeConfig.primary;
    // iOS tarzı, ultra sade ve modern açıklama kartı
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: colors.textSecondary),
              const SizedBox(width: 6),
              Text(
                'result_description'.tr,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: colors.textPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

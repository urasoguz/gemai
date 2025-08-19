import 'package:dermai/app/core/theme/app_theme_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeWelcomeWidget extends StatelessWidget {
  const HomeWelcomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Tema renklerini al
    final colors =
        Theme.of(context).brightness == Brightness.light
            ? AppThemeConfig.lightColors
            : AppThemeConfig.darkColors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'home_welcome_title'.tr,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'home_welcome_desc'.tr,
            style: TextStyle(
              fontSize: 15,
              color: colors.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

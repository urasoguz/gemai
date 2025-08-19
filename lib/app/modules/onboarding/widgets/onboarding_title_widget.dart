import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:flutter/material.dart';

class OnboardingTitleWidget extends StatelessWidget {
  final String title;
  const OnboardingTitleWidget({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 400),
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppThemeConfig.textPrimary,
      ),
      child: Text(title, textAlign: TextAlign.center),
    );
  }
}

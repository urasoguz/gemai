import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:flutter/material.dart';

class OnboardingDescWidget extends StatelessWidget {
  final String desc;
  const OnboardingDescWidget({required this.desc, super.key});

  @override
  Widget build(BuildContext context) {
    final colors =
        AppThemeConfig.colors;
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 400),
      style: TextStyle(fontSize: 16, color: colors.onboardingDescTextColor),
      child: Text(desc, textAlign: TextAlign.center),
    );
  }
}

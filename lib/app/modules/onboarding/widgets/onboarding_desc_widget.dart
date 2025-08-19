import 'package:dermai/app/core/theme/app_theme_config.dart';
import 'package:flutter/material.dart';

class OnboardingDescWidget extends StatelessWidget {
  final String desc;
  const OnboardingDescWidget({required this.desc, super.key});

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).brightness == Brightness.light
            ? AppThemeConfig.lightColors
            : AppThemeConfig.darkColors;
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 400),
      style: TextStyle(fontSize: 16, color: colors.onboardingDescTextColor),
      child: Text(desc, textAlign: TextAlign.center),
    );
  }
}

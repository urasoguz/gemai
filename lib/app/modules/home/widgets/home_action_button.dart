import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dermai/app/core/theme/app_theme_config.dart';

class HomeActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  const HomeActionButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    // Tema renklerini al
    final colors =
        Theme.of(context).brightness == Brightness.light
            ? AppThemeConfig.lightColors
            : AppThemeConfig.darkColors;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 72,
        width: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.surface,
          boxShadow: [
            BoxShadow(
              color: colors.buttonShadow.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [colors.gradientPrimary, colors.gradientSecondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(
              CupertinoIcons.camera_viewfinder,
              color: colors.buttonIcon,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}

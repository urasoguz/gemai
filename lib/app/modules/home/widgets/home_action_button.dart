import 'package:flutter/cupertino.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';

class HomeActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  const HomeActionButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    // Tema renklerini al

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 72,
        width: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppThemeConfig.primary,
          boxShadow: [
            BoxShadow(
              color: AppThemeConfig.buttonShadow.withValues(alpha: 0.08),
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
                colors: [
                  AppThemeConfig.gradientPrimary,
                  AppThemeConfig.gradientSecondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(
              CupertinoIcons.camera_viewfinder,
              color: AppThemeConfig.buttonIcon,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}

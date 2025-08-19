import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:flutter/material.dart';

class OnboardingImageWidget extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;

  const OnboardingImageWidget({this.icon, this.imagePath, super.key})
    : assert(
        icon != null || imagePath != null,
        'Either icon or imagePath must be provided',
      );

  @override
  Widget build(BuildContext context) {
    final colors =
        AppThemeConfig.primary;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 700),
      curve: Curves.elasticOut,
      builder:
          (context, scale, child) => Transform.scale(
            scale: scale,
            child:
                imagePath != null
                    ? Container(
                      width: 300,
                      height: 300,
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: colors.onboardingImageShadow.withValues(
                              alpha: 0.1,
                            ),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          imagePath!,
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  const SizedBox.shrink(),
                        ),
                      ),
                    )
                    : Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: colors.onboardingImageBackground,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colors.onboardingImageShadow.withValues(
                              alpha: 0.08,
                            ),
                            blurRadius: 32,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        size: 64,
                        color: colors.onboardingImageIcon,
                      ),
                    ),
          ),
    );
  }
}

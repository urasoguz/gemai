import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:gemai/app/modules/onboarding/controller/onboarding_controller.dart';

/// Yeni onboarding tasarımı için footer widget'ı
class NewOnboardingFooter extends StatelessWidget {
  final bool isSmallScreen;
  final OnboardingController controller;

  const NewOnboardingFooter({
    super.key,
    required this.isSmallScreen,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppThemeConfig.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight:
            MediaQuery.of(context).size.height *
            0.5, // Maksimum %50 ekran (paywall ile aynı)
      ),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Ana başlık (her sayfada farklı)
            Obx(() {
              final pageIndex = controller.pageIndex.value;
              return Text(
                _getMainTitle(pageIndex),
                style: TextStyle(
                  fontSize: isSmallScreen ? 20 : 24,
                  fontWeight: FontWeight.bold,
                  color: AppThemeConfig.textPrimary,
                  height: 1.2,
                  decoration: TextDecoration.none, // Alt çizgiyi kaldır
                ),
                textAlign: TextAlign.center,
              );
            }),
            const SizedBox(height: 12),

            // Alt başlık (her sayfada farklı)
            Obx(() {
              final pageIndex = controller.pageIndex.value;
              return Text(
                _getSubTitle(pageIndex),
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 18,
                  color:
                      AppThemeConfig
                          .textPrimary, // Sarı yerine normal text rengi
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none, // Alt çizgiyi kaldır
                ),
                textAlign: TextAlign.center,
              );
            }),

            const SizedBox(height: 16),

            // İlerleme barı (nokta şeklinde) - 4 yuvarlak nokta, sadece mevcut sayfa seçili
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4, // 4 yuvarlak nokta
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width:
                        controller.pageIndex.value == i
                            ? 20
                            : 8, // Sadece mevcut sayfa seçili
                    height: 8,
                    decoration: BoxDecoration(
                      color:
                          controller.pageIndex.value == i
                              ? AppThemeConfig.onboardingButtonBackground
                              : AppThemeConfig.divider,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Devam butonu (paywall ile bire bir aynı)
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.selectionClick();
                  if (controller.pageIndex.value == controller.pageCount - 1) {
                    controller.completeOnboarding();
                  } else {
                    controller.nextPage();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppThemeConfig.buttonBackground, // Paywall ile aynı renk
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  shadowColor: AppThemeConfig.buttonBackground.withValues(
                    alpha: 0.3,
                  ), // Paywall ile aynı
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      controller.pageIndex.value == controller.pageCount - 1
                          ? 'continue'
                              .tr // Son sayfada continue
                          : 'continue'.tr, // Tüm sayfalarda continue
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none, // Alt çizgiyi kaldır
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Footer links (paywall ile bire bir aynı)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFooterButton(
                  text: 'Terms of Use',
                  onPressed: () {
                    // Terms sayfasına git
                    Get.toNamed('/legal', arguments: {'type': 'terms'});
                  },
                ),
                _buildFooterButton(
                  text: 'Privacy Policy',
                  onPressed: () {
                    // Privacy sayfasına git
                    Get.toNamed('/legal', arguments: {'type': 'privacy'});
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _getMainTitle(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return 'Discover detailed\ninfo about rocks';
      case 1:
        return 'Best results with\ncustom AI model';
      case 2:
        return 'Create and manage\nyour collection';
      default:
        return '';
    }
  }

  String _getSubTitle(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return 'Dive deep into the specifics of each rock and mineral you encounter';
      case 1:
        return 'With our advanced database, you can learn the value of every stone you see.';
      case 2:
        return 'Organize, manage, and showcase your growing rock collection with ease';
      default:
        return '';
    }
  }

  /// Footer button helper widget'ı (paywall ile bire bir aynı)
  Widget _buildFooterButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        splashFactory: NoSplash.splashFactory,
        shadowColor: WidgetStateProperty.all(Colors.transparent),
        foregroundColor: WidgetStateProperty.all(AppThemeConfig.textSecondary),
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppThemeConfig.textSecondary,
          fontSize: 12,
          decoration: TextDecoration.none, // Alt çizgiyi kaldır
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

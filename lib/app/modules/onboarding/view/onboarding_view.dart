import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gemai/app/modules/onboarding/controller/onboarding_controller.dart';
import 'package:gemai/app/modules/onboarding/widgets/onboarding_image_widget.dart';
import 'package:gemai/app/modules/onboarding/widgets/onboarding_title_widget.dart';
import 'package:gemai/app/modules/onboarding/widgets/onboarding_desc_widget.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).brightness == Brightness.light
            ? AppThemeConfig.lightColors
            : AppThemeConfig.darkColors;
    final pageController = PageController();
    return Scaffold(
      backgroundColor: colors.onboardingBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 32),
              Expanded(
                child: PageView(
                  controller: pageController,
                  onPageChanged: (i) => controller.pageIndex.value = i,
                  children: [
                    _OnboardingPage(
                      imagePath: 'assets/onboarding/onbarding-1.png',
                      title: 'onboarding_title_1'.tr,
                      desc: 'onboarding_desc_1'.tr,
                    ),
                    _OnboardingPage(
                      imagePath: 'assets/onboarding/onbarding-2.png',
                      title: 'onboarding_title_2'.tr,
                      desc: 'onboarding_desc_2'.tr,
                    ),
                    _OnboardingPage(
                      imagePath: 'assets/onboarding/onbarding-3.png',
                      title: 'onboarding_title_3'.tr,
                      desc: 'onboarding_desc_3'.tr,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    controller.pageCount,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: controller.pageIndex.value == i ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color:
                            controller.pageIndex.value == i
                                ? colors.onboardingPageIndicatorActive
                                : colors.onboardingPageIndicatorInactive,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Obx(() {
                final isLast =
                    controller.pageIndex.value == controller.pageCount - 1;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (!isLast)
                      TextButton(
                        onPressed: controller.skip,
                        style: TextButton.styleFrom(
                          foregroundColor: colors.onboardingSkipTextColor,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('onboarding_skip'.tr),
                      ),
                    Expanded(
                      child: Align(
                        alignment:
                            isLast ? Alignment.center : Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed:
                              isLast
                                  ? controller.completeOnboarding
                                  : () {
                                    pageController.nextPage(
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      curve: Curves.easeInOut,
                                    );
                                    controller.nextPage();
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.onboardingButtonBackground,
                            foregroundColor: colors.onboardingButtonText,
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 36,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            elevation: 6,
                            shadowColor: colors.onboardingButtonShadow
                                .withValues(alpha: 0.15),
                          ),
                          child: Text(
                            isLast
                                ? 'onboarding_start'.tr
                                : 'onboarding_next'.tr,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final IconData? image;
  final String? imagePath;
  final String title;
  final String desc;

  const _OnboardingPage({
    this.image,
    this.imagePath,
    required this.title,
    required this.desc,
  }) : assert(
         image != null || imagePath != null,
         'Either image or imagePath must be provided',
       );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OnboardingImageWidget(icon: image, imagePath: imagePath),
        const SizedBox(height: 40),
        OnboardingTitleWidget(title: title),
        const SizedBox(height: 20),
        OnboardingDescWidget(desc: desc),
      ],
    );
  }
}

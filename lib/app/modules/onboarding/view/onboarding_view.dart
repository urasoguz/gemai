import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gemai/app/modules/onboarding/controller/onboarding_controller.dart';
import 'package:gemai/app/modules/onboarding/widgets/onboarding_image_widget.dart';
import 'package:gemai/app/modules/onboarding/widgets/onboarding_title_widget.dart';
import 'package:gemai/app/modules/onboarding/widgets/onboarding_desc_widget.dart';
import 'package:gemai/app/modules/onboarding/view/new_onboarding_view.dart';
import 'package:gemai/app/core/services/app_settings_service.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    // Üst bardaki sistem metinlerini beyaz yap
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Status bar şeffaf
        statusBarIconBrightness: Brightness.dark, // Android: ikonlar siyah
        statusBarBrightness: Brightness.light, // iOS: metin/ikonlar siyah
        systemNavigationBarColor: Colors.transparent, // Alt navigasyon şeffaf
        systemNavigationBarIconBrightness:
            Brightness.dark, // Alt navigasyon ikonları koyu
      ),
    );

    // Küçük ekran kontrolü
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    // App settings service'den paywall UI değerini al
    final appSettings = Get.find<AppSettingsService>();
    final paywallUi = appSettings.paywallUi;

    // PaywallUi == 2 ise yeni onboarding, değilse eski onboarding
    if (paywallUi == 2) {
      return NewOnboardingView(
        isSmallScreen: isSmallScreen,
        controller: controller,
      );
    }

    // Eski onboarding (mevcut kod)
    final pageController = PageController();
    return Scaffold(
      backgroundColor: AppThemeConfig.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 32),
              Expanded(
                child: PageView(
                  controller: pageController,
                  physics:
                      const NeverScrollableScrollPhysics(), // Geri gitmeyi engelle
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
                                ? AppThemeConfig.onboardingButtonBackground
                                : AppThemeConfig.divider,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Paywall continue button ile aynı tasarım
              Container(
                width: double.infinity,
                height: 56,
                margin: const EdgeInsets.only(bottom: 16),
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    if (controller.pageIndex.value ==
                        controller.pageCount - 1) {
                      controller.completeOnboarding();
                    } else {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                      controller.nextPage();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppThemeConfig.onboardingButtonBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    shadowColor: AppThemeConfig.onboardingButtonBackground
                        .withValues(alpha: 0.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        controller.pageIndex.value == controller.pageCount - 1
                            ? 'continue'
                                .tr // Son sayfada paywall ile aynı metin
                            : 'continue'.tr, // Tüm sayfalarda continue
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
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
    // Dikey taşmayı kesin çözmek için görüntü ve metni oranlayarak dağıtıyoruz
    return LayoutBuilder(
      builder: (context, constraints) {
        final Size screen = MediaQuery.of(context).size;
        final bool isTablet = screen.shortestSide >= 600;
        // Küçük cihazlarda görseli biraz küçült, metne daha fazla alan ver
        final int imageFlex = isTablet ? 6 : 5;
        final int textFlex = isTablet ? 4 : 5;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: imageFlex,
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: isTablet ? 0.72 : 0.88,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: OnboardingImageWidget(
                      icon: image,
                      imagePath: imagePath,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: textFlex,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  OnboardingTitleWidget(title: title),
                  const SizedBox(height: 12),
                  OnboardingDescWidget(desc: desc),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:gemai/app/modules/premium/controller/premium_controller.dart';
import 'package:gemai/app/modules/premium/widgets/new_paywall_header.dart';
import 'package:gemai/app/modules/premium/widgets/new_paywall_subscription.dart';
import 'package:gemai/app/modules/premium/widgets/new_paywall_footer.dart';

/// Yeni paywall tasarımı
class NewPaywallView extends StatelessWidget {
  final bool isSmallScreen;
  final PremiumController controller;

  const NewPaywallView({
    super.key,
    required this.isSmallScreen,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Status bar yazılarını beyaz yap
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    final double statusBar = MediaQuery.of(context).viewPadding.top;
    // Alt panel için ayrılacak minimum güvenli alan (buton+başlık+footer)

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        // Arkaplan görseli (altta kısa fade)
        Image.asset('assets/premium/new_logo.png', fit: BoxFit.cover),

        // Ana içerik (üst header ve alt içerik arasında spaceBetween)
        Positioned(
          top: statusBar,
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Üst Header (feature kartları)
              Expanded(
                child: NewPaywallHeader(
                  isSmallScreen: isSmallScreen,
                  onClose: controller.closeScreen,
                  showCloseButton: controller.showCloseButton,
                  delayedCloseButton: controller.delayedCloseButton,
                  timerController: controller.timerController,
                  showXIcon: controller.showXIcon.value,
                  controller: controller,
                ),
              ),

              // Alt içerik (dibe sabit; küçük ekranda kendi içinde scroll eder)
              Container(
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
                      0.5, // Maksimum %50 ekran
                ),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'premium_new_view_title'.tr,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 18 : 20,
                          fontWeight: FontWeight.bold,
                          color: AppThemeConfig.textPrimary,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Obx(() {
                        if (controller.packages.isEmpty) {
                          return Text(
                            '',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                              color: AppThemeConfig.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          );
                        }
                        final selectedPkg =
                            controller.packages[controller.selectedPlan.value];
                        final info = controller.getPackageDisplayInfo(
                          selectedPkg,
                        );
                        final String displayTitle =
                            (info['trialTitle']?.isNotEmpty == true)
                                ? info['trialTitle']!
                                : (info['planTitle'] ??
                                    selectedPkg.storeProduct.title);
                        final String periodText = info['periodText'] ?? '';
                        final String periodFormat = periodText.replaceAll(
                          'per ',
                          '',
                        );
                        final String priceText =
                            '$displayTitle ${selectedPkg.storeProduct.priceString} / $periodFormat';
                        return Text(
                          priceText,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 14,
                            color: AppThemeConfig.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        );
                      }),
                      const SizedBox(height: 1),
                      Text(
                        'premium_new_view_no_commitment'.tr,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 14,
                          color: AppThemeConfig.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      // Onboarding'den gelinirse 4 yuvarlak nokta göster
                      if (controller.isFromOnboarding) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            4, // 4 yuvarlak nokta
                            (i) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: i == 3 ? 20 : 8, // 4. nokta seçili
                              height: 8,
                              decoration: BoxDecoration(
                                color:
                                    i == 3
                                        ? AppThemeConfig
                                            .onboardingButtonBackground
                                        : AppThemeConfig.divider,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      NewPaywallSubscription(
                        isSmallScreen: isSmallScreen,
                        controller: controller,
                      ),
                      NewPaywallFooter(
                        isSmallScreen: isSmallScreen,
                        controller: controller,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Kapat butonu (sağ üst köşede ayrı)
        if (controller.showCloseButton)
          Positioned(
            top: statusBar,
            right: 16,
            child:
                controller.delayedCloseButton
                    ? // Gecikmeli/animasyonlu kapat butonu
                    Obx(
                      () => SizedBox(
                        width: 40,
                        height: 40,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Çember animasyonu
                            if (!controller.showXIcon.value)
                              AnimatedBuilder(
                                animation: controller.timerController,
                                builder: (context, child) {
                                  return CustomPaint(
                                    painter: _CircleProgressPainter(
                                      controller.timerController.value,
                                    ),
                                    child: const SizedBox(
                                      width: 30,
                                      height: 30,
                                    ),
                                  );
                                },
                              ),
                            // X ikonu fade ile
                            AnimatedOpacity(
                              opacity: controller.showXIcon.value ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 400),
                              child:
                                  controller.showXIcon.value
                                      ? GestureDetector(
                                        onTap: controller.closeScreen,
                                        child: Icon(
                                          Icons.close,
                                          color: AppThemeConfig.paywallCloseIcon
                                              .withOpacity(0.2),
                                          size: 30,
                                        ),
                                      )
                                      : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                    )
                    : // Klasik, hemen erişilebilir kapat butonu
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: AppThemeConfig.paywallCloseIcon,
                        size: 40,
                      ),
                      onPressed: controller.closeScreen,
                    ),
          ),
      ],
    );
  }
}

class _CircleProgressPainter extends CustomPainter {
  final double progress;
  _CircleProgressPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = AppThemeConfig.paywallCloseIcon.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;
    final Rect rect = Offset.zero & size;
    canvas.drawArc(rect.deflate(3), -1.5708, 6.2832 * progress, false, paint);
  }

  @override
  bool shouldRepaint(_CircleProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

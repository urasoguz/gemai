import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gemai/app/modules/premium/controller/premium_controller.dart';
import 'package:gemai/app/modules/premium/widgets/premium_plan_card.dart';
import 'package:gemai/app/modules/premium/widgets/animated_app_icon.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';

/// Eski paywall tasarımı - Tamamen ayrı ve bağımsız
class OldPaywallView extends StatelessWidget {
  final bool isSmallScreen;
  final PremiumController controller;

  const OldPaywallView({
    super.key,
    required this.isSmallScreen,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double statusBarHeight = MediaQuery.of(context).viewPadding.top;
    final double bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final bool compact = screenHeight < 700;

    // Status bar metin/ikonlarını siyah yap
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppThemeConfig.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppThemeConfig.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: AppThemeConfig.transparent,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SizedBox(
          height: screenHeight - statusBarHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Üst kısım - Kapat ve Restore butonları
                    SizedBox(
                      height: 56,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Restore butonu sol üstte
                          Obx(
                            () => _buildTopRestoreButton(
                              isRestoring: controller.isRestoring.value,
                              onPressed:
                                  controller.isRestoring.value
                                      ? null
                                      : controller.restorePurchases,
                            ),
                          ),
                          // Kapat butonu sağ üstte (backend ayarına göre)
                          Obx(() {
                            if (!controller.showCloseButton) {
                              return const SizedBox.shrink(); // paywall_close_button false ise hiçbir kapat butonu gösterme
                            }

                            if (controller.delayedCloseButton) {
                              // Gecikmeli/animasyonlu kapat butonu
                              return SizedBox(
                                width: 40,
                                height: 40,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Çember animasyonu
                                    Obx(
                                      () =>
                                          !controller.showXIcon.value
                                              ? AnimatedBuilder(
                                                animation:
                                                    controller.timerController,
                                                builder: (context, child) {
                                                  return CustomPaint(
                                                    painter:
                                                        _CircleProgressPainter(
                                                          controller
                                                              .timerController
                                                              .value,
                                                        ),
                                                    child: const SizedBox(
                                                      width: 30,
                                                      height: 30,
                                                    ),
                                                  );
                                                },
                                              )
                                              : const SizedBox.shrink(),
                                    ),
                                    // X ikonu fade ile
                                    Obx(
                                      () => AnimatedOpacity(
                                        opacity:
                                            controller.showXIcon.value
                                                ? 1.0
                                                : 0.0,
                                        duration: const Duration(
                                          milliseconds: 400,
                                        ),
                                        child:
                                            controller.showXIcon.value
                                                ? GestureDetector(
                                                  onTap: controller.closeScreen,
                                                  child: Icon(
                                                    Icons.close,
                                                    color:
                                                        AppThemeConfig
                                                            .paywallCloseIcon,
                                                    size: 40,
                                                  ),
                                                )
                                                : const SizedBox.shrink(),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              // Klasik, hemen erişilebilir kapat butonu
                              return IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: AppThemeConfig.paywallCloseIcon,
                                  size: 40,
                                ),
                                onPressed: controller.closeScreen,
                              );
                            }
                          }),
                        ],
                      ),
                    ),

                    // Efektli logo - Responsive boyut (ekran küçüldükçe küçülsün)
                    Center(
                      child: AnimatedAppIcon(
                        size: compact ? 110 : (isSmallScreen ? 140 : 170),
                        backgroundColor: AppThemeConfig.transparent,
                        child: Image.asset(
                          'assets/premium/logo.png',
                          width: compact ? 92 : (isSmallScreen ? 120 : 150),
                          height: compact ? 92 : (isSmallScreen ? 120 : 150),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    SizedBox(height: compact ? 8 : (isSmallScreen ? 10 : 16)),

                    // Başlık - Responsive boyut
                    Text(
                      'premium_title'.tr,
                      style: TextStyle(
                        fontSize: compact ? 22 : (isSmallScreen ? 26 : 30),
                        fontWeight: FontWeight.w600,
                        color: AppThemeConfig.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: compact ? 4 : 5),

                    // Premium özellikler listesi - Responsive boyut
                    SizedBox(
                      width: 400,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:
                            controller.features.map((feature) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical:
                                      compact ? 1.5 : (isSmallScreen ? 2 : 4),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // İkon
                                    SizedBox(
                                      width:
                                          compact
                                              ? 20
                                              : (isSmallScreen ? 22 : 27),
                                      height:
                                          compact
                                              ? 20
                                              : (isSmallScreen ? 22 : 27),
                                      child: Icon(
                                        feature['icon'] as IconData,
                                        color: feature['color'] as Color,
                                        size:
                                            compact
                                                ? 20
                                                : (isSmallScreen ? 22 : 27),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Başlık
                                    Flexible(
                                      child: Text(
                                        feature['title'] as String,
                                        style: TextStyle(
                                          fontSize:
                                              compact
                                                  ? 13
                                                  : (isSmallScreen ? 14 : 16),
                                          color: AppThemeConfig.textPrimary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                      ),
                    ),

                    // Özellikler ve paketler arası boşluk
                    SizedBox(height: compact ? 10 : (isSmallScreen ? 14 : 20)),

                    // Premium plan kartları
                    Obx(
                      () => Column(
                        children: List.generate(controller.packages.length, (
                          idx,
                        ) {
                          final pkg = controller.packages[idx];
                          final info = controller.getPackageDisplayInfo(pkg);
                          final selected = controller.selectedPlan.value == idx;
                          return AnimatedScale(
                            scale: selected ? 1.05 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            child: GestureDetector(
                              onTap: () => controller.selectPlan(idx),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                child: PremiumPlanCard(
                                  title:
                                      info['planTitle'] ??
                                      pkg.storeProduct.title,
                                  subtitle: pkg.storeProduct.priceString,
                                  badgeText: info['badgeText'],
                                  badgeColor: info['badgeColor'],
                                  selected: selected,
                                  onTap: () => controller.selectPlan(idx),
                                  checkColor:
                                      AppThemeConfig.paywallCardBorderCheck,
                                  isTrial: info['isTrial'],
                                  trialTitle: info['trialTitle'],
                                  periodText: info['periodText'],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    // Paketler listesinden sonra ek boşluk
                    SizedBox(height: compact ? 12 : 24),

                    Obx(
                      () =>
                          !controller.hasTrial.value
                              ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                child: Text(
                                  'premium_trial_not_available'.tr,
                                  style: TextStyle(
                                    color: AppThemeConfig.error,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                              : const SizedBox.shrink(),
                    ),

                    // Paket ve buton arası boşluk
                    SizedBox(
                      height:
                          compact
                              ? 12
                              : (isSmallScreen
                                  ? 16
                                  : (controller.showCloseButton ? 0 : 20)),
                    ),

                    // Satın alma butonu
                    Obx(() {
                      final selectedPkg =
                          controller.packages.isNotEmpty
                              ? controller.packages[controller
                                  .selectedPlan
                                  .value]
                              : null;
                      final info =
                          selectedPkg != null
                              ? controller.getPackageDisplayInfo(selectedPkg)
                              : {};
                      final isTrial = info['isTrial'] ?? false;
                      if (controller.isPurchasing.value) {
                        return Center(
                          child: SizedBox(
                            width: 32,
                            height: 32,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppThemeConfig.textPrimary,
                              ),
                              strokeWidth: 3,
                            ),
                          ),
                        );
                      }
                      return Container(
                        width: double.infinity,
                        height: compact ? 50 : 56,
                        margin: EdgeInsets.only(
                          bottom: compact ? 10 : (isSmallScreen ? 12 : 16),
                        ),
                        child: ElevatedButton(
                          onPressed: controller.startTrial,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppThemeConfig.buttonBackground,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 2,
                            shadowColor: AppThemeConfig.buttonBackground
                                .withValues(alpha: 0.3),
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            transitionBuilder:
                                (child, anim) =>
                                    FadeTransition(opacity: anim, child: child),
                            child: Row(
                              key: ValueKey(isTrial),
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  isTrial ? 'try_for_free'.tr : 'continue'.tr,
                                  style: TextStyle(
                                    color: AppThemeConfig.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: AppThemeConfig.white,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    // Kapatma butonu (paywall_close_button false olduğunda)
                    Obx(() {
                      if (controller.showCloseButton) {
                        return const SizedBox.shrink(); // Normal close button gösteriliyorsa bu gizli
                      }
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Center(
                          child: TextButton(
                            onPressed: controller.closeScreen,
                            style: TextButton.styleFrom(
                              foregroundColor: AppThemeConfig.textPrimary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 8,
                              ),
                            ),
                            child: Text(
                              'premium_continue_without'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppThemeConfig.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),

                    // Footer links - Sadece Terms ve Privacy
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: bottomPadding > 0 ? bottomPadding + 16 : 24,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: _buildFooterButton(
                              text: 'premium_terms'.tr,
                              onPressed: controller.openTerms,
                            ),
                          ),
                          Expanded(
                            child: _buildFooterButton(
                              text: 'premium_privacy'.tr,
                              onPressed: controller.openPrivacy,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Footer button helper widget'ı
  Widget _buildFooterButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(AppThemeConfig.transparent),
        splashFactory: NoSplash.splashFactory,
        shadowColor: WidgetStateProperty.all(AppThemeConfig.transparent),
        foregroundColor: WidgetStateProperty.all(AppThemeConfig.textSecondary),
        backgroundColor: WidgetStateProperty.all(AppThemeConfig.transparent),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(color: AppThemeConfig.textSecondary, fontSize: 12),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// Top restore button helper widget'ı (sol üst köşe için)
  Widget _buildTopRestoreButton({
    required bool isRestoring,
    required VoidCallback? onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(AppThemeConfig.transparent),
        splashFactory: NoSplash.splashFactory,
        shadowColor: WidgetStateProperty.all(AppThemeConfig.transparent),
        foregroundColor: WidgetStateProperty.all(AppThemeConfig.textSecondary),
        backgroundColor: WidgetStateProperty.all(AppThemeConfig.transparent),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        ),
      ),
      child:
          isRestoring
              ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppThemeConfig.textSecondary,
                  ),
                  strokeWidth: 2,
                ),
              )
              : Text(
                'premium_restore'.tr,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppThemeConfig.textSecondary,
                ),
              ),
    );
  }
}

class _CircleProgressPainter extends CustomPainter {
  final double progress; // 0.0 - 1.0
  _CircleProgressPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color =
              Get.isDarkMode
                  ? AppThemeConfig.circleProgressDark
                  : AppThemeConfig.circleProgressLight
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;
    final Rect rect = Offset.zero & size;
    canvas.drawArc(
      rect.deflate(3),
      -1.5708, // Başlangıç açısı (yukarıdan başlasın)
      6.2832 * progress, // 2*PI*progress
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_CircleProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

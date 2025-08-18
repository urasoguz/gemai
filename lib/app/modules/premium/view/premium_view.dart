import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gemai/app/modules/premium/controller/premium_controller.dart';
import 'package:gemai/app/modules/premium/widgets/premium_plan_card.dart';
import 'package:gemai/app/modules/premium/widgets/animated_app_icon.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';

class PremiumView extends GetView<PremiumController> {
  const PremiumView({super.key});

  @override
  Widget build(BuildContext context) {
    // Dark/Light mode uyumlu renkler
    final colors =
        Theme.of(context).brightness == Brightness.light
            ? AppThemeConfig.lightColors
            : AppThemeConfig.darkColors;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SizedBox(
          height:
              MediaQuery.of(context)
                  .size
                  .height, // 👈 Burada Column'a tam ekran yüksekliği veriyoruz
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Kapat butonu (backend ayarına göre)
                Obx(() {
                  if (!controller.showCloseButton) {
                    return const SizedBox.shrink(); // paywall_close_button false ise hiçbir kapat butonu gösterme
                  }

                  if (controller.delayedCloseButton) {
                    // Gecikmeli/animasyonlu kapat butonu
                    return Padding(
                      padding: const EdgeInsets.only(top: 8, right: 0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: SizedBox(
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
                                          animation: controller.timerController,
                                          builder: (context, child) {
                                            return CustomPaint(
                                              painter: _CircleProgressPainter(
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
                                      controller.showXIcon.value ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 400),
                                  child:
                                      controller.showXIcon.value
                                          ? GestureDetector(
                                            onTap: controller.closeScreen,
                                            child: Icon(
                                              Icons.close,
                                              color:
                                                  isDark
                                                      ? colors.textSecondary
                                                      : const Color.fromARGB(
                                                        255,
                                                        228,
                                                        228,
                                                        228,
                                                      ),
                                              size: 40,
                                            ),
                                          )
                                          : const SizedBox.shrink(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    // Klasik, hemen erişilebilir kapat butonu
                    return Padding(
                      padding: const EdgeInsets.only(top: 8, right: 0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                            color:
                                isDark
                                    ? colors.textSecondary
                                    : const Color.fromARGB(255, 228, 228, 228),
                            size: 40,
                          ),
                          onPressed: controller.closeScreen,
                        ),
                      ),
                    );
                  }
                }),

                Column(
                  children: [
                    Center(
                      child: AnimatedAppIcon(
                        size: 170,
                        backgroundColor: Colors.transparent,
                        child: Image.asset(
                          isDark
                              ? 'assets/premium/dark_logo.png'
                              : 'assets/premium/light_logo.png',
                          width: 150,
                          height: 150,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    Column(
                      children: [
                        // Başlık - Dark/Light mode uyumlu
                        Text(
                          'premium_title'.tr,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        // Premium özellikler listesi - Basit yapı
                        SizedBox(
                          width: 400,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children:
                                controller.features.map((feature) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // İkon
                                        SizedBox(
                                          width: 27,
                                          height: 27,
                                          child: Icon(
                                            feature['icon'] as IconData,
                                            color: feature['color'] as Color,
                                            size: 27,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        // Başlık
                                        Flexible(
                                          child: Text(
                                            feature['title'] as String,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: colors.textPrimary,
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
                      ],
                    ),
                  ],
                ),
                // Animasyonlu icon - Swift kodundaki gibi
                const SizedBox(height: 0),
                // Premium plan kartları
                Column(
                  children: [
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
                                decoration: BoxDecoration(
                                  boxShadow:
                                      selected
                                          ? [
                                            BoxShadow(
                                              color:
                                                  isDark
                                                      ? Colors.black.withValues(
                                                        alpha: 0.3,
                                                      )
                                                      : Colors.black.withValues(
                                                        alpha: 0.08,
                                                      ),
                                              blurRadius: 16,
                                              offset: const Offset(0, 4),
                                            ),
                                          ]
                                          : [],
                                ),
                                child: PremiumPlanCard(
                                  title:
                                      info['planTitle'] ??
                                      pkg.storeProduct.title,
                                  subtitle: pkg.storeProduct.priceString,
                                  badgeText: info['badgeText'],
                                  badgeColor: info['badgeColor'],
                                  selected: selected,
                                  onTap: () => controller.selectPlan(idx),
                                  checkColor: Colors.blue,
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
                                    color: colors.error,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                              : const SizedBox.shrink(),
                    ),
                  ],
                ),

                //const SizedBox(height: 5),
                Column(
                  children: [
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
                                colors.textPrimary,
                              ),
                              strokeWidth: 3,
                            ),
                          ),
                        );
                      }
                      return Container(
                        width: double.infinity,
                        height: 56,
                        margin: const EdgeInsets.only(bottom: 5),
                        child: ElevatedButton(
                          onPressed: controller.startTrial,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isDark
                                    ? const Color(
                                      0xFF71B280,
                                    ) // Parlak yeşil dark modda
                                    : Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: isDark ? 2 : 0,
                            shadowColor:
                                isDark
                                    ? const Color(
                                      0xFF71B280,
                                    ).withValues(alpha: 0.3)
                                    : Colors.transparent,
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
                      );
                    }),

                    // Kapatma butonu (paywall_close_button false olduğunda)
                    Obx(() {
                      if (controller.showCloseButton) {
                        return const SizedBox.shrink(); // Normal close button gösteriliyorsa bu gizli
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Center(
                          child: TextButton(
                            onPressed: controller.closeScreen,
                            style: TextButton.styleFrom(
                              foregroundColor: colors.textPrimary,
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
                                color: colors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),

                // Footer links - Responsive
                Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Obx(
                      () => _buildFooterRestoreButton(
                        isRestoring: controller.isRestoring.value,
                        onPressed:
                            controller.isRestoring.value
                                ? null
                                : controller.restorePurchases,
                        colors: colors,
                      ),
                    ),
                    _buildFooterButton(
                      text: 'premium_terms'.tr,
                      onPressed: controller.openTerms,
                      colors: colors,
                    ),
                    _buildFooterButton(
                      text: 'premium_privacy'.tr,
                      onPressed: controller.openPrivacy,
                      colors: colors,
                    ),
                  ],
                ),
              ],
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
    required dynamic colors,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        splashFactory: NoSplash.splashFactory,
        shadowColor: WidgetStateProperty.all(Colors.transparent),
        foregroundColor: WidgetStateProperty.all(colors.textSecondary),
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(color: colors.textSecondary, fontSize: 12),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// Restore button helper widget'ı
  Widget _buildFooterRestoreButton({
    required bool isRestoring,
    required VoidCallback? onPressed,
    required dynamic colors,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        splashFactory: NoSplash.splashFactory,
        shadowColor: WidgetStateProperty.all(Colors.transparent),
        foregroundColor: WidgetStateProperty.all(colors.textSecondary),
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
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
                    colors.textSecondary,
                  ),
                  strokeWidth: 2,
                ),
              )
              : Text(
                'premium_restore'.tr,
                style: TextStyle(color: colors.textSecondary, fontSize: 12),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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
                  ? const Color(0xFFBDBDBD)
                  : const Color.fromARGB(255, 228, 228, 228)
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

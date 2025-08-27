import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gemai/app/modules/premium/controller/premium_controller.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';

/// Yeni paywall tasarımı için footer widget'ı
class NewPaywallFooter extends StatelessWidget {
  final bool isSmallScreen;
  final PremiumController controller;

  const NewPaywallFooter({
    super.key,
    required this.isSmallScreen,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Continue butonu
        Obx(() {
          final selectedPkg =
              controller.packages.isNotEmpty
                  ? controller.packages[controller.selectedPlan.value]
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
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              ),
            );
          }

          return Container(
            width: double.infinity,
            height: 56,
            margin: const EdgeInsets.only(bottom: 16),
            child: ElevatedButton(
              onPressed: controller.startTrial,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    AppThemeConfig
                        .buttonBackground, // Eski paywall ile aynı renk
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                shadowColor: AppThemeConfig.buttonBackground.withValues(
                  alpha: 0.3,
                ), // Eski paywall ile aynı
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isTrial ? 'Try for Free' : 'Continue',
                    style: const TextStyle(
                      color:
                          Colors.white, // Eski paywall ile aynı (beyaz metin)
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white, // Eski paywall ile aynı (beyaz ikon)
                    size: 16,
                  ),
                ],
              ),
            ),
          );
        }),

        // Footer links
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildFooterButton(
              text: 'Other Plans',
              icon: Icons.keyboard_arrow_up, // Yukarı ok
              onPressed: () => _showPlansBottomSheet(context),
            ),
            _buildFooterButton(
              text: 'Restore',
              onPressed: controller.restorePurchases,
            ),
            _buildFooterButton(
              text: 'Privacy & EULA',
              onPressed: controller.openPrivacy,
            ),
          ],
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  /// Planları gösteren bottom sheet
  void _showPlansBottomSheet(BuildContext context) {
    // Telefon titreşimi ver
    HapticFeedback.mediumImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: false, // Sadece Hide Plans ile kapanabilir
      enableDrag: true, // Yukarıdan aşağı kaydırma ile kapanabilir
      builder: (context) => _PlansBottomSheet(controller: controller),
    );
  }

  /// Footer button helper widget'ı
  Widget _buildFooterButton({
    required String text,
    required VoidCallback onPressed,
    IconData? icon, // Icon parametresi eklendi
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(color: AppThemeConfig.textSecondary, fontSize: 12),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (icon != null) ...[
            const SizedBox(width: 4),
            Icon(icon, color: AppThemeConfig.textSecondary, size: 16),
          ],
        ],
      ),
    );
  }
}

/// Planları gösteren bottom sheet widget'ı
class _PlansBottomSheet extends StatefulWidget {
  final PremiumController controller;

  const _PlansBottomSheet({required this.controller});

  @override
  State<_PlansBottomSheet> createState() => _PlansBottomSheetState();
}

class _PlansBottomSheetState extends State<_PlansBottomSheet>
    with TickerProviderStateMixin {
  final PageController _testimonialController = PageController();
  int _currentTestimonialIndex = 0;

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  final List<String> _testimonials = [
    'Being a geologist, I\'ve seen many tools. This app provides consistent and reliable results. Good job, developers!',
    'Finally, an app that actually works! I\'ve identified over 50 rocks in my collection with 100% accuracy.',
    'As a rock collector, this app has been a game-changer. The AI recognition is incredibly accurate.',
    'Professional geologist here. This app rivals expensive lab equipment. Highly recommended for field work.',
    'Amazing app! I use it for my geology classes and it helps students learn rock identification quickly.',
  ];

  @override
  void initState() {
    super.initState();

    // Slide animasyonu için controller
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Slide animasyonu - aşağıdan yukarı
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    // Animasyonu başlat
    _slideController.forward();

    _testimonialController.addListener(() {
      final page = _testimonialController.page?.round() ?? 0;
      if (page != _currentTestimonialIndex) {
        setState(() {
          _currentTestimonialIndex = page;
        });
      }
    });
  }

  @override
  void dispose() {
    _testimonialController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: AppThemeConfig.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar kaldırıldı
            const SizedBox(height: 20),

            // Join Millions of Happy Users başlığı
            Text(
              'Join Millions of Happy Users',
              style: TextStyle(
                color: AppThemeConfig.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // 5 yıldız rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Icon(
                  Icons.star,
                  color: const Color(0xFFFFD700),
                  size: 28,
                );
              }),
            ),

            const SizedBox(height: 16),

            // Kayar testimonial'lar
            SizedBox(
              height: 80,
              child: PageView.builder(
                controller: _testimonialController,
                itemCount: _testimonials.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      _testimonials[index],
                      style: TextStyle(
                        fontSize: 16,
                        color: AppThemeConfig.textPrimary,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Pagination dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_testimonials.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: index == _currentTestimonialIndex ? 12 : 8,
                  height: index == _currentTestimonialIndex ? 12 : 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        index == _currentTestimonialIndex
                            ? AppThemeConfig.black
                            : AppThemeConfig.textSecondary.withOpacity(0.3),
                  ),
                );
              }),
            ),

            const SizedBox(height: 32),

            // Paketler listesi - Eski paywall tasarımı ile
            Obx(
              () => Column(
                children: List.generate(widget.controller.packages.length, (
                  idx,
                ) {
                  final pkg = widget.controller.packages[idx];
                  final info = widget.controller.getPackageDisplayInfo(pkg);
                  final selected = widget.controller.selectedPlan.value == idx;

                  return AnimatedScale(
                    scale: selected ? 1.05 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: GestureDetector(
                      onTap: () {
                        widget.controller.selectPlan(idx);
                        // Telefon titreşimi ver
                        HapticFeedback.lightImpact();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        margin: EdgeInsets.only(
                          bottom: info['isTrial'] == true ? 0 : 16,
                          left: 20,
                          right: 20,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppThemeConfig.card,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color:
                                selected
                                    ? AppThemeConfig.paywallCardBorderCheck
                                    : AppThemeConfig.paywallCardBorder,
                            width: selected ? 1 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    // Eski paywall'daki gibi başlık seçimi: trial varsa trialTitle, yoksa planTitle
                                    (info['trialTitle']?.isNotEmpty == true)
                                        ? info['trialTitle']!
                                        : (info['planTitle'] ??
                                            pkg.storeProduct.title),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppThemeConfig.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        pkg.storeProduct.priceString,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppThemeConfig.textSecondary,
                                        ),
                                      ),
                                      if (info['periodText'] != null &&
                                          info['periodText']!.isNotEmpty) ...[
                                        const SizedBox(width: 6),
                                        Text(
                                          info['periodText']!,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppThemeConfig.textHint,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (info['badgeText']?.isNotEmpty == true)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: info['isTrial'] == true ? 10 : 12,
                                  vertical: info['isTrial'] == true ? 8 : 6,
                                ),
                                decoration: BoxDecoration(
                                  color: info['badgeColor'],
                                  borderRadius: BorderRadius.circular(
                                    info['isTrial'] == true ? 8 : 5,
                                  ),
                                  border:
                                      info['isTrial'] == true
                                          ? Border.all(
                                            color: AppThemeConfig.transparent,
                                            width: 1,
                                          )
                                          : null,
                                ),
                                child: Text(
                                  info['badgeText']!,
                                  style: TextStyle(
                                    color:
                                        info['isTrial'] == true
                                            ? AppThemeConfig.textPrimary
                                            : Colors.white,
                                    fontSize: info['isTrial'] == true ? 16 : 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            SizedBox(width: info['isTrial'] == true ? 0 : 10),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      selected
                                          ? AppThemeConfig
                                              .paywallCardBorderCheck
                                          : AppThemeConfig.paywallCardCheck,
                                  width: 2,
                                ),
                                color:
                                    selected
                                        ? AppThemeConfig.paywallCardBorderCheck
                                        : Colors.transparent,
                              ),
                              child:
                                  selected
                                      ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      )
                                      : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 32),

            // Continue butonu
            Obx(() {
              final selectedPkg =
                  widget.controller.packages.isNotEmpty
                      ? widget.controller.packages[widget
                          .controller
                          .selectedPlan
                          .value]
                      : null;
              final info =
                  selectedPkg != null
                      ? widget.controller.getPackageDisplayInfo(selectedPkg)
                      : {};
              final isTrial = info['isTrial'] ?? false;

              if (widget.controller.isPurchasing.value) {
                return Center(
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 3,
                    ),
                  ),
                );
              }

              return Container(
                width: double.infinity,
                height: 56,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: widget.controller.startTrial,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppThemeConfig
                            .buttonBackground, // Eski paywall ile aynı renk
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    shadowColor: AppThemeConfig.buttonBackground.withValues(
                      alpha: 0.3,
                    ), // Eski paywall ile aynı
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isTrial ? 'Try for Free' : 'Continue',
                        style: const TextStyle(
                          color:
                              Colors
                                  .white, // Eski paywall ile aynı (beyaz metin)
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color:
                            Colors.white, // Eski paywall ile aynı (beyaz ikon)
                        size: 16,
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),

            // Footer links
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFooterButton(
                  color: AppThemeConfig.textLink,
                  text: 'Hide Plans',
                  fontWeight: FontWeight.w700,
                  icon: Icons.keyboard_arrow_down, // Aşağı ok
                  onPressed: () {
                    // Telefon titreşimi ver
                    HapticFeedback.mediumImpact();
                    Navigator.pop(context); // Close bottom sheet
                  },
                ),
                _buildFooterButton(
                  color: AppThemeConfig.textSecondary,
                  text: 'Restore',
                  onPressed: widget.controller.restorePurchases,
                ),
                _buildFooterButton(
                  color: AppThemeConfig.textSecondary,
                  text: 'Privacy & EULA',
                  onPressed: widget.controller.openPrivacy,
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Footer button helper widget'ı
  Widget _buildFooterButton({
    required String text,
    required VoidCallback onPressed,
    required Color color,
    FontWeight fontWeight = FontWeight.w500,
    IconData? icon, // Icon parametresi eklendi
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: fontWeight,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (icon != null) ...[
            const SizedBox(width: 4),
            Icon(icon, color: color, size: 16),
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:gemai/app/modules/onboarding/controller/onboarding_controller.dart';
import 'package:gemai/app/modules/onboarding/widgets/new_onboarding_header.dart';
import 'package:gemai/app/modules/onboarding/widgets/new_onboarding_footer.dart';

/// Yeni onboarding tasarımı (paywall tasarımının onboarding versiyonu)
class NewOnboardingView extends StatelessWidget {
  final bool isSmallScreen;
  final OnboardingController controller;

  const NewOnboardingView({
    super.key,
    required this.isSmallScreen,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final double statusBar = MediaQuery.of(context).viewPadding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Arkaplan görseli (her sayfada değişecek) - GERÇEKTEN TAM EKRAN
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: _BackgroundCrossFade(controller: controller),
          ),

          // Ana içerik (üst header ve alt footer arasında spaceBetween)
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
                  child: NewOnboardingHeader(
                    isSmallScreen: isSmallScreen,
                    controller: controller,
                  ),
                ),

                // Alt footer (ilerleme barı ve devam butonu)
                NewOnboardingFooter(
                  isSmallScreen: isSmallScreen,
                  controller: controller,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Özel cross-fade widget'ı - beyazlık olmadan geçiş
class _BackgroundCrossFade extends StatefulWidget {
  final OnboardingController controller;

  const _BackgroundCrossFade({required this.controller});

  @override
  State<_BackgroundCrossFade> createState() => _BackgroundCrossFadeState();
}

class _BackgroundCrossFadeState extends State<_BackgroundCrossFade>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  int _currentPageIndex = 0;
  int _previousPageIndex = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // İlk sayfa
    _currentPageIndex = widget.controller.pageIndex.value;
    _animationController.value = 1.0;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int newPageIndex) {
    if (_currentPageIndex != newPageIndex) {
      setState(() {
        _previousPageIndex = _currentPageIndex;
        _currentPageIndex = newPageIndex;
      });

      // Cross-fade animasyonunu başlat
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final pageIndex = widget.controller.pageIndex.value;

      // Sayfa değiştiğinde animasyonu tetikle
      if (pageIndex != _currentPageIndex) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _onPageChanged(pageIndex);
        });
      }

      return Stack(
        fit: StackFit.expand,
        children: [
          // Önceki görsel (her zaman alttta)
          Image.asset(
            'assets/onboarding/new_${_previousPageIndex + 1}.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // Yeni görsel (fade ile geliyor)
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Image.asset(
                  'assets/onboarding/new_${_currentPageIndex + 1}.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              );
            },
          ),
        ],
      );
    });
  }
}

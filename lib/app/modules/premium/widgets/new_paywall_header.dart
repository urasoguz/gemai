import 'package:flutter/material.dart';
import 'package:gemai/app/modules/premium/controller/premium_controller.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';

/// Yeni paywall tasarımı için header widget'ı
class NewPaywallHeader extends StatefulWidget {
  final bool isSmallScreen;
  final VoidCallback onClose;
  final bool showCloseButton;
  final bool delayedCloseButton;
  final AnimationController? timerController;
  final bool showXIcon;
  final PremiumController controller;

  const NewPaywallHeader({
    super.key,
    required this.isSmallScreen,
    required this.onClose,
    required this.showCloseButton,
    required this.delayedCloseButton,
    this.timerController,
    required this.showXIcon,
    required this.controller,
  });

  @override
  State<NewPaywallHeader> createState() => _NewPaywallHeaderState();
}

class _NewPaywallHeaderState extends State<NewPaywallHeader>
    with TickerProviderStateMixin {
  late List<AnimationController> _cardControllers;
  late List<Animation<double>> _cardAnimations;
  late List<Animation<double>> _scaleAnimations;

  @override
  void initState() {
    super.initState();

    // 6 card için animasyon controller'ları oluştur
    _cardControllers = List.generate(6, (index) {
      return AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );
    });

    // Opacity animasyonları (yoktan var olma)
    _cardAnimations =
        _cardControllers.map((controller) {
          return Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
        }).toList();

    // Scale animasyonları (küçükten büyüyerek gelme)
    _scaleAnimations =
        _cardControllers.map((controller) {
          return Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeOutBack),
          );
        }).toList();

    // Sırayla animasyonları başlat (soldan sağa)
    _startAnimations();
  }

  void _startAnimations() async {
    // Soldan sağa sıralama: [0,2,4,1,3,5]
    final animationOrder = [0, 2, 4, 1, 3, 5];
    for (int i = 0; i < animationOrder.length; i++) {
      await Future.delayed(Duration(milliseconds: 100 * i));
      if (mounted) {
        _cardControllers[animationOrder[i]].forward();
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _cardControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Gradient ile "Elevate Your Complete Rock Experience" kısmından önce saydamlaştır
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [1, 0.6, 0.8, 1],
          colors: [
            Colors.transparent,
            Colors.transparent,
            AppThemeConfig.background.withOpacity(0.7),
            AppThemeConfig.background,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 50.0, 0, 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 6 Feature Card'ları (2x3 Grid) - Responsive kartlar
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = constraints.maxWidth;
                  final isSmallScreen = screenWidth < 400;
                  final cardSpacing =
                      isSmallScreen ? 8.0 : 12.0; // Daha fazla boşluk
                  final horizontalPadding = isSmallScreen ? 16.0 : 20.0;

                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // İlk satır (2 card)
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2, // Metin kartı - daha küçük
                                child: SizedBox(
                                  height: 120, // Daha karemsi yükseklik
                                  child: _buildAnimatedFeatureCard(
                                    index: 0,
                                    text: 'Unlimited scans',
                                    isText: true,
                                    isSmallScreen: isSmallScreen,
                                  ),
                                ),
                              ),
                              SizedBox(width: cardSpacing),
                              Expanded(
                                flex: 3, // Fotoğraf kartı - daha büyük
                                child: SizedBox(
                                  height: 120, // Daha karemsi yükseklik
                                  child: _buildAnimatedFeatureCard(
                                    index: 1,
                                    imagePath: 'assets/premium/p1_r1.png',
                                    glowColor: const Color.fromARGB(
                                      119,
                                      7,
                                      25,
                                      39,
                                    ),
                                    isText: false,
                                    isSmallScreen: isSmallScreen,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: cardSpacing * 1.2,
                        ), // Daha fazla satır arası boşluk
                        // İkinci satır (2 card)
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3, // Fotoğraf kartı - daha büyük
                                child: SizedBox(
                                  height: 120, // Daha karemsi yükseklik
                                  child: _buildAnimatedFeatureCard(
                                    index: 2,
                                    imagePath: 'assets/premium/p1_r2.png',
                                    glowColor: const Color.fromARGB(
                                      58,
                                      66,
                                      46,
                                      11,
                                    ),
                                    isText: false,
                                    isSmallScreen: isSmallScreen,
                                  ),
                                ),
                              ),
                              SizedBox(width: cardSpacing),
                              Expanded(
                                flex: 2, // Metin kartı - daha küçük
                                child: SizedBox(
                                  height: 120, // Daha karemsi yükseklik
                                  child: _buildAnimatedFeatureCard(
                                    index: 3,
                                    text: 'Premium features',
                                    isText: true,
                                    isSmallScreen: isSmallScreen,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: cardSpacing * 1.2,
                        ), // Daha fazla satır arası boşluk
                        // Üçüncü satır (2 card)
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2, // Metin kartı - daha küçük
                                child: SizedBox(
                                  height: 120, // Daha karemsi yükseklik
                                  child: _buildAnimatedFeatureCard(
                                    index: 4,
                                    text: 'Expert support',
                                    isText: true,
                                    isSmallScreen: isSmallScreen,
                                  ),
                                ),
                              ),
                              SizedBox(width: cardSpacing),
                              Expanded(
                                flex: 3, // Fotoğraf kartı - daha büyük
                                child: SizedBox(
                                  height: 120, // Daha karemsi yükseklik
                                  child: _buildAnimatedFeatureCard(
                                    index: 5,
                                    imagePath: 'assets/premium/p1_r3.png',
                                    glowColor: const Color.fromARGB(
                                      89,
                                      4,
                                      52,
                                      58,
                                    ),
                                    isText: false,
                                    isSmallScreen: isSmallScreen,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Animasyonlu feature card widget'ı
  Widget _buildAnimatedFeatureCard({
    required int index,
    String? text,
    IconData? icon,
    Color? iconColor,
    String? imagePath,
    Color? glowColor,
    required bool isText,
    required bool isSmallScreen,
  }) {
    return AnimatedBuilder(
      animation: _cardControllers[index],
      builder: (context, child) {
        return Opacity(
          opacity: _cardAnimations[index].value,
          child: Transform.scale(
            scale: _scaleAnimations[index].value,
            child: _buildFeatureCard(
              text: text,
              icon: icon,
              iconColor: iconColor,
              imagePath: imagePath,
              glowColor: glowColor,
              isText: isText,
              isSmallScreen: isSmallScreen,
            ),
          ),
        );
      },
    );
  }

  /// Feature card widget'ı
  Widget _buildFeatureCard({
    String? text,
    IconData? icon,
    Color? iconColor,
    String? imagePath,
    Color? glowColor,
    required bool isText,
    required bool isSmallScreen,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Yatay dikdörtgen yapı için genişliği kullan
        final cardWidth = constraints.maxWidth;
        final cardHeight = constraints.maxHeight;

        return Container(
          width: cardWidth,
          height: cardHeight,
          decoration: BoxDecoration(
            // Cam tasarımı (glassmorphism) - BackdropFilter olmadan
            color: Colors.white.withOpacity(0.08), // Daha şeffaf arka plan
            borderRadius: BorderRadius.circular(20), // Yuvarlatılmış köşeler
            border: Border.all(
              color: Colors.white.withOpacity(0.3), // Daha belirgin border
              width: 1.5,
            ),
            // Cam efekti için box shadow
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 25,
                spreadRadius: 0,
                offset: const Offset(0, 15),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.15),
                blurRadius: 2,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
            // Gradient ile cam efekti
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.02),
                Colors.white.withOpacity(0.08),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: Center(
            child:
                isText
                    ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        text!,
                        style: TextStyle(
                          color: Colors.white, // Beyaz metin
                          fontSize: 15, // Daha büyük font
                          fontWeight: FontWeight.w700, // Daha kalın font
                          decoration: TextDecoration.none,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.6),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                    : imagePath != null
                    ? _buildGlowingImage(imagePath, glowColor!, isLarge: true)
                    : Icon(icon!, color: iconColor, size: 40),
          ),
        );
      },
    );
  }

  /// Parlayan görsel widget'ı
  Widget _buildGlowingImage(
    String imagePath,
    Color glowColor, {
    bool isLarge = false,
  }) {
    final size = isLarge ? 70.0 : 50.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Cam tasarımına uygun glow efekti
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.4),
            blurRadius: isLarge ? 30 : 25,
            spreadRadius: isLarge ? 10 : 8,
            offset: const Offset(0, 0),
          ),
          BoxShadow(
            color: glowColor.withOpacity(0.2),
            blurRadius: isLarge ? 60 : 50,
            spreadRadius: isLarge ? 20 : 15,
            offset: const Offset(0, 0),
          ),
          // Ek cam efekti
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: isLarge ? 15 : 10,
            spreadRadius: isLarge ? 5 : 3,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // Cam efekti için gradient
          gradient: RadialGradient(
            colors: [Colors.white.withOpacity(0.1), Colors.transparent],
          ),
        ),
        child: Center(
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain, // contain ile görsel tam sığacak
            width: size * 0.9, // Görsel boyutunu büyüttüm
            height: size * 0.9, // Görsel boyutunu büyüttüm
          ),
        ),
      ),
    );
  }
}

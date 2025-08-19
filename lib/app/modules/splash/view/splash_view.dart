import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  final String _text = AppThemeConfig.appName;

  @override
  void initState() {
    super.initState();

    // Tek controller ile tüm animasyonlar
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Fade animasyonu - yumuşak giriş
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    // Scale animasyonu - hafif büyüme
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutBack),
      ),
    );

    // Slide animasyonu - aşağıdan yukarı
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.1, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mainController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Tema renklerini al

    return Scaffold(
      backgroundColor: AppThemeConfig.background,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppThemeConfig.gradientPrimary,
              AppThemeConfig.gradientSecondary,
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _mainController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Text(
                      _text,
                      style: GoogleFonts.koHo(
                        fontSize: 42,
                        fontWeight: FontWeight.w600,
                        color: AppThemeConfig.splashTextColor,
                        letterSpacing: 2.5,
                        shadows: [
                          Shadow(
                            color: AppThemeConfig.splashTextShadowColor
                                .withValues(alpha: 0.4),
                            offset: const Offset(0, 3),
                            blurRadius: 6,
                          ),
                          Shadow(
                            color: AppThemeConfig.splashTextColor.withValues(
                              alpha: 0.2,
                            ),
                            offset: const Offset(0, 0),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:get/get.dart';

class AnalysisScanningOverlay extends StatefulWidget {
  final bool isVisible;

  const AnalysisScanningOverlay({super.key, required this.isVisible});

  @override
  State<AnalysisScanningOverlay> createState() =>
      _AnalysisScanningOverlayState();
}

class _AnalysisScanningOverlayState extends State<AnalysisScanningOverlay>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _scanController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();

    // Fade animasyonu
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Tarama animasyonu
    _scanController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );

    if (widget.isVisible) {
      _controller.forward();
      _scanController.repeat();
    }
  }

  @override
  void didUpdateWidget(AnalysisScanningOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _controller.forward();
        _scanController.repeat();
      } else {
        _controller.reverse();
        _scanController.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).brightness == Brightness.light
            ? AppThemeConfig.lightColors
            : AppThemeConfig.darkColors;

    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Visibility(
          visible: _fadeAnimation.value > 0,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.transparent,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: colors.background.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Tarama animasyonu
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: Stack(
                              children: [
                                // Dış çember
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: colors.primary.withValues(
                                        alpha: 0.3,
                                      ),
                                      width: 2,
                                    ),
                                  ),
                                ),

                                // Tarama çizgisi
                                AnimatedBuilder(
                                  animation: _scanAnimation,
                                  builder: (context, child) {
                                    return Positioned(
                                      top: 120 * _scanAnimation.value - 1,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: 2,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.transparent,
                                              colors.primary,
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                // Merkez ikonu
                                Center(
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: colors.primary.withValues(
                                        alpha: 0.2,
                                      ),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: colors.primary.withValues(
                                          alpha: 0.3,
                                        ),
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.biotech_rounded, // DNA/analiz ikonu
                                      size: 28,
                                      color: colors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Analiz ediliyor yazısı
                          Text(
                            'skin_analysis_scanning'.tr,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Alt yazı
                          Text(
                            'skin_analysis_scanning_desc'.tr,
                            style: TextStyle(
                              fontSize: 14,
                              color: colors.textSecondary,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 20),

                          // Yükleme çubuğu
                          Container(
                            width: 200,
                            height: 4,
                            decoration: BoxDecoration(
                              color: colors.divider,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: AnimatedBuilder(
                              animation: _scanAnimation,
                              builder: (context, child) {
                                return FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor:
                                      (_scanAnimation.value * 0.7) + 0.3,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: colors.primary,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

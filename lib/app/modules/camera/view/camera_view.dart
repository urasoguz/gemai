import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gemai/app/modules/camera/controller/camera_controller.dart';
import 'package:gemai/app/modules/camera/widgets/camera_preview_widget.dart';
import 'dart:io';

/// DermAI için Camerawesome ile gömülü kamera view'ı
class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller'ı bağla
    final CameraController controller = Get.put(CameraController());

    return Scaffold(
      backgroundColor: AppThemeConfig.cameraScaffold,
      body: SafeArea(
        child: Stack(
          children: [
            // Ana kamera widget'ı
            const CameraPreviewWidget(),

            // Analiz overlay'i
            Obx(() {
              if (controller.isAnalyzing.value) {
                return _buildAnalysisOverlay(context, controller);
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  /// Modern analiz overlay'i
  /// Yukarıdan aşağıya tarama efekti ile
  Widget _buildAnalysisOverlay(
    BuildContext context,
    CameraController controller,
  ) {
    return Container(
      color: AppThemeConfig.cameraAnalyzeBackground.withValues(alpha: 0.9),
      child: Stack(
        children: [
          // Arka plan görseli (çekilen fotoğraf)
          if (controller.capturedImagePath.value.isNotEmpty)
            Positioned.fill(
              child: Image.file(
                File(controller.capturedImagePath.value),
                fit: BoxFit.cover,
              ),
            ),

          // Tarama efekti
          Positioned.fill(
            child: CustomPaint(
              painter: ScanEffectPainter(
                progress: controller.scanProgress.value,
                context: context,
              ),
            ),
          ),

          // Merkez içerik - Responsive
          Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenHeight = MediaQuery.of(context).size.height;
                final isSmallScreen = screenHeight < 700;

                return Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 16 : 24,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 16 : 24,
                    vertical: isSmallScreen ? 16 : 24,
                  ),
                  decoration: BoxDecoration(
                    color: AppThemeConfig.cameraAnalyzeBackground.withValues(
                      alpha: 0.65,
                    ),
                    borderRadius: BorderRadius.circular(
                      isSmallScreen ? 16 : 24,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppThemeConfig.cameraAnalyzeBackgroundShadow
                            .withValues(alpha: 0.18),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // DermAI logo animasyonu - Responsive
                      Container(
                        width: isSmallScreen ? 60.0 : 80.0,
                        height: isSmallScreen ? 60.0 : 80.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              AppThemeConfig.gradientPrimary,
                              AppThemeConfig.gradientSecondary,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppThemeConfig.cameraAnalyzeLogoIconShadow
                                  .withValues(alpha: 0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.medical_services,
                          color: AppThemeConfig.cameraAnalyzeLogoIcon,
                          size: isSmallScreen ? 30.0 : 40.0,
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 16 : 24),

                      // Başlık - Responsive
                      Text(
                        'camera_scanning'.tr,
                        style: TextStyle(
                          color: AppThemeConfig.cameraAnalyzeTitleText,
                          fontSize: isSmallScreen ? 16 : 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 8 : 12),

                      // Alt başlık - Responsive
                      Text(
                        'camera_scanning_desc'.tr,
                        style: TextStyle(
                          color: AppThemeConfig.cameraAnalyzeText,
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isSmallScreen ? 20 : 32),

                      // İlerleme çubuğu - Responsive
                      Container(
                        width: isSmallScreen ? 160 : 200,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppThemeConfig.cameraAnalyzeProgressBackground
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Obx(
                          () => LinearProgressIndicator(
                            value: controller.scanProgress.value,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppThemeConfig.cameraAnalyzeProgressBar,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 12 : 16),

                      // İlerleme yüzdesi - Responsive
                      Obx(
                        () => Text(
                          '${(controller.scanProgress.value * 100).toInt()}%',
                          style: TextStyle(
                            color: AppThemeConfig.cameraAnalyzeText,
                            fontSize: isSmallScreen ? 16 : 18,
                            fontWeight: FontWeight.w600,
                          ),
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
    );
  }
}

/// Yukarıdan aşağıya tarama efekti için CustomPainter
class ScanEffectPainter extends CustomPainter {
  final double progress;
  final BuildContext context;

  ScanEffectPainter({required this.progress, required this.context});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = AppThemeConfig.cameraAnalyzeEffect.withValues(alpha: 0.3)
          ..style = PaintingStyle.fill;

    // Tarama çizgisi
    final scanLineY = size.height * progress;
    final scanLineHeight = 4.0;

    canvas.drawRect(
      Rect.fromLTWH(
        0,
        scanLineY - scanLineHeight / 2,
        size.width,
        scanLineHeight,
      ),
      paint,
    );

    // Tarama efekti (gradient)
    final gradientPaint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppThemeConfig.cameraAnalyzeEffect.withValues(alpha: 0.1),
              AppThemeConfig.cameraAnalyzeEffect.withValues(alpha: 0.3),
              AppThemeConfig.cameraAnalyzeEffect.withValues(alpha: 0.1),
            ],
            stops: [0.0, 0.5, 1.0],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, scanLineY - 20, size.width, 40),
      gradientPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

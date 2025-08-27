import 'package:flutter/cupertino.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:gemai/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gemai/app/modules/camera/controller/camera_controller.dart';
import 'package:gemai/app/modules/camera/widgets/photo_tips_dialog.dart';

/// DermAI için Camerawesome ile gömülü kamera widget'ı
class CamerawesomeWidget extends GetView<CameraController> {
  const CamerawesomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // İlk açılışta otomatik dialog kontrolü
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final shouldShow = await PhotoTipsDialog.shouldShowOnFirstOpen();
      if (shouldShow) {
        // Kısa bir gecikme ile dialog'u göster
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (context.mounted) {
            PhotoTipsDialog.show(context);
          }
        });
      }
    });

    return Obx(() {
      // Eğer analiz yapılıyorsa hiçbir şey gösterme (AnalysisWidget gösterilecek)
      if (controller.isAnalyzing.value) {
        return const SizedBox.shrink();
      }

      // Normal kamera arayüzü - eski fotoğraf önizlemesi kaldırıldı
      return _buildCameraAwesome(context);
    });
  }

  /// Kamera arayüzü
  Widget _buildCameraAwesome(BuildContext context) {
    return Obx(
      () => KeyedSubtree(
        key: ValueKey<int>(controller.cameraRebuildKey.value),
        child: CameraAwesomeBuilder.awesome(
          saveConfig: SaveConfig.photo(),
          sensorConfig: SensorConfig.single(
            sensor: Sensor.position(SensorPosition.back),
            aspectRatio: CameraAspectRatios.ratio_4_3,
            zoom: 0.0,
            flashMode: controller.flashMode.value,
          ),
          previewFit: CameraPreviewFit.contain,
          theme: AwesomeTheme(
            bottomActionsBackgroundColor: AppThemeConfig
                .cameraBottomActionsBackgroundColor
                .withValues(alpha: 0.3),
            buttonTheme: AwesomeButtonTheme(
              backgroundColor: AppThemeConfig.cameraThemeBackgroundColor
                  .withValues(alpha: 0.2),
              iconSize: 24,
              foregroundColor: AppThemeConfig.cameraThemeForegroundColor,
              padding: const EdgeInsets.all(16),
            ),
          ),
          onMediaCaptureEvent: (event) {
            if (event.status == MediaCaptureStatus.success && event.isPicture) {
              event.captureRequest.when(
                single: (single) {
                  if (single.file?.path != null) {
                    // Fotoğraf çekildikten sonra direkt analiz başlat
                    controller.capturedImagePath.value = single.file!.path;
                    controller.startAnalysis();
                  }
                },
                multiple: (multiple) {
                  final firstFile = multiple.fileBySensor.values.first;
                  if (firstFile?.path != null) {
                    // Fotoğraf çekildikten sonra direkt analiz başlat
                    controller.capturedImagePath.value = firstFile!.path;
                    controller.startAnalysis();
                  }
                },
              );
            }
          },
          topActionsBuilder: (state) => _buildModernTopBar(context, state),
          middleContentBuilder: (state) => _buildSmartOverlay(context, state),
          bottomActionsBuilder:
              (state) => _buildModernBottomBar(context, state),
        ),
      ),
    );
  }

  /// Modern üst bar
  Widget _buildModernTopBar(BuildContext context, CameraState state) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isVerySmallScreen = screenHeight < 650;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      height: isVerySmallScreen ? 60 : 70,
      color: AppThemeConfig.cameraScaffold,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _circleButton(
            icon: Icons.close,
            onTap: () {
              if (Get.key.currentState?.canPop() ?? false) {
                Get.back();
              } else {
                Get.offAllNamed(AppRoutes.home);
              }
            },
            context: context,
          ),
          _circleButton(
            icon: CupertinoIcons.question,
            onTap: () {
              PhotoTipsDialog.show(context);
            },
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required BuildContext context,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppThemeConfig.cameraCircleButtonBackgroundColor.withValues(
            alpha: 0.12,
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AppThemeConfig.cameraCircleButtonBorder.withValues(
              alpha: 0.2,
            ),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppThemeConfig.cameraCircleButtonShadow.withValues(
                alpha: 0.08,
              ),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            color: AppThemeConfig.cameraCircleButtonIcon,
            size: 22,
          ),
        ),
      ),
    );
  }

  /// Akıllı overlay - çerçeve ile entegre
  Widget _buildSmartOverlay(BuildContext context, CameraState state) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;
    final isVerySmallScreen = screenHeight < 650;

    // Ekran boyutuna göre frame boyutunu ayarla
    final frameSize =
        isVerySmallScreen
            ? 180.0 // Daha küçük ekranlar için daha küçük frame
            : isSmallScreen
            ? 220.0 // Küçük ekranlar için orta frame
            : 260.0; // Normal ekranlar için büyük frame

    // Ekran boyutuna göre spacing'i daha agresif ayarla
    final spacing =
        isVerySmallScreen
            ? 15.0 // Çok küçük ekranlarda minimum spacing
            : isSmallScreen
            ? 20.0 // Küçük ekranlarda az spacing
            : 25.0; // Normal ekranlarda orta spacing

    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          painter: SmartOverlayPainter(
            screenSize: Size(constraints.maxWidth, constraints.maxHeight),
            frameSize: frameSize,
            spacing: spacing,
            isSmallScreen: isSmallScreen,
            overlayColor: Colors.black.withValues(alpha: 0.6),
          ),
          child: Center(
            child: _buildCenteredContent(
              context,
              state,
              frameSize,
              spacing,
              isSmallScreen,
            ),
          ),
        );
      },
    );
  }

  /// Ortalanmış ana içerik
  Widget _buildCenteredContent(
    BuildContext context,
    CameraState state,
    double frameSize,
    double spacing,
    bool isSmallScreen,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Başlık baloncuğu
        _buildTitleBubble(context, isSmallScreen),

        SizedBox(height: spacing * 0.8), // Spacing'i biraz azalt
        // Ana çerçeve
        _buildFrame(context, frameSize),

        SizedBox(height: spacing * 0.6), // Spacing'i daha da azalt
        // Zoom kontrolü
        _buildZoomControl(context, state),
      ],
    );
  }

  /// Başlık baloncuğu
  Widget _buildTitleBubble(BuildContext context, bool isSmallScreen) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isVerySmallScreen = screenHeight < 650;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          padding: EdgeInsets.symmetric(
            horizontal: isVerySmallScreen ? 14 : (isSmallScreen ? 16 : 20),
            vertical: isVerySmallScreen ? 6 : (isSmallScreen ? 8 : 10),
          ),
          decoration: BoxDecoration(
            color: AppThemeConfig.cameraScanFrameBackground.withValues(
              alpha: 0.7,
            ),
            borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            'Taşın en desenli kısmına odaklayın',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppThemeConfig.cameraScanFrameTitleText,
              fontSize: isSmallScreen ? 12 : 13,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        ClipPath(
          clipper: TriangleClipper(),
          child: Container(
            width: 20,
            height: 10,
            color: AppThemeConfig.cameraScanFrameBackground.withValues(
              alpha: 0.7,
            ),
          ),
        ),
      ],
    );
  }

  /// Sadece çerçeve köşeleri
  Widget _buildFrame(BuildContext context, double frameSize) {
    return SizedBox(
      width: frameSize,
      height: frameSize,
      child: Stack(
        children: [
          // Sarı köşe işaretleri
          Positioned(top: 0, left: 0, child: _cornerBox(topLeft: true)),
          Positioned(top: 0, right: 0, child: _cornerBox(topRight: true)),
          Positioned(bottom: 0, left: 0, child: _cornerBox(bottomLeft: true)),
          Positioned(bottom: 0, right: 0, child: _cornerBox(bottomRight: true)),
        ],
      ),
    );
  }

  /// Köşe işaretleri
  Widget _cornerBox({
    bool topLeft = false,
    bool topRight = false,
    bool bottomLeft = false,
    bool bottomRight = false,
  }) {
    return SizedBox(
      width: 70,
      height: 70,
      child: CustomPaint(
        painter: CornerPainter(
          color: const Color(0xFFFFD700),
          thickness: 4,
          isTopLeft: topLeft,
          isTopRight: topRight,
          isBottomLeft: bottomLeft,
          isBottomRight: bottomRight,
        ),
      ),
    );
  }

  /// Zoom kontrolü
  Widget _buildZoomControl(BuildContext context, CameraState state) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isVerySmallScreen = screenHeight < 650;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 2,
        vertical: isVerySmallScreen ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: AppThemeConfig.cameraCircleButtonBackgroundColor.withValues(
          alpha: 0.2,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppThemeConfig.cameraCircleButtonBorder.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _zoomButton(context, state, 0.0, '0.5x'),
          _zoomButton(context, state, 0.03, '1x'),
          _zoomButton(context, state, 0.06, '2x'),
        ],
      ),
    );
  }

  Widget _zoomButton(
    BuildContext context,
    CameraState state,
    double zoomLevel,
    String label,
  ) {
    return StreamBuilder<double>(
      stream: state.sensorConfig.zoom$,
      builder: (context, snapshot) {
        final currentZoom = snapshot.data ?? 0.0;
        final isActive = (currentZoom - zoomLevel).abs() < 0.01;

        return GestureDetector(
          onTap: () => state.sensorConfig.setZoom(zoomLevel),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color:
                  isActive
                      ? AppThemeConfig.cameraThemeBackgroundColor.withValues(
                        alpha: 0.8,
                      )
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              label,
              style: TextStyle(
                color:
                    isActive
                        ? AppThemeConfig.white
                        : AppThemeConfig.cameraCircleButtonIcon,
                fontSize: isActive ? 16 : 14,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernBottomBar(BuildContext context, CameraState state) {
    return Container(
      color: Colors.black, // Tam siyah yapıldı
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20), // Üstten boşluk artırıldı
          // Eski tasarım - AwesomeBottomActions ile
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20), // Yatay margin
            child: AwesomeBottomActions(
              state: state,
              left: _buildModernGalleryButton(context),
              right: _buildFlashButton(context, state),
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
          const SizedBox(height: 24), // Alttan boşluk artırıldı
        ],
      ),
    );
  }

  Widget _buildFlashButton(BuildContext context, CameraState state) {
    return StreamBuilder<FlashMode>(
      stream: state.sensorConfig.flashMode$,
      builder: (context, snapshot) {
        final flashMode = snapshot.data ?? FlashMode.none;
        return GestureDetector(
          onTap: () {
            FlashMode nextFlash =
                flashMode == FlashMode.always
                    ? FlashMode.none
                    : FlashMode.always;
            state.sensorConfig.setFlashMode(nextFlash);
          },
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppThemeConfig.cameraGalleryButtonBackgroundColor
                  .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: AppThemeConfig.cameraGalleryButtonBorder.withValues(
                  alpha: 0.3,
                ),
                width: 1,
              ),
            ),
            child: Center(
              child: Icon(
                flashMode == FlashMode.always
                    ? Icons.flash_on
                    : Icons.flash_off,
                color: AppThemeConfig.cameraGalleryButtonIcon,
                size: 28,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernGalleryButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picker = ImagePicker();
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
        );
        if (image != null) {
          // Galeri'den fotoğraf seçildikten sonra direkt analiz başlat
          controller.capturedImagePath.value = image.path;
          controller.startAnalysis();
        }
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: AppThemeConfig.cameraGalleryButtonBackgroundColor.withValues(
            alpha: 0.2,
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: AppThemeConfig.cameraGalleryButtonBorder.withValues(
              alpha: 0.3,
            ),
            width: 1,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.photo_library,
            color: AppThemeConfig.cameraGalleryButtonIcon,
            size: 28,
          ),
        ),
      ),
    );
  }
}

/// Akıllı overlay painter - widget layout'unu taklit ediyor
class SmartOverlayPainter extends CustomPainter {
  final Size screenSize;
  final double frameSize;
  final double spacing;
  final bool isSmallScreen;
  final Color overlayColor;

  SmartOverlayPainter({
    required this.screenSize,
    required this.frameSize,
    required this.spacing,
    required this.isSmallScreen,
    required this.overlayColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = overlayColor
          ..style = PaintingStyle.fill;

    // Tüm ekranı kaplayan path
    final fullScreenPath =
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Center widget'ındaki Column layout'unu taklit et
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Başlık yüksekliğini tahmin et
    final titleHeight =
        (isSmallScreen ? 35.0 : 40.0) + 10; // container + triangle

    // Column içindeki toplam yükseklik - daha konservatif hesaplama
    final totalContentHeight =
        titleHeight +
        spacing +
        frameSize +
        (spacing * 0.75) +
        50; // 50 zoom height tahmini

    // Column'un başlangıç y koordinatı
    final contentStartY = centerY - (totalContentHeight / 2);

    // Çerçevenin y koordinatı (responsive offset)
    final screenHeight = size.height;
    double dynamicOffset;

    if (screenHeight < 650) {
      dynamicOffset = screenHeight * 0.005; // Çok küçük ekranlarda %3
    } else if (screenHeight < 700) {
      dynamicOffset = screenHeight * 0.005; // Küçük ekranlarda %2.5
    } else if (screenHeight < 800) {
      dynamicOffset = screenHeight * 0.02; // Orta ekranlarda %2
    } else {
      dynamicOffset = screenHeight * 0.015; // Büyük ekranlarda %1.5
    }

    final frameY = contentStartY + titleHeight + spacing + dynamicOffset;

    // Çerçeve alanı
    final frameRect = Rect.fromCenter(
      center: Offset(centerX, frameY + (frameSize / 2)),
      width: frameSize,
      height: frameSize,
    );

    // Delik path
    final holePath = Path()..addRect(frameRect);

    // Delik çıkarma işlemi
    final finalPath = Path.combine(
      PathOperation.difference,
      fullScreenPath,
      holePath,
    );

    canvas.drawPath(finalPath, paint);
  }

  @override
  bool shouldRepaint(covariant SmartOverlayPainter oldDelegate) {
    return oldDelegate.frameSize != frameSize ||
        oldDelegate.spacing != spacing ||
        oldDelegate.isSmallScreen != isSmallScreen ||
        oldDelegate.overlayColor != overlayColor;
  }
}

/// L şeklinde köşe çizgiler için custom painter
class CornerPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final bool isTopLeft;
  final bool isTopRight;
  final bool isBottomLeft;
  final bool isBottomRight;

  CornerPainter({
    required this.color,
    required this.thickness,
    this.isTopLeft = false,
    this.isTopRight = false,
    this.isBottomLeft = false,
    this.isBottomRight = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = thickness
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

    final cornerLength = size.width * 0.9;
    final radius = 6.0;

    if (isTopLeft) {
      final path = Path();
      path.moveTo(0, cornerLength);
      path.lineTo(0, radius);
      path.quadraticBezierTo(0, 0, radius, 0);
      path.lineTo(cornerLength, 0);
      canvas.drawPath(path, paint);
    }

    if (isTopRight) {
      final path = Path();
      path.moveTo(size.width - cornerLength, 0);
      path.lineTo(size.width - radius, 0);
      path.quadraticBezierTo(size.width, 0, size.width, radius);
      path.lineTo(size.width, cornerLength);
      canvas.drawPath(path, paint);
    }

    if (isBottomLeft) {
      final path = Path();
      path.moveTo(0, size.height - cornerLength);
      path.lineTo(0, size.height - radius);
      path.quadraticBezierTo(0, size.height, radius, size.height);
      path.lineTo(cornerLength, size.height);
      canvas.drawPath(path, paint);
    }

    if (isBottomRight) {
      final path = Path();
      path.moveTo(size.width, size.height - cornerLength);
      path.lineTo(size.width, size.height - radius);
      path.quadraticBezierTo(
        size.width,
        size.height,
        size.width - radius,
        size.height,
      );
      path.lineTo(size.width - cornerLength, size.height);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Üçgen çizen clipper
class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.45, size.height * 0.6);
    path.lineTo(size.width * 0.55, size.height * 0.6);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

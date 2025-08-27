import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gemai/app/modules/camera/controller/camera_controller.dart';
import 'dart:math';

/// iOS tarzı minimal analiz ekranı widget'ı
/// Altın tonları ve modern iOS tasarım anlayışı
class AnalysisWidget extends StatefulWidget {
  const AnalysisWidget({super.key});

  @override
  State<AnalysisWidget> createState() => _AnalysisWidgetState();
}

class _AnalysisWidgetState extends State<AnalysisWidget>
    with TickerProviderStateMixin {
  AnimationController? _scanningController;
  AnimationController? _magnifierController;
  Animation<double>? _scanningAnimation;
  Animation<double>? _magnifierAnimation;
  bool _isDisposed = false;

  // iOS tarzı renk paleti
  static const Color primaryGold = Color(0xFFE6D7B8);
  static const Color secondaryGold = Color(0xFFD4A574);

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupProgressListener();
  }

  void _initializeAnimations() {
    if (_isDisposed) return;

    // Minimal scanning animasyonu
    _scanningController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _scanningAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanningController!, curve: Curves.easeInOut),
    );

    // Subtle magnifier animasyonu
    _magnifierController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _magnifierAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _magnifierController!,
        curve: Curves.easeInOutSine,
      ),
    );

    _startAnimations();
  }

  void _setupProgressListener() {
    final controller = Get.find<CameraController>();
    ever(controller.scanProgress, (double progress) {
      if (_isDisposed) return;

      if (progress >= 1.0) {
        _stopAnimations();
      } else if (progress >= 0.0) {
        if (!_scanningController!.isAnimating) {
          _startAnimations();
        }
      }
    });

    // Analiz durumunu dinle - geri gitme kısıtlaması için
    ever(controller.isAnalyzing, (bool isAnalyzing) {
      if (_isDisposed) return;

      if (isAnalyzing) {
        _startAnimations();
      } else {
        _stopAnimations();
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    try {
      _scanningController?.dispose();
      _magnifierController?.dispose();
    } catch (e) {
      return;
    }
    super.dispose();
  }

  void _startAnimations() {
    if (_isDisposed) return;
    try {
      _scanningController?.repeat();
      _magnifierController?.repeat();
    } catch (e) {
      return;
    }
  }

  void _stopAnimations() {
    if (_isDisposed) return;

    final controller = Get.find<CameraController>();
    if (!controller.isAnalyzing.value) {
      try {
        _scanningController?.stop();
        _magnifierController?.stop();
      } catch (e) {
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CameraController>();
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: PopScope(
        canPop: !controller.isAnalyzing.value,
        child: AbsorbPointer(
          absorbing: controller.isAnalyzing.value,
          child: WillPopScope(
            onWillPop: () async {
              if (controller.isAnalyzing.value) {
                return false;
              }
              return true;
            },
            child: SafeArea(
              child: Column(
                children: [
                  // iOS tarzı minimal header
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Text(
                      'Identification...',
                      style: TextStyle(
                        fontSize: 24,
                        color: primaryGold,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),

                  // Ana içerik
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Stack(
                        children: [
                          // Ana fotoğraf container - iOS tarzı
                          Center(
                            child: Container(
                              width: screenSize.width * 0.85,
                              height: screenSize.height * 0.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: primaryGold.withOpacity(0.3),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: secondaryGold.withOpacity(0.1),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14.5),
                                child: Stack(
                                  children: [
                                    // Fotoğraf
                                    Obx(() {
                                      final imagePath =
                                          controller.capturedImagePath.value;
                                      if (imagePath.isNotEmpty) {
                                        return Image.file(
                                          File(imagePath),
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        );
                                      }
                                      return Container(
                                        color: Colors.grey[900],
                                        child: Icon(
                                          Icons.image_outlined,
                                          size: 48,
                                          color: primaryGold.withOpacity(0.6),
                                        ),
                                      );
                                    }),

                                    // Minimal grid overlay
                                    Positioned.fill(
                                      child: CustomPaint(
                                        painter: _MinimalGridPainter(),
                                      ),
                                    ),

                                    // iOS tarzı scanning line
                                    _buildScanningLine(screenSize.height * 0.5),

                                    // Minimal corner indicators
                                    _buildCornerIndicators(),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Subtle magnifier animation
                          _buildMagnifierIcon(screenSize),
                        ],
                      ),
                    ),
                  ),

                  // Alt progress alanı - iOS tarzı
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        _buildIOSProgress(),
                        const SizedBox(height: 16),
                        _buildStatusText(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// iOS tarzı minimal scanning line
  Widget _buildScanningLine(double imageHeight) {
    if (_scanningAnimation == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _scanningAnimation!,
      builder: (context, child) {
        final position = _scanningAnimation!.value * (imageHeight - 40);

        return Positioned(
          top: 20 + position,
          left: 30,
          right: 30,
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  primaryGold.withOpacity(0.4),
                  primaryGold,
                  primaryGold.withOpacity(0.4),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
              ),
              borderRadius: BorderRadius.circular(1),
              boxShadow: [
                BoxShadow(color: primaryGold.withOpacity(0.3), blurRadius: 4),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Minimal köşe göstergeleri
  Widget _buildCornerIndicators() {
    return Stack(
      children: [
        // Sadece köşelerde minimal çizgiler
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: primaryGold, width: 2),
                left: BorderSide(color: primaryGold, width: 2),
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
              ),
            ),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: primaryGold, width: 2),
                right: BorderSide(color: primaryGold, width: 2),
              ),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(4),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 12,
          left: 12,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: primaryGold, width: 2),
                left: BorderSide(color: primaryGold, width: 2),
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(4),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 12,
          right: 12,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: primaryGold, width: 2),
                right: BorderSide(color: primaryGold, width: 2),
              ),
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Subtle magnifier icon
  Widget _buildMagnifierIcon(Size screenSize) {
    if (_magnifierAnimation == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _magnifierAnimation!,
      builder: (context, child) {
        final progress = _magnifierAnimation!.value;
        final xPosition =
            (screenSize.width - 60) * (0.5 + 0.2 * sin(progress * 2 * pi));

        return Positioned(
          bottom: 140,
          left: xPosition,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.8),
              border: Border.all(
                color: secondaryGold.withOpacity(0.6),
                width: 1.5,
              ),
            ),
            child: Icon(Icons.search, color: primaryGold, size: 24),
          ),
        );
      },
    );
  }

  /// iOS tarzı progress circle
  Widget _buildIOSProgress() {
    return Obx(() {
      final controller = Get.find<CameraController>();
      final progress = controller.scanProgress.value;

      return SizedBox(
        width: 80,
        height: 80,
        child: Stack(
          children: [
            // Background circle
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[900],
                  border: Border.all(
                    color: primaryGold.withOpacity(0.2),
                    width: 2,
                  ),
                ),
              ),
            ),
            // Progress indicator
            Center(
              child: SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 3,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(secondaryGold),
                ),
              ),
            ),
            // Percentage text
            Center(
              child: Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: primaryGold,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  /// Clean status text
  Widget _buildStatusText() {
    return Obx(() {
      final controller = Get.find<CameraController>();
      final progress = controller.scanProgress.value;

      String statusText;
      if (progress < 0.25) {
        statusText = 'Object recognition';
      } else if (progress < 0.5) {
        statusText = 'AI analysis...';
      } else if (progress < 0.75) {
        statusText = 'Processing data...';
      } else {
        statusText = 'Finalizing results...';
      }

      return Text(
        statusText,
        style: TextStyle(
          fontSize: 15,
          color: primaryGold.withOpacity(0.8),
          fontWeight: FontWeight.w500,
        ),
      );
    });
  }
}

/// Minimal grid painter - iOS tarzı
class _MinimalGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFFE6D7B8).withOpacity(0.1)
          ..strokeWidth = 0.5;

    // Sabit boyutlu kareler - her kare 20x20 piksel
    const double squareSize = 20.0;

    // Yatay çizgiler - her 20 pikselde bir
    for (double y = squareSize; y < size.height; y += squareSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Dikey çizgiler - her 20 pikselde bir
    for (double x = squareSize; x < size.width; x += squareSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

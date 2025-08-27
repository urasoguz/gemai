import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Fotoğraf çekme ipuçları için animasyonlu dialog
class PhotoTipsDialog extends StatefulWidget {
  const PhotoTipsDialog({super.key});

  @override
  State<PhotoTipsDialog> createState() => _PhotoTipsDialogState();

  /// İlk açılışta otomatik gösterilip gösterilmeyeceğini kontrol eder
  static Future<bool> shouldShowOnFirstOpen() async {
    final prefs = await SharedPreferences.getInstance();
    final hasShownBefore = prefs.getBool('photo_tips_shown') ?? false;

    if (!hasShownBefore) {
      // İlk defa gösteriliyor, flag'i set et
      await prefs.setBool('photo_tips_shown', true);
      return true;
    }

    return false;
  }

  /// Dialog'u gösterir
  static Future<void> show(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => const PhotoTipsDialog(),
    );
  }
}

class _PhotoTipsDialogState extends State<PhotoTipsDialog> {
  int _currentIndex = 0;
  Timer? _timer;
  bool _isPaused = false; // Mükemmel olan gösterildiğinde duraklatma flag'i

  // İpuçları listesi - 6 farklı durum
  final List<Map<String, dynamic>> _tips = [
    {
      'label': 'Uzak',
      'isGood': false,
      'image': 'assets/camera/amethyst.png',
      'effect': 'far', // Sadece uzak
    },
    {
      'label': 'Çok yakın',
      'isGood': false,
      'image': 'assets/camera/amethyst.png',
      'effect': 'close', // Çok yakın
    },
    {
      'label': 'Karanlık',
      'isGood': false,
      'image': 'assets/camera/amethyst.png',
      'effect': 'dark', // Sadece karanlık
    },
    {
      'label': 'Bulanık',
      'isGood': false,
      'image': 'assets/camera/amethyst.png',
      'effect': 'blurry',
    },
    {
      'label': 'Farklı Türde Taşlar',
      'isGood': false,
      'image': 'assets/camera/rocks.png',
      'effect': null,
    },
    {
      'label': 'Mükemmel',
      'isGood': true,
      'image': 'assets/camera/amethyst.png',
      'effect': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    // İlk ipucunu göster ve timer'ı başlat
    _startTimer();
  }

  /// Timer'ı başlatır - mükemmel olan geldiğinde bekleme süresi ekler
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPaused) return; // Duraklatılmışsa hiçbir şey yapma

      // Widget hala ekranda mı kontrol et
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        // Mükemmel olan geldiğinde 3 saniye bekle
        if (_tips[_currentIndex]['isGood'] == true) {
          _isPaused = true; // Duraklat
          timer.cancel();

          // 3 saniye sonra devam et
          Timer(const Duration(seconds: 3), () {
            // Widget hala ekranda mı kontrol et
            if (mounted) {
              setState(() {
                _isPaused = false;
                _currentIndex = (_currentIndex + 1) % _tips.length;
              });
              _startTimer(); // Timer'ı tekrar başlat
            }
          });
        } else {
          // Normal ipuçları için 1 saniyede değiş
          _currentIndex = (_currentIndex + 1) % _tips.length;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tip = _tips[_currentIndex];
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.height < 700;
    final isVerySmallScreen = screenSize.height < 600;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical:
            isVerySmallScreen
                ? 10
                : isSmallScreen
                ? 20
                : 40,
      ),
      child: SafeArea(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: screenSize.height * 0.8,
            maxWidth: screenSize.width * 0.9,
          ),
          padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Başlık
                Text(
                  'Yapış İpuçları',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 18 : 20,
                    fontWeight: FontWeight.bold,
                    color: AppThemeConfig.textPrimary,
                  ),
                ),

                SizedBox(height: isSmallScreen ? 6 : 8),

                // Açıklama metni
                Text(
                  'Net, yüksek kaliteli fotoğraflar en iyi sonuçlara yol açar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 13 : 14,
                    color: AppThemeConfig.textSecondary.withValues(alpha: 0.8),
                  ),
                ),

                SizedBox(height: isSmallScreen ? 16 : 24),

                // METİN LABEL - Çerçeve dışında, üstte
                Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (
                      Widget child,
                      Animation<double> animation,
                    ) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: Container(
                      key: ValueKey<String>(tip['label']),
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 12 : 16,
                        vertical: isSmallScreen ? 6 : 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            tip['isGood']
                                ? Icons.check_circle
                                : tip['effect'] == 'far_dark'
                                ? Icons.error
                                : tip['effect'] == 'blurry'
                                ? Icons.error
                                : Icons.error,
                            color:
                                tip['isGood']
                                    ? const Color(0xFF4CAF50)
                                    : tip['effect'] == 'far_dark'
                                    ? const Color(0xFFE53935)
                                    : tip['effect'] == 'blurry'
                                    ? const Color(0xFFE53935)
                                    : const Color(0xFFE53935),
                            size: isSmallScreen ? 18 : 20,
                          ),
                          SizedBox(width: isSmallScreen ? 4 : 6),
                          Flexible(
                            child: Text(
                              tip['label'],
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: isSmallScreen ? 16 : 20,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 1,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Mükemmel olan gösterildiğinde loading indicator
                          if (tip['isGood'] && _isPaused) ...[
                            SizedBox(width: isSmallScreen ? 4 : 6),
                            SizedBox(
                              width: isSmallScreen ? 16 : 18,
                              height: isSmallScreen ? 16 : 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  const Color(0xFF4CAF50),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: isSmallScreen ? 12 : 16),

                // Animasyonlu görsel alanı - ÇERÇEVE (metin olmadan)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (
                    Widget child,
                    Animation<double> animation,
                  ) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: Container(
                    key: ValueKey<int>(_currentIndex),
                    width:
                        isVerySmallScreen
                            ? 200
                            : isSmallScreen
                            ? 240
                            : 280,
                    height:
                        isVerySmallScreen
                            ? 200
                            : isSmallScreen
                            ? 240
                            : 280,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F0E8),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF8D6E63).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // 1. GÖRSEL + EFEKTLER - TÜM ALANI KAPLIYOR
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: _buildFrameContent(tip),
                          ),
                        ),

                        // 2. Köşe çerçeveleri - TAM KÖŞELERDE
                        ..._buildCornerFrames(),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: isSmallScreen ? 16 : 24),

                // Kapatma butonu
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemeConfig.textLink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: isSmallScreen ? 14 : 16,
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Anladım!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 15 : 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Çerçeve içeriği - Görsel + efektler
  Widget _buildFrameContent(Map<String, dynamic> tip) {
    Widget baseImage = Image.asset(tip['image'], fit: BoxFit.contain);

    // Görsel boyutunu duruma göre ayarla
    double imageSize = _getImageSize(tip['effect']);

    Widget imageWidget = Center(
      child: SizedBox(width: imageSize, height: imageSize, child: baseImage),
    );

    // Efekti uygula
    if (tip['effect'] == 'far') {
      // Sadece uzak - görseli küçült
      return imageWidget;
    } else if (tip['effect'] == 'close') {
      // Aşırı yakın - nesne belli olmuyor
      final screenSize = MediaQuery.of(context).size;
      final isSmallScreen = screenSize.height < 700;
      final isVerySmallScreen = screenSize.height < 600;

      // OverflowBox boyutlarını ekran boyutuna göre ayarla
      double maxSize =
          isVerySmallScreen
              ? 200
              : isSmallScreen
              ? 250
              : 300;
      double scale =
          isVerySmallScreen
              ? 2.0
              : isSmallScreen
              ? 2.2
              : 2.5;

      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: OverflowBox(
          maxWidth: maxSize,
          maxHeight: maxSize,
          child: Transform.scale(
            scale: scale, // Aşırı büyütme
            child: imageWidget,
          ),
        ),
      );
    } else if (tip['effect'] == 'dark') {
      // Sadece karanlık - tüm çerçeveyi kaplar
      return Stack(
        children: [
          imageWidget,
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.65),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      );
    } else if (tip['effect'] == 'blurry') {
      // Blur efekti - tüm çerçeveyi etkiler
      return ImageFiltered(
        imageFilter: ui.ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
        child: imageWidget,
      );
    } else {
      // Perfect veya wrong - efektsiz
      return imageWidget;
    }
  }

  /// Duruma göre görsel boyutu - responsive
  double _getImageSize(String? effect) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.height < 700;
    final isVerySmallScreen = screenSize.height < 600;

    // Temel boyutları ekran boyutuna göre ayarla
    double baseSize =
        isVerySmallScreen
            ? 0.6
            : isSmallScreen
            ? 0.8
            : 1.0;

    switch (effect) {
      case 'far':
        return (70 * baseSize).roundToDouble(); // Çok küçük - uzak
      case 'close':
        return (300 * baseSize)
            .roundToDouble(); // Aşırı büyük - nesne belli olmuyor
      case 'dark':
        return (140 * baseSize).roundToDouble(); // Orta boyut - karanlıkta
      case 'blurry':
        return (140 * baseSize).roundToDouble(); // Orta boyut
      default:
        return (180 * baseSize).roundToDouble(); // Normal boyut - büyük
    }
  }

  /// Köşe çerçeveleri - TAM KÖŞELERDE - responsive
  List<Widget> _buildCornerFrames() {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.height < 700;
    final isVerySmallScreen = screenSize.height < 600;

    // Köşe boyutlarını ekran boyutuna göre ayarla
    double cornerLength =
        isVerySmallScreen
            ? 25
            : isSmallScreen
            ? 30
            : 35;
    double strokeWidth =
        isVerySmallScreen
            ? 3
            : isSmallScreen
            ? 3.5
            : 4;
    const Color frameColor = AppThemeConfig.textLink; // Kahverengi

    return [
      // Sol üst köşe - TAM KÖŞEDE
      Positioned(
        top: 0,
        left: 0,
        child: SizedBox(
          width: cornerLength,
          height: cornerLength,
          child: CustomPaint(
            painter: CornerPainter(
              color: frameColor,
              strokeWidth: strokeWidth,
              corner: Corner.topLeft,
            ),
          ),
        ),
      ),
      // Sağ üst köşe - TAM KÖŞEDE
      Positioned(
        top: 0,
        right: 0,
        child: SizedBox(
          width: cornerLength,
          height: cornerLength,
          child: CustomPaint(
            painter: CornerPainter(
              color: frameColor,
              strokeWidth: strokeWidth,
              corner: Corner.topRight,
            ),
          ),
        ),
      ),
      // Sol alt köşe - TAM KÖŞEDE
      Positioned(
        bottom: 0,
        left: 0,
        child: SizedBox(
          width: cornerLength,
          height: cornerLength,
          child: CustomPaint(
            painter: CornerPainter(
              color: frameColor,
              strokeWidth: strokeWidth,
              corner: Corner.bottomLeft,
            ),
          ),
        ),
      ),
      // Sağ alt köşe - TAM KÖŞEDE
      Positioned(
        bottom: 0,
        right: 0,
        child: SizedBox(
          width: cornerLength,
          height: cornerLength,
          child: CustomPaint(
            painter: CornerPainter(
              color: frameColor,
              strokeWidth: strokeWidth,
              corner: Corner.bottomRight,
            ),
          ),
        ),
      ),
    ];
  }
}

enum Corner { topLeft, topRight, bottomLeft, bottomRight }

class CornerPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final Corner corner;
  final double radius;
  final double armFactor; // 0..1 arası: kolların uzunluğu

  CornerPainter({
    required this.color,
    required this.strokeWidth,
    required this.corner,
    this.radius = 20,
    this.armFactor = 1.4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final ax = size.width * armFactor;
    final ay = size.height * armFactor;

    switch (corner) {
      case Corner.topLeft:
        path.moveTo(0, ay);
        path.lineTo(0, radius);
        path.arcToPoint(
          Offset(radius, 0),
          radius: Radius.circular(radius),
          clockwise: true,
        );
        path.lineTo(ax, 0);
        break;

      case Corner.topRight:
        path.moveTo(size.width * (1 - armFactor), 0);
        path.lineTo(size.width - radius, 0);
        path.arcToPoint(
          Offset(size.width, radius),
          radius: Radius.circular(radius),
          clockwise: true,
        );
        path.lineTo(size.width, ay);
        break;

      case Corner.bottomLeft:
        path.moveTo(0, size.height * (1 - armFactor));
        path.lineTo(0, size.height - radius);
        path.arcToPoint(
          Offset(radius, size.height),
          radius: Radius.circular(radius),
          clockwise: false, // ⬅️ alt köşede ters
        );
        path.lineTo(ax, size.height);
        break;

      case Corner.bottomRight:
        path.moveTo(size.width * (1 - armFactor), size.height);
        path.lineTo(size.width - radius, size.height);
        path.arcToPoint(
          Offset(size.width, size.height - radius),
          radius: Radius.circular(radius),
          clockwise: false, // ⬅️ alt köşede ters
        );
        path.lineTo(size.width, size.height * (1 - armFactor));
        break;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CornerPainter old) =>
      old.color != color ||
      old.strokeWidth != strokeWidth ||
      old.corner != corner ||
      old.radius != radius ||
      old.armFactor != armFactor;
}

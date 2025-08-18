import 'package:flutter/material.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:get/get.dart';

// Modern ve minimal şiddet derecesi göstergesi
class SeverityIndicatorWidget extends StatelessWidget {
  final int value; // 1-10 arası değer
  final double width;
  final double height;

  const SeverityIndicatorWidget({
    super.key,
    required this.value,
    this.width = 180,
    this.height = 32,
  });

  // Şiddet derecesine göre renk döndürür
  Color getSeverityColor(BuildContext context, int value) {
    final colors =
        Theme.of(context).brightness == Brightness.light
            ? AppThemeConfig.lightColors
            : AppThemeConfig.darkColors;
    if (value <= 3) return colors.severityIndicatorColor1; // Yeşil
    if (value <= 6) return colors.severityIndicatorColor2; // Sarı
    if (value <= 8) return colors.severityIndicatorColor3; // Turuncu
    return colors.severityIndicatorColor4; // Kırmızı
  }

  // Şiddet derecesine göre başlık döndürür
  String getSeverityLabel(int value) {
    if (value <= 2) return 'result_severity_low'.tr;
    if (value <= 4) return 'result_severity_medium'.tr;
    if (value <= 6) return 'result_severity_high'.tr;
    if (value <= 8) return 'result_severity_very_high'.tr;
    return 'result_severity_very_very_very_high'.tr;
  }

  @override
  Widget build(BuildContext context) {
    final color = getSeverityColor(context, value);
    final colors =
        Theme.of(context).brightness == Brightness.light
            ? AppThemeConfig.lightColors
            : AppThemeConfig.darkColors;
    //final label = getSeverityLabel(value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Başlık (küçük, bold, renkli)
        // Padding(
        //   padding: const EdgeInsets.only(left: 2, bottom: 2),
        //   child: Text(
        //     label,
        //     style: TextStyle(
        //       fontSize: 13,
        //       fontWeight: FontWeight.w700,
        //       color: color,
        //       letterSpacing: 0.1,
        //     ),
        //   ),
        // ),
        SizedBox(
          width: width,
          height: height,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: (value - 1) / 9.0),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            builder: (context, percent, child) {
              return CustomPaint(
                painter: _SeverityBarPainter(
                  percent: percent,
                  color: color,
                  colors: colors,
                  barHeight: 5,
                  markerRadius: 8,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Modern bar ve işaretçi çizimi
class _SeverityBarPainter extends CustomPainter {
  final double percent; // 0.0 - 1.0
  final Color color;
  final double barHeight;
  final double markerRadius;
  final ColorPalette colors;

  _SeverityBarPainter({
    required this.percent,
    required this.color,
    required this.colors,
    this.barHeight = 5,
    this.markerRadius = 8,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final barY = size.height / 2;
    final start = Offset(0, barY);
    final end = Offset(size.width, barY);

    // Arka plan barı (çok silik)
    final bgPaint =
        Paint()
          ..color = colors.divider.withValues(alpha: 0.18)
          ..strokeWidth = barHeight
          ..strokeCap = StrokeCap.round;
    canvas.drawLine(start, end, bgPaint);

    // Dolan bar (soft gradient)
    final gradient = LinearGradient(
      colors: [
        colors.severityIndicatorColor1,
        colors.severityIndicatorColor2,
        colors.severityIndicatorColor3,
        colors.severityIndicatorColor4,
      ],
      stops: [0.0, 0.4, 0.7, 1.0],
    );
    final rect = Rect.fromLTWH(0, barY - barHeight / 2, size.width, barHeight);
    final fgPaint =
        Paint()
          ..shader = gradient.createShader(rect)
          ..strokeWidth = barHeight
          ..strokeCap = StrokeCap.round;
    canvas.drawLine(start, Offset(size.width * percent, barY), fgPaint);

    // İşaretçi (yarı saydam daire, shadow ile)
    final markerX = size.width * percent;
    final markerY = barY;
    final markerPaint =
        Paint()
          ..color = color.withValues(alpha: 0.85)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawCircle(Offset(markerX, markerY), markerRadius, markerPaint);

    // Dış kenar (beyaz, çok ince)
    final borderPaint =
        Paint()
          ..color = colors.divider.withValues(alpha: 0.85)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
    canvas.drawCircle(Offset(markerX, markerY), markerRadius, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

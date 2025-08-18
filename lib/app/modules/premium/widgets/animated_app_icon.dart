import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Animasyonlu uygulama ikonu widget'ı
///
/// Premium sayfasının üst kısmında sallanan ve yaklaşan bir ikon gösterir.
/// Swift koduna uygun smooth animasyon.
class AnimatedAppIcon extends StatelessWidget {
  final double size;
  final Color backgroundColor;
  final Widget child;

  const AnimatedAppIcon({
    super.key,
    required this.size,
    required this.backgroundColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [],
          ),
          child: Center(child: child),
        )
        // Animasyonun tekrarlanmasını sağlar
        .animate(onPlay: (controller) => controller.repeat())
        .then(delay: 1.5.seconds)
        // Yakınlaşma ve sallanma animasyonlarını aynı anda başlatır
        .shake(
          duration: 1.0.seconds,
          hz: 3,
          rotation: 0.08,
          curve: Curves.easeInOut,
        )
        .scale(
          duration: 1.0.seconds,
          begin: const Offset(0.9, 0.9),
          end: const Offset(0.95, 0.95),
          curve: Curves.easeInOut,
        )
        .then()
        .shake(
          duration: 1.0.seconds,
          hz: 3,
          rotation: 0.08,
          curve: Curves.easeInOut,
        )
        // Yakınlaşma ve sallanma tamamlandıktan sonra, ikon eski boyutuna döner
        .scale(
          duration: 1.0.seconds,
          begin: const Offset(0.95, 0.95),
          end: const Offset(0.9, 0.9),
          curve: Curves.easeInOut,
        );
    // Tekrar başlamadan önce 2 saniye bekler
  }
}

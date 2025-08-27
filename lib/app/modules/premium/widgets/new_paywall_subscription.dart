import 'package:flutter/material.dart';
import 'package:gemai/app/modules/premium/controller/premium_controller.dart';

/// Yeni paywall tasarımı için subscription widget'ı
class NewPaywallSubscription extends StatelessWidget {
  final bool isSmallScreen;
  final PremiumController controller;

  const NewPaywallSubscription({
    super.key,
    required this.isSmallScreen,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // Boş widget çünkü Other Plans footer'a taşındı
  }
}

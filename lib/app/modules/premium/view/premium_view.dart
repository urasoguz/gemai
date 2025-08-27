import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gemai/app/modules/premium/controller/premium_controller.dart';
import 'package:gemai/app/modules/premium/widgets/old_paywall_view.dart';
import 'package:gemai/app/modules/premium/widgets/new_paywall_view.dart';
import 'package:gemai/app/core/services/app_settings_service.dart';

class PremiumView extends GetView<PremiumController> {
  const PremiumView({super.key});

  @override
  Widget build(BuildContext context) {
    // Üst bardaki sistem metinlerini beyaz yap
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Status bar şeffaf
        statusBarIconBrightness: Brightness.light, // Status bar ikonları beyaz
        statusBarBrightness: Brightness.dark, // iOS için status bar koyu tema
        systemNavigationBarColor: Colors.transparent, // Alt navigasyon şeffaf
        systemNavigationBarIconBrightness:
            Brightness.dark, // Alt navigasyon ikonları koyu
      ),
    );

    // Küçük ekran kontrolü
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    // App settings service'den paywall UI değerini al
    final appSettings = Get.find<AppSettingsService>();
    final paywallUi = appSettings.paywallUi;

    return Scaffold(
      body:
          paywallUi == 2
              ? NewPaywallView(
                isSmallScreen: isSmallScreen,
                controller: controller,
              )
              : SafeArea(
                child: OldPaywallView(
                  isSmallScreen: isSmallScreen,
                  controller: controller,
                ),
              ),
    );
  }
}

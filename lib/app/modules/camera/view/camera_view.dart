import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gemai/app/modules/camera/controller/camera_controller.dart';
import 'package:gemai/app/modules/camera/widgets/camera_preview_widget.dart';

/// DermAI için kamera view'ı
/// Yeni analiz widget'ı ile entegre edildi
class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    // Üst bardaki sistem metinlerini siyah yap (camera için - home'a dönünce siyah olsun)
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppThemeConfig.transparent, // Status bar şeffaf
        statusBarIconBrightness: Brightness.dark, // Status bar ikonları siyah
        statusBarBrightness: Brightness.light, // iOS için status bar açık tema
        systemNavigationBarColor:
            AppThemeConfig.transparent, // Alt navigasyon şeffaf
        systemNavigationBarIconBrightness:
            Brightness.dark, // Alt navigasyon ikonları koyu
      ),
    );

    // Controller'ı bağla
    Get.put(CameraController());

    return Scaffold(
      backgroundColor: AppThemeConfig.cameraScaffold,
      body: SafeArea(child: const CameraPreviewWidget()),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gemai/app/modules/camera/widgets/camerawesome_widget.dart';
import 'package:gemai/app/modules/camera/widgets/analysis_widget.dart';
import 'package:gemai/app/modules/camera/controller/camera_controller.dart';

/// DermAI için kamera preview widget'ı
class CameraPreviewWidget extends GetView<CameraController> {
  const CameraPreviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Eğer analiz yapılıyorsa analiz widget'ını göster
      if (controller.isAnalyzing.value) {
        return const AnalysisWidget();
      }

      // Normal kamera arayüzü
      return const CamerawesomeWidget();
    });
  }
}

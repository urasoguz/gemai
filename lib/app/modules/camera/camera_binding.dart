import 'package:get/get.dart';
import 'package:gemai/app/modules/camera/controller/camera_controller.dart';
import 'package:gemai/app/modules/camera/controller/gem_analysis_controller.dart';
import 'package:gemai/app/data/api/gem_analysis_api_service.dart';
import 'package:gemai/app/core/services/image_processing_service.dart';

/// Camera modülü için binding sınıfı
/// CameraController'ı GetX dependency injection sistemine kaydeder
class CameraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GemAnalysisApiService>(() => GemAnalysisApiService());
    Get.lazyPut<ImageProcessingService>(() => ImageProcessingService());
    Get.lazyPut<CameraController>(() => CameraController());
    Get.lazyPut<GemAnalysisController>(() => GemAnalysisController());
  }
}

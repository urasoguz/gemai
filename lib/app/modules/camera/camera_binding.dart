import 'package:get/get.dart';
import 'package:gemai/app/modules/camera/controller/camera_controller.dart';

/// Camera modülü için binding sınıfı
/// CameraController'ı GetX dependency injection sistemine kaydeder
class CameraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CameraController>(() => CameraController());
  }
}

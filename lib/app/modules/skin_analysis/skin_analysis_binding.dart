import 'package:gemai/app/core/services/sembast_service.dart';
import 'package:gemai/app/modules/skin_analysis/controller/skin_analysis_controller.dart';
import 'package:gemai/app/modules/auth/controller/user_controller.dart';
import 'package:gemai/app/core/network/api_client.dart';
import 'package:get/get.dart';

/// Camera modülü için binding sınıfı
/// CameraController'ı GetX dependency injection sistemine kaydeder
class SkinAnalysisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SkinAnalysisController>(() => SkinAnalysisController());
    Get.lazyPut<SembastService>(() => SembastService());
    Get.lazyPut<UserController>(
      () => UserController(apiClient: Get.find<ApiClient>()),
    );
  }
}

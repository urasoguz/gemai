import 'package:get/get.dart';
import 'package:gemai/app/modules/gem_result/controller/gem_result_controller.dart';

class GemResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GemResultController>(() => GemResultController());
  }
}


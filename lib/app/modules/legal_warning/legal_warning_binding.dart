import 'package:get/get.dart';
import 'package:gemai/app/modules/legal_warning/controller/legal_warning_controller.dart';

/// Legal Warning modülü için binding
class LegalWarningBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LegalWarningController>(() => LegalWarningController());
  }
}

import 'package:get/get.dart';
import 'package:dermai/app/modules/home/controller/home_controller.dart';
import 'package:dermai/app/modules/history/controller/history_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<HistoryController>(() => HistoryController());
  }
}

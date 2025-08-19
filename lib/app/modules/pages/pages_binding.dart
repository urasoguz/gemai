import 'package:get/get.dart';
import 'package:gemai/app/data/api/pages_api_service.dart';
import 'package:gemai/app/modules/pages/controller/pages_controller.dart';
import 'package:gemai/app/modules/pages/controller/page_detail_controller.dart';

/// Pages modülü binding'i
class PagesBinding extends Bindings {
  @override
  void dependencies() {
    // PagesApiService'i global olarak ekle
    if (!Get.isRegistered<PagesApiService>()) {
      Get.put<PagesApiService>(PagesApiService(), permanent: true);
    }

    // PagesController'ı ekle
    Get.lazyPut<PagesController>(() => PagesController());

    // PageDetailController'ı ekle
    Get.lazyPut<PageDetailController>(() => PageDetailController());
  }
}

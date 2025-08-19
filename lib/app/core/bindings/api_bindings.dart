import 'package:get/get.dart';
import 'package:dermai/app/data/api/auth_api_service.dart';
import 'package:dermai/app/data/api/skin_analysis_api_service.dart';
import 'package:dermai/app/core/services/image_processing_service.dart';

/// API servisleri için dependency injection binding'leri
///
/// KULLANIM ÖRNEĞİ:
/// ```dart
/// // main.dart'ta register et
/// void main() {
///   Get.put(ApiBindings());
///   runApp(MyApp());
/// }
///
/// // Controller'da kullan
/// class MyController extends GetxController {
///   final AuthApiService _authService = Get.find<AuthApiService>();
///   final SkinAnalysisApiService _skinService = Get.find<SkinAnalysisApiService>();
///
///   @override
///   void onInit() {
///     super.onInit();
///     // API servisleri hazır
///   }
/// }
/// ```
class ApiBindings extends Bindings {
  @override
  void dependencies() {
    // Auth API servisi - Singleton olarak kaydet
    Get.lazyPut<AuthApiService>(() => AuthApiService(), fenix: true);

    // Skin Analysis API servisi - Singleton olarak kaydet
    Get.lazyPut<SkinAnalysisApiService>(
      () => SkinAnalysisApiService(),
      fenix: true, // Uygulama boyunca tek instance
    );

    // Image Processing servisi - Singleton olarak kaydet
    Get.lazyPut<ImageProcessingService>(
      () => ImageProcessingService(),
      fenix: true,
    );
  }
}

/// Alternatif olarak, her modül için ayrı binding'ler de oluşturabilirsin
class AuthApiBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthApiService>(() => AuthApiService(), fenix: true);
  }
}

class SkinAnalysisApiBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SkinAnalysisApiService>(
      () => SkinAnalysisApiService(),
      fenix: true,
    );
  }
}

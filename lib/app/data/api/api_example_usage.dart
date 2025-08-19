import 'package:dermai/app/core/services/shrine_dialog_service.dart';
import 'package:dermai/app/core/theme/app_theme_config.dart';
import 'package:dermai/app/data/model/skin_analysis/skin_analysis_request_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dermai/app/data/api/auth_api_service.dart';
import 'package:dermai/app/data/api/skin_analysis_api_service.dart';
import 'package:dermai/app/data/model/user/user_model.dart';

/// API servislerinin controller'larda nasıl kullanılacağını gösteren örnek
class ApiUsageExample {
  // API servislerini inject et
  final AuthApiService _authApiService = Get.find<AuthApiService>();
  final SkinAnalysisApiService _skinAnalysisApiService =
      Get.find<SkinAnalysisApiService>();

  /// Kullanıcı girişi örneği
  Future<void> loginExample() async {
    final colors =
        Theme.of(Get.context!).brightness == Brightness.light
            ? AppThemeConfig.primary
            : AppThemeConfig.primary;
    try {
      // API çağrısı yap
      final response = await _authApiService.login(
        email: 'user@example.com',
        password: 'password123',
      );

      // Yanıtı kontrol et
      if (response.isSuccess) {
        final user = response.data;
        if (kDebugMode) {
          print('Giriş başarılı: ${user?.data?.name}');
        }

        // Başarılı giriş sonrası işlemler
        Get.offAllNamed('/home');
      } else {
        // Hata durumunda
        if (kDebugMode) {
          print('Giriş hatası: ${response.message}');
        }
        ShrineDialogService.showError(response.message, colors);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Beklenmeyen hata: $e');
      }
    }
  }

  /// Cilt analizi örneği
  Future<void> analyzeSkinExample() async {
    final colors =
        Theme.of(Get.context!).brightness == Brightness.light
            ? AppThemeConfig.primary
            : AppThemeConfig.primary;
    try {
      // Dosya seçimi (örnek)
      // File imageFile = await ImagePicker().pickImage(source: ImageSource.camera);

      // API çağrısı yap
      final response = await _skinAnalysisApiService.analyzeSkin(
        SkinAnalysisRequestModel(
          imageBase64: 'path/to/image.jpg', // Gerçek dosya burada olacak
          age: 25,
          bodyParts: ['Yüz', 'El'],
          complaints: 'Kaşıntı ve kızarıklık var',
          language: 'tr',
        ),
      );

      if (response.isSuccess) {
        final result = response.data;
        if (kDebugMode) {
          print('Analiz tamamlandı: ${result?.name}');
        }

        // Sonucu göster
        Get.toNamed('/result', arguments: result);
      } else {
        if (kDebugMode) {
          print('Analiz hatası: ${response.message}');
        }
        ShrineDialogService.showError(response.message, colors);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Beklenmeyen hata: $e');
      }
    }
  }

  /// Analiz geçmişi örneği
  // Future<void> getHistoryExample() async {
  //   try {
  //     final response = await _skinAnalysisApiService.getHistory();

  //     if (response.isSuccess) {
  //       final history = response.data;
  //       print('Geçmiş yüklendi: ${history?.length} kayıt');

  //       // Geçmişi göster
  //       // historyController.updateHistory(history);
  //     } else {
  //       print('Geçmiş yükleme hatası: ${response.message}');
  //     }
  //   } catch (e) {
  //     print('Beklenmeyen hata: $e');
  //   }
  // }

  /// Profil güncelleme örneği
  Future<void> updateProfileExample() async {
    final colors =
        Theme.of(Get.context!).brightness == Brightness.light
            ? AppThemeConfig.primary
            : AppThemeConfig.primary;
    try {
      final response = await _authApiService.updateProfile(
        name: 'Yeni İsim',
        email: 'yeni@email.com',
      );

      if (response.isSuccess) {
        final updatedUser = response.data;
        if (kDebugMode) {
          print('Profil güncellendi: ${updatedUser?.data?.name}');
        }

        // Kullanıcı bilgilerini güncelle
        // userController.updateUser(updatedUser);
        ShrineDialogService.showSuccess('Profil güncellendi', colors);
      } else {
        if (kDebugMode) {
          print('Profil güncelleme hatası: ${response.message}');
        }
        ShrineDialogService.showError(response.message, colors);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Beklenmeyen hata: $e');
      }
    }
  }
}

/// Controller'da kullanım örneği
class ExampleController extends GetxController {
  final AuthApiService _authApiService = Get.find<AuthApiService>();
  final SkinAnalysisApiService _skinAnalysisApiService =
      Get.find<SkinAnalysisApiService>();

  // Reactive değişkenler
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  /// Kullanıcı girişi
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _authApiService.login(
        email: email,
        password: password,
      );

      if (response.isSuccess) {
        currentUser.value = response.data;
        Get.offAllNamed('/home');
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = 'Beklenmeyen hata: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Cilt analizi
  Future<void> analyzeSkin(dynamic imageFile) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _skinAnalysisApiService.analyzeSkin(
        SkinAnalysisRequestModel(
          imageBase64: imageFile,
          age: 25,
          bodyParts: ['Yüz', 'El'],
          complaints: 'Kaşıntı ve kızarıklık var',
          language: 'tr',
        ),
      );

      if (response.isSuccess) {
        Get.toNamed('/result', arguments: response.data);
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = 'Beklenmeyen hata: $e';
    } finally {
      isLoading.value = false;
    }
  }
}

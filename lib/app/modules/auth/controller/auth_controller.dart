import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  //var isLoading = true.obs;
  // late Box userBox;
  // UserModel? user;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  void init() {
    if (kDebugMode) {
      print("login controller");
    }
  }

  // Future<void> init() async {
  //   userBox = await Hive.openBox('userBox');
  //   String phoneId = await _getPhoneId();

  //   if (userBox.get('user') == null) {
  //     // Backend'e yeni kullanıcı gönder
  //     final response = await registerUserToBackend(phoneId);
  //     if (response.isSuccess) {
  //       user = response.user;
  //       userBox.put('user', user);
  //     }
  //   } else {
  //     user = userBox.get('user');
  //   }

  //   isLoading.value = false;
  //   Get.offAllNamed('/home');
  // }

  // Future<String> _getPhoneId() async {
  //   final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //   final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //   return androidInfo.id;
  // }

  // Future<BackendResponse> registerUserToBackend(String phoneId) async {
  //   // Burada Dio veya http ile API isteği yap
  // }
}

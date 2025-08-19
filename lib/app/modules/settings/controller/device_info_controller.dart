import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:dermai/app/modules/auth/controller/user_controller.dart';
import 'package:dermai/app/data/model/user/user.dart';
import 'package:get_storage/get_storage.dart';

/// Cihaz bilgilerini toplayan controller
class DeviceInfoController extends GetxController {
  final GetStorage sharedPref = GetStorage();

  // Cihaz bilgileri
  final RxString userId = ''.obs;
  final RxString deviceType = ''.obs;
  final RxString appName = ''.obs;
  final RxString packageName = ''.obs;
  final RxString version = ''.obs;
  final RxString buildNumber = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDeviceInfo();

    // UserController'daki user değişikliklerini dinle
    final userController = Get.find<UserController>();
    ever(userController.user, (User? user) {
      if (kDebugMode) {
        print('📱 UserController.user değişti: ${user?.id}');
      }
      _updateUserId(user);
    });
  }

  /// User ID'yi günceller
  void _updateUserId(User? user) {
    userId.value = user?.id?.toString() ?? 'N/A';
    if (kDebugMode) {
      print('📱 User ID güncellendi: ${userId.value}');
    }
  }

  /// Cihaz bilgilerini yükler
  Future<void> _loadDeviceInfo() async {
    try {
      // Kullanıcı ID'sini UserController'dan al
      final userController = Get.find<UserController>();

      if (kDebugMode) {
        print('📱 DeviceInfoController._loadDeviceInfo:');
        print('   - UserController.user.value: ${userController.user.value}');
        print(
          '   - UserController.user.value?.id: ${userController.user.value?.id}',
        );
        print(
          '   - UserController.user.value?.id?.toString(): ${userController.user.value?.id?.toString()}',
        );
      }

      userId.value = userController.user.value?.id?.toString() ?? 'N/A';

      // Cihaz tipi
      deviceType.value = defaultTargetPlatform.toString().split('.').last;

      // Uygulama bilgileri
      final packageInfo = await PackageInfo.fromPlatform();
      appName.value = packageInfo.appName;
      packageName.value = packageInfo.packageName;
      version.value = packageInfo.version;
      buildNumber.value = packageInfo.buildNumber;

      if (kDebugMode) {
        print('📱 Device Info yüklendi:');
        print('   - User ID: ${userId.value}');
        print('   - Device Type: ${deviceType.value}');
        print('   - App Name: ${appName.value}');
        print('   - Package Name: ${packageName.value}');
        print('   - Version: ${version.value}');
        print('   - Build Number: ${buildNumber.value}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Device Info yüklenirken hata: $e');
      }
    }
  }
}

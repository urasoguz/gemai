import 'dart:async';
import 'dart:io';
import 'package:dermai/app/data/model/user/user.dart';
import 'package:dermai/app/shared/helpers/my_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dermai/app/core/network/api_client.dart';
import 'package:dermai/app/data/api/auth_api_service.dart';

class UserController extends GetxController {
  final ApiClient apiClient;
  late final AuthApiService _authApiService;
  final GetStorage userData = GetStorage();

  UserController({required this.apiClient});

  @override
  void onInit() {
    super.onInit();
    // AuthApiService'i onInit'te inject et
    _authApiService = Get.find<AuthApiService>();
    getUsers();
    isSubscribed.value = userData.read(MyHelper.isAccountPremium) ?? false;
  }

  var user = Rx<User?>(null);
  var isSubscribed = false.obs;

  Future<void> getUsers() async {
    try {
      final response = await _authApiService.getProfile();
      if (response.isSuccess) {
        user.value = response.data?.data; // UserModel içindeki User objesi

        // Token ve premium bilgisini GetStorage'a kaydet
        if (user.value != null) {
          userData.write(
            MyHelper.accountRemainingToken,
            user.value!.remainingToken ?? 0,
          );
          userData.write(
            MyHelper.isAccountPremium,
            user.value!.isPremium ?? false,
          );
          if (kDebugMode) {
            print(
              '💾 Token ve premium kaydedildi: ${user.value!.remainingToken} token, ${user.value!.isPremium} premium',
            );
            print('🔄 UserController.getUsers() tamamlandı:');
            print('   👤 User ID: ${user.value!.id}');
            print('   💎 isPremium: ${user.value!.isPremium}');
            print('   📅 premiumExpiryDate: ${user.value!.premiumExpiryDate}');
            print('   🕐 Update time: ${DateTime.now()}');
          }
        }

        if (user.value != null && user.value!.isPremium == true) {
          updateSub(true);
          userData.write(
            MyHelper.expiaryDate,
            user.value!.premiumExpiryDate?.toIso8601String(),
          );
        } else {
          updateSub(false);
        }
      } else if (response.statusCode == 405 || response.statusCode == 401) {
        user.value = null;
        userData.write(MyHelper.bToken, '');
      }
    } catch (e) {
      debugPrint("Error fetching user: $e");
    }
  }

  /// Cihazı guest olarak kaydeder ve token'ı storage'a kaydeder
  Future<void> doRegisterAsGuest() async {
    String deviceId = await getDeviceId();
    try {
      final response = await _authApiService.registerDevice(deviceId: deviceId);
      if (response.isSuccess) {
        // Token'ı response'dan al ve storage'a kaydet
        final token = response.token;
        if (token != null && token.isNotEmpty) {
          userData.write(MyHelper.bToken, token);
          apiClient.updateHeader(); // Header'ı hemen güncelle
        }
        if (kDebugMode) {
          print("yeni token: $token");
        }
        final userModel = response.data;
        if (userModel != null && userModel.data != null) {
          user.value = userModel.data; // User bilgisini ata

          // Token ve premium bilgisini GetStorage'a kaydet
          userData.write(
            MyHelper.accountRemainingToken,
            user.value!.remainingToken ?? 0,
          );
          userData.write(
            MyHelper.isAccountPremium,
            user.value!.isPremium ?? false,
          );
          if (kDebugMode) {
            print(
              '💾 Guest token ve premium kaydedildi: ${user.value!.remainingToken} token, ${user.value!.isPremium} premium',
            );
          }

          if (user.value!.isPremium == true) {
            updateSub(true);
            userData.write(
              MyHelper.expiaryDate,
              user.value!.premiumExpiryDate?.toIso8601String(),
            );
          } else {
            updateSub(false);
          }
        }
      }
    } catch (e) {
      debugPrint("doRegisterAsGuest error: $e");
    }
  }

  Future<String> getDeviceId() async {
    String deviceId = 'Loading...';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isIOS) {
        IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
        deviceId = iosDeviceInfo.identifierForVendor ?? '';
      } else if (Platform.isAndroid) {
        AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
        deviceId = androidDeviceInfo.id;
      }
      return deviceId;
    } catch (e) {
      return deviceId;
    }
  }

  void updateSub(bool value) {
    isSubscribed.value = value;
    userData.write(MyHelper.isAccountPremium, value);
    update();
  }
}

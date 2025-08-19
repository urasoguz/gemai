import 'package:gemai/app/core/services/shrine_dialog_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gemai/app/modules/settings/controller/device_info_controller.dart';
import 'package:gemai/app/core/services/app_settings_service.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';

/// İletişim mail controller'ı
class ContactMailController extends GetxController {
  final DeviceInfoController deviceInfoController = Get.put(
    DeviceInfoController(),
  );
  final GetStorage sharedPref = GetStorage();

  // E-posta bilgileri (AppSettingsService'den alıyoruz)
  String get email {
    final settingsService = Get.find<AppSettingsService>();
    return settingsService.contactEmail ?? 'contact@zytnecllc.com';
  }

  String get subject => "contact_mail_subject".tr; // Çeviri dosyasındaki key

  String get body => """
${"contact_mail_body_write_here".tr}



----------------------

${"contact_mail_user_id".tr}: ${deviceInfoController.userId.value}

${"contact_mail_device_type".tr}: ${deviceInfoController.deviceType.value}

${"contact_mail_app_name".tr}: ${deviceInfoController.appName.value}
${"contact_mail_package_name".tr}: ${deviceInfoController.packageName.value}
${"contact_mail_version".tr}: ${deviceInfoController.version.value}
${"contact_mail_build_number".tr}: ${deviceInfoController.buildNumber.value}

----------------------

""";

  /// E-posta gönderme fonksiyonu
  Future<void> sendEmail() async {
    try {
      final String encodedSubject = Uri.encodeComponent(subject);
      final String encodedBody = Uri.encodeComponent(body);

      final Uri emailUri = Uri.parse(
        "mailto:$email?subject=$encodedSubject&body=$encodedBody",
      );

      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        showContactPopup(Get.context!);
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Mail gönderilirken hata: $e');
      }
      showContactPopup(Get.context!);
    }
  }

  /// İletişim popup'ını gösterir
  void showContactPopup(BuildContext context) {
    final colors = AppThemeConfig.primary;

    String mail = email; // Email getter'ını kullan

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: AppThemeConfig.background,
          insetPadding: const EdgeInsets.symmetric(horizontal: 30),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Başlık
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'contact'.tr,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppThemeConfig.textPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.close,
                        color: AppThemeConfig.textSecondary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                /// Açıklama
                Text(
                  'contact_text'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppThemeConfig.textSecondary,
                  ),
                ),

                const SizedBox(height: 25),

                /// Mail Butonu
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final email = Uri.parse('mailto:$mail');
                      if (await canLaunchUrl(email)) {
                        await launchUrl(email);
                      } else {
                        ShrineDialogService.showError(
                          'could_not_open_mail_app'.tr,
                          colors,
                          duration: const Duration(seconds: 3),
                        );
                      }
                    } catch (e) {
                      ShrineDialogService.showError(
                        'could_not_open_mail_app'.tr,
                        colors,
                        duration: const Duration(seconds: 3),
                      );
                    }
                  },
                  icon: Icon(
                    Icons.email_outlined,
                    size: 20,
                    color: AppThemeConfig.background,
                  ),
                  label: Text(
                    mail,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppThemeConfig.background,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppThemeConfig.primary,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

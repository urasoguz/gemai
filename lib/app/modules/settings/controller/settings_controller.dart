import 'package:gemai/app/core/services/restore_premium_service.dart';
import 'package:gemai/app/core/services/shrine_dialog_service.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:gemai/app/modules/settings/controller/share_controller.dart';
import 'package:gemai/app/modules/settings/controller/contact_mail_controller.dart';
import 'package:gemai/app/routes/app_routes.dart';
import 'package:gemai/app/shared/helpers/my_helper.dart';
import 'package:gemai/app/core/services/theme_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gemai/app/shared/controllers/lang_controller.dart';
import 'package:gemai/app/modules/auth/controller/user_controller.dart';
import 'package:gemai/app/core/services/sembast_service.dart';

class SettingsController extends GetxController {
  final LangController langController = Get.find<LangController>();
  //final UserController userController = Get.find<UserController>();
  final GetStorage sharedPref = GetStorage();
  final ThemeService _themeService = ThemeService();
  final ContactMailController _contactMailController = Get.put(
    ContactMailController(),
  );

  var isDarkMode = false.obs;
  var currentLanguage = 'tr'.obs;
  var appVersion = '1.0.0'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  void _loadSettings() {
    // Tema ayarını ThemeService'den yükle
    isDarkMode.value = _themeService.isDarkMode;

    // Dil ayarını yükle
    currentLanguage.value = langController.currentLanguage.value;

    // Uygulama versiyonunu yükle
    appVersion.value = sharedPref.read(MyHelper.appVersion) ?? '1.0.0';
  }

  void toggleTheme() {
    _themeService.switchTheme();
    isDarkMode.value = _themeService.isDarkMode;
  }

  void changeLanguage(String languageCode) {
    currentLanguage.value = languageCode;
    langController.changeLanguage(languageCode);
  }

  void shareApp() {
    AppShare().shareApp();
  }

  void rateApp() {
    AppShare().openStore();
  }

  void contactUs() {
    // Debug: UserController durumunu kontrol et
    if (kDebugMode) {
      final userController = Get.find<UserController>();
      print('📧 SettingsController.contactUs:');
      print('   - UserController.user.value: ${userController.user.value}');
      print(
        '   - UserController.user.value?.id: ${userController.user.value?.id}',
      );
    }

    // İletişim mail controller'ını kullan
    _contactMailController.sendEmail();
  }

  Future<void> restorePurchases() async {
    try {
      if (kDebugMode) {
        print('🔄 Account settings restore işlemi başlatılıyor...');
      }

      // Merkezi restore servisi kullan
      final restoreService = Get.find<RestorePremiumService>();
      final success = await restoreService.performCompleteRestore();

      if (!success) {
        // Hata mesajı servis tarafından gösterildi
        if (kDebugMode) {
          print('❌ Account settings restore başarısız');
        }
      } else {
        if (kDebugMode) {
          print('✅ Account settings restore başarılı');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Account settings restore hatası: $e');
      }
    }
  }

  /// Veritabanını temizler - İLERDE KULLANILABİLİR
  /*
  Future<void> clearDatabase() async {
    try {
      if (kDebugMode) {
        print('🧹 Veritabanı temizleme başlatılıyor...');
      }

      final sembastService = SembastService();

      // Onay dialog'u göster
      bool confirmed = false;
      ShrineDialogService.showSimpleConfirm(
        message:
            'Tüm analiz verileri kalıcı olarak silinecek. Bu işlem geri alınamaz. Devam etmek istiyor musunuz?',
        title: 'Veritabanını Temizle',
        showCancelButton: true,
        showOkButton: true,
        okButtonColor: Colors.red,
        onConfirm: (result) async {
          confirmed = result;
          if (confirmed) {
            await sembastService.clearAllData();

            if (kDebugMode) {
              print('✅ Veritabanı temizlendi');
            }

            // Başarı mesajı göster
            ShrineDialogService.showInfoDialog(
              message: 'Veritabanı başarıyla temizlendi.',
              title: 'Başarılı',
              showCancelButton: false,
              showOkButton: true,
              okButtonColor: Colors.green,
            );
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('❌ Veritabanı temizleme hatası: $e');
      }

      // Hata mesajı göster
      ShrineDialogService.showError(
        'Veritabanı temizlenirken hata oluştu: $e',
        AppThemeConfig.primary,
        duration: const Duration(seconds: 3),
      );
    }
  }
  */

  /// Sadece test verilerini temizler - İLERDE KULLANILABİLİR
  /*
  Future<void> clearTestData() async {
    try {
      if (kDebugMode) {
        print('🧹 Test verileri temizleme başlatılıyor...');
      }

      final sembastService = SembastService();

      // Onay dialog'u göster
      bool confirmed = false;
      ShrineDialogService.showSimpleConfirm(
        message:
            'Test analiz verileri kalıcı olarak silinecek. Devam etmek istiyor musunuz?',
        title: 'Test Verilerini Temizle',
        showCancelButton: true,
        showOkButton: true,
        okButtonColor: Colors.orange,
        onConfirm: (result) async {
          confirmed = result;
          if (confirmed) {
            await sembastService.clearTestData();

            if (kDebugMode) {
              print('✅ Test verileri temizlendi');
            }

            // Başarı mesajı göster
            ShrineDialogService.showInfoDialog(
              message: 'Test verileri başarıyla temizlendi.',
              title: 'Başarılı',
              showCancelButton: false,
              showOkButton: true,
              okButtonColor: Colors.green,
            );
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('❌ Test verileri temizleme hatası: $e');
      }

      // Hata mesajı göster
      ShrineDialogService.showError(
        'Test verileri temizlenirken hata oluştu: $e',
        AppThemeConfig.primary,
        duration: const Duration(seconds: 3),
      );
    }
  }
  */

  void openPrivacyPolicy() {
    Get.toNamed(AppRoutes.pageDetail, arguments: {'slug': 'privacy'});
  }

  void openFAQ() {
    Get.toNamed(AppRoutes.pageDetail, arguments: {'slug': 'faq'});
  }

  void openTerms() {
    Get.toNamed(AppRoutes.pageDetail, arguments: {'slug': 'terms'});
  }

  void openAbout() {
    Get.toNamed(AppRoutes.pageDetail, arguments: {'slug': 'about'});
  }
}

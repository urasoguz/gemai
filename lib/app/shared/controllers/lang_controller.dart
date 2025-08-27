import 'dart:ui';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LangController extends GetxController {
  final GetStorage _storage = GetStorage();
  RxString currentLanguage = 'en'.obs; // Varsayılan dil

  @override
  void onInit() {
    super.onInit();
    _initLanguage(); // Dil yükleme işlemi
  }

  void _initLanguage() {
    bool isFirstLaunch = _storage.read('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      // İlk yükleme ise telefon dilini kontrol et
      String deviceLanguage = Get.deviceLocale?.languageCode ?? 'en';
      if ([
        'en',
        'tr',
        'zh',
        'ru',
        'es',
        'pt',
        'hi',
        'ar',
        'fr',
        'de',
        'it',
        'id',
        'nl',
        'ja',
        'ko',
        'pl',
        'uk',
        'vi',
        'th',
      ].contains(deviceLanguage)) {
        currentLanguage.value = deviceLanguage;
      } else {
        currentLanguage.value = 'en'; // Desteklenmiyorsa İngilizce
      }
      _storage.write('language', currentLanguage.value); // Dil tercihini kaydet
      _storage.write('isFirstLaunch', false); // İlk yükleme durumunu güncelle
    } else {
      // İlk yükleme değilse kayıtlı dili kullan
      currentLanguage.value = _storage.read('language') ?? 'en';
    }
    Get.updateLocale(Locale(currentLanguage.value)); // Dil güncellemesi yap
  }

  void changeLanguage(String languageCode) {
    currentLanguage.value = languageCode; // Dil değişimi
    Get.updateLocale(Locale(languageCode)); // Dil güncellemesi
    _storage.write('language', languageCode); // Yeni dil tercihini kaydet
  }
}

import 'package:dash_flags/dash_flags.dart';

class Languages {
  static const List<String> supportedLanguages = [
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
  ];
  static String? getLanguageName(String languageCode) {
    Map<String, String> languageKeys = {
      'en': 'English',
      'tr': 'Türkçe',
      'zh': '中文',
      'ru': 'Русский',
      'es': 'Español',
      'pt': 'Português',
      'hi': 'हिंदी',
      'ar': 'العربية',
      'fr': 'Français',
      'de': 'Deutsch',
      'it': 'Italiano',
      'id': 'Indonesia',
      'nl': 'Nederlands',
      'ja': '日本語',
      'ko': '한국어',
      'pl': 'Polski',
      'uk': 'Українська',
      'vi': 'Tiếng Việt',
      'th': 'ภาษาไทย',
    };

    return languageKeys.containsKey(languageCode)
        ? languageKeys[languageCode]
        : 'language_unknown';
  }

  // Dil koduna göre ülke bayrağını döndür
  static Country getCountryFlag(String languageCode) {
    switch (languageCode) {
      case 'en':
        return Country.gb;
      case 'tr':
        return Country.tr;
      case 'zh':
        return Country.cn;
      case 'ru':
        return Country.ru;
      case 'es':
        return Country.es;
      case 'pt':
        return Country.pt;
      case 'hi':
        return Country.c_in;
      case 'ar':
        return Country.sa;
      case 'fr':
        return Country.fr;
      case 'de':
        return Country.de;
      case 'it':
        return Country.it;
      case 'id':
        return Country.id;
      case 'nl':
        return Country.nl;
      case 'ja':
        return Country.jp;
      case 'ko':
        return Country.kr;
      case 'pl':
        return Country.pl;
      case 'uk':
        return Country.ua;
      case 'vi':
        return Country.vn;
      case 'th':
        return Country.th;
      default:
        return Country.us;
    }
  }
}

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
    'fa',
    'nl',
    'sv',
    'ja',
    'ko',
    'pl',
    'ms',
    'uk',
    'ur',
    'vi',
    'el',
    'th',
    'bn',
    'fi',
    'tk',
    'az',
    'ku',
    'ro',
    'hu',
    'cs',
    'sk',
    'sr',
    'he',
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
      'fa': 'فارسی',
      'nl': 'Nederlands',
      'sv': 'Svenska',
      'ja': '日本語',
      'ko': '한국어',
      'pl': 'Polski',
      'ms': 'Melayu',
      'uk': 'Українська',
      'ur': 'اردو',
      'vi': 'Tiếng Việt',
      'el': 'Ελληνικά',
      'th': 'ภาษาไทย',
      'bn': 'বাংলা',
      'fi': 'Suomi',
      'tk': 'Türkmençe',
      'az': 'Azərbaycanca',
      'ku': 'Kurdî',
      'ro': 'Română',
      'hu': 'Magyar',
      'cs': 'Čeština',
      'sk': 'Slovenčina',
      'sr': 'Српски',
      'he': 'עברית',
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
      case 'fa':
        return Country.ir;
      case 'nl':
        return Country.nl;
      case 'sv':
        return Country.se;
      case 'ja':
        return Country.jp;
      case 'ko':
        return Country.kr;
      case 'pl':
        return Country.pl;
      case 'ms':
        return Country.my;
      case 'uk':
        return Country.ua;
      case 'ur':
        return Country.pk;
      case 'vi':
        return Country.vn;
      case 'el':
        return Country.gr;
      case 'th':
        return Country.th;
      case 'bn':
        return Country.bd;
      case 'fi':
        return Country.fi;
      case 'tk':
        return Country.tm;
      case 'az':
        return Country.az;
      case 'ku':
        return Country.iq;
      case 'ro':
        return Country.ro;
      case 'hu':
        return Country.hu;
      case 'cs':
        return Country.cz;
      case 'sk':
        return Country.sk;
      case 'sr':
        return Country.rs;
      case 'he':
        return Country.il;
      default:
        return Country.us;
    }
  }
}

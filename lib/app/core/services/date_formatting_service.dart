import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:dermai/app/shared/controllers/lang_controller.dart';

/// Tarih formatlaması için modüler servis
/// Çok dilli uygulamalarda tarih ve zaman ifadelerini formatlar
class DateFormattingService extends GetxService {
  /// Locale verilerinin başlatılıp başlatılmadığını kontrol eder
  /// [locale] - Kontrol edilecek locale
  Future<void> _ensureLocaleInitialized(String locale) async {
    try {
      // Locale verilerinin başlatılıp başlatılmadığını kontrol et
      DateFormat('dd MMM yyyy', locale);
    } catch (e) {
      // Eğer locale başlatılmamışsa başlat
      await initializeDateFormatting(locale, null);
    }
  }

  /// Göreceli tarih formatlaması yapar (örn: "2 saat önce", "Dün", "3 gün önce")
  /// [dateTime] - Formatlanacak tarih
  /// [locale] - Dil kodu (opsiyonel, varsayılan olarak mevcut dil kullanılır)
  Future<String> formatRelativeDate(DateTime dateTime, [String? locale]) async {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    // Dil kontrolcüsünü al
    final langController = Get.find<LangController>();
    final currentLocale = locale ?? langController.currentLanguage.value;

    // Locale verilerinin başlatıldığından emin ol
    await _ensureLocaleInitialized(currentLocale);

    if (difference.inDays == 0) {
      // Bugün
      if (difference.inHours == 0) {
        // Son 1 saat içinde
        if (difference.inMinutes == 0) {
          return 'just_now'.tr;
        } else {
          return 'minutes_ago'.tr.replaceAll(
            '{count}',
            difference.inMinutes.toString(),
          );
        }
      } else {
        return 'hours_ago'.tr.replaceAll(
          '{count}',
          difference.inHours.toString(),
        );
      }
    } else if (difference.inDays == 1) {
      // Dün
      return 'yesterday'.tr;
    } else if (difference.inDays < 7) {
      // Bu hafta
      return 'days_ago'.tr.replaceAll('{count}', difference.inDays.toString());
    } else {
      // Daha eski - tam tarih
      final dateFormat = DateFormat('date_format'.tr, currentLocale);
      return dateFormat.format(dateTime);
    }
  }

  /// Tam tarih formatlaması yapar
  /// [dateTime] - Formatlanacak tarih
  /// [locale] - Dil kodu (opsiyonel, varsayılan olarak mevcut dil kullanılır)
  Future<String> formatFullDate(DateTime dateTime, [String? locale]) async {
    final langController = Get.find<LangController>();
    final currentLocale = locale ?? langController.currentLanguage.value;

    // Locale verilerinin başlatıldığından emin ol
    await _ensureLocaleInitialized(currentLocale);

    final dateFormat = DateFormat('date_format'.tr, currentLocale);
    return dateFormat.format(dateTime);
  }

  /// Tarih ve saat formatlaması yapar
  /// [dateTime] - Formatlanacak tarih ve saat
  /// [locale] - Dil kodu (opsiyonel, varsayılan olarak mevcut dil kullanılır)
  Future<String> formatDateTime(DateTime dateTime, [String? locale]) async {
    final langController = Get.find<LangController>();
    final currentLocale = locale ?? langController.currentLanguage.value;

    // Locale verilerinin başlatıldığından emin ol
    await _ensureLocaleInitialized(currentLocale);

    final dateFormat = DateFormat('dd MMM yyyy HH:mm', currentLocale);
    return dateFormat.format(dateTime);
  }

  /// Sadece saat formatlaması yapar
  /// [dateTime] - Formatlanacak saat
  /// [locale] - Dil kodu (opsiyonel, varsayılan olarak mevcut dil kullanılır)
  Future<String> formatTime(DateTime dateTime, [String? locale]) async {
    final langController = Get.find<LangController>();
    final currentLocale = locale ?? langController.currentLanguage.value;

    // Locale verilerinin başlatıldığından emin ol
    await _ensureLocaleInitialized(currentLocale);

    final timeFormat = DateFormat('HH:mm', currentLocale);
    return timeFormat.format(dateTime);
  }
}

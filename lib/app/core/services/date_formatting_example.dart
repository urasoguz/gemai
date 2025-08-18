import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gemai/app/core/services/date_formatting_service.dart';

/// DateFormattingService kullanım örnekleri
/// Bu dosya, tarih formatlaması servisinin nasıl kullanılacağını gösterir
class DateFormattingExample {
  /// Göreceli tarih formatlaması örneği
  Future<void> relativeDateExample() async {
    final dateService = Get.find<DateFormattingService>();

    // Şu anki zaman
    final now = DateTime.now();

    // 5 dakika önce
    final fiveMinutesAgo = now.subtract(Duration(minutes: 5));
    await dateService.formatRelativeDate(fiveMinutesAgo);
    // Sonuç: "5 dakika önce" (Türkçe), "5 minutes ago" (İngilizce), "5分前" (Japonca), vs.

    // 2 saat önce
    await dateService.formatRelativeDate(now.subtract(Duration(hours: 2)));
    // Sonuç: "2 saat önce" (Türkçe), "2 hours ago" (İngilizce), "2時間前" (Japonca), vs.

    // Dün
    await dateService.formatRelativeDate(now.subtract(Duration(days: 1)));
    // Sonuç: "Dün" (Türkçe), "Yesterday" (İngilizce), "昨日" (Japonca), vs.

    // 3 gün önce
    await dateService.formatRelativeDate(now.subtract(Duration(days: 3)));
    // Sonuç: "3 gün önce" (Türkçe), "3 days ago" (İngilizce), "3日前" (Japonca), vs.

    // 10 gün önce (tam tarih formatında)
    await dateService.formatRelativeDate(now.subtract(Duration(days: 10)));
    // Sonuç: "15 Oca 2024" (Türkçe), "Jan 15, 2024" (İngilizce), "2024年1月15日" (Japonca), vs.
  }

  /// Tam tarih formatlaması örneği
  Future<void> fullDateExample() async {
    final dateService = Get.find<DateFormattingService>();

    final date = DateTime(2024, 1, 15);
    await dateService.formatFullDate(date);
    // Sonuç: "15 Oca 2024" (Türkçe), "Jan 15, 2024" (İngilizce), "2024年1月15日" (Japonca), vs.
  }

  /// Tarih ve saat formatlaması örneği
  Future<void> dateTimeExample() async {
    final dateService = Get.find<DateFormattingService>();

    final dateTime = DateTime(2024, 1, 15, 14, 30);
    await dateService.formatDateTime(dateTime);
    // Sonuç: "15 Oca 2024 14:30" (Türkçe), "Jan 15, 2024 14:30" (İngilizce), vs.
  }

  /// Sadece saat formatlaması örneği
  Future<void> timeExample() async {
    final dateService = Get.find<DateFormattingService>();

    final time = DateTime(2024, 1, 15, 14, 30);
    await dateService.formatTime(time);
    // Sonuç: "14:30" (tüm dillerde aynı format)
  }

  /// Belirli bir dil için formatlaması örneği
  Future<void> specificLanguageExample() async {
    final dateService = Get.find<DateFormattingService>();

    final date = DateTime(2024, 1, 15);

    // Türkçe için
    await dateService.formatRelativeDate(date, 'tr');

    // İngilizce için
    await dateService.formatRelativeDate(date, 'en');

    // Japonca için
    await dateService.formatRelativeDate(date, 'ja');

    // Arapça için
    await dateService.formatRelativeDate(date, 'ar');
  }
}

/// Widget içinde kullanım örneği
class DateFormattingWidgetExample {
  Widget buildDateWidget(DateTime dateTime) {
    final dateService = Get.find<DateFormattingService>();

    return FutureBuilder<String>(
      future: dateService.formatRelativeDate(dateTime),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            snapshot.data!,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget buildDateWidgetWithLocale(DateTime dateTime, String locale) {
    final dateService = Get.find<DateFormattingService>();

    return FutureBuilder<String>(
      future: dateService.formatRelativeDate(dateTime, locale),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            snapshot.data!,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

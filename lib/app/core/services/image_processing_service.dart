// lib/app/core/services/image_processing_service.dart
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

/// Görsel işleme servisi
/// Base64 dönüşümü ve sıkıştırma işlemleri
class ImageProcessingService {
  static final ImageProcessingService _instance =
      ImageProcessingService._internal();
  factory ImageProcessingService() => _instance;
  ImageProcessingService._internal();

  /// Görsel dosyasını Base64'e dönüştürür (sıkıştırılmamış)
  ///
  /// Args:
  /// - imagePath: Görsel dosya yolu
  ///
  /// Returns:
  /// - String: Base64 encoded görsel
  Future<String> convertToBase64(String imagePath) async {
    try {
      if (kDebugMode) {
        print('🖼️ Görsel Base64\'e dönüştürülüyor: $imagePath');
      }

      // Dosyayı oku
      final File imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        throw Exception('Görsel dosyası bulunamadı: $imagePath');
      }

      // Dosyayı bytes olarak oku
      final Uint8List imageBytes = await imageFile.readAsBytes();

      // Base64'e dönüştür
      final String base64String = base64Encode(imageBytes);

      // Dosya uzantısını kontrol et ve MIME type belirle
      final extension = imagePath.split('.').last.toLowerCase();
      String mimeType;

      switch (extension) {
        case 'jpg':
        case 'jpeg':
          mimeType = 'image/jpeg';
          break;
        case 'png':
          mimeType = 'image/png';
          break;
        default:
          mimeType = 'image/jpeg'; // Varsayılan
      }

      // Backend'de data:image/jpeg;base64, formatı bekleniyor
      final formattedBase64 = 'data:$mimeType;base64,$base64String';

      if (kDebugMode) {
        print(
          '✅ Görsel Base64\'e dönüştürüldü - Boyut: ${formattedBase64.length} karakter',
        );
      }

      return formattedBase64;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Base64 dönüştürme hatası: $e');
      }
      rethrow;
    }
  }

  /// Görsel dosyasını sıkıştırır ve Base64'e dönüştürür
  ///
  /// Args:
  /// - imagePath: Görsel dosya yolu
  /// - maxWidth: Maksimum genişlik (varsayılan: 800)
  /// - quality: Kalite (0-100, varsayılan: 80)
  ///
  /// Returns:
  /// - String: Sıkıştırılmış Base64 encoded görsel
  Future<String> compressAndConvertToBase64(
    String imagePath, {
    int maxWidth = 800,
    int quality = 80,
  }) async {
    try {
      if (kDebugMode) {
        print(
          '🖼️ Görsel sıkıştırılıyor ve Base64\'e dönüştürülüyor: $imagePath',
        );
      }

      // Dosyayı oku
      final File imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        throw Exception('Görsel dosyası bulunamadı: $imagePath');
      }

      // Görseli decode et
      final Uint8List imageBytes = await imageFile.readAsBytes();
      final img.Image? originalImage = img.decodeImage(imageBytes);

      if (originalImage == null) {
        throw Exception('Görsel decode edilemedi');
      }

      // Boyutları hesapla
      final int originalWidth = originalImage.width;
      final int originalHeight = originalImage.height;

      if (kDebugMode) {
        print('📏 Orijinal boyut: $originalWidth x $originalHeight');
      }

      // Görseli yeniden boyutlandır
      img.Image resizedImage = originalImage;
      if (originalWidth > maxWidth) {
        final double aspectRatio = originalWidth / originalHeight;
        final int newHeight = (maxWidth / aspectRatio).round();

        resizedImage = img.copyResize(
          originalImage,
          width: maxWidth,
          height: newHeight,
          interpolation: img.Interpolation.linear,
        );

        if (kDebugMode) {
          print('📏 Yeni boyut: ${resizedImage.width}x${resizedImage.height}');
        }
      }

      // JPEG formatında encode et
      final List<int> compressedBytes = img.encodeJpg(
        resizedImage,
        quality: quality,
      );

      // Base64'e dönüştür
      final String base64String = base64Encode(compressedBytes);

      // Sıkıştırılmış görsel her zaman JPEG formatında
      final formattedBase64 = 'data:image/jpeg;base64,$base64String';

      if (kDebugMode) {
        print('✅ Görsel sıkıştırıldı ve Base64\'e dönüştürüldü');
        print(
          '📊 Sıkıştırma oranı: ${((1 - compressedBytes.length / imageBytes.length) * 100).toStringAsFixed(1)}%',
        );
      }

      return formattedBase64;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Görsel sıkıştırma hatası: $e');
      }
      rethrow;
    }
  }
}

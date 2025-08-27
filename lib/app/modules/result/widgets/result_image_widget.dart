import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:gemai/app/routes/app_routes.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:gemai/app/data/model/response/scan_result_model.dart';
import 'package:flutter/foundation.dart';

class ResultImageWidget extends StatelessWidget {
  final String? imagePath;
  final double width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;
  final ScanResultModel? model; // Model parametresi eklendi

  const ResultImageWidget({
    super.key,
    this.imagePath,
    required this.width,
    required this.height,
    this.borderRadius = 20,
    this.margin,
    this.model, // Model parametresi eklendi
  });

  @override
  Widget build(BuildContext context) {
    Widget? imageWidget;

    if (kDebugMode) {
      print(
        '🔍 ResultImageWidget - imagePath: ${imagePath != null ? "Mevcut (${imagePath!.length} karakter)" : "Yok"}',
      );
      if (imagePath != null) {
        print(
          '🔍 ResultImageWidget - ImagePath başlangıcı: ${imagePath!.substring(0, 50)}...',
        );
      }
    }

    // Base64 görsel desteği
    if (imagePath != null && imagePath!.startsWith('data:image')) {
      try {
        final base64Str = imagePath!.split(',').last;
        final bytes = base64Decode(base64Str);
        if (kDebugMode) {
          print(
            '🔍 ResultImageWidget - Base64 görsel yüklendi - Boyut: ${bytes.length} bytes',
          );
        }
        imageWidget = ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Image.memory(
            bytes,
            width: width,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              if (kDebugMode) {
                print(
                  '❌ ResultImageWidget - Base64 görsel yüklenemedi: $error',
                );
              }
              return Icon(
                Icons.broken_image,
                size: width * 0.6,
                color: AppThemeConfig.error,
              );
            },
          ),
        );
      } catch (e) {
        if (kDebugMode) {
          print('❌ ResultImageWidget - Base64 decode hatası: $e');
        }
        imageWidget = Icon(
          Icons.broken_image,
          size: width * 0.6,
          color: AppThemeConfig.error,
        );
      }
    } else if (imagePath != null && imagePath!.isNotEmpty) {
      imageWidget = Icon(
        Icons.image,
        size: width * 0.6,
        color: AppThemeConfig.textSecondary,
      );
    } else {
      imageWidget = Icon(
        Icons.image,
        size: width * 0.6,
        color: AppThemeConfig.textSecondary,
      );
    }

    // Tıklanınca result sayfasına yönlendir (zoom yok)
    return GestureDetector(
      onTap: () {
        // Eğer bu widget gem_result sayfasında kullanılıyorsa hiçbir şey yapma
        // Eğer history/home sayfalarında kullanılıyorsa result sayfasına git
        if (Get.currentRoute != AppRoutes.gemResult && model?.id != null) {
          // Result sayfasına git
          Get.toNamed(AppRoutes.gemResult, arguments: model!.id);
        }
      },
      child: Container(
        width: width,
        height: height,
        margin: margin ?? const EdgeInsets.only(top: 8, bottom: 18),
        decoration: BoxDecoration(
          color: AppThemeConfig.card,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: imageWidget,
      ),
    );
  }
}

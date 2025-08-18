import 'dart:io';
import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gemai/app/modules/skin_analysis/controller/skin_analysis_controller.dart';

/// Görsel sonuç widget'ı
/// Çekilen fotoğrafı gösterir
class ImageResultWidget extends GetView<SkinAnalysisController> {
  const ImageResultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).brightness == Brightness.light
            ? AppThemeConfig.lightColors
            : AppThemeConfig.darkColors;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: colors.buttonShadow.withValues(alpha: 0.01),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 14,
                  decoration: BoxDecoration(
                    color: colors.gradientSecondary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'skin_analysis_image'.tr,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          // Görsel
          Obx(() {
            if (controller.imagePath.value.isEmpty) {
              return Container(
                height: 120,
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 36,
                    color: colors.textHint,
                  ),
                ),
              );
            }
            return GestureDetector(
              onTap: () => _showImageDialog(context),
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: colors.buttonShadow.withValues(alpha: 0.05),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(controller.imagePath.value),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: colors.card,
                        child: Center(
                          child: Icon(
                            Icons.error_outline,
                            size: 36,
                            color: colors.textHint,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void _showImageDialog(BuildContext context) {
    final colors =
        Theme.of(context).brightness == Brightness.light
            ? AppThemeConfig.lightColors
            : AppThemeConfig.darkColors;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: colors.cameraScaffold.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                // Büyük görsel
                Center(
                  child: Image.file(
                    File(controller.imagePath.value),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.error_outline,
                          size: 64,
                          color: colors.cameraAnalyzeText,
                        ),
                      );
                    },
                  ),
                ),
                // Kapat butonu
                Positioned(
                  top: 20,
                  right: 20,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.buttonShadow.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: colors.cameraAnalyzeText,
                        size: 24,
                      ),
                    ),
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

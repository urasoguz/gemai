import 'dart:io';
import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class ResultImageWidget extends StatelessWidget {
  final String? imagePath;
  final double width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const ResultImageWidget({
    super.key,
    this.imagePath,
    this.width = 140,
    this.height = 100,
    this.borderRadius = 20,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    Widget? imageWidget;
    // Base64 görsel desteği
    if (imagePath != null && imagePath!.startsWith('data:image')) {
      try {
        final base64Str = imagePath!.split(',').last;
        final bytes = base64Decode(base64Str);
        imageWidget = ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Image.memory(
            bytes,
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
        );
      } catch (e) {
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

    // Tıklanınca ImageResultWidget tarzı dialog göster
    return GestureDetector(
      onTap: imageWidget is ClipRRect ? () => _showImageDialog(context) : null,
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

  /// Görsel dialog'unu gösterir
  void _showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: AppThemeConfig.cameraScaffold.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                // Büyük görsel
                Center(child: _buildDialogImageWidget()),
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
                        color: AppThemeConfig.buttonShadow.withValues(
                          alpha: 0.1,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: AppThemeConfig.cameraAnalyzeText,
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

  /// Dialog için görsel widget'ı
  Widget _buildDialogImageWidget() {
    // Base64 görsel desteği
    if (imagePath != null && imagePath!.startsWith('data:image')) {
      try {
        final base64Str = imagePath!.split(',').last;
        final bytes = base64Decode(base64Str);
        return Image.memory(
          bytes,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return _buildDialogErrorWidget();
          },
        );
      } catch (e) {
        return _buildDialogErrorWidget();
      }
    } else if (imagePath != null && imagePath!.isNotEmpty) {
      return Image.file(
        File(imagePath!),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _buildDialogErrorWidget();
        },
      );
    } else {
      return _buildDialogErrorWidget();
    }
  }

  /// Dialog hata durumu için widget
  Widget _buildDialogErrorWidget() {
    return Builder(
      builder: (context) {
        return Center(
          child: Icon(
            Icons.error_outline,
            size: 64,
            color: AppThemeConfig.cameraAnalyzeText,
          ),
        );
      },
    );
  }
}

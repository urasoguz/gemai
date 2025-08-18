import 'dart:io';
import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:gemai/app/routes/app_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gemai/app/modules/camera/controller/camera_controller.dart';

/// gemai için Camerawesome ile gömülü kamera widget'ı
class CamerawesomeWidget extends GetView<CameraController> {
  const CamerawesomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Eğer fotoğraf çekildiyse onu göster
      if (controller.capturedImagePath.value.isNotEmpty) {
        return _buildCapturedImagePreview(context);
      }

      // Normal kamera arayüzü
      return _buildCameraAwesome(context);
    });
  }

  /// Çekilen fotoğraf önizlemesi
  Widget _buildCapturedImagePreview(BuildContext context) {
    // Tema renklerini al
    final colors =
        Theme.of(context).brightness == Brightness.light
            ? AppThemeConfig.lightColors
            : AppThemeConfig.darkColors;

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: colors.cameraCapturedBackground,
      child: Stack(
        children: [
          // Fotoğraf
          Positioned.fill(
            child: Image.file(
              File(controller.capturedImagePath.value),
              fit: BoxFit.cover,
            ),
          ),

          // Kontrol butonları
          Positioned(
            top: 20,
            left: 20,
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: colors.cameraControlButtonIcon,
                size: 32,
              ),
              onPressed: controller.clearPhoto,
            ),
          ),
        ],
      ),
    );
  }

  /// Kamera arayüzü
  Widget _buildCameraAwesome(BuildContext context) {
    // Tema renklerini al
    final colors =
        Theme.of(context).brightness == Brightness.light
            ? AppThemeConfig.lightColors
            : AppThemeConfig.darkColors;

    return Obx(
      () => CameraAwesomeBuilder.awesome(
        saveConfig: SaveConfig.photo(),
        sensorConfig: SensorConfig.single(
          sensor: Sensor.position(SensorPosition.back),
          aspectRatio: CameraAspectRatios.ratio_4_3,
          zoom: 0.0,
          flashMode: controller.flashMode.value,
        ),
        previewFit: CameraPreviewFit.contain,
        theme: AwesomeTheme(
          bottomActionsBackgroundColor: colors
              .cameraBottomActionsBackgroundColor
              .withValues(alpha: 0.3),
          buttonTheme: AwesomeButtonTheme(
            backgroundColor: colors.cameraThemeBackgroundColor.withValues(
              alpha: 0.2,
            ),
            iconSize: 24,
            foregroundColor: colors.cameraThemeForegroundColor,
            padding: const EdgeInsets.all(16),
          ),
        ),
        onMediaCaptureEvent: (event) {
          if (event.status == MediaCaptureStatus.success && event.isPicture) {
            event.captureRequest.when(
              single: (single) {
                if (single.file?.path != null) {
                  controller.onPhotoCaptured(single.file!.path);
                }
              },
              multiple: (multiple) {
                final firstFile = multiple.fileBySensor.values.first;
                if (firstFile?.path != null) {
                  controller.onPhotoCaptured(firstFile!.path);
                }
              },
            );
          }
        },
        topActionsBuilder: (state) => _buildModernTopBar(context, state),
        middleContentBuilder: (state) => _buildModernScanFrame(context),
        bottomActionsBuilder: (state) => _buildModernBottomBar(context, state),
      ),
    );
  }

  /// Modern üst bar
  Widget _buildModernTopBar(BuildContext context, CameraState state) {
    // Tema renklerini al
    final colors =
        Theme.of(context).brightness == Brightness.light
            ? AppThemeConfig.lightColors
            : AppThemeConfig.darkColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      height: 70,
      color: colors.cameraScaffold,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _circleButton(
            icon: Icons.close,
            onTap: () {
              if (Get.key.currentState?.canPop() ?? false) {
                Get.back();
              } else {
                Get.offAllNamed(AppRoutes.home);
              }
            },
            context: context,
          ),
          Row(
            children: [
              // Reactive flash button - sadece açık/kapalı
              StreamBuilder<FlashMode>(
                stream: state.sensorConfig.flashMode$,
                builder: (context, snapshot) {
                  final flashMode = snapshot.data ?? FlashMode.none;
                  return _circleButton(
                    icon: _getFlashIcon(flashMode),
                    onTap: () {
                      // Flash mode'u sadece açık/kapalı toggle et
                      FlashMode nextFlash;

                      if (flashMode == FlashMode.always) {
                        nextFlash = FlashMode.none; // Açık → Kapalı
                      } else {
                        nextFlash = FlashMode.always; // Kapalı → Açık
                      }

                      state.sensorConfig.setFlashMode(nextFlash);
                      if (kDebugMode) {
                        print('Flash değişti: $flashMode → $nextFlash');
                      }
                    },
                    context: context,
                  );
                },
              ),
              const SizedBox(width: 16),
              _circleButton(
                icon: Icons.cameraswitch,
                onTap: () => state.switchCameraSensor(),
                context: context,
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required BuildContext context,
    VoidCallback? onTap,
  }) {
    // Tema renklerini al
    final colors =
        Theme.of(context).brightness == Brightness.light
            ? AppThemeConfig.lightColors
            : AppThemeConfig.darkColors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: colors.cameraCircleButtonBackgroundColor.withValues(
            alpha: 0.12,
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: colors.cameraCircleButtonBorder.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.cameraCircleButtonShadow.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Icon(icon, color: colors.cameraCircleButtonIcon, size: 22),
        ),
      ),
    );
  }

  IconData _getFlashIcon(FlashMode mode) {
    // Sadece açık/kapalı icon'ları
    switch (mode) {
      case FlashMode.always:
        return Icons.flash_on; // Açık
      case FlashMode.none:
      default:
        return Icons.flash_off; // Kapalı
    }
  }

  Widget _buildModernScanFrame(BuildContext context) {
    // Tema renklerini al
    final colors =
        Theme.of(context).brightness == Brightness.light
            ? AppThemeConfig.lightColors
            : AppThemeConfig.darkColors;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // gemai başlığı
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: colors.cameraScanFrameBackground.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'camera_scan_title'.tr,
              style: TextStyle(
                color: colors.cameraScanFrameTitleText,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Tarama çerçevesi
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              border: Border.all(color: colors.cameraScanFrameBorder, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                // Köşe işaretleri
                Positioned(
                  top: -1,
                  left: -1,
                  child: _cornerBox(topLeft: true, context: context),
                ),
                Positioned(
                  top: -1,
                  right: -1,
                  child: _cornerBox(topRight: true, context: context),
                ),
                Positioned(
                  bottom: -1,
                  left: -1,
                  child: _cornerBox(bottomLeft: true, context: context),
                ),
                Positioned(
                  bottom: -1,
                  right: -1,
                  child: _cornerBox(bottomRight: true, context: context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Talimat metni
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: colors.cameraScanDecorationBackground.withValues(
                alpha: 0.9,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: colors.cameraScanDecorationShadow.withValues(
                    alpha: 0.1,
                  ),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              'camera_scan_desc'.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: colors.cameraScanDecorationText,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernBottomBar(BuildContext context, CameraState state) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Galeri butonu
          _buildModernGalleryButton(context),

          // Çekim butonu - AwesomeBottomActions kullan
          Expanded(
            child: AwesomeBottomActions(
              state: state,
              left: const SizedBox.shrink(),
              right: const SizedBox.shrink(),
            ),
          ),

          // Boş alan (simetri için)
          const SizedBox(width: 60),
        ],
      ),
    );
  }

  Widget _buildModernGalleryButton(BuildContext context) {
    // Tema renklerini al
    final colors =
        Theme.of(context).brightness == Brightness.light
            ? AppThemeConfig.lightColors
            : AppThemeConfig.darkColors;

    return GestureDetector(
      onTap: () async {
        final picker = ImagePicker();
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
        );
        if (image != null) {
          controller.onPhotoCaptured(image.path);
        }
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: colors.cameraGalleryButtonBackgroundColor.withValues(
            alpha: 0.2,
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: colors.cameraGalleryButtonBorder.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.photo_library,
            color: colors.cameraGalleryButtonIcon,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _cornerBox({
    required BuildContext context,
    bool topLeft = false,
    bool topRight = false,
    bool bottomLeft = false,
    bool bottomRight = false,
  }) {
    // Tema renklerini al
    final colors =
        Theme.of(context).brightness == Brightness.light
            ? AppThemeConfig.lightColors
            : AppThemeConfig.darkColors;

    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: colors.cameraScanFrameBorder,
        borderRadius: BorderRadius.only(
          topLeft: topLeft ? const Radius.circular(16) : Radius.zero,
          topRight: topRight ? const Radius.circular(16) : Radius.zero,
          bottomLeft: bottomLeft ? const Radius.circular(16) : Radius.zero,
          bottomRight: bottomRight ? const Radius.circular(16) : Radius.zero,
        ),
      ),
    );
  }
}

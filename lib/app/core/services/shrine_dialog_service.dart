import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shirne_dialog/shirne_dialog.dart';
import 'package:gemai/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:gemai/app/data/model/response/response_model.dart';
import 'dart:io';
import 'dart:ui' as ui;
//import 'package:gemai/app/core/camera/camera_controller.dart';
import 'package:gemai/app/modules/camera/controller/camera_controller.dart';

class ShrineDialogService {
  /// Hata koduna göre uygun shirne dialog'u gösterir
  static void handleError(int errorCode, String errorMessage) {
    final Color colors = AppThemeConfig.textLink;
    try {
      switch (errorCode) {
        case 0:
          // Timeout hatası - API çağrısı zaman aşımına uğradı
          try {
            showNativeAlert(
              title: 'scan_dialog_title_info'.tr,
              message: 'scan_dialog_0'.tr,
              okButtonText: 'scan_dialog_ok'.tr,
              onOkPressed: () {},
            );
          } catch (e) {
            if (kDebugMode) {
              print('🔥 MyDialog.toast hatası (0): $e');
            }
          }
          break;

        case 200:
          // Başarılı response - hata gösterme
          if (kDebugMode) {
            print('✅ Başarılı response (200) - hata gösterilmiyor');
          }
          break;

        case 400:
          // Validation hatası
          try {
            showError(
              'scan_dialog_400'.tr,
              colors,
              duration: const Duration(seconds: 3),
            );
          } catch (e) {
            if (kDebugMode) {
              print('🔥 MyDialog.toast hatası (400): $e');
            }
          }
          break;

        case 403:
          // Token hakkı kalmamış - Premium'a yönlendir
          try {
            // MyDialog.toast(
            //   'scan_dialog_403'.tr,
            //   iconType: IconType.warning,
            //   style: const ToastStyle().center(),
            // );
            Get.offAllNamed(AppRoutes.premium);
          } catch (e) {
            if (kDebugMode) {
              print('🔥 MyDialog.confirm hatası (403): $e');
            }
          }
          break;

        case 500:
          // AI servisi hatası
          try {
            showWarning(
              'scan_dialog_500'.tr,
              colors,
              duration: const Duration(seconds: 3),
            );
          } catch (e) {
            if (kDebugMode) {
              print('🔥 MyDialog.toast hatası (500): $e');
            }
          }
          break;

        case 501:
          // Sistem bakım modunda
          try {
            showNativeAlert(
              title: 'scan_dialog_title_info'.tr,
              message: 'scan_dialog_501'.tr,
              okButtonText: 'scan_dialog_ok'.tr,
              onOkPressed: () {},
            );
          } catch (e) {
            if (kDebugMode) {
              print('🔥 MyDialog.toast hatası (503): $e');
            }
          }
          break;

        case 503:
          // Sistem yoğun hatası
          try {
            showNativeAlert(
              title: 'scan_dialog_title_info'.tr,
              message: 'scan_dialog_503'.tr,
              okButtonText: 'scan_dialog_ok'.tr,
              onOkPressed: () {},
            );
          } catch (e) {
            if (kDebugMode) {
              print('🔥 MyDialog.toast hatası (503): $e');
            }
          }
          break;

        case 5000:
          try {
            showNativeAlert(
              title: 'scan_dialog_title_info'.tr,
              message: 'scan_dialog_5000'.tr,
              okButtonText: 'scan_dialog_ok'.tr,
              onOkPressed: () {
                Get.offAllNamed(AppRoutes.home);
              },
            );
          } catch (e) {
            if (kDebugMode) {
              print('🔥 MyDialog.confirm hatası (5000): $e');
            }
          }
          break;

        case 429:
          try {
            showNativeAlert(
              title: 'scan_dialog_title_info'.tr,
              message: 'scan_dialog_429'.tr,
              okButtonText: 'scan_dialog_ok'.tr,
              onOkPressed: () {
                Get.offAllNamed(AppRoutes.home);
              },
            );
          } catch (e) {
            if (kDebugMode) {
              print('🔥 MyDialog.confirm hatası (429): $e');
            }
          }
          break;

        default:
          // Genel hata - Ana sayfaya yönlendir
          if (kDebugMode) {
            print(
              '🔥 handleError default case: kod=$errorCode, mesaj=$errorMessage',
            );
          }

          break;
      }
    } catch (e) {
      if (kDebugMode) {
        print('🔥 handleError içinde hata: $e');
      }
      // Fallback olarak basit toast göster
      showNativeAlert(
        title: 'scan_dialog_title_error'.tr,
        message: 'scan_dialog_error'.tr,
        okButtonText: 'scan_dialog_ok'.tr,
        onOkPressed: () {},
      );
    }
  }

  /// Snackbar yerine shirne toast gösterir
  static void showMessage({
    required String message,
    IconType? iconType,
    Duration? duration,
    required Color colors,
  }) {
    MyDialog.toast(
      message,
      duration: duration,
      iconType: iconType,
      style: ToastStyle(backgroundColor: colors).center(),
    );
  }

  /// Başarı mesajı gösterir
  static void showSuccess(String message, Color colors, {Duration? duration}) {
    MyDialog.toast(
      message,
      duration: duration,
      iconType: IconType.success,
      style: ToastStyle(backgroundColor: colors).center(),
    );
  }

  /// 🚨 YENİ: iOS tarzı native alert dialog gösterir
  /// iOS'ta native alert, Android'de Material dialog gösterir
  static void showNativeAlert({
    required String title,
    required String message,
    String? okButtonText,
    VoidCallback? onOkPressed,
    bool barrierDismissible = false,
  }) {
    if (GetPlatform.isIOS) {
      // iOS tarzı native alert
      showCupertinoDialog(
        context: Get.context!,
        barrierDismissible: barrierDismissible,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              title,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            content: Text(
              message,
              style: TextStyle(
                fontSize: 13,
                color: AppThemeConfig.textSecondary,
              ),
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  onOkPressed?.call();
                },
                child: Text(
                  okButtonText ?? 'OK',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppThemeConfig.primary,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      // Android tarzı Material dialog
      showDialog(
        context: Get.context!,
        barrierDismissible: barrierDismissible,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            content: Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: AppThemeConfig.textSecondary,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onOkPressed?.call();
                },
                child: Text(
                  okButtonText ?? 'OK',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppThemeConfig.primary,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  /// 🚨 YENİ: iOS tarzı native confirmation dialog gösterir
  /// Kullanıcı onayı gerektiren durumlar için
  static void showNativeConfirm({
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = false,
  }) {
    if (GetPlatform.isIOS) {
      // iOS tarzı native confirmation
      showCupertinoDialog(
        context: Get.context!,
        barrierDismissible: barrierDismissible,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              title,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            content: Text(
              message,
              style: TextStyle(
                fontSize: 13,
                color: AppThemeConfig.textSecondary,
              ),
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  onCancel?.call();
                },
                isDestructiveAction: false,
                child: Text(
                  cancelText ?? 'Cancel',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: AppThemeConfig.textSecondary,
                  ),
                ),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm?.call();
                },
                isDefaultAction: true,
                child: Text(
                  confirmText ?? 'OK',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppThemeConfig.primary,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      // Android tarzı Material confirmation
      showDialog(
        context: Get.context!,
        barrierDismissible: barrierDismissible,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            content: Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: AppThemeConfig.textSecondary,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onCancel?.call();
                },
                child: Text(
                  cancelText ?? 'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppThemeConfig.textSecondary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm?.call();
                },
                child: Text(
                  confirmText ?? 'OK',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppThemeConfig.primary,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  /// Hata mesajı gösterir
  static void showError(String message, Color colors, {Duration? duration}) {
    MyDialog.toast(
      duration: duration,
      message,
      iconType: IconType.error,
      style: ToastStyle(backgroundColor: colors).center(),
    );
  }

  /// Uyarı mesajı gösterir
  static void showWarning(String message, Color colors, {Duration? duration}) {
    MyDialog.toast(
      message,
      duration: duration,
      iconType: IconType.warning,
      style: ToastStyle(backgroundColor: colors).center(),
    );
  }

  /// Bilgi mesajı gösterir
  static void showInfo(String message, Color colors, {Duration? duration}) {
    MyDialog.toast(
      duration: duration,
      message,
      iconType: IconType.info,
      style: ToastStyle(backgroundColor: colors).center(),
    );
  }

  /// Loading dialog gösterir
  static ProgressController showLoading(String message) {
    return MyDialog.loading(message);
  }

  static void showConfirm(
    String message,
    String title,
    DialogType dialogType,
    Color? okButtonColor,
    Color? cancelButtonColor,
    bool showCancelButton,
    bool showOkButton, {
    Function(bool)? onConfirm,
  }) {
    final context = Get.context;
    if (context == null) return;

    try {
      AwesomeDialog(
        dialogBackgroundColor: AppThemeConfig.background,
        context: context,
        dialogType: dialogType,
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        animType: AnimType.bottomSlide,
        btnCancelColor: cancelButtonColor,
        btnOkColor: okButtonColor,
        btnCancelText: 'scan_dialog_cancel'.tr,
        btnOkText: 'scan_dialog_ok'.tr,
        title: title,
        desc: message,
        btnCancelOnPress:
            showCancelButton
                ? () {
                  onConfirm?.call(false);
                }
                : null,
        btnOkOnPress:
            showOkButton
                ? () {
                  onConfirm?.call(true);
                }
                : null,
      ).show();
    } catch (e) {
      // Hata durumunda sessizce devam et
    }
  }

  /// Basit onay dialog'u
  static void showSimpleConfirm({
    required String message,
    required String title,
    bool showCancelButton = true,
    bool showOkButton = false,
    Color? okButtonColor,
    Color? cancelButtonColor,
    Function(bool)? onConfirm,
  }) {
    showConfirm(
      message,
      title,
      DialogType.info,
      okButtonColor,
      cancelButtonColor,
      showCancelButton,
      showOkButton,
      onConfirm: onConfirm,
    );
  }

  // Hata dialog'u
  static void showErrorConfirm({
    required String message,
    required String title,
    bool showCancelButton = true,
    bool showOkButton = false,
    Color? okButtonColor,
    Color? cancelButtonColor,
    Function(bool)? onConfirm,
  }) {
    showConfirm(
      message,
      title,
      DialogType.error,
      okButtonColor ?? AppThemeConfig.error,
      cancelButtonColor,
      showCancelButton,
      showOkButton,
      onConfirm: onConfirm,
    );
  }

  // Uyarı dialog'u
  static void showWarningConfirm({
    required String message,
    required String title,
    bool showCancelButton = true,
    bool showOkButton = false,
    Color? okButtonColor,
    Color? cancelButtonColor,
    Function(bool)? onConfirm,
  }) {
    showConfirm(
      message,
      title,
      DialogType.warning,
      okButtonColor ?? AppThemeConfig.primary,
      cancelButtonColor ?? AppThemeConfig.primary,
      showCancelButton,
      showOkButton,
      onConfirm: onConfirm,
    );
  }

  // Sadece OK butonu olan dialog
  static void showInfoDialog({
    required String message,
    required String title,
    bool showCancelButton = false,
    bool showOkButton = true,
    Color? okButtonColor,
    Color? cancelButtonColor,
    Function()? onOk,
  }) {
    showConfirm(
      message,
      title,
      DialogType.info,
      okButtonColor,
      cancelButtonColor,
      showCancelButton,
      showOkButton,
      onConfirm: (confirmed) {
        onOk?.call();
      },
    );
  }

  /// Backend'den gelen hata kodunu kontrol eder
  /// Artık kelime arama yapmıyor, sadece backend'den gelen kodu kullanıyor
  static int getErrorCodeFromResponse(ResponseModel response) {
    // Backend'den gelen hata kodunu kullan
    if (response.code != null) {
      return response.code!;
    }

    // HTTP status code'u kullan
    return response.statusCode;
  }

  /// Yeniden çekim nedenleri
  /// 1001-1004 gibi durumlar için kullanılacak
  // Türkçe açıklamalar UI içinde gösterilecek
  /// Çeviri anahtarlarını tutar; çeviri çalışma zamanında yapılır
  static const Map<RetakeReason, String> _reasonTitleKeys =
      <RetakeReason, String>{
        RetakeReason.notFound: 'retake_dialog_title_not_found',
        RetakeReason.notStone: 'retake_dialog_title_not_stone',
        RetakeReason.tooFarOrClose: 'retake_dialog_title_too_far_or_close',
        RetakeReason.blurry: 'retake_dialog_title_blurry',
        RetakeReason.multipleStones: 'retake_dialog_title_multiple_stones',
        RetakeReason.notRecognized: 'retake_dialog_title_not_recognized',
        RetakeReason.tooDark: 'retake_dialog_title_too_dark',
      };

  /// Verilen nedene göre başlık çevirisini döndürür
  static String getReasonTitle(RetakeReason reason) {
    final String? key = _reasonTitleKeys[reason];
    if (key == null) return 'Retake';
    return key.tr;
  }

  /// 1001-1004 için özel "tekrar çek" alt sayfası
  /// imagePath: Kullanıcının az önce çektiği fotoğraf yolu
  static Future<void> showRetakeGuide({
    required String imagePath,
    required RetakeReason reason,
  }) async {
    final BuildContext? ctx = Get.context;
    if (ctx == null) return;

    final String title = getReasonTitle(reason);

    // Türkçe açıklama satırı
    final String subtitle = switch (reason) {
      RetakeReason.notStone => 'retake_dialog_subtitle_not_stone'.tr,
      RetakeReason.tooFarOrClose =>
        'retake_dialog_subtitle_too_far_or_close'.tr,
      RetakeReason.blurry => 'retake_dialog_subtitle_blurry'.tr,
      RetakeReason.multipleStones =>
        'retake_dialog_subtitle_multiple_stones'.tr,
      RetakeReason.notRecognized => 'retake_dialog_subtitle_not_recognized'.tr,
      RetakeReason.tooDark => 'retake_dialog_subtitle_too_dark'.tr,
      RetakeReason.notFound => 'retake_dialog_subtitle_not_found'.tr,
    };

    await showModalBottomSheet<void>(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (BuildContext context) {
        return Stack(
          children: <Widget>[
            // Arka plan: çekilen görsel (tam ekran)
            Positioned.fill(
              child:
                  imagePath.isNotEmpty && File(imagePath).existsSync()
                      ? Image.file(File(imagePath), fit: BoxFit.cover)
                      : Image.asset(
                        'assets/camera/amethyst.png',
                        fit: BoxFit.cover,
                      ),
            ),

            // Karanlık overlay - sadece alt kısımda
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 400, // Sadece alt kısımda overlay
              child: Container(color: AppThemeConfig.black.withOpacity(0.45)),
            ),

            // Sol üst kapat düğmesi
            Positioned(
              top: MediaQuery.of(context).padding.top + 20,
              left: 12,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppThemeConfig.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.close,
                      size: 22,
                      color: AppThemeConfig.white,
                    ),
                  ),
                ),
              ),
            ),

            // Beyaz panel - sadece alt kısımda
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppThemeConfig.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: EdgeInsets.fromLTRB(
                  20,
                  16,
                  20,
                  MediaQuery.of(context).padding.bottom + 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Başlık
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.error_outline,
                          color: AppThemeConfig.severityIndicatorColor4,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppThemeConfig.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppThemeConfig.black.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Üst: Doğru çekim örneği (geniş kart)
                    _CorrectExampleCard(),

                    const SizedBox(height: 14),

                    // 2x2 kötü örnek gridi
                    _BadExamplesGrid(reason: reason),

                    const SizedBox(height: 16),

                    // Tekrar al butonu
                    ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppThemeConfig.textLink,
                        foregroundColor: AppThemeConfig.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: Text(
                        'retake_button_title'.tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
    // Sheet kapandıktan sonra kamerayı yeniden inşa et
    if (Get.isRegistered<CameraController>()) {
      try {
        final cam = Get.find<CameraController>();
        cam.rebuildCamera();
      } catch (_) {}
    }
  }
}

/// Yeniden çekim nedenleri
enum RetakeReason {
  notFound, // 1001 eski mantık
  notStone, // 1002
  tooFarOrClose, // 1003
  blurry, // 1003 varyasyonu
  multipleStones, // 1004 varyasyonu
  notRecognized, // 1004
  tooDark, // 1003 varyasyonu
}

/// Örnekler grid'i - doğru/kötü çekim kartları
class _ExampleCard extends StatelessWidget {
  final String label;
  final bool good;
  final String asset;
  final RetakeEffect effect;
  const _ExampleCard({
    required this.label,
    required this.good,
    required this.asset,
    this.effect = RetakeEffect.none,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppThemeConfig.neutralSurfaceDark,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildEffectImage(),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: <Widget>[
              Icon(
                good ? Icons.check_circle : Icons.cancel,
                size: 18,
                color:
                    good
                        ? AppThemeConfig.success
                        : AppThemeConfig.severityIndicatorColor4,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppThemeConfig.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Efektli görseli üretir
  Widget _buildEffectImage() {
    // Temel görseli 'tam sığdır' (contain) olarak tanımla
    final Widget contained = Center(
      child: Image.asset(
        asset,
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
      ),
    );

    switch (effect) {
      case RetakeEffect.dark:
        // Karanlık overlay ile, görsel tam sığdır
        return Stack(
          children: <Widget>[
            Positioned.fill(
              child: Container(color: AppThemeConfig.neutralSurfaceAlmostBlack),
            ),
            Positioned.fill(child: contained),
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.65)),
            ),
          ],
        );
      case RetakeEffect.far:
        // Uzak: görseli daha da küçült, merkezde tut
        return Container(
          color: AppThemeConfig.neutralSurfaceAlmostBlack,
          child: Center(
            child: SizedBox(
              width: 25,
              height: 25,
              child: Image.asset(asset, fit: BoxFit.contain),
            ),
          ),
        );
      case RetakeEffect.blurry:
        // Bulanık: tam sığdır + blur
        return Container(
          color: AppThemeConfig.neutralSurfaceAlmostBlack,
          child: ImageFiltered(
            imageFilter: ui.ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
            child: contained,
          ),
        );
      case RetakeEffect.none:
        // Varsayılan: tam sığdır
        return Container(
          color: AppThemeConfig.neutralSurfaceAlmostBlack,
          child: contained,
        );
    }
  }
}

class _CorrectExampleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppThemeConfig.panelBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppThemeConfig.panelBorderBrown.withOpacity(0.25),
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 120,
              height: 80,
              color: AppThemeConfig.neutralSurfaceAlmostBlack,
              child: Center(
                child: Image.asset(
                  'assets/camera/amethyst.png',
                  fit: BoxFit.contain, // tam sığdır
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'retake_dialog_correct_example'.tr,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppThemeConfig.black,
              ),
            ),
          ),
          const Icon(Icons.check_circle, color: AppThemeConfig.success),
        ],
      ),
    );
  }
}

class _BadExamplesGrid extends StatelessWidget {
  final RetakeReason reason;
  const _BadExamplesGrid({required this.reason});

  @override
  Widget build(BuildContext context) {
    final List<_ExampleCard> items = _buildBadItems(reason);
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.1, // Daha kompakt
      children: items,
    );
  }

  List<_ExampleCard> _buildBadItems(RetakeReason r) {
    // 4 kart döner - her biri farklı efekt uygular
    final List<_ExampleCard> list = <_ExampleCard>[
      _ExampleCard(
        label: 'retake_dialog_dark'.tr,
        good: false,
        asset: 'assets/camera/amethyst.png',
        effect: RetakeEffect.dark,
      ),
      _ExampleCard(
        label: 'retake_dialog_far'.tr,
        good: false,
        asset: 'assets/camera/amethyst.png',
        effect: RetakeEffect.far,
      ),
      _ExampleCard(
        label: 'retake_dialog_blurry'.tr,
        good: false,
        asset: 'assets/camera/amethyst.png',
        effect: RetakeEffect.blurry,
      ),
      _ExampleCard(
        label: 'retake_dialog_multiple_stones'.tr,
        good: false,
        asset:
            r == RetakeReason.multipleStones
                ? 'assets/camera/rocks.png'
                : 'assets/camera/rocks.png',
        effect: RetakeEffect.none,
      ),
    ];

    return list;
  }
}

/// Efekt türleri (retake örnek kartları için)
enum RetakeEffect { none, far, dark, blurry }

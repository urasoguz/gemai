import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dermai/app/core/theme/app_theme_config.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shirne_dialog/shirne_dialog.dart';
import 'package:dermai/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:dermai/app/data/model/response/response_model.dart';

class ShrineDialogService {
  /// Hata koduna göre uygun shirne dialog'u gösterir
  static void handleError(int errorCode, String errorMessage) {
    final colors =
        Theme.of(Get.context!).brightness == Brightness.light
            ? AppThemeConfig.colors
            : AppThemeConfig.colors;
    try {
      switch (errorCode) {
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
            showInfoDialog(
              message: 'scan_dialog_501'.tr,
              title: 'scan_dialog_title_info'.tr,
              showCancelButton: false,
              showOkButton: true,
              okButtonColor: colors.primary,
              onOk: () {
                Get.offAllNamed(AppRoutes.home);
              },
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
            showWarning(
              'scan_dialog_503'.tr,
              colors,
              duration: const Duration(seconds: 3),
            );
          } catch (e) {
            if (kDebugMode) {
              print('🔥 MyDialog.toast hatası (503): $e');
            }
          }
          break;

        case 1001:
          // Görsel insan cildiyle ilgili değil - Kamera'ya yönlendir
          try {
            showWarningConfirm(
              message: 'scan_dialog_1001'.tr,
              title: 'scan_dialog_title_warning'.tr,
              showCancelButton: false,
              showOkButton: true,
              colors: colors,
              onConfirm: (confirmed) {
                Get.offAllNamed(AppRoutes.home);
              },
            );
          } catch (e) {
            if (kDebugMode) {
              print('🔥 MyDialog.confirm hatası (1001): $e');
            }
          }
          break;

        case 5000:
          try {
            showWarning(
              'scan_dialog_5000'.tr,
              colors,
              duration: const Duration(seconds: 3),
            );
            Future.delayed(const Duration(seconds: 3), () {
              Get.offAllNamed(AppRoutes.home);
            });
          } catch (e) {
            if (kDebugMode) {
              print('🔥 MyDialog.confirm hatası (5000): $e');
            }
          }
          break;

        case 429:
          try {
            showWarning(
              'scan_dialog_429'.tr,
              colors,
              duration: const Duration(seconds: 3),
            );
            Future.delayed(const Duration(seconds: 3), () {
              Get.offAllNamed(AppRoutes.home);
            });
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
          showError(
            'scan_dialog_error'.tr,
            colors,
            duration: const Duration(seconds: 3),
          );
          Future.delayed(const Duration(seconds: 3), () {
            Get.offAllNamed(AppRoutes.home);
          });
          break;
      }
    } catch (e) {
      if (kDebugMode) {
        print('🔥 handleError içinde hata: $e');
      }
      // Fallback olarak basit toast göster
      showError(
        'scan_dialog_error'.tr,
        colors,
        duration: const Duration(seconds: 3),
      );
    }
  }

  /// Snackbar yerine shirne toast gösterir
  static void showMessage({
    required String message,
    IconType? iconType,
    Duration? duration,
    required dynamic colors,
  }) {
    MyDialog.toast(
      message,
      duration: duration,
      iconType: iconType,
      style: ToastStyle(backgroundColor: colors.black).center(),
    );
  }

  /// Başarı mesajı gösterir
  static void showSuccess(
    String message,
    dynamic colors, {
    Duration? duration,
  }) {
    MyDialog.toast(
      message,
      duration: duration,
      iconType: IconType.success,
      style: ToastStyle(backgroundColor: colors.black).center(),
    );
  }

  /// Hata mesajı gösterir
  static void showError(String message, dynamic colors, {Duration? duration}) {
    MyDialog.toast(
      duration: duration,
      message,
      iconType: IconType.error,
      style: ToastStyle(backgroundColor: colors.black).center(),
    );
  }

  /// Uyarı mesajı gösterir
  static void showWarning(
    String message,
    dynamic colors, {
    Duration? duration,
  }) {
    MyDialog.toast(
      message,
      duration: duration,
      iconType: IconType.warning,
      style: ToastStyle(backgroundColor: colors.black).center(),
    );
  }

  /// Bilgi mesajı gösterir
  static void showInfo(String message, dynamic colors, {Duration? duration}) {
    MyDialog.toast(
      duration: duration,
      message,
      iconType: IconType.info,
      style: ToastStyle(backgroundColor: colors.black).center(),
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
    final colors =
        Theme.of(Get.context!).brightness == Brightness.light
            ? AppThemeConfig.colors
            : AppThemeConfig.colors;
    AwesomeDialog(
      dialogBackgroundColor: colors.background,
      context: Get.context!,
      dialogType: dialogType,
      dismissOnTouchOutside: false, // Dışarıya dokununca kapanmaz
      dismissOnBackKeyPress: false, // Geri tuşu ile kapanmaz
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

      //boşluğa basınca kapatmayı engelle
    ).show();
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
    required dynamic colors,
  }) {
    showConfirm(
      message,
      title,
      DialogType.error,
      colors.red,
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
    required dynamic colors,
  }) {
    showConfirm(
      message,
      title,
      DialogType.warning,
      colors.primary,
      colors.primary,
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
}

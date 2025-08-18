import 'package:gemai/app/core/localization/translations.dart';
import 'package:gemai/app/core/services/theme_service.dart';
import 'package:gemai/app/core/services/date_formatting_service.dart';
import 'package:gemai/app/core/services/in_app_review_service.dart';
import 'package:gemai/app/shared/controllers/lang_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gemai/app/routes/app_pages.dart';
import 'package:gemai/app/routes/app_routes.dart';
import 'package:gemai/app/core/services/sembast_service.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:gemai/app/core/bindings/api_bindings.dart';
import 'package:gemai/app/core/bindings/app_settings_binding.dart';
import 'package:gemai/app/core/network/api_client.dart';
import 'package:gemai/app/data/api/api_endpoints.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:shirne_dialog/shirne_dialog.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:gemai/app/core/localization/languages.dart';
import 'package:gemai/app/core/services/network_service.dart';
import 'package:gemai/app/shared/widgets/no_internet_screen.dart';
import 'package:upgrader/upgrader.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // SharedPreferences'ı önce başlat
    await GetStorage.init();
    Get.put(GetStorage());

    // SharedPreferences'ı da başlat (iOS için)
    await SharedPreferences.getInstance();
  } catch (e, stack) {
    debugPrint("Hata oluştu: $e");
    debugPrint(stack.toString());
  }

  await SembastService().db; // Sembast başlat

  // API servislerini register et (AuthApiService dahil)
  ApiBindings().dependencies(); // <-- DOĞRU YERDE ÇAĞIR

  // App Settings binding'ini register et
  AppSettingsBinding().dependencies();

  // Tarih formatlaması servisini kaydet
  Get.put<DateFormattingService>(DateFormattingService(), permanent: true);

  // Tema servisini register et
  Get.put<ThemeService>(ThemeService(), permanent: true);

  // In-app review servisini register et
  Get.put<InAppReviewService>(InAppReviewService(), permanent: true);

  // Network Service'i başlat
  Get.put<NetworkService>(NetworkService(), permanent: true);

  // Locale verilerini başlat (intl paketi için) - Tüm desteklenen diller
  await _initializeAllLocales();

  // ApiClient'ı global olarak register et
  Get.put<ApiClient>(
    ApiClient(
      appBaseUrl: ApiEndpoints.baseUrl, // ApiEndpoints'ten alıyoruz
      sharedPreferences: GetStorage(),
    ),
    permanent: true,
  );

  runApp(Phoenix(child: const MyApp()));
}

/// Tüm desteklenen diller için locale verilerini başlatır
Future<void> _initializeAllLocales() async {
  // Her dil için uygun locale formatını belirle
  final localeMap = {
    'en': 'en_US',
    'tr': 'tr_TR',
    'zh': 'zh_CN',
    'ru': 'ru_RU',
    'es': 'es_ES',
    'pt': 'pt_BR',
    'hi': 'hi_IN',
    'ar': 'ar_SA',
    'fr': 'fr_FR',
    'de': 'de_DE',
    'it': 'it_IT',
    'id': 'id_ID',
    'fa': 'fa_IR',
    'nl': 'nl_NL',
    'sv': 'sv_SE',
    'ja': 'ja_JP',
    'ko': 'ko_KR',
    'pl': 'pl_PL',
    'ms': 'ms_MY',
    'uk': 'uk_UA',
    'ur': 'ur_PK',
    'vi': 'vi_VN',
    'el': 'el_GR',
    'th': 'th_TH',
    'bn': 'bn_BD',
    'fi': 'fi_FI',
    'tk': 'tk_TM',
    'az': 'az_AZ',
    'ku': 'ku_IQ',
    'ro': 'ro_RO',
    'hu': 'hu_HU',
    'cs': 'cs_CZ',
    'sk': 'sk_SK',
    'sr': 'sr_RS',
    'he': 'he_IL',
  };

  // Tüm desteklenen diller için locale verilerini başlat
  for (final languageCode in Languages.supportedLanguages) {
    final locale = localeMap[languageCode];
    if (locale != null) {
      try {
        await initializeDateFormatting(locale, null);
        debugPrint('✅ Locale başlatıldı: $locale');
      } catch (e) {
        debugPrint('❌ Locale başlatılamadı: $locale - $e');
      }
    }
  }
}

final LangController langController = Get.put(LangController());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final networkService = Get.find<NetworkService>();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: MyDialog.navigatorKey,
      theme: _buildThemeData(AppThemeConfig.lightColors, Brightness.light),
      darkTheme: _buildThemeData(AppThemeConfig.darkColors, Brightness.dark),
      themeMode: themeService.theme,
      translations: AppTranslations(),
      locale: Locale(langController.currentLanguage.value),
      fallbackLocale: const Locale('en'),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: Builder(
            builder: (context) {
              // Internet bağlantısı kontrolü
              return Obx(() {
                if (!networkService.isConnected.value) {
                  return const NoInternetScreen();
                }
                return UpgradeAlert(
                  upgrader: Upgrader(
                    // Debug modda güncelleme kontrolü
                    debugLogging: kDebugMode,

                    // Güncelleme dialog'u gösterilmeden önce beklenecek süre
                    durationUntilAlertAgain: Duration(days: 1),
                  ),
                  child: child!,
                );
              });
            },
          ),
        );
      },
    );
  }

  ThemeData _buildThemeData(ColorPalette colors, Brightness brightness) {
    return ThemeData(
      brightness: brightness,
      primaryColor: colors.primary,
      scaffoldBackgroundColor: colors.background,
      cardColor: colors.card,
      dividerColor: colors.divider,
      fontFamily: AppThemeConfig.fontFamily,
      extensions: [const ShirneDialogTheme()],
      appBarTheme: AppBarTheme(
        backgroundColor: colors.appBar,
        foregroundColor: colors.textPrimary,
        elevation: 4.0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: colors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: AppThemeConfig.fontFamily,
        ),
      ),
      cardTheme: CardTheme(
        color: colors.card,
        elevation: AppThemeConfig.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeConfig.borderRadius),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: colors.textPrimary,
          fontFamily: AppThemeConfig.fontFamily,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: colors.textPrimary,
          fontFamily: AppThemeConfig.fontFamily,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: colors.textPrimary,
          fontFamily: AppThemeConfig.fontFamily,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: TextStyle(
          color: colors.textPrimary,
          fontFamily: AppThemeConfig.fontFamily,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: colors.textPrimary,
          fontFamily: AppThemeConfig.fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: colors.textPrimary,
          fontFamily: AppThemeConfig.fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        titleLarge: TextStyle(
          color: colors.textPrimary,
          fontFamily: AppThemeConfig.fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        titleMedium: TextStyle(
          color: colors.textPrimary,
          fontFamily: AppThemeConfig.fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: colors.textPrimary,
          fontFamily: AppThemeConfig.fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: colors.textPrimary,
          fontFamily: AppThemeConfig.fontFamily,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: colors.textPrimary,
          fontFamily: AppThemeConfig.fontFamily,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: colors.textSecondary,
          fontFamily: AppThemeConfig.fontFamily,
          fontSize: 12,
        ),
        labelLarge: TextStyle(
          color: colors.textPrimary,
          fontFamily: AppThemeConfig.fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          color: colors.textSecondary,
          fontFamily: AppThemeConfig.fontFamily,
          fontSize: 12,
        ),
        labelSmall: TextStyle(
          color: colors.textHint,
          fontFamily: AppThemeConfig.fontFamily,
          fontSize: 10,
        ),
      ),
      // Diğer tema ayarları buraya eklenebilir
    );
  }
}

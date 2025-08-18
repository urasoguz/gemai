class MyHelper {
  // Web sayfaları için base URL
  static const String baseUrl = "https://gemai.us";
  static const String appname = "gemai";

  /// RevenueCat API anahtarları
  /// iOS için ayrı, Android için ayrı kullanılır
  static const String revenuecatApiKeyIOS =
      "appl_UVxdbKjOvpEHJvNmZcEDYYkgAag"; // Buraya kendi iOS anahtarını yaz
  static const String revenuecatApiKeyAndroid =
      "goog_xxx"; // Buraya kendi Android anahtarını yaz

  //from this below no need to change. If anything change app will not work
  // Bu endpoint'ler artık ApiEndpoints'te tanımlı
  // static const String registerViaDeviceUrl = "api/register-device";
  // static const String userUrl = "api/user";
  // static const String scanUrl = "api/scan-image";

  //local storage
  static const String bToken = "bearer_token";
  static const String expiaryDate = "expiary_date";
  static const String isAccountPremium = "is_account_premium";
  static const String accountRemainingToken = "account_remaining_token";
  static const String paywallFirstLaunch = "paywall_first_launch";
  static const String paywallFirstShown = "paywall_first_shown";
  static const String isDarkMode = "is_dark_mode";
  static const String appVersion = "app_version";
  static const String isOnboardingCompleted = "is_onboarding_completed";
  static const String isLegalWarningAccepted = "is_legal_warning_accepted";
  static const String hasShownInAppReview = "has_shown_in_app_review";
}

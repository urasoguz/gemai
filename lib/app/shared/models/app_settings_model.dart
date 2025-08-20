// Uygulama ayarlarını tutan model
//
// Backend'den gelen ayarları parse eder ve tutar
//
// KULLANIM ÖRNEĞİ:
// ```dart
// // API'den gelen veriyi parse etme
// final settings = AppSettingsModel.fromJson(jsonData);
//
// // Ayarlara erişim
// print('Paywall Every Launch: ${settings.paywall?.paywallEveryLaunch}');
// print('Contact Mail: ${settings.ui?.mail}');
// print('Ads Provider: ${settings.ads?.adsProvider}');
// ```

// Paywall ayarları
class PaywallSettings {
  final bool? paywallEveryLaunch;
  final bool? paywallDelayedCloseButton;
  final int? paywallCloseButtonDelay;
  final bool? paywallCloseButton;

  PaywallSettings({
    this.paywallEveryLaunch,
    this.paywallDelayedCloseButton,
    this.paywallCloseButtonDelay,
    this.paywallCloseButton,
  });

  factory PaywallSettings.fromJson(Map<String, dynamic> json) {
    return PaywallSettings(
      paywallEveryLaunch: json['paywall_every_launch'],
      paywallDelayedCloseButton: json['paywall_delayed_close_button'],
      paywallCloseButtonDelay: json['paywall_close_button_delay'],
      paywallCloseButton: json['paywall_close_button'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paywall_every_launch': paywallEveryLaunch,
      'paywall_delayed_close_button': paywallDelayedCloseButton,
      'paywall_close_button_delay': paywallCloseButtonDelay,
      'paywall_close_button': paywallCloseButton,
    };
  }
}

// UI ayarları (eski AppLinkSettings yerine)
class UiSettings {
  final String? mail;
  final bool? appleReview;
  final bool? googleReview;

  UiSettings({this.mail, this.appleReview, this.googleReview});

  factory UiSettings.fromJson(Map<String, dynamic> json) {
    return UiSettings(
      mail: json['mail'],
      appleReview:
          json['apple_review'] ??
          true, // Default true (güvenlik için inceleme modu)
      googleReview:
          json['google_review'] ??
          true, // Default true (güvenlik için inceleme modu)
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mail': mail,
      'apple_review': appleReview,
      'google_review': googleReview,
    };
  }
}

// Reklam ayarları
class AdsSettings {
  final int? adsProvider;

  AdsSettings({this.adsProvider});

  factory AdsSettings.fromJson(Map<String, dynamic> json) {
    return AdsSettings(adsProvider: json['ads_provider']);
  }

  Map<String, dynamic> toJson() {
    return {'ads_provider': adsProvider};
  }
}

// App Store bağlantıları
class AppStoreLinks {
  final String? appleStoreUrl;
  final String? googlePlayStoreUrl;

  AppStoreLinks({this.appleStoreUrl, this.googlePlayStoreUrl});

  factory AppStoreLinks.fromJson(Map<String, dynamic> json) {
    return AppStoreLinks(
      appleStoreUrl: json['apple_store_url'],
      googlePlayStoreUrl: json['google_play_store_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'apple_store_url': appleStoreUrl,
      'google_play_store_url': googlePlayStoreUrl,
    };
  }
}

// Ana ayarlar modeli
class AppSettingsModel {
  final PaywallSettings? paywall;
  final UiSettings? ui;
  final AdsSettings? ads;
  final AppStoreLinks? appStoreLinks;

  AppSettingsModel({this.paywall, this.ui, this.ads, this.appStoreLinks});

  /// JSON'dan AppSettingsModel oluşturur
  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      paywall:
          json['paywall'] != null
              ? PaywallSettings.fromJson(json['paywall'])
              : null,
      ui: json['ui'] != null ? UiSettings.fromJson(json['ui']) : null,
      ads: json['ads'] != null ? AdsSettings.fromJson(json['ads']) : null,
      appStoreLinks:
          json['app_store_links'] != null
              ? AppStoreLinks.fromJson(json['app_store_links'])
              : null,
    );
  }

  /// AppSettingsModel'i JSON'a dönüştürür
  Map<String, dynamic> toJson() {
    return {
      'paywall': paywall?.toJson(),
      'ui': ui?.toJson(),
      'ads': ads?.toJson(),
      'app_store_links': appStoreLinks?.toJson(),
    };
  }

  /// Boş bir AppSettingsModel oluşturur
  factory AppSettingsModel.empty() {
    return AppSettingsModel();
  }

  /// Modelin boş olup olmadığını kontrol eder
  bool get isEmpty =>
      paywall == null && ui == null && ads == null && appStoreLinks == null;

  /// Modelin dolu olup olmadığını kontrol eder
  bool get isNotEmpty => !isEmpty;

  /// Kopya oluşturur ve belirtilen alanları günceller
  AppSettingsModel copyWith({
    PaywallSettings? paywall,
    UiSettings? ui,
    AdsSettings? ads,
    AppStoreLinks? appStoreLinks,
  }) {
    return AppSettingsModel(
      paywall: paywall ?? this.paywall,
      ui: ui ?? this.ui,
      ads: ads ?? this.ads,
      appStoreLinks: appStoreLinks ?? this.appStoreLinks,
    );
  }

  @override
  String toString() {
    return 'AppSettingsModel{paywall: $paywall, ui: $ui, ads: $ads, appStoreLinks: $appStoreLinks}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSettingsModel &&
        other.paywall == paywall &&
        other.ui == ui &&
        other.ads == ads &&
        other.appStoreLinks == appStoreLinks;
  }

  @override
  int get hashCode {
    return paywall.hashCode ^
        ui.hashCode ^
        ads.hashCode ^
        appStoreLinks.hashCode;
  }
}

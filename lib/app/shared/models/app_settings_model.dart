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

  UiSettings({this.mail});

  factory UiSettings.fromJson(Map<String, dynamic> json) {
    return UiSettings(mail: json['mail']);
  }

  Map<String, dynamic> toJson() {
    return {'mail': mail};
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

// Ana ayarlar modeli
class AppSettingsModel {
  final PaywallSettings? paywall;
  final UiSettings? ui;
  final AdsSettings? ads;

  AppSettingsModel({this.paywall, this.ui, this.ads});

  /// JSON'dan AppSettingsModel oluşturur
  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      paywall:
          json['paywall'] != null
              ? PaywallSettings.fromJson(json['paywall'])
              : null,
      ui: json['ui'] != null ? UiSettings.fromJson(json['ui']) : null,
      ads: json['ads'] != null ? AdsSettings.fromJson(json['ads']) : null,
    );
  }

  /// AppSettingsModel'i JSON'a dönüştürür
  Map<String, dynamic> toJson() {
    return {
      'paywall': paywall?.toJson(),
      'ui': ui?.toJson(),
      'ads': ads?.toJson(),
    };
  }

  /// Boş bir AppSettingsModel oluşturur
  factory AppSettingsModel.empty() {
    return AppSettingsModel();
  }

  /// Modelin boş olup olmadığını kontrol eder
  bool get isEmpty => paywall == null && ui == null && ads == null;

  /// Modelin dolu olup olmadığını kontrol eder
  bool get isNotEmpty => !isEmpty;

  /// Kopya oluşturur ve belirtilen alanları günceller
  AppSettingsModel copyWith({
    PaywallSettings? paywall,
    UiSettings? ui,
    AdsSettings? ads,
  }) {
    return AppSettingsModel(
      paywall: paywall ?? this.paywall,
      ui: ui ?? this.ui,
      ads: ads ?? this.ads,
    );
  }

  @override
  String toString() {
    return 'AppSettingsModel{paywall: $paywall, ui: $ui, ads: $ads}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSettingsModel &&
        other.paywall == paywall &&
        other.ui == ui &&
        other.ads == ads;
  }

  @override
  int get hashCode {
    return paywall.hashCode ^ ui.hashCode ^ ads.hashCode;
  }
}

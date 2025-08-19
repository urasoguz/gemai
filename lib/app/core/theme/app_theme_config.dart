import 'package:flutter/material.dart';

/// Tüm tema ayarlarını merkezi olarak yöneten dosya
/// Sadece bu dosyayı değiştirerek yeni bir uygulama oluşturabilirsiniz
class AppThemeConfig {
  static const String appName = 'GEMAI';
  static const String fontFamily =
      'Roboto'; // Varsayılan font - KoHo sadece AppBar'da kullanılıyor

  /// Tek renk paleti - gemAI için özel tasarım
  static const ColorPalette colors = ColorPalette(
    // Ana Renkler - Gradient'ten alınan renkler
    primary: Color(0xFF134E5E), // Koyu yeşil-mavi (gradient başlangıcı)
    secondary: Color(0xFF71B280), // Açık yeşil (gradient bitişi)
    // Arka Plan Renkleri
    background: Color(0xFFF9F9F9), // Ana arka plan (Scaffold backgroundColor)
    surface: Color(0xFFFFFFFF), // Beyaz yüzey (kartlar, AppBar)
    card: Color(0xFFFFFFFF), // Beyaz kart rengi
    // Metin Renkleri
    textPrimary: Color(0xFF222222), // Ana metin rengi (siyah)
    textSecondary: Color(0xFF757575), // İkincil metin rengi (gri)
    textTertiary: Color(0xFF222222), // üçüncü metin rengi (gri)
    textHint: Color(0xFFBDBDBD), // İpucu metin rengi (açık gri)
    textLink: Color(0xFF1268A4), // Link metin rengi (mavi)
    // UI Element Renkleri
    appBar: Color(0xFFFFFFFF), // AppBar rengi (beyaz)
    bottomNav: Color(0xFFFFFFFF), // Alt navigasyon rengi (beyaz)
    divider: Color(0xFFE0E0E0), // Ayırıcı çizgi rengi (AppBar divider)
    // Durum Renkleri
    success: Color(0xFF4CAF50), // Başarı rengi (yeşil)
    warning: Color(0xFFFFC700), // Uyarı rengi (sarı - lightbulb)
    error: Color(0xFFF44336), // Hata rengi (kırmızı)
    info: Color(0xFF2196F3), // Bilgi rengi (mavi)
    // Gradient Renkleri
    gradientPrimary: Color(0xFF134E5E),
    gradientSecondary: Color(0xFF71B280),
    //bottom navbar
    buttonIcon: Color(0xFFFFFFFF),
    buttonBorder: Color(0xFFFFFFFF),
    buttonShadow: Colors.black,
    buttonText: Color(0xFFFFFFFF),
    black: Colors.black,
    orange: Color(0xFFFF9800),
    red: Color(0xFFF44336),
    //analyze button
    analyzeButton: Color(0xFFFFFFFF),
    analyzeButtonIcon: Color(0xFF134E5E),

    //camera
    //cameraBackground: Color(0x00000000),
    cameraScaffold: Color(0xFF000000), // Siyah arka plan (alpha = 0xFF)
    cameraCapturedBackground: Color(0xFF000000), // Siyah arka plan
    cameraControlButtonIcon: Color(0xffffffff),
    cameraBottomActionsBackgroundColor: Color(0xFF000000), // Siyah arka plan
    cameraThemeBackgroundColor: Color(0xffffffff),
    cameraThemeForegroundColor: Color(0xffffffff),
    cameraCircleButtonIcon: Color(0xffffffff),
    cameraCircleButtonBackgroundColor: Color(0xffffffff),
    cameraCircleButtonBorder: Color(0xffffffff),
    cameraCircleButtonShadow: Color(0xFF000000),

    cameraScanFrameBackground: Color(0xFF000000),
    cameraScanFrameTitleText: Color(0xffffffff),
    cameraScanFrameBorder: Color(0xFF71B280),
    cameraScanDecorationBackground: Color(0xffffffff),
    cameraScanDecorationShadow: Color(0xFF000000),
    cameraScanDecorationText: Color(0xFF000000),
    cameraGalleryButtonBackgroundColor: Color(0xffffffff),
    cameraGalleryButtonBorder: Color(0xffffffff),
    cameraGalleryButtonIcon: Color(0xffffffff),

    cameraAnalyzeBackground: Color(0xFF000000),
    cameraAnalyzeBackgroundShadow: Color(0xFF000000),
    cameraAnalyzeTitleText: Color(0xffffffff),
    cameraAnalyzeText: Color(0xFFC7C7C7),
    cameraAnalyzeProgressBackground: Color(0xffffffff),
    cameraAnalyzeProgressBar: Color(0xFF71B280),
    cameraAnalyzeLogoIcon: Color(0xffffffff),
    cameraAnalyzeLogoIconShadow: Color(0xFF71B280),
    cameraAnalyzeEffect: Color(0xFF71B280),

    //skin analysis
    skinAnalysisYearText: Color(0xFF134E5E),
    symptomChipColor: Color(0xFFD32F2F),
    bodyPartChipColor: Color(0xFFFF9800),
    riskFactorChipColor: Color(0xFF7B1FA2),
    treatmentChipColor: Color(0xFF009688),
    preventionChipColor: Color(0xFF388E3C),
    alternativeTreatmentChipColor: Color(0xFF43A047),

    //result
    severityIndicatorColor1: Color(0xFF4CAF50),
    severityIndicatorColor2: Color(0xFFFFC107),
    severityIndicatorColor3: Color(0xFFFF9800),
    severityIndicatorColor4: Color(0xFFE53935),

    //splash
    splashTextColor: Color(0xFFFFFFFF),
    splashTextShadowColor: Color(0xFF000000),

    //onboarding
    onboardingBackground: Color(0xFFFFFFFF),
    onboardingPageIndicatorActive: Color(0xFF000000),
    onboardingPageIndicatorInactive: Color(0xFF757575),
    onboardingButtonText: Color(0xFFFFFFFF),
    onboardingButtonBackground: Color(0xFF000000),
    onboardingButtonShadow: Color(0xFF000000),
    onboardingSkipTextColor: Color(0xFF000000),
    onboardingDescTextColor: Colors.black54,
    onboardingTitleTextColor: Color(0xFF2D2D2D),
    onboardingImageBackground: Color(0xFFFFFFFF),
    onboardingImageShadow: Color(0xFF000000),
    onboardingImageIcon: Color(0xFF000000),
    cardBackground: Color(0xFFFFFFFF),
    borderColor: Color(0xFFE0E0E0),
  );



  /// Tema ayarları (köşe yarıçapı, animasyon vs.)
  static const double borderRadius = 16.0; // Mevcut uygulamada kullanılan değer
  static const double cardElevation = 0.0; // Mevcut uygulamada elevation yok
  static const Duration animationDuration = Duration(milliseconds: 300);
}

/// Renk paleti sınıfı
class ColorPalette {
  final Color primary;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color card;
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color appBar;
  final Color bottomNav;
  final Color divider;
  final Color success;
  final Color warning;
  final Color error;
  final Color info;
  final Color gradientPrimary;
  final Color gradientSecondary;
  final Color buttonIcon;
  final Color buttonBorder;
  final Color buttonShadow;
  final Color analyzeButton;
  final Color analyzeButtonIcon;
  final Color textTertiary;
  final Color textLink;
  final Color cameraScaffold;
  final Color cameraCapturedBackground;
  final Color cameraControlButtonIcon;
  final Color cameraBottomActionsBackgroundColor;
  final Color cameraThemeBackgroundColor;
  final Color cameraThemeForegroundColor;
  final Color cameraCircleButtonIcon;
  final Color cameraCircleButtonBackgroundColor;
  final Color cameraCircleButtonBorder;
  final Color cameraCircleButtonShadow;
  final Color cameraScanFrameTitleText;
  final Color cameraScanFrameBorder;
  final Color cameraScanDecorationShadow;
  final Color cameraScanDecorationText;
  final Color cameraScanFrameBackground;
  final Color cameraScanDecorationBackground;
  final Color cameraGalleryButtonBackgroundColor;
  final Color cameraGalleryButtonBorder;
  final Color cameraGalleryButtonIcon;
  final Color cameraAnalyzeBackground;
  final Color cameraAnalyzeTitleText;
  final Color cameraAnalyzeText;
  final Color cameraAnalyzeProgressBackground;
  final Color cameraAnalyzeProgressBar;
  final Color cameraAnalyzeBackgroundShadow;
  final Color cameraAnalyzeLogoIcon;
  final Color cameraAnalyzeLogoIconShadow;
  final Color cameraAnalyzeEffect;
  final Color skinAnalysisYearText;
  final Color buttonText;
  final Color symptomChipColor;
  final Color bodyPartChipColor;
  final Color riskFactorChipColor;
  final Color treatmentChipColor;
  final Color preventionChipColor;
  final Color alternativeTreatmentChipColor;
  final Color severityIndicatorColor1;
  final Color severityIndicatorColor2;
  final Color severityIndicatorColor3;
  final Color severityIndicatorColor4;
  final Color splashTextColor;
  final Color splashTextShadowColor;
  final Color onboardingBackground;
  final Color onboardingPageIndicatorActive;
  final Color onboardingPageIndicatorInactive;
  final Color onboardingButtonText;
  final Color onboardingButtonBackground;
  final Color onboardingButtonShadow;
  final Color onboardingSkipTextColor;
  final Color onboardingDescTextColor;
  final Color onboardingTitleTextColor;
  final Color onboardingImageBackground;
  final Color onboardingImageShadow;
  final Color onboardingImageIcon;
  final Color black;
  final Color orange;
  final Color red;
  final Color cardBackground;
  final Color borderColor;

  const ColorPalette({
    required this.primary,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.card,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.appBar,
    required this.bottomNav,
    required this.divider,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.gradientPrimary,
    required this.gradientSecondary,
    required this.buttonIcon,
    required this.buttonBorder,
    required this.buttonShadow,
    required this.analyzeButton,
    required this.analyzeButtonIcon,
    required this.textTertiary,
    required this.textLink,
    required this.cameraScaffold,
    required this.cameraCapturedBackground,
    required this.cameraControlButtonIcon,
    required this.cameraBottomActionsBackgroundColor,
    required this.cameraThemeBackgroundColor,
    required this.cameraThemeForegroundColor,
    required this.cameraCircleButtonIcon,
    required this.cameraCircleButtonBackgroundColor,
    required this.cameraCircleButtonBorder,
    required this.cameraCircleButtonShadow,
    required this.cameraScanFrameTitleText,
    required this.cameraScanFrameBorder,
    required this.cameraScanDecorationShadow,
    required this.cameraScanDecorationText,
    required this.cameraScanFrameBackground,
    required this.cameraScanDecorationBackground,
    required this.cameraGalleryButtonBackgroundColor,
    required this.cameraGalleryButtonBorder,
    required this.cameraGalleryButtonIcon,
    required this.cameraAnalyzeBackground,
    required this.cameraAnalyzeTitleText,
    required this.cameraAnalyzeText,
    required this.cameraAnalyzeProgressBackground,
    required this.cameraAnalyzeProgressBar,
    required this.cameraAnalyzeBackgroundShadow,
    required this.cameraAnalyzeLogoIcon,
    required this.cameraAnalyzeLogoIconShadow,
    required this.cameraAnalyzeEffect,
    required this.skinAnalysisYearText,
    required this.buttonText,
    required this.symptomChipColor,
    required this.bodyPartChipColor,
    required this.riskFactorChipColor,
    required this.treatmentChipColor,
    required this.preventionChipColor,
    required this.alternativeTreatmentChipColor,
    required this.severityIndicatorColor1,
    required this.severityIndicatorColor2,
    required this.severityIndicatorColor3,
    required this.severityIndicatorColor4,
    required this.splashTextColor,
    required this.splashTextShadowColor,
    required this.onboardingBackground,
    required this.onboardingPageIndicatorActive,
    required this.onboardingPageIndicatorInactive,
    required this.onboardingButtonText,
    required this.onboardingButtonBackground,
    required this.onboardingButtonShadow,
    required this.onboardingSkipTextColor,
    required this.onboardingDescTextColor,
    required this.onboardingTitleTextColor,
    required this.onboardingImageBackground,
    required this.onboardingImageShadow,
    required this.onboardingImageIcon,
    required this.black,
    required this.orange,
    required this.red,
    required this.cardBackground,
    required this.borderColor,
  });
}

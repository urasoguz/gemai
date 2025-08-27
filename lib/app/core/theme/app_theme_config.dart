import 'package:flutter/material.dart';

/// Tüm tema ayarlarını merkezi olarak yöneten dosya
/// Sadece bu dosyayı değiştirerek yeni bir uygulama oluşturabilirsiniz
class AppThemeConfig {
  static const String appName = 'GEMAI';
  static const String fontFamily = 'Roboto'; // Varsayılan font

  // ===== ANA RENKLER =====
  static const Color primary = Color(0xFF134E5E); // Koyu yeşil-mavi
  static const Color secondary = Color(0xFF71B280); // Açık yeşil
  static const Color transparent = Color(0x00000000); // Transparan

  // ===== ARKA PLAN RENKLERİ =====
  static const Color background = Color(0xFFF9F9F9); // Ana arka plan
  static const Color surface = Color(0xFFFFFFFF); // Beyaz yüzey
  static const Color card = Color(0xFFFFFFFF); // Beyaz kart rengi

  // ===== METİN RENKLERİ =====
  static const Color textPrimary = Color(0xFF222222); // Ana metin rengi
  static const Color textSecondary = Color(0xFF757575); // İkincil metin rengi
  static const Color textTertiary = Color(0xFF222222); // Üçüncü metin rengi
  static const Color textHint = Color(0xFFBDBDBD); // İpucu metin rengi
  static const Color textLink = Color(0xFFD4A574); // Link metin rengi

  // ===== UI ELEMENT RENKLERİ =====
  static const Color appBar = Color(0xFFFFFFFF); // AppBar rengi
  static const Color bottomNav = Color(0xFFFFFFFF); // Alt navigasyon rengi
  static const Color divider = Color(0xFFE0E0E0); // Ayırıcı çizgi rengi

  // ===== DURUM RENKLERİ =====
  static const Color success = Color(0xFF4CAF50); // Başarı rengi
  static const Color warning = Color(0xFFFFC700); // Uyarı rengi
  static const Color error = Color(0xFFF44336); // Hata rengi
  static const Color info = Color(0xFF2196F3); // Bilgi rengi

  // ===== GRADIENT RENKLERİ =====
  static const Color gradientPrimary = Color(0xFFE6D7B8);
  static const Color gradientSecondary = Color(0xFFD4A574);

  // static const Color gradientPrimary = Color(0xFFF5D58A);
  // static const Color gradientSecondary = Color(0xFFD8A64E);

  // ===== BUTTON RENKLERİ =====
  static const Color buttonIcon = Color(0xFFFFFFFF);
  static const Color buttonBorder = Color(0xFFFFFFFF);
  static const Color buttonShadow = Colors.black;
  static const Color buttonText = Color(0xFFFFFFFF);
  static const Color buttonBackground = Colors.black;

  // ===== ANALYZE BUTTON =====
  static const Color analyzeButton = Color(0xFFFFFFFF);
  static const Color analyzeButtonIcon = Color(0xFF134E5E);

  // ===== KAMERA RENKLERİ =====
  static const Color cameraScaffold = Color(0xFF000000);
  static const Color cameraCapturedBackground = Color(0xFF000000);
  static const Color cameraControlButtonIcon = Color(0xFFFFFFFF);
  static const Color cameraBottomActionsBackgroundColor = Color(0xFF000000);
  static const Color cameraThemeBackgroundColor = Color(0xFFFFFFFF);
  static const Color cameraThemeForegroundColor = Color(0xFFFFFFFF);
  static const Color cameraCircleButtonIcon = Color(0xFFFFFFFF);
  static const Color cameraCircleButtonBackgroundColor = Color(0xFFFFFFFF);
  static const Color cameraCircleButtonBorder = Color(0xFFFFFFFF);
  static const Color cameraCircleButtonShadow = Color(0xFF000000);
  static const Color cameraScanFrameBackground = Color(0xFF000000);
  static const Color cameraScanFrameTitleText = Color(0xFFFFFFFF);
  static const Color cameraScanFrameBorder = Color(0xFF71B280);
  static const Color cameraScanFrameColor = Color(
    0xFFFFD700,
  ); // Sarı çerçeve rengi
  static const Color cameraScanDecorationBackground = Color(0xFFFFFFFF);
  static const Color cameraScanDecorationShadow = Color(0xFF000000);
  static const Color cameraScanDecorationText = Color(0xFF000000);
  static const Color cameraGalleryButtonBackgroundColor = Color(0xFFFFFFFF);
  static const Color cameraGalleryButtonBorder = Color(0xFFFFFFFF);
  static const Color cameraGalleryButtonIcon = Color(0xFFFFFFFF);
  static const Color cameraAnalyzeBackground = Color(0xFF000000);
  static const Color cameraAnalyzeBackgroundShadow = Color(0xFF000000);
  static const Color cameraAnalyzeTitleText = Color(0xFFFFFFFF);
  static const Color cameraAnalyzeText = Color(0xFFC7C7C7);
  static const Color cameraAnalyzeProgressBackground = Color(0xFFFFFFFF);
  static const Color cameraAnalyzeProgressBar = Color(0xFF71B280);
  static const Color cameraAnalyzeLogoIcon = Color(0xFFFFFFFF);
  static const Color cameraAnalyzeLogoIconShadow = Color(0xFF71B280);
  static const Color cameraAnalyzeEffect = Color(0xFF71B280);

  // ===== PAYWALL RENKLERİ =====
  static const Color paywallCloseIcon = Color.fromARGB(255, 228, 228, 228);
  static const Color paywallCardBorder = Color(0xFFE0E0E0);
  static const Color paywallCardBorderCheck = Color(0xFF000000);
  static const Color paywallCardCheck = Color(0xFFBDBDBD);

  // ===== SKIN ANALYSIS RENKLERİ =====
  static const Color skinAnalysisYearText = Color(0xFF134E5E);
  static const Color symptomChipColor = Color(0xFFD32F2F);
  static const Color bodyPartChipColor = Color(0xFFFF9800);
  static const Color riskFactorChipColor = Color(0xFF7B1FA2);
  static const Color treatmentChipColor = Color(0xFF009688);
  static const Color preventionChipColor = Color(0xFF388E3C);
  static const Color alternativeTreatmentChipColor = Color(0xFF43A047);

  // ===== SONUÇ RENKLERİ =====
  static const Color severityIndicatorColor1 = Color(0xFF4CAF50);
  static const Color severityIndicatorColor2 = Color(0xFFFFC107);
  static const Color severityIndicatorColor3 = Color(0xFFFF9800);
  static const Color severityIndicatorColor4 = Color(0xFFE53935);

  // ===== SPLASH RENKLERİ =====
  static const Color splashTextColor = Color(0xFFFFFFFF);
  static const Color splashTextShadowColor = Color(0xFF000000);

  // ===== ONBOARDING RENKLERİ =====
  static const Color onboardingBackground = Color(0xFFFFFFFF);
  static const Color onboardingPageIndicatorActive = Color(0xFF000000);
  static const Color onboardingPageIndicatorInactive = Color(0xFF757575);
  static const Color onboardingButtonText = Color(0xFFFFFFFF);
  static const Color onboardingButtonBackground = Color(0xFF000000);
  static const Color onboardingButtonShadow = Color(0xFF000000);
  static const Color onboardingSkipTextColor = Color(0xFF000000);
  static const Color onboardingDescTextColor = Colors.black54;
  static const Color onboardingTitleTextColor = Color(0xFF2D2D2D);
  static const Color onboardingImageBackground = Color(0xFFFFFFFF);
  static const Color onboardingImageShadow = Color(0xFF000000);
  static const Color onboardingImageIcon = Color(0xFF000000);

  // ===== GENEL RENKLER =====
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color borderColor = Color(0xFFE0E0E0);
  static const Color black = Colors.black;
  static const Color white = Color(0xFFFFFFFF);
  static const Color orange = Color(0xFFFF9800);
  static const Color red = Color(0xFFF44336);

  // ===== TEMA AYARLARI =====
  static const double borderRadius = 16.0;
  static const double cardElevation = 0.0;
  static const Duration animationDuration = Duration(milliseconds: 300);
}

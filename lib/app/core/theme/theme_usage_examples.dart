import 'package:flutter/material.dart';
import 'package:dermai/app/core/theme/app_theme_config.dart';

/// TEMA KULLANIM ÖRNEKLERİ
/// Bu dosya, tema sisteminin nasıl kullanılacağını gösterir
///
/// İÇİNDEKİLER:
/// 1. Renk Kullanım Örnekleri
/// 2. Font Kullanım Örnekleri
/// 3. Widget Örnekleri
/// 4. Yeni Uygulama Oluşturma Rehberi
/// 5. Modüler Yapı İçin Gerekli Bileşenler

// =============================================================================
// 1. RENK KULLANIM ÖRNEKLERİ
// =============================================================================

class ColorUsageExamples {
  /// Ana renkler
  static Color getPrimaryColor(BuildContext context) {
    return Theme.of(context).primaryColor;
  }

  /// Arka plan renkleri
  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  /// Kart rengi
  static Color getCardColor(BuildContext context) {
    return Theme.of(context).cardColor;
  }

  /// Metin renkleri
  static Color getTextPrimaryColor(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
  }

  /// AppBar rengi
  static Color getAppBarColor(BuildContext context) {
    return Theme.of(context).appBarTheme.backgroundColor ?? Colors.blue;
  }

  /// Divider rengi
  static Color getDividerColor(BuildContext context) {
    return Theme.of(context).dividerColor;
  }
}

// =============================================================================
// 2. FONT KULLANIM ÖRNEKLERİ
// =============================================================================

class FontUsageExamples {
  /// Başlık fontları
  static TextStyle getDisplayLarge(BuildContext context) {
    return Theme.of(context).textTheme.displayLarge ??
        TextStyle(fontSize: 32, fontWeight: FontWeight.bold);
  }

  static TextStyle getHeadlineLarge(BuildContext context) {
    return Theme.of(context).textTheme.headlineLarge ??
        TextStyle(fontSize: 22, fontWeight: FontWeight.w600);
  }

  /// Vücut metni fontları
  static TextStyle getBodyLarge(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge ?? TextStyle(fontSize: 16);
  }

  static TextStyle getBodyMedium(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium ?? TextStyle(fontSize: 14);
  }

  /// Etiket fontları
  static TextStyle getLabelLarge(BuildContext context) {
    return Theme.of(context).textTheme.labelLarge ??
        TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
  }

  /// Özel font ailesi
  static String getFontFamily() {
    return AppThemeConfig.fontFamily;
  }
}

// =============================================================================
// 3. WIDGET ÖRNEKLERİ
// =============================================================================

/// Temalı Container örneği
class ThemedContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const ThemedContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppThemeConfig.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Temalı Button örneği
class ThemedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const ThemedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeConfig.borderRadius),
        ),
        textStyle: TextStyle(
          fontFamily: AppThemeConfig.fontFamily,
          fontWeight: FontWeight.w600,
        ),
      ),
      child:
          isLoading
              ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
              : Text(text),
    );
  }
}

/// Temalı Text örneği
class ThemedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ThemedText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ?? Theme.of(context).textTheme.bodyMedium,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Temalı Card örneği
class ThemedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const ThemedCard({super.key, required this.child, this.padding, this.margin});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin ?? const EdgeInsets.all(8),
      elevation: AppThemeConfig.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeConfig.borderRadius),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

/// Temalı AppBar örneği
class ThemedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;

  const ThemedAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: Theme.of(context).appBarTheme.titleTextStyle),
      centerTitle: centerTitle,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      elevation: Theme.of(context).appBarTheme.elevation,
      actions: actions,
      leading: leading,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// =============================================================================
// 4. SAYFA ÖRNEKLERİ
// =============================================================================

/// Temalı sayfa örneği
class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemedAppBar(
        title: 'Örnek Sayfa',
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlık
            ThemedText(
              'Hoş Geldiniz!',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),

            // Açıklama
            ThemedText(
              'Bu bir örnek sayfadır. Tema sistemi kullanılarak oluşturulmuştur.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),

            // Kart örneği
            ThemedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ThemedText(
                    'Kart Başlığı',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  ThemedText(
                    'Bu bir kart içeriğidir. Tema renkleri otomatik olarak uygulanır.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Buton örneği
            ThemedButton(
              text: 'Devam Et',
              onPressed: () {
                // İşlem
              },
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 5. YENİ UYGULAMA OLUŞTURMA REHBERİ
// =============================================================================

/*
YENİ UYGULAMA OLUŞTURMAK İÇİN:

1. PROJEYİ KOPYALAYIN
   - Mevcut projeyi yeni bir klasöre kopyalayın
   - pubspec.yaml'daki package adını değiştirin

2. TEMA AYARLARINI DEĞİŞTİRİN (app_theme_config.dart)
   - AppThemeConfig.appName = 'Yeni Uygulama Adı'
   - AppThemeConfig.fontFamily = 'Yeni Font'
   - lightColors ve darkColors renklerini değiştirin
   - borderRadius, cardElevation gibi ayarları değiştirin

3. UYGULAMA BİLGİLERİNİ GÜNCELLEYİN
   - pubspec.yaml: name, description, version
   - android/app/build.gradle: applicationId
   - ios/Runner/Info.plist: CFBundleDisplayName
   - assets/icon/app_icon.png (yeni ikon)

4. GEREKSİZ DOSYALARI SİLİN
   - Kullanılmayan modülleri kaldırın
   - Gereksiz assetleri temizleyin

5. TEST EDİN
   - Light ve dark mode'da test edin
   - Farklı ekran boyutlarında test edin
*/

// =============================================================================
// 6. MODÜLER YAPI İÇİN GEREKLİ BİLEŞENLER
// =============================================================================

/*
MODÜLER KEMİK UYGULAMA İÇİN GEREKLİ BİLEŞENLER:

1. TEMA SİSTEMİ ✅
   - Merkezi tema yönetimi
   - Dark/Light mode desteği
   - Kolay özelleştirme

2. ROUTING SİSTEMİ ✅
   - GetX routing
   - Modüler sayfa yapısı
   - Route parametreleri

3. STATE MANAGEMENT ✅
   - GetX controllers
   - Reactive programming
   - Dependency injection

4. API SİSTEMİ ✅
   - Merkezi API client
   - Interceptor'lar
   - Error handling

5. LOCALIZATION ✅
   - Çoklu dil desteği
   - Kolay dil ekleme

6. STORAGE SİSTEMİ ✅
   - GetStorage
   - Sembast database
   - Secure storage

7. UTILITY SINIFLARI
   - UI helper'lar
   - Validation helper'lar
   - Date/time helper'lar

8. CONSTANT SINIFLARI
   - API endpoints
   - App constants
   - Error messages

9. WIDGET KÜTÜPHANESİ
   - Ortak widget'lar
   - Custom widget'lar
   - Loading states

10. ERROR HANDLING
    - Global error handling
    - Try-catch blokları
    - User-friendly messages

11. TESTING
    - Unit tests
    - Widget tests
    - Integration tests

12. DOCUMENTATION
    - README dosyaları
    - API documentation
    - Code comments
*/

// =============================================================================
// 7. RENK TANIMLAMA REHBERİ
// =============================================================================

/*
RENK TANIMLAMA YÖNTEMLERİ:

1. HEX RENK KODLARI
   Color(0xFFE91E63)  // FF = Alpha, E91E63 = RGB
   
2. RGB RENK KODLARI
   Color.fromRGBO(233, 30, 99, 1.0)  // R, G, B, Alpha
   
3. HSL RENK KODLARI
   HSLColor.fromAHSL(1.0, 340, 0.81, 0.52).toColor()
   
4. MATERIAL DESIGN RENKLERİ
   Colors.red, Colors.blue, Colors.green
   
5. CUSTOM RENK PALETLERİ
   - Primary: Ana marka rengi
   - Secondary: İkincil marka rengi
   - Background: Arka plan rengi
   - Surface: Yüzey rengi
   - Card: Kart rengi
   - Text: Metin renkleri
   - Status: Durum renkleri (success, warning, error)

RENK SEÇİMİ İPUÇLARI:
- Light mode için açık arka planlar
- Dark mode için koyu arka planlar
- Yeterli kontrast oranı (WCAG standartları)
- Marka kimliğine uygun renkler
- Accessibility için renk körlüğü dostu paletler
*/

// =============================================================================
// 8. FONT TANIMLAMA REHBERİ
// =============================================================================

/*
FONT TANIMLAMA:

1. GOOGLE FONTS
   - pubspec.yaml'a ekleyin
   - fontFamily: 'Roboto'

2. CUSTOM FONTS
   - assets/fonts/ klasörüne ekleyin
   - pubspec.yaml'da tanımlayın
   - fontFamily: 'CustomFont'

3. FONT WEIGHT'LER
   - FontWeight.w100 (Thin)
   - FontWeight.w300 (Light)
   - FontWeight.w400 (Regular)
   - FontWeight.w500 (Medium)
   - FontWeight.w600 (SemiBold)
   - FontWeight.w700 (Bold)
   - FontWeight.w900 (Black)

4. FONT SİZE'LAR
   - displayLarge: 32px
   - displayMedium: 28px
   - displaySmall: 24px
   - headlineLarge: 22px
   - headlineMedium: 20px
   - headlineSmall: 18px
   - titleLarge: 16px
   - titleMedium: 14px
   - titleSmall: 12px
   - bodyLarge: 16px
   - bodyMedium: 14px
   - bodySmall: 12px
   - labelLarge: 14px
   - labelMedium: 12px
   - labelSmall: 10px
*/

// =============================================================================
// 9. PERFORMANS İPUÇLARI
// =============================================================================

/*
PERFORMANS İPUÇLARI:

1. TEMA KULLANIMI
   - Theme.of(context) yerine Theme.of(context, listen: false) kullanın
   - Sabit değerler için const kullanın
   - Gereksiz rebuild'leri önleyin

2. WIDGET OPTIMIZATION
   - const constructor'ları kullanın
   - ListView.builder kullanın
   - Gereksiz widget'ları kaldırın

3. MEMORY MANAGEMENT
   - Controller'ları dispose edin
   - Stream subscription'ları iptal edin
   - Image cache'i yönetin

4. BUILD OPTIMIZATION
   - Debug mode'da hot reload kullanın
   - Release mode'da test edin
   - Performance overlay kullanın
*/

// =============================================================================
// 10. DEBUGGING İPUÇLARI
// =============================================================================

/*
DEBUGGING İPUÇLARI:

1. TEMA DEBUGGING
   - Theme.of(context) değerlerini kontrol edin
   - Color değerlerini debug edin
   - Font yükleme durumunu kontrol edin

2. PERFORMANCE DEBUGGING
   - Flutter Inspector kullanın
   - Performance overlay açın
   - Memory leak'leri kontrol edin

3. ERROR HANDLING
   - Try-catch blokları ekleyin
   - Error log'ları tutun
   - User-friendly error mesajları gösterin

4. TESTING
   - Unit testler yazın
   - Widget testler yazın
   - Integration testler yazın
*/

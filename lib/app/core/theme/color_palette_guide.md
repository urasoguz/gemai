# RENK PALETİ TANIMLAMA REHBERİ

## 1. RENK TANIMLAMA YÖNTEMLERİ

### Hex Renk Kodları
```dart
// Format: Color(0xFFRRGGBB)
// FF = Alpha (opaklık), RR = Kırmızı, GG = Yeşil, BB = Mavi
Color(0xFFE91E63)  // Pembe
Color(0xFF2196F3)  // Mavi
Color(0xFF4CAF50)  // Yeşil
Color(0xFFFF9800)  // Turuncu
Color(0xFF9C27B0)  // Mor
Color(0xFF607D8B)  // Gri-Mavi
```

### RGB Renk Kodları
```dart
// Format: Color.fromRGBO(R, G, B, Alpha)
// R, G, B: 0-255 arası, Alpha: 0.0-1.0 arası
Color.fromRGBO(233, 30, 99, 1.0)   // Pembe
Color.fromRGBO(33, 150, 243, 1.0)  // Mavi
Color.fromRGBO(76, 175, 80, 1.0)   // Yeşil
Color.fromRGBO(255, 152, 0, 1.0)   // Turuncu
```

### Material Design Renkleri
```dart
Colors.red[500]      // Kırmızı
Colors.blue[500]     // Mavi
Colors.green[500]    // Yeşil
Colors.orange[500]   // Turuncu
Colors.purple[500]   // Mor
Colors.grey[500]     // Gri
```

## 2. RENK PALETİ YAPISI

### Light Mode Renk Paleti
```dart
static const ColorPalette lightColors = ColorPalette(
  // Ana Renkler
  primary: Color(0xFFE91E63),      // Ana marka rengi
  secondary: Color(0xFF9C27B0),    // İkincil marka rengi
  
  // Arka Plan Renkleri
  background: Color(0xFFFAFAFA),   // Ana arka plan
  surface: Color(0xFFFFFFFF),      // Yüzey rengi
  card: Color(0xFFFFFFFF),         // Kart rengi
  
  // Metin Renkleri
  textPrimary: Color(0xFF212121),  // Ana metin rengi
  textSecondary: Color(0xFF757575), // İkincil metin rengi
  textHint: Color(0xFFBDBDBD),     // İpucu metin rengi
  
  // UI Element Renkleri
  appBar: Color(0xFFE91E63),       // AppBar rengi
  bottomNav: Color(0xFFFFFFFF),    // Alt navigasyon rengi
  divider: Color(0xFFE0E0E0),      // Ayırıcı çizgi rengi
  
  // Durum Renkleri
  success: Color(0xFF4CAF50),      // Başarı rengi
  warning: Color(0xFFFF9800),      // Uyarı rengi
  error: Color(0xFFF44336),        // Hata rengi
  info: Color(0xFF2196F3),         // Bilgi rengi
);
```

### Dark Mode Renk Paleti
```dart
static const ColorPalette darkColors = ColorPalette(
  // Ana Renkler
  primary: Color(0xFFB00063),      // Koyu pembe
  secondary: Color(0xFF6A0080),    // Koyu mor
  
  // Arka Plan Renkleri
  background: Color(0xFF181A20),   // Koyu arka plan
  surface: Color(0xFF23242B),      // Koyu yüzey
  card: Color(0xFF23242B),         // Koyu kart
  
  // Metin Renkleri
  textPrimary: Color(0xFFFFFFFF),  // Beyaz metin
  textSecondary: Color(0xFFBDBDBD), // Açık gri metin
  textHint: Color(0xFF757575),     // Orta gri metin
  
  // UI Element Renkleri
  appBar: Color(0xFFB00063),       // Koyu AppBar
  bottomNav: Color(0xFF23242B),    // Koyu alt navigasyon
  divider: Color(0xFF31313A),      // Koyu ayırıcı
  
  // Durum Renkleri (aynı kalabilir)
  success: Color(0xFF4CAF50),
  warning: Color(0xFFFF9800),
  error: Color(0xFFF44336),
  info: Color(0xFF2196F3),
);
```

## 3. RENK SEÇİM İPUÇLARI

### Marka Kimliği
- **Primary Color**: Uygulamanızın ana rengi, marka kimliğinizi yansıtmalı
- **Secondary Color**: Primary ile uyumlu, tamamlayıcı renk
- **Accent Color**: Vurgu için kullanılan renk

### Accessibility (Erişilebilirlik)
- **Kontrast Oranı**: En az 4.5:1 oranında olmalı
- **Renk Körlüğü**: Sadece renkle bilgi vermeyin, ikon veya metin de ekleyin
- **WCAG Standartları**: Web Content Accessibility Guidelines'a uyun

### Light vs Dark Mode
- **Light Mode**: Açık arka plan, koyu metin
- **Dark Mode**: Koyu arka plan, açık metin
- **Aynı Renkler**: Durum renkleri (success, warning, error) genelde aynı kalır

## 4. POPÜLER RENK PALETLERİ

### Sağlık Uygulamaları
```dart
// DermAI - Pembe/Mor
primary: Color(0xFFE91E63)
secondary: Color(0xFF9C27B0)

// Genel Sağlık - Yeşil
primary: Color(0xFF4CAF50)
secondary: Color(0xFF8BC34A)

// Hastane - Mavi
primary: Color(0xFF2196F3)
secondary: Color(0xFF03A9F4)
```

### Finans Uygulamaları
```dart
// Para Analizi - Yeşil
primary: Color(0xFF4CAF50)
secondary: Color(0xFF66BB6A)

// Banka - Mavi
primary: Color(0xFF1976D2)
secondary: Color(0xFF42A5F5)

// Kripto - Turuncu
primary: Color(0xFFFF9800)
secondary: Color(0xFFFFB74D)
```

### Eğitim Uygulamaları
```dart
// Çiçek Analizi - Mor
primary: Color(0xFF9C27B0)
secondary: Color(0xFFBA68C8)

// Genel Eğitim - Mavi
primary: Color(0xFF2196F3)
secondary: Color(0xFF64B5F6)

// Çocuk - Turuncu
primary: Color(0xFFFF9800)
secondary: Color(0xFFFFCC02)
```

## 5. RENK ARAÇLARI

### Online Renk Araçları
- **Adobe Color**: https://color.adobe.com
- **Coolors**: https://coolors.co
- **Paletton**: https://paletton.com
- **Material Design Color Tool**: https://material.io/design/color

### Flutter Renk Araçları
- **Flutter Inspector**: Renkleri canlı olarak değiştirme
- **DevTools**: Performance ve renk analizi
- **VS Code Extensions**: Color picker ve preview

## 6. RENK KODLAMA STANDARTLARI

### Dosya Organizasyonu
```dart
// app_theme_config.dart
class AppThemeConfig {
  // Uygulama bilgileri
  static const String appName = 'Uygulama Adı';
  static const String fontFamily = 'Font Adı';
  
  // Light renk paleti
  static const ColorPalette lightColors = ColorPalette(...);
  
  // Dark renk paleti
  static const ColorPalette darkColors = ColorPalette(...);
  
  // Tema ayarları
  static const double borderRadius = 12.0;
  static const double cardElevation = 4.0;
  static const Duration animationDuration = Duration(milliseconds: 300);
}
```

### Kullanım Örnekleri
```dart
// Widget'larda renk kullanımı
Container(
  color: Theme.of(context).primaryColor,
  child: Text(
    'Metin',
    style: TextStyle(
      color: Theme.of(context).textTheme.bodyLarge?.color,
    ),
  ),
)

// Özel renk kullanımı
Container(
  color: AppThemeConfig.lightColors.success,
  child: Text('Başarı'),
)
```

## 7. RENK TESTİ

### Kontrast Testi
```dart
// Renk kontrastını test etmek için
double getContrastRatio(Color color1, Color color2) {
  // WCAG kontrast hesaplama formülü
  // 4.5:1 minimum oran önerilir
}
```

### Renk Körlüğü Testi
- **Protanopia**: Kırmızı-yeşil renk körlüğü
- **Deuteranopia**: Yeşil-kırmızı renk körlüğü
- **Tritanopia**: Mavi-sarı renk körlüğü

### Test Araçları
- **Color Oracle**: Renk körlüğü simülasyonu
- **WebAIM Contrast Checker**: Online kontrast testi
- **Flutter Inspector**: Canlı renk değiştirme

## 8. PERFORMANS İPUÇLARI

### Renk Optimizasyonu
```dart
// const kullanarak performansı artırın
const Color primaryColor = Color(0xFFE91E63);

// Theme.of(context, listen: false) kullanın
final color = Theme.of(context, listen: false).primaryColor;

// Renk hesaplamalarını önbelleğe alın
class ColorCache {
  static final Map<String, Color> _cache = {};
  
  static Color getColor(String key) {
    return _cache.putIfAbsent(key, () => _calculateColor(key));
  }
}
```

### Memory Management
- Gereksiz renk hesaplamalarından kaçının
- Renk değerlerini const olarak tanımlayın
- Theme değişikliklerini optimize edin

## 9. YENİ UYGULAMA İÇİN RENK SEÇİMİ

### Adım 1: Marka Analizi
- Uygulamanızın amacı nedir?
- Hedef kitle kimdir?
- Hangi duyguları uyandırmak istiyorsunuz?

### Adım 2: Renk Araştırması
- Rakiplerinizin renkleri
- Sektör standartları
- Kültürel renk anlamları

### Adım 3: Renk Paleti Oluşturma
- Primary color seçimi
- Secondary color seçimi
- Supporting colors seçimi

### Adım 4: Test ve İyileştirme
- Light/Dark mode testi
- Accessibility testi
- Kullanıcı geri bildirimi

### Adım 5: Dokümantasyon
- Renk kodlarını kaydedin
- Kullanım kurallarını belirleyin
- Style guide oluşturun 
# GemAI Flutter Projesi Dokümantasyonu

## Proje Genel Bilgileri
- **Proje Adı**: GemAI
- **Framework**: Flutter
- **State Management**: GetX
- **Mimari**: MVC (Model-View-Controller)
- **Dil**: Dart

## Yapılan Görevler

### 1. Eski Paywall Tasarımı Scroll ve Footer Sorunları Düzeltildi
**Tarih**: 2024-12-19
**Dosya**: `lib/app/modules/premium/widgets/old_paywall_view.dart`

#### Sorun
- Eski paywall tasarımında ekran içeriği scroll edilemiyordu
- Footer alt tarafta kalıyordu ve erişilemiyordu
- `ConstrainedBox` ile minimum yükseklik ayarlanması scroll sorunlarına neden oluyordu

#### Çözüm
1. **Layout Yapısı Değişikliği**:
   - `ConstrainedBox` kaldırıldı
   - `Scaffold` eklendi (backgroundColor: Colors.transparent)
   - `SingleChildScrollView` korundu ama daha iyi yapılandırıldı

2. **Scroll Yapısı**:
   - `Container` ile `constraints` daha esnek hale getirildi
   - `minHeight: screenHeight - statusBarHeight` ile minimum yükseklik ayarlandı
   - `mainAxisAlignment: MainAxisAlignment.spaceBetween` kaldırıldı

3. **Footer İyileştirmeleri**:
   - Footer linkleri `Expanded` ile eşit genişlikte yapıldı
   - Bottom padding desteği eklendi (iPhone'lardaki home indicator için)
   - Responsive tasarım iyileştirildi

4. **Responsive Tasarım**:
   - `MediaQuery` ile ekran boyutları alındı
   - Status bar ve bottom padding hesaplamaları eklendi
   - Küçük ekranlar için optimize edildi

5. **Paketler ile Button Arası Boşluk**:
   - Paketler listesinden sonra 24px ek boşluk eklendi
   - PremiumPlanCard widget'ındaki margin ile uyumlu hale getirildi
   - Daha iyi görsel hiyerarşi sağlandı

#### Teknik Detaylar
- `Scaffold` ile daha iyi layout yönetimi
- `Container` constraints ile esnek yükseklik ayarı
- `Expanded` ile footer linklerinin eşit genişlikte olması
- Bottom padding hesaplaması ile iPhone uyumluluğu

#### Sonuç
- Eski paywall içeriği artık düzgün scroll edilebiliyor
- Footer her zaman görünür ve erişilebilir
- Responsive tasarım iyileştirildi
- iPhone'lardaki home indicator ile uyumlu
- Daha iyi kullanıcı deneyimi

### 2. Paywall Tasarımı Scroll ve Footer Sorunları Düzeltildi
**Tarih**: 2024-12-19
**Dosya**: `lib/app/modules/premium/widgets/new_paywall_view.dart` ve `lib/app/modules/premium/widgets/new_paywall_footer.dart`

#### Sorun
- Yeni paywall tasarımında ekran içeriği scroll edilemiyordu
- Footer alt tarafta kalıyordu ve erişilemiyordu
- Responsive tasarım eksikti

#### Çözüm
1. **Ana View Düzenlemesi**:
   - Alt panel yüksekliği %50'den %60'a çıkarıldı
   - Minimum yükseklik %40 olarak ayarlandı
   - İçerik ve footer ayrıldı

2. **Scroll Yapısı**:
   - İçerik kısmı `Expanded` ve `SingleChildScrollView` ile sarıldı
   - Footer her zaman görünür ve scroll edilemez yapıldı
   - Bottom padding desteği eklendi

3. **Footer İyileştirmeleri**:
   - `mainAxisSize: MainAxisSize.min` eklendi
   - Responsive padding ayarlandı
   - Footer linkleri `Expanded` ile eşit genişlikte yapıldı

4. **Bottom Sheet İyileştirmeleri**:
   - Paketler listesi `Flexible` ve `SingleChildScrollView` ile sarıldı
   - Footer linkleri `Expanded` ile düzenlendi
   - Daha iyi responsive tasarım sağlandı

#### Teknik Detaylar
- `ConstrainedBox` ile yükseklik sınırları belirlendi
- `Column` ve `Expanded` kullanılarak layout düzenlendi
- `SingleChildScrollView` ile scroll desteği eklendi
- `MediaQuery` ile ekran boyutları alındı

#### Sonuç
- Paywall içeriği artık düzgün scroll edilebiliyor
- Footer her zaman görünür ve erişilebilir
- Responsive tasarım iyileştirildi
- Eski paywall tasarımı ile uyumlu hale getirildi

## Proje Gereksinimleri

### GetX Flutter Development Rules
- İngilizce kod ve dokümantasyon
- Tüm değişken ve fonksiyonlarda tip belirtimi
- PascalCase sınıf isimleri
- camelCase değişken ve fonksiyon isimleri
- snake_case dosya ve dizin isimleri
- Controller isimleri "Controller" ile bitmeli

### Kod Stil Kuralları
- Her fonksiyon, sınıf, değişken ve karmaşık mantık için Türkçe yorumlar
- Paket import'ları kullan (relative path yerine)
- Kısa ve odaklanmış fonksiyonlar (20 satırdan az)
- Erken return ile derin iç içe geçmeyi önle

### Mimari Kuralları
- Her modül için: controller, view, widgets klasörleri
- Tek sorumluluk prensibi
- GetX controller'ları için proper disposal
- Service katmanı için business logic

## Modül Yapısı
```
lib/app/modules/
├── auth/           # Kimlik doğrulama
├── camera/         # Kamera işlemleri
├── gem_result/     # Taş analiz sonuçları
├── history/        # Geçmiş kayıtları
├── home/           # Ana sayfa
├── legal_warning/  # Yasal uyarılar
├── onboarding/     # İlk kullanım
├── pages/          # Sayfa yönetimi
├── premium/        # Premium özellikler
├── result/         # Sonuç sayfaları
├── settings/       # Ayarlar
└── skin_analysis/  # Cilt analizi
```

## Servisler
- API Service (GetConnect tabanlı)
- Storage Service (GetStorage)
- App Settings Service
- Date Formatting Service

## Tema ve UI
- AppThemeConfig ile merkezi tema yönetimi
- Responsive tasarım desteği
- Dark/Light mode desteği
- Tutarlı renk paleti

## Test Stratejisi
- Controller'lar için unit testler
- Mock servisler ile bağımlılık testleri
- Error scenario testleri
- Reactive variable testleri

## Güvenlik
- API güvenliği (token yönetimi)
- Local storage encryption
- Input validation
- Secure storage kullanımı

## Performans Optimizasyonu
- GetBuilder kullanımı (sık rebuild gereken widget'lar için)
- Lazy loading controller'lar
- Proper disposal
- Image caching
- ListView.builder kullanımı

## Notlar
- Tüm yorumlar Türkçe yazılmalı
- Kod kalitesi ve okunabilirlik öncelikli
- GetX best practices takip edilmeli
- Responsive tasarım her zaman düşünülmeli

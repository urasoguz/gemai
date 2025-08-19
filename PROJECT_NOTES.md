# gemAI – Project Log

Bu dosya, proje boyunca yapılan değişikliklerin ve alınan kararların kısa notlarını içerir.

## 2025-08-18
- Proje hedefi güncellendi: Dermai (cilt analizi) altyapısından fork edilerek gemAI (değerli taş ve maden tanımlayıcı) uygulamasına dönüştürülecek.
- İsimlendirme ve paket importları: `package:dermai` → `package:gemai` dönüşümü başlatıldı.
- Git başlangıç adımları için `.gitignore` eklendi ve standart Flutter/IDE kalıpları ignore edildi.

## Yapılacaklar (Backlog)
- Paket adı ve iOS/Android bundle id güncellemesi
- App icon ve splash görsellerinin gemAI için yenilenmesi
- UI teması ve bileşenlerinin gemAI tasarımına uyarlanması
- Kalan `package:dermai` importlarının tamamının `package:gemai` ile güncellenmesi
- Modüllerin gereksiz kısımlarının kaldırılması ve yeni özelliklerin eklenmesi

## Tamamlananlar
- Legal warning kontrolü devre dışı bırakıldı (onboarding ve splash controller'larda)
- Legal warning modülü korundu ama kullanımı kapatıldı
- Dark/light tema sistemi kaldırıldı, tek tema (light) kullanılıyor
- AppThemeConfig.appName 'DERMAI' → 'GEMAI' olarak güncellendi
- Tema servisi basitleştirildi, tema değiştirme devre dışı bırakıldı
- 181 dosyada lightColors/darkColors referansları AppThemeConfig.colors ile değiştirildi
- Tema sistemi tamamen tek tema olarak yeniden yapılandırıldı
- ColorPalette sınıfı kaldırıldı, tüm renkler AppThemeConfig sınıfında static const olarak tanımlandı
- 54 dosyada AppThemeConfig.colors referansları AppThemeConfig.primary ile değiştirildi (manuel düzenleme gerekli)
- Tüm package:dermai import'ları package:gemai olarak güncellendi
- 82 dosyada toplam 853 ekleme, 1106 silme işlemi yapıldı
- Flutter analyze'da sadece 12 uyarı kaldı (kritik hata yok)

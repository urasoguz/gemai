# 📱 gemai Yayın Rehberi - Adım Adım

## 🚀 **1. ANDROID PACKAGE NAME AYARLAMA**

### ✅ **Tamamlandı:**
- `android/app/build.gradle.kts` dosyasında:
  - `namespace = "com.gemai.app"`
  - `applicationId = "com.gemai.app"`

### 🔧 **Kontrol:**
```bash
flutter clean
flutter pub get
flutter build apk --release
```

## 🍎 **2. APP STORE CONNECT YAYINI**

### **Adım 1: App Oluşturma**
1. **https://appstoreconnect.apple.com** → **"My Apps"**
2. **"+"** → **"New App"**
3. **Platforms**: iOS
4. **Bundle ID**: `com.gemai.app`
5. **App Name**: `gemai`
6. **Primary Language**: Turkish
7. **SKU**: `gemai_skin_analysis`
8. **User Access**: Full Access

### **Adım 2: App Information**
- **App Name**: `gemai`
- **Subtitle**: `AI Cilt Analizi`
- **Keywords**: `skin,analysis,ai,artificial,intelligence,dermatology,beauty,health`
- **Description**: `ios/AppStoreMetadata.md` dosyasındaki metni kopyalayın
- **Support URL**: `https://yourwebsite.com/support`
- **Marketing URL**: `https://yourwebsite.com`

### **Adım 3: App Privacy**
- **Privacy Policy URL**: `https://yourwebsite.com/privacy`
- **Data Collection**: Gerekli bilgileri doldurun
- **Tracking**: App tracking transparency

### **Adım 4: Screenshots**
- **iPhone 6.7"**: 1290 x 2796 px
- **iPhone 6.5"**: 1242 x 2688 px
- **iPhone 5.5"**: 1242 x 2208 px

## 🤖 **3. GOOGLE PLAY CONSOLE YAYINI**

### **Adım 1: App Oluşturma**
1. **https://play.google.com/console** → **"Create app"**
2. **App name**: `gemai`
3. **Default language**: Turkish
4. **App or game**: App
5. **Free or paid**: Free
6. **Create app**

### **Adım 2: Store Listing**
- **App name**: `gemai`
- **Short description**: `AI destekli cilt analizi uygulaması`
- **Full description**: `android/PlayStoreMetadata.md` dosyasındaki metni kopyalayın
- **App category**: `Medical` veya `Health & Fitness`
- **Tags**: `skin analysis, AI dermatology, beauty app`

### **Adım 3: App Content**
- **Privacy policy**: `https://yourwebsite.com/privacy`
- **Data safety**: Veri kullanım bilgilerini doldurun
- **Content rating**: 3+ (Everyone)

### **Adım 4: Screenshots**
- **Phone**: 1080 x 1920 px (minimum)
- **7-inch Tablet**: 1200 x 1920 px
- **10-inch Tablet**: 1920 x 1200 px

## 📋 **4. YAYIN ÖNCESİ KONTROL LİSTESİ**

### **App Store:**
- [ ] Bundle ID: `com.gemai.app`
- [ ] App Name: `gemai`
- [ ] Version: `1.0.0`
- [ ] Screenshots hazır
- [ ] Description yazıldı
- [ ] Keywords eklendi
- [ ] Privacy Policy URL eklendi
- [ ] Support URL eklendi

### **Play Store:**
- [ ] Package Name: `com.gemai.app`
- [ ] App Name: `gemai`
- [ ] Version: `1.0.0`
- [ ] Screenshots hazır
- [ ] Description yazıldı
- [ ] Privacy Policy URL eklendi
- [ ] Content Rating ayarlandı

## 🔧 **5. BUILD VE YÜKLEME**

### **iOS Build:**
```bash
flutter build ios --release
# Xcode'da Archive → Distribute App
```

### **Android Build:**
```bash
flutter build appbundle --release
# Play Console'da Bundle yükle
```

## 📝 **6. ÖNEMLİ NOTLAR**

### **App Store:**
- **Minimum supported version**: Açıklamaya `[Minimum supported app version: 1.0.0]` ekleyin
- **Review süresi**: 1-7 gün
- **TestFlight**: Önce internal testing yapın

### **Play Store:**
- **Minimum API level**: `android:minSdkVersion="21"`
- **Target API level**: `android:targetSdkVersion="34"`
- **Review süresi**: 1-3 gün
- **Internal testing**: Önce test edin

## 🚨 **7. YAYIN SONRASI**

### **Monitoring:**
- [ ] Crash reporting aktif
- [ ] Analytics takibi
- [ ] User feedback monitoring
- [ ] Performance monitoring
- [ ] Update planning

### **Support:**
- [ ] Support email aktif
- [ ] FAQ hazır
- [ ] User guide hazır
- [ ] Troubleshooting guide

---

## 🎯 **SONUÇ**

**gemai uygulamanız şu anda %95 yayına hazır!**

Sadece App Store Connect ve Google Play Console'da metadata girmeniz gerekiyor. Tüm teknik konfigürasyonlar tamamlandı!

**Hangi adımda yardıma ihtiyacınız var?**
1. **App Store Connect'te app oluşturma**
2. **Play Console'da app oluşturma**
3. **Screenshot'ları optimize etme**
4. **Privacy policy hazırlama**

🚀 **Başarılar!**

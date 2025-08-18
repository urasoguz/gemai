# MODÜLER KEMİK UYGULAMA REHBERİ

## 1. TEMEL YAPI

### Proje Klasör Yapısı
```
lib/
├── app/
│   ├── core/                    # Çekirdek bileşenler
│   │   ├── theme/              # Tema sistemi
│   │   ├── network/            # API ve ağ işlemleri
│   │   ├── services/           # Servisler
│   │   ├── bindings/           # GetX bindings
│   │   ├── localization/       # Çoklu dil desteği
│   │   └── utils/              # Yardımcı sınıflar
│   ├── data/                   # Veri katmanı
│   │   ├── api/                # API servisleri
│   │   ├── model/              # Veri modelleri
│   │   └── repository/         # Repository pattern
│   ├── modules/                # Özellik modülleri
│   │   ├── auth/               # Kimlik doğrulama
│   │   ├── home/               # Ana sayfa
│   │   ├── settings/           # Ayarlar
│   │   └── [feature]/          # Diğer özellikler
│   ├── routes/                 # Rota tanımları
│   └── shared/                 # Paylaşılan bileşenler
│       ├── widgets/            # Ortak widget'lar
│       ├── helpers/            # Yardımcı sınıflar
│       └── constants/          # Sabitler
└── main.dart                   # Uygulama girişi
```

## 2. GEREKLİ BİLEŞENLER

### ✅ Tema Sistemi
```dart
// lib/app/core/theme/app_theme_config.dart
class AppThemeConfig {
  static const String appName = 'Uygulama Adı';
  static const String fontFamily = 'Font Adı';
  static const ColorPalette lightColors = ColorPalette(...);
  static const ColorPalette darkColors = ColorPalette(...);
  static const double borderRadius = 12.0;
  static const double cardElevation = 4.0;
  static const Duration animationDuration = Duration(milliseconds: 300);
}
```

### ✅ Routing Sistemi
```dart
// lib/app/routes/app_routes.dart
abstract class AppRoutes {
  static const String splash = '/splash';
  static const String home = '/home';
  static const String auth = '/auth';
  static const String settings = '/settings';
}

// lib/app/routes/app_pages.dart
class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.splash, page: () => const SplashView()),
    GetPage(name: AppRoutes.home, page: () => const HomeView()),
    GetPage(name: AppRoutes.auth, page: () => const AuthView()),
    GetPage(name: AppRoutes.settings, page: () => const SettingsView()),
  ];
}
```

### ✅ State Management (GetX)
```dart
// lib/app/modules/home/controller/home_controller.dart
class HomeController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<Item> items = <Item>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    loadItems();
  }
  
  Future<void> loadItems() async {
    isLoading.value = true;
    try {
      // API çağrısı
      final response = await apiService.getItems();
      items.value = response;
    } catch (e) {
      // Hata yönetimi
    } finally {
      isLoading.value = false;
    }
  }
}
```

### ✅ API Sistemi
```dart
// lib/app/core/network/api_client.dart
class ApiClient extends GetConnect {
  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = ApiEndpoints.baseUrl;
    httpClient.timeout = const Duration(seconds: 30);
    
    // Request interceptor
    httpClient.addRequestModifier((request) {
      request.headers['Authorization'] = 'Bearer ${getToken()}';
      return request;
    });
    
    // Response interceptor
    httpClient.addResponseModifier((request, response) {
      if (response.statusCode == 401) {
        Get.offAllNamed(AppRoutes.auth);
      }
      return response;
    });
  }
}
```

### ✅ Localization
```dart
// lib/app/core/localization/translations.dart
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': en,
    'tr': tr,
  };
}

// lib/app/core/localization/tr.dart
final Map<String, String> tr = {
  'welcome': 'Hoş Geldiniz',
  'login': 'Giriş Yap',
  'logout': 'Çıkış Yap',
  'settings': 'Ayarlar',
};
```

### ✅ Storage Sistemi
```dart
// lib/app/core/services/storage_service.dart
class StorageService extends GetxService {
  late GetStorage _storage;
  
  @override
  Future<void> onInit() async {
    super.onInit();
    await GetStorage.init();
    _storage = GetStorage();
  }
  
  void saveToken(String token) => _storage.write('token', token);
  String? getToken() => _storage.read('token');
  void removeToken() => _storage.remove('token');
}
```

## 3. MODÜL YAPISI

### Her Modül İçin Gerekli Dosyalar
```
modules/[feature]/
├── controller/
│   └── [feature]_controller.dart
├── view/
│   └── [feature]_view.dart
├── widgets/
│   ├── [feature]_widget.dart
│   └── [feature]_card.dart
└── [feature]_binding.dart
```

### Controller Örneği
```dart
class FeatureController extends GetxController {
  // State variables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<Data> dataList = <Data>[].obs;
  
  // Dependencies
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();
  
  @override
  void onInit() {
    super.onInit();
    loadData();
  }
  
  Future<void> loadData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final response = await _apiService.getData();
      dataList.value = response;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  
  @override
  void onClose() {
    // Cleanup
    super.onClose();
  }
}
```

### View Örneği
```dart
class FeatureView extends GetView<FeatureController> {
  const FeatureView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('feature_title'.tr),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              children: [
                Text(controller.errorMessage.value),
                ElevatedButton(
                  onPressed: controller.loadData,
                  child: Text('retry'.tr),
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          itemCount: controller.dataList.length,
          itemBuilder: (context, index) {
            return FeatureCard(data: controller.dataList[index]);
          },
        );
      }),
    );
  }
}
```

### Binding Örneği
```dart
class FeatureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeatureController>(() => FeatureController());
    Get.lazyPut<FeatureService>(() => FeatureService());
  }
}
```

## 4. YARDIMCI SINIFLAR

### UI Helper
```dart
// lib/app/shared/helpers/ui_helper.dart
class UIHelper {
  static void showSnackbar(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? Colors.red[400] : Colors.white,
      colorText: isError ? Colors.white : Colors.black,
      duration: const Duration(seconds: 2),
    );
  }
  
  static void showLoading() {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
  }
  
  static void hideLoading() {
    Get.back();
  }
}
```

### Validation Helper
```dart
// lib/app/shared/helpers/validation_helper.dart
class ValidationHelper {
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'email_required'.tr;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'email_invalid'.tr;
    }
    return null;
  }
  
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'password_required'.tr;
    }
    if (password.length < 6) {
      return 'password_min_length'.tr;
    }
    return null;
  }
}
```

### Constants
```dart
// lib/app/shared/constants/app_constants.dart
class AppConstants {
  static const String appName = 'Uygulama Adı';
  static const String appVersion = '1.0.0';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
}

// lib/app/data/api/api_endpoints.dart
class ApiEndpoints {
  static const String baseUrl = 'https://api.example.com';
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String profile = '/user/profile';
  static const String items = '/items';
}
```

## 5. ERROR HANDLING

### Custom Exception Sınıfları
```dart
// lib/app/core/exceptions/app_exception.dart
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;
  
  AppException(this.message, [this.statusCode]);
}

class ApiException extends AppException {
  ApiException(String message, [int? statusCode]) : super(message, statusCode);
  
  factory ApiException.fromResponse(Response response) {
    return ApiException(
      response.statusText ?? 'Unknown error',
      response.statusCode,
    );
  }
}

class NetworkException extends AppException {
  NetworkException(String message) : super(message);
}

class ValidationException extends AppException {
  ValidationException(String message) : super(message);
}
```

### Global Error Handler
```dart
// lib/app/core/error/error_handler.dart
class ErrorHandler {
  static void handleError(dynamic error) {
    if (error is ApiException) {
      UIHelper.showSnackbar('Error', error.message, isError: true);
    } else if (error is NetworkException) {
      UIHelper.showSnackbar('Network Error', error.message, isError: true);
    } else if (error is ValidationException) {
      UIHelper.showSnackbar('Validation Error', error.message, isError: true);
    } else {
      UIHelper.showSnackbar('Error', 'An unexpected error occurred', isError: true);
    }
  }
}
```

## 6. TESTING

### Unit Test Örneği
```dart
// test/controllers/feature_controller_test.dart
void main() {
  group('FeatureController', () {
    late FeatureController controller;
    late MockApiService mockApiService;
    
    setUp(() {
      mockApiService = MockApiService();
      Get.put<ApiService>(mockApiService);
      controller = FeatureController();
    });
    
    tearDown(() {
      Get.reset();
    });
    
    test('should load data successfully', () async {
      // Arrange
      final mockData = [Data(id: 1, name: 'Test')];
      when(mockApiService.getData()).thenAnswer((_) async => mockData);
      
      // Act
      await controller.loadData();
      
      // Assert
      expect(controller.dataList.value, mockData);
      expect(controller.isLoading.value, false);
      expect(controller.errorMessage.value, '');
    });
  });
}
```

### Widget Test Örneği
```dart
// test/widgets/feature_widget_test.dart
void main() {
  testWidgets('FeatureWidget displays data correctly', (tester) async {
    // Arrange
    final controller = FeatureController();
    Get.put(controller);
    
    // Act
    await tester.pumpWidget(
      GetMaterialApp(
        home: FeatureView(),
      ),
    );
    
    // Assert
    expect(find.byType(FeatureView), findsOneWidget);
  });
}
```

## 7. PERFORMANCE OPTIMIZATION

### Widget Optimization
```dart
// const constructor kullanın
const MyWidget({super.key});

// ListView.builder kullanın
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(item: items[index]),
)

// Gereksiz rebuild'leri önleyin
Obx(() => Text(controller.value.value))
```

### Memory Management
```dart
// Controller'ları dispose edin
@override
void onClose() {
  // Cleanup
  super.onClose();
}

// Stream subscription'ları iptal edin
StreamSubscription? _subscription;

@override
void onClose() {
  _subscription?.cancel();
  super.onClose();
}
```

## 8. SECURITY

### API Security
```dart
// Token yönetimi
class TokenManager {
  static const String _tokenKey = 'auth_token';
  
  static Future<void> saveToken(String token) async {
    final storage = GetStorage();
    await storage.write(_tokenKey, token);
  }
  
  static String? getToken() {
    final storage = GetStorage();
    return storage.read(_tokenKey);
  }
  
  static Future<void> removeToken() async {
    final storage = GetStorage();
    await storage.remove(_tokenKey);
  }
}
```

### Input Validation
```dart
// Güvenli input validation
class SecurityHelper {
  static String sanitizeInput(String input) {
    // XSS ve injection saldırılarını önle
    return input.replaceAll(RegExp(r'[<>"\']'), '');
  }
  
  static bool isValidInput(String input) {
    // Güvenli karakter kontrolü
    return RegExp(r'^[a-zA-Z0-9\s\-_\.]+$').hasMatch(input);
  }
}
```

## 9. DEPLOYMENT

### Build Configuration
```dart
// android/app/build.gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        applicationId "com.example.app"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
    
    buildTypes {
        release {
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
```

### Environment Configuration
```dart
// lib/app/core/config/environment.dart
enum Environment { dev, staging, production }

class EnvironmentConfig {
  static Environment environment = Environment.dev;
  
  static String get apiBaseUrl {
    switch (environment) {
      case Environment.dev:
        return 'https://dev-api.example.com';
      case Environment.staging:
        return 'https://staging-api.example.com';
      case Environment.production:
        return 'https://api.example.com';
    }
  }
}
```

## 10. DOCUMENTATION

### README Template
```markdown
# Uygulama Adı

## Açıklama
Uygulamanın kısa açıklaması

## Özellikler
- Özellik 1
- Özellik 2
- Özellik 3

## Kurulum
1. Projeyi klonlayın
2. `flutter pub get` çalıştırın
3. `flutter run` ile başlatın

## Kullanım
Temel kullanım örnekleri

## Katkıda Bulunma
Katkıda bulunma rehberi

## Lisans
Lisans bilgisi
```

### API Documentation
```dart
/// Kullanıcı girişi yapar
/// 
/// [email] Kullanıcı e-posta adresi
/// [password] Kullanıcı şifresi
/// 
/// Returns: [LoginResponse] Giriş yanıtı
/// Throws: [ApiException] API hatası durumunda
Future<LoginResponse> login(String email, String password) async {
  // Implementation
}
```

Bu rehber, modüler ve sürdürülebilir bir Flutter uygulaması oluşturmak için gerekli tüm bileşenleri içerir. Her bileşen, yeni uygulamalar için kolayca özelleştirilebilir ve genişletilebilir şekilde tasarlanmıştır. 
/// API endpoint'leri için sabitler
///
/// KULLANIM ÖRNEĞİ:
/// ```dart
/// // Endpoint'leri kullanma
/// final response = await apiService.get(
///   ApiEndpoints.profile,
///   fromJson: (json) => UserModel.fromJson(json),
/// );
///
/// // Parametreli endpoint'ler
/// final result = await apiService.get(
///   ApiEndpoints.getResultById('123'),
///   fromJson: (json) => ScanResultModel.fromMap(json),
/// );
///
/// // Query parametreleri
/// final history = await apiService.get(
///   ApiEndpoints.history,
///   queryParameters: ApiEndpoints.paginationParams(page: 1, limit: 10),
///   fromJson: (json) => List<ScanResultModel>.from(
///     json.map((item) => ScanResultModel.fromMap(item)),
///   ),
/// );
/// ```
class ApiEndpoints {
  // Base URL'ler - MyHelper ile uyumlu
  static const String baseUrl = 'https://gemai.zyntecllc.com';
  static const String appApiKey = 'oguz123';
  static const String authBaseUrl = '$baseUrl/api/v1/auth';
  static const String skinAnalysisBaseUrl = '$baseUrl/api/v1/scan';
  static const String userBaseUrl = '$baseUrl/api/v1/user';

  // Auth endpoints - Mevcut yapıya uygun
  static const String login = '/api/v1/auth/login';
  static const String register = '/api/v1/auth/guest'; // MyHelper ile uyumlu
  static const String logout = '/api/v1/auth/logout';
  static const String refreshToken = '/api/v1/auth/refresh';
  static const String forgotPassword = '/api/v1/auth/forgot-password';
  static const String resetPassword = '/api/v1/auth/reset-password';
  static const String verifyEmail = '/api/v1/auth/verify-email';

  // User endpoints - Mevcut yapıya uygun
  static const String profile = '/api/v1/user'; // MyHelper ile uyumlu
  static const String updateProfile = '/api/v1/user/update';
  static const String changePassword = '/api/v1/user/change-password';
  static const String deleteAccount = '/api/v1/user/delete';

  // Skin Analysis endpoints - Mevcut yapıya uygun
  static const String analyze = '/api/v1/scan'; // Backend route ile uyumlu
  static const String history = '/api/v1/scan/history';
  static const String result = '/api/v1/scan/result'; // /result/{id}
  static const String delete = '/api/v1/scan/delete'; // /delete/{id}
  static const String share = '/api/v1/scan/share'; // /share/{id}
  static const String recommendations = '/api/skin-analysis/recommendations';
  static const String products = '/api/skin-analysis/products';
  static const String stats = '/api/skin-analysis/stats';

  // Settings endpoints - Yeni eklenen
  static const String appSettings = '/api/v1/app/settings';

  // Pages endpoints - Yeni eklenen
  static const String pages = '/api/v1/pages';
  static String getPageBySlug(String slug) => '$pages/$slug';

  // Premium/Subscription endpoints
  static const String restorePurchase = '/api/v1/user/restore-premium';

  // Utility methods
  static String getResultById(String id) => '$result/$id';
  static String getDeleteById(String id) => '$delete/$id';
  static String getShareById(String id) => '$share/$id';
}

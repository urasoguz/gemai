import 'package:gemai/app/data/api/base_api_service.dart';
import 'package:gemai/app/data/api/api_endpoints.dart';
import 'package:gemai/app/data/model/response/response_model.dart';
import 'package:gemai/app/data/model/user/user_model.dart';

/// Kimlik doğrulama API servisi
///
/// KULLANIM ÖRNEĞİ:
/// ```dart
/// // Controller'da kullanım
/// class AuthController extends GetxController {
///   final AuthApiService _authApiService = Get.find<AuthApiService>();
///
///   Future<void> login(String email, String password) async {
///     final response = await _authApiService.login(
///       email: email,
///       password: password,
///     );
///
///     if (response.isSuccess) {
///       // Başarılı giriş
///       Get.offAllNamed('/home');
///     } else {
///       // Hata durumu
///       Get.snackbar('Hata', response.message);
///     }
///   }
/// }
/// ```
class AuthApiService extends BaseApiService {
  /// Kullanıcı girişi yapar
  Future<ResponseModel<UserModel>> login({
    required String email,
    required String password,
  }) async {
    return await post<UserModel>(
      ApiEndpoints.login,
      {'email': email, 'password': password},
      fromJson: (json) => UserModel.fromJson(Map<String, dynamic>.from(json)),
      isLogin: true,
    );
  }

  /// Kullanıcı kaydı yapar
  Future<ResponseModel<UserModel>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    return await post<UserModel>(
      ApiEndpoints.register,
      {
        'name': name,
        'email': email,
        'password': password,
        if (phone != null) 'phone': phone,
      },
      fromJson: (json) => UserModel.fromJson(Map<String, dynamic>.from(json)),
    );
  }

  /// Sadece device_id ile cihaz kaydı yapar (guest kullanıcı)
  Future<ResponseModel<UserModel>> registerDevice({
    required String deviceId,
    String? countryCode,
  }) async {
    // Ülke kodunu opsiyonel olarak gönder
    final Map<String, dynamic> body = <String, dynamic>{
      'device_id': deviceId,
      if (countryCode != null && countryCode.isNotEmpty)
        'country_code': countryCode,
    };
    return await post<UserModel>(
      ApiEndpoints.register,
      body,
      fromJson: (json) => UserModel.fromJson(Map<String, dynamic>.from(json)),
    );
  }

  /// Kullanıcı çıkışı yapar
  Future<ResponseModel<void>> logout() async {
    return await post<void>(ApiEndpoints.logout, {});
  }

  /// Kullanıcı profilini getirir
  Future<ResponseModel<UserModel>> getProfile() async {
    return await get<UserModel>(
      ApiEndpoints.profile,
      fromJson: (json) => UserModel.fromJson(Map<String, dynamic>.from(json)),
    );
  }

  /// Kullanıcı profilini günceller
  Future<ResponseModel<UserModel>> updateProfile({
    String? name,
    String? email,
    String? phone,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (email != null) body['email'] = email;
    if (phone != null) body['phone'] = phone;

    return await put<UserModel>(
      ApiEndpoints.updateProfile,
      body,
      fromJson: (json) => UserModel.fromJson(Map<String, dynamic>.from(json)),
    );
  }

  /// Şifre sıfırlama isteği gönderir
  Future<ResponseModel<void>> forgotPassword({required String email}) async {
    return await post<void>(ApiEndpoints.forgotPassword, {'email': email});
  }

  /// Şifre sıfırlama işlemini tamamlar
  Future<ResponseModel<void>> resetPassword({
    required String token,
    required String password,
  }) async {
    return await post<void>(ApiEndpoints.resetPassword, {
      'token': token,
      'password': password,
    });
  }

  /// Token yenileme işlemi
  Future<ResponseModel<Map<String, dynamic>>> refreshToken({
    required String refreshToken,
  }) async {
    return await post<Map<String, dynamic>>(ApiEndpoints.refreshToken, {
      'refresh_token': refreshToken,
    }, fromJson: (json) => json);
  }
}

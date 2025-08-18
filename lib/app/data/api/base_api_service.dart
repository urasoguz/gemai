import 'dart:convert';
import 'package:get/get.dart';
import 'package:gemai/app/core/network/api_client.dart';
import 'package:gemai/app/data/model/response/response_model.dart';

/// Temel API servis sınıfı - Tüm API çağrıları için ortak fonksiyonlar
///
/// KULLANIM ÖRNEĞİ:
/// ```dart
/// class MyApiService extends BaseApiService {
///   Future<ResponseModel<UserModel>> getUser(String id) async {
///     return await get<UserModel>(
///       '/users/$id',
///       fromJson: (json) => UserModel.fromJson(json),
///     );
///   }
///
///   Future<ResponseModel<void>> createUser(UserModel user) async {
///     return await post<void>(
///       '/users',
///       user.toJson(),
///     );
///   }
/// }
/// ```
abstract class BaseApiService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  /// GET isteği gönderir ve ResponseModel döner
  Future<ResponseModel<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _apiClient.getData(
        endpoint,
        query: queryParameters,
        headers: headers,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ResponseModel<T>.error(
        message: 'API isteği başarısız: $e',
        statusCode: 0,
      );
    }
  }

  /// POST isteği gönderir ve ResponseModel döner
  Future<ResponseModel<T>> post<T>(
    String endpoint,
    dynamic body, {
    Map<String, String>? headers,
    T Function(dynamic)? fromJson,
    bool isLogin = false,
  }) async {
    try {
      final response = await _apiClient.postData(
        endpoint,
        body,
        headers: headers,
        isLogin: isLogin,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ResponseModel<T>.error(
        message: 'API isteği başarısız: $e',
        statusCode: 0,
      );
    }
  }

  /// PUT isteği gönderir ve ResponseModel döner
  Future<ResponseModel<T>> put<T>(
    String endpoint,
    dynamic body, {
    Map<String, String>? headers,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _apiClient.putData(
        endpoint,
        body,
        headers: headers,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ResponseModel<T>.error(
        message: 'API isteği başarısız: $e',
        statusCode: 0,
      );
    }
  }

  /// DELETE isteği gönderir ve ResponseModel döner
  Future<ResponseModel<T>> delete<T>(
    String endpoint, {
    Map<String, String>? headers,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _apiClient.deleteData(endpoint, headers: headers);

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ResponseModel<T>.error(
        message: 'API isteği başarısız: $e',
        statusCode: 0,
      );
    }
  }

  /// API yanıtını ResponseModel'e dönüştürür
  ResponseModel<T> _handleResponse<T>(
    dynamic response,
    T Function(dynamic)? fromJson,
  ) {
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 403) {
      try {
        dynamic jsonData;

        if (response.body is String) {
          jsonData = json.decode(response.body);
        } else {
          jsonData = response.body;
        }

        // Tüm response'larda success field'ını kontrol et
        if (jsonData is Map<String, dynamic>) {
          final isSuccess = jsonData['success']; // null olabilir
          if (isSuccess == false) {
            // Sadece false ise hata
            // Hata response'u döndür
            return ResponseModel<T>.error(
              message: jsonData['message'] ?? 'Bilinmeyen hata',
              statusCode: response.statusCode,
              code: jsonData['code'],
            );
          }
        }

        T? data;
        if (fromJson != null) {
          data = fromJson(jsonData);
        }

        String message = 'İşlem başarılı';
        if (jsonData is Map<String, dynamic>) {
          message = jsonData['message'] ?? message;
        }

        // TOKEN'I JSON'DAN AL!
        String? token;
        if (jsonData is Map<String, dynamic> && jsonData.containsKey('token')) {
          token = jsonData['token'];
        }

        return ResponseModel<T>.success(
          data: data,
          message: message,
          statusCode: response.statusCode,
          token: token,
          code: jsonData is Map<String, dynamic> ? jsonData['code'] : null,
        );
      } catch (e) {
        return ResponseModel<T>.error(
          message: 'Veri işleme hatası: $e',
          statusCode: response.statusCode,
        );
      }
    } else {
      return ResponseModel<T>.error(
        message: response.body ?? 'Bilinmeyen hata',
        statusCode: response.statusCode,
      );
    }
  }
}

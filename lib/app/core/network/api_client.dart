import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:gemai/app/shared/helpers/my_helper.dart';
import 'package:gemai/app/data/model/response/error_response.dart';
import 'package:gemai/app/data/api/api_endpoints.dart';

class ApiClient {
  final String appBaseUrl;
  final GetStorage sharedPreferences;
  static const String noInternetMessage = 'connection_to_api_server_failed';
  final int timeoutInSeconds = 30;

  String? token;
  late Map<String, String> _mainHeaders;

  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    token = sharedPreferences.read(MyHelper.bToken);
    if (kDebugMode) {
      debugPrint('Token: $token');
    }
    updateHeader();
  }

  void updateHeader({bool? multipart, bool? isUddokta, bool isToken = false}) {
    // Token'ı storage'dan al
    token = sharedPreferences.read(MyHelper.bToken);
    if (multipart ?? false) {
      _mainHeaders = {
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
        'X-API-Key': ApiEndpoints.appApiKey, // <-- API Key header'ı ekle
        'Authorization': 'Bearer $token', // <-- Token'ı header'a ekle
      };
    } else {
      _mainHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-API-Key': ApiEndpoints.appApiKey, // <-- API Key header'ı ekle
        'Authorization': 'Bearer $token', // <-- Token'ı header'a ekle
      };
    }
  }

  Future<http.Response> getData(
    String uri, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse(appBaseUrl + uri).replace(queryParameters: query);
      if (kDebugMode) {
        debugPrint('====> API Call: $url\nHeader: $_mainHeaders');
      }
      final response = await http
          .get(url, headers: headers ?? _mainHeaders)
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('====> GET API Error: $e');
        debugPrint('====> Error Type: ${e.runtimeType}');
        debugPrint('====> URL: ${appBaseUrl + uri}');
      }
      return http.Response(noInternetMessage, 0);
    }
  }

  Future<http.Response> postData(
    String uri,
    dynamic body, {
    Map<String, String>? headers,
    bool? isRaw,
    bool? isLogin,
  }) async {
    try {
      final url = Uri.parse(appBaseUrl + uri);
      if (kDebugMode) {
        debugPrint('====> API Call: $url\nHeader: $_mainHeaders');
        debugPrint('====> API Body: $body');
      }

      final response = await http
          .post(
            url,
            body: (isRaw ?? false) ? body : jsonEncode(body),
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));

      if (kDebugMode) {
        debugPrint('====> API Response Status: ${response.statusCode}');
        debugPrint('====> API Response Body: ${response.body}');
        debugPrint('====> API Response Headers: ${response.headers}');
      }

      return handleResponse(response, uri, isLogin: isLogin ?? false);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('====> POST API Error: $e');
        debugPrint('====> URL: ${appBaseUrl + uri}');
        debugPrint('====> Headers: $_mainHeaders');
        debugPrint('====> Body: $body');
        debugPrint('====> Error Type: ${e.runtimeType}');
        debugPrint('====> Error Details: $e');
      }
      return http.Response(noInternetMessage, 0);
    }
  }

  Future<http.Response> putData(
    String uri,
    dynamic body, {
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse(appBaseUrl + uri);
      if (kDebugMode) {
        debugPrint('====> API Call: $url\nHeader: $_mainHeaders');
        debugPrint('====> API Body: $body');
      }
      final response = await http
          .put(url, body: jsonEncode(body), headers: headers ?? _mainHeaders)
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return http.Response(noInternetMessage, 0);
    }
  }

  Future<http.Response> deleteData(
    String uri, {
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse(appBaseUrl + uri);
      if (kDebugMode) {
        debugPrint('====> API Call: $url\nHeader: $_mainHeaders');
      }
      final response = await http
          .delete(url, headers: headers ?? _mainHeaders)
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return http.Response(noInternetMessage, 0);
    }
  }

  http.Response handleResponse(
    http.Response response,
    String uri, {
    bool? isLogin,
  }) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {}
    http.Response response0 = http.Response(response.body, response.statusCode);

    // 403 status code'u normal response olarak algıla (backend'den valid JSON geliyor)
    if (response0.statusCode == 403 && response0.body.isNotEmpty) {
      // 403 ile gelen response'u normal response olarak döndür
      return response0;
    }

    if (response0.statusCode != 200 && response0.body.isNotEmpty) {
      if (response0.body.toString().startsWith('{errors: [{code:')) {
        ErrorResponse errorResponse = ErrorResponse.fromJson(
          json.decode(response0.body),
        );
        response0 = http.Response(
          errorResponse.errors!.email![0],
          response0.statusCode,
        );
      } else if (response0.statusCode == 401) {
        response0 = http.Response(
          body["message"].toString(),
          response0.statusCode,
        );
        if (isLogin ?? false) {
          return response0;
        }
        sharedPreferences.write(MyHelper.bToken, "");
      } else {
        response0 = http.Response(
          body["message"].toString(),
          response0.statusCode,
        );
      }
    } else if (response0.statusCode != 200 && response0.body.isEmpty) {
      response0 = http.Response(noInternetMessage, 0);
    }
    if (kDebugMode) {
      debugPrint(
        '====> API Response: [[32m${response0.statusCode}[0m] $uri\n${response0.body}',
      );
    }
    return response0;
  }
}

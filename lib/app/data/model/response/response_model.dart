/// API yanıtları için generic response model
///
/// KULLANIM ÖRNEĞİ:
/// ```dart
/// // API çağrısı sonucu
/// final response = await apiService.getUser('123');
///
/// if (response.isSuccess) {
///   final user = response.data; // UserModel?
///   print('Kullanıcı: ${user?.name}');
/// } else {
///   print('Hata: ${response.message}');
///   print('Status: ${response.statusCode}');
/// }
///
/// // Manuel oluşturma
/// final successResponse = ResponseModel.success(
///   data: userModel,
///   message: 'Kullanıcı bulundu',
/// );
///
/// final errorResponse = ResponseModel.error(
///   message: 'Kullanıcı bulunamadı',
///   statusCode: 404,
/// );
/// ```
class ResponseModel<T> {
  final T? data;
  final String message;
  final int statusCode;
  final bool isSuccess;
  final String? token;
  final int? code; // Backend'den gelen hata kodu

  ResponseModel._({
    required this.data,
    required this.message,
    required this.statusCode,
    required this.isSuccess,
    this.token,
    this.code,
  });

  /// Başarılı yanıt oluşturur
  factory ResponseModel.success({
    T? data,
    String? message,
    int? statusCode,
    String? token,
    int? code,
  }) {
    return ResponseModel._(
      data: data,
      message: message ?? 'İşlem başarılı',
      statusCode: statusCode ?? 200,
      isSuccess: true,
      token: token,
      code: code,
    );
  }

  /// Hata yanıtı oluşturur
  factory ResponseModel.error({
    T? data,
    required String message,
    int? statusCode,
    String? token,
    int? code,
  }) {
    return ResponseModel._(
      data: data,
      message: message,
      statusCode: statusCode ?? 400,
      isSuccess: false,
      token: token,
      code: code,
    );
  }

  /// JSON'dan ResponseModel oluşturur
  factory ResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    final isSuccess =
        json['success'] ??
        json['status'] == 'success' || json['statusCode'] == 200;

    T? data;
    if (fromJson != null && json['data'] != null) {
      data = fromJson(json['data']);
    }

    return ResponseModel._(
      data: data,
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 200,
      isSuccess: isSuccess,
      token: json['token'],
      code: json['code'], // Backend'den gelen hata kodu
    );
  }

  /// ResponseModel'i JSON'a dönüştürür
  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'message': message,
      'statusCode': statusCode,
      'success': isSuccess,
      'token': token, // <-- EKLENDİ
    };
  }

  @override
  String toString() {
    return 'ResponseModel{data: $data, message: $message, statusCode: $statusCode, isSuccess: $isSuccess}';
  }
}

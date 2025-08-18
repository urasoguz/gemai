import 'dart:convert';

class ErrorResponse {
  final String? message;
  final Errors? errors;

  ErrorResponse({this.message, this.errors});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
    message: json["message"],
    errors: json["errors"] == null ? null : Errors.fromJson(json["errors"]),
  );

  factory ErrorResponse.fromRawJson(String str) =>
      ErrorResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
    "message": message,
    "errors": errors?.toJson(),
  };

  String get displayMessage {
    if (message != null) return message!;
    if (errors?.email?.isNotEmpty ?? false) return errors!.email!.first;
    return 'An unknown error occurred';
  }
}

class Errors {
  final List<String>? email;

  Errors({this.email});

  factory Errors.fromRawJson(String str) => Errors.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Errors.fromJson(Map<String, dynamic> json) => Errors(
    email:
        json["email"] == null
            ? null
            : List<String>.from(json["email"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "email": email == null ? null : List<dynamic>.from(email!.map((x) => x)),
  };
}

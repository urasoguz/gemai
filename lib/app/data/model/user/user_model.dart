// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

import 'package:gemai/app/data/model/user/user.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  final String? status;
  final String? message;
  final User? data;

  UserModel({this.status, this.message, this.data});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    status: json["status"],
    message: json["message"],
    // Eğer "user" varsa onu, yoksa tüm json'u User olarak parse et
    data:
        json["user"] != null
            ? User.fromJson(json["user"])
            : User.fromJson(json),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "user": data?.toJson(), // <-- DÜZELTİLDİ
  };
}

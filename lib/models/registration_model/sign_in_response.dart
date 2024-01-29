// To parse this JSON data, do
//
//     final singInResponse = singInResponseFromJson(jsonString);

import 'dart:convert';

SingInResponse singInResponseFromJson(String str) =>
    SingInResponse.fromJson(json.decode(str));

String singInResponseToJson(SingInResponse data) => json.encode(data.toJson());

class SingInResponse {
  SingInResponse({
    this.status,
    this.message,
    this.data,
  });

  dynamic status;
  String? message;
  Data? data;

  factory SingInResponse.fromJson(Map<String, dynamic> json) => SingInResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? null : data!.toJson(),
      };
}

class Data {
  Data({this.userExist, this.userId, this.message});

  bool? userExist;
  dynamic userId;
  String? message;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      userExist: json["userExist"]?? true,
      userId: json["userId"],
      message: json["message"] ?? "");

  Map<String, dynamic> toJson() => {
        "userExist": userExist,
        "userId": userId,
      };
}

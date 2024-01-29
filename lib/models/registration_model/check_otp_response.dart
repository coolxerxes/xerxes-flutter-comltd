// To parse this JSON data, do
//
//     final checkOtpResponse = checkOtpResponseFromJson(jsonString);

import 'dart:convert';

CheckOtpResponse checkOtpResponseFromJson(String str) =>
    CheckOtpResponse.fromJson(json.decode(str));

String checkOtpResponseToJson(CheckOtpResponse data) =>
    json.encode(data.toJson());

class CheckOtpResponse {
  CheckOtpResponse({
    this.status,
    this.message,
    this.data,
  });

  dynamic status;
  String? message;
  Data? data;

  factory CheckOtpResponse.fromJson(Map<String, dynamic> json) =>
      CheckOtpResponse(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? null : data!.toJson(),
      };
}

class Data {
  Data({
    this.status,
    this.message,
    this.userId,
  });

  String? status;
  String? message;
  dynamic userId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
        message: json["message"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "userID": userId,
      };
}

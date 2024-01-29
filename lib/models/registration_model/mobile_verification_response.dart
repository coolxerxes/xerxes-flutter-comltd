// To parse this JSON data, do
//
//     final mobileVerificationResponse = mobileVerificationResponseFromJson(jsonString);

import 'dart:convert';

MobileVerificationResponse mobileVerificationResponseFromJson(String str) =>
    MobileVerificationResponse.fromJson(json.decode(str));

String mobileVerificationResponseToJson(MobileVerificationResponse data) =>
    json.encode(data.toJson());

class MobileVerificationResponse {
  MobileVerificationResponse({
    this.status,
    this.message,
    this.data,
  });

  dynamic status;
  String? message;
  Data? data;

  factory MobileVerificationResponse.fromJson(Map<String, dynamic> json) =>
      MobileVerificationResponse(
        status: json["status"]??-1,
        message: json["message"]??"",
        data: Data.fromJson(json["data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  Data({
    this.status,
    this.otp,
  });

  dynamic status;
  dynamic otp;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"]??"",
        otp: json["OTP"]??"",
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "OTP": otp,
      };
}

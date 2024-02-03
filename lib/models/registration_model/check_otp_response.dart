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
    this.isOverviewed,
    this.overviewStep,
    this.token
  });

  String? status;
  String? message;
  dynamic userId;
  bool? isOverviewed;
  dynamic overviewStep;
  String? token;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
        message: json["message"],
        userId: json["userId"],
        isOverviewed: json["isOverviewed"]??false,
        overviewStep: json["overviewStep"]??0,
        token: json["token"]
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "userID": userId,
      };
}

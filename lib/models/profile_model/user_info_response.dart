// To parse this JSON data, do
//
//     final userInfoResponse = userInfoResponseFromJson(jsonString);

import 'dart:convert';

UserInfoResponse userInfoResponseFromJson(String str) =>
    UserInfoResponse.fromJson(json.decode(str));

String userInfoResponseToJson(UserInfoResponse data) =>
    json.encode(data.toJson());

class UserInfoResponse {
  UserInfoResponse({this.status, this.message, this.data, this.friendCount});

  dynamic status;
  String? message;
  Data? data;
  dynamic friendCount;

  factory UserInfoResponse.fromJson(Map<String, dynamic> json) =>
      UserInfoResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        friendCount: json["friendCount"]??"0"
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? null : data!.toJson(),
      };
}

class Data {
  Data({
    this.id,
    this.hpNo,
    this.countryCode,
  });

  dynamic id;
  String? hpNo;
  dynamic countryCode;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        hpNo: json["hpNo"],
        countryCode: json["countryCode"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "hpNo": hpNo,
        "countryCode": countryCode,
      };
}

// To parse this JSON data, do
//
//     final jioMeResponseModel = jioMeResponseModelFromJson(jsonString);

import 'dart:convert';

JioMeResponseModel jioMeResponseModelFromJson(String str) =>
    JioMeResponseModel.fromJson(json.decode(str));

String jioMeResponseModelToJson(JioMeResponseModel data) =>
    json.encode(data.toJson());

class JioMeResponseModel {
  JioMeResponseModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  Data? data;

  factory JioMeResponseModel.fromJson(Map<String, dynamic> json) =>
      JioMeResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : json["data"] is Map
                ? Data.fromJson(json["data"])
                : Data(),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  Data({
    this.id,
    this.userId,
    this.postId,
    this.jioDate,
  });

  int? id;
  int? userId;
  int? postId;
  String? jioDate;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"]??0,
        userId: json["userId"]??0,
        postId: json["postId"]??0,
        jioDate: json["jioDate"]??"",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "postId": postId,
        "jioDate": jioDate,
      };
}

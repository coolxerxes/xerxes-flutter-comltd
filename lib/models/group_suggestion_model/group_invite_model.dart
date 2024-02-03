// To parse this JSON data, do
//
//     final groupInviteModel = groupInviteModelFromJson(jsonString);

import 'dart:convert';

GroupInviteModel groupInviteModelFromJson(String str) => GroupInviteModel.fromJson(json.decode(str));

String groupInviteModelToJson(GroupInviteModel data) => json.encode(data.toJson());

class GroupInviteModel {
    int? status;
    String? message;
    Data? data;

    GroupInviteModel({
        this.status,
        this.message,
        this.data,
    });

    factory GroupInviteModel.fromJson(Map<String, dynamic> json) => GroupInviteModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    Data();

    factory Data.fromJson(Map<String, dynamic> json) => Data(
    );

    Map<String, dynamic> toJson() => {
    };
}

/**
 * REQ
 * {
    "userArray": [3],
    "groupId": 2,
    "userId": 2
  }
 */
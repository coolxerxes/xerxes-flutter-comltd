// To parse this JSON data, do
//
//     final acceptOrRejectGroupInviteModel = acceptOrRejectGroupInviteModelFromJson(jsonString);

import 'dart:convert';

AcceptOrRejectGroupInviteModel acceptOrRejectGroupInviteModelFromJson(String str) => AcceptOrRejectGroupInviteModel.fromJson(json.decode(str));

String acceptOrRejectGroupInviteModelToJson(AcceptOrRejectGroupInviteModel data) => json.encode(data.toJson());

class AcceptOrRejectGroupInviteModel {
    int? status;
    String? message;
    List<int>? data;

    AcceptOrRejectGroupInviteModel({
        this.status,
        this.message,
        this.data,
    });

    factory AcceptOrRejectGroupInviteModel.fromJson(Map<String, dynamic> json) => AcceptOrRejectGroupInviteModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<int>.from(json["data"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
    };
}

/**
 * REQ
 * {
    "groupId": 2,
    "userId": 3,
    "isAccept": 1
   }
 */

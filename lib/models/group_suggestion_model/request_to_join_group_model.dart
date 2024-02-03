// To parse this JSON data, do
//
//     final requestToJoinGroupModel = requestToJoinGroupModelFromJson(jsonString);

import 'dart:convert';

RequestToJoinGroupModel requestToJoinGroupModelFromJson(String str) => RequestToJoinGroupModel.fromJson(json.decode(str));

String requestToJoinGroupModelToJson(RequestToJoinGroupModel data) => json.encode(data.toJson());

class RequestToJoinGroupModel {
    int? status;
    String? message;
    Data? data;

    RequestToJoinGroupModel({
        this.status,
        this.message,
        this.data,
    });

    factory RequestToJoinGroupModel.fromJson(Map<String, dynamic> json) => RequestToJoinGroupModel(
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
    String? role;
    bool? isInvited;
    int? id;
    int? userId;
    int? groupId;
    String? status;
    String? createdAt;

    Data({
        this.role,
        this.isInvited,
        this.id,
        this.userId,
        this.groupId,
        this.status,
        this.createdAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        role: json["role"],
        isInvited: json["isInvited"],
        id: json["id"],
        userId: json["userId"],
        groupId: json["groupId"],
        status: json["status"],
        createdAt: json["createdAt"],
    );

    Map<String, dynamic> toJson() => {
        "role": role,
        "isInvited": isInvited,
        "id": id,
        "userId": userId,
        "groupId": groupId,
        "status": status,
        "createdAt": createdAt,
    };
}

/**
 * REQ
 * {
    "userId": 4,
    "groupId": 2
   }
 */

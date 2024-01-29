// To parse this JSON data, do
//
//     final sendFriendReqResponseModel = sendFriendReqResponseModelFromJson(jsonString);

import 'dart:convert';

SendFriendReqResponseModel sendFriendReqResponseModelFromJson(String str) => SendFriendReqResponseModel.fromJson(json.decode(str));

String sendFriendReqResponseModelToJson(SendFriendReqResponseModel data) => json.encode(data.toJson());

class SendFriendReqResponseModel {
    SendFriendReqResponseModel({
        this.status,
        this.message,
        this.data,
    });

    int? status;
    String? message;
    Data? data;

    factory SendFriendReqResponseModel.fromJson(Map<String, dynamic> json) => SendFriendReqResponseModel(
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
    Data({
        this.id,
        this.userId,
        this.friendId,
        this.status,
        this.createdAt,
    });

    int? id;
    int? userId;
    int? friendId;
    String? status;
    String? createdAt;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["userId"],
        friendId: json["friendId"],
        status: json["status"],
        createdAt: json["createdAt"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "friendId": friendId,
        "status": status,
        "createdAt": createdAt
    };
}

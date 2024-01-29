// To parse this JSON data, do
//
//     final fetchBlockedUserResponse = fetchBlockedUserResponseFromJson(jsonString);

import 'dart:convert';

FetchBlockedUserResponse fetchBlockedUserResponseFromJson(String str) => FetchBlockedUserResponse.fromJson(json.decode(str));

String fetchBlockedUserResponseToJson(FetchBlockedUserResponse data) => json.encode(data.toJson());

class FetchBlockedUserResponse {
    FetchBlockedUserResponse({
        this.status,
        this.message,
        this.data,
    });

    int? status;
    String? message;
    Data? data;

    factory FetchBlockedUserResponse.fromJson(Map<String, dynamic> json) => FetchBlockedUserResponse(
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
        this.createdAt,
    });

    int? id;
    int? userId;
    int? friendId;
    String? createdAt;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["userId"],
        friendId: json["friendId"],
        createdAt: json["createdAt"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "friendId": friendId,
        "createdAt": createdAt,
    };
}

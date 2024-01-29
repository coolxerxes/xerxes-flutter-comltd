// To parse this JSON data, do
//
//     final pendingFreindReqResponseModel = pendingFreindReqResponseModelFromJson(jsonString);

import 'dart:convert';

PendingFreindReqResponseModel pendingFreindReqResponseModelFromJson(String str) => PendingFreindReqResponseModel.fromJson(json.decode(str));

String pendingFreindReqResponseModelToJson(PendingFreindReqResponseModel data) => json.encode(data.toJson());

class PendingFreindReqResponseModel {
    PendingFreindReqResponseModel({
        this.status,
        this.message,
        this.data,
    });

    int? status;
    String? message;
    List<Datum>? data;

    factory PendingFreindReqResponseModel.fromJson(Map<String, dynamic> json) => PendingFreindReqResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        this.id,
        this.userId,
        this.friendId,
        this.status,
        this.createdAt,
        this.userInfo,
    });

    int? id;
    int? userId;
    int? friendId;
    String? status;
    String? createdAt;
    UserInfo? userInfo;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["userId"],
        friendId: json["friendId"],
        status: json["status"],
        createdAt: json["createdAt"],
        userInfo: json["userInfo"] == null ? null : UserInfo.fromJson(json["userInfo"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "friendId": friendId,
        "status": status,
        "createdAt": createdAt,
        "userInfo": userInfo?.toJson(),
    };
}

class UserInfo {
    UserInfo({
        this.id,
        this.userId,
        this.firstName,
        this.lastName,
        this.username,
        this.profilePic,
    });

    int? id;
    int? userId;
    String? firstName;
    String? lastName;
    String? username;
    String? profilePic;

    factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        id: json["id"],
        userId: json["userId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        username: json["username"],
        profilePic: json["profilePic"]??"",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "username": username,
        "profilePic": profilePic,
    };
}

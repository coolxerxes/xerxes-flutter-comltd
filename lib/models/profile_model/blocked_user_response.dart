// To parse this JSON data, do
//
//     final blockedUserListResponseModel = blockedUserListResponseModelFromJson(jsonString);

import 'dart:convert';

BlockedUserListResponseModel blockedUserListResponseModelFromJson(String str) => BlockedUserListResponseModel.fromJson(json.decode(str));

String blockedUserListResponseModelToJson(BlockedUserListResponseModel data) => json.encode(data.toJson());

class BlockedUserListResponseModel {
    BlockedUserListResponseModel({
        this.status,
        this.message,
        this.data,
    });

    int? status;
    String? message;
    List<Datum>? data;

    factory BlockedUserListResponseModel.fromJson(Map<String, dynamic> json) => BlockedUserListResponseModel(
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
        this.createdAt,
        this.userInfo,
        this.isHidden,
    });

    int? id;
    int? userId;
    int? friendId;
    String? createdAt;
    UserInfo? userInfo;
    bool? isHidden;
    
    bool? get getIsHidden => isHidden;
    set setIsHidden(bool? isHidden) => this.isHidden = isHidden;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["userId"],
        friendId: json["friendId"],
        createdAt: json["createdAt"],
        userInfo: json["userInfo"] == null ? null : UserInfo.fromJson(json["userInfo"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "friendId": friendId,
        "createdAt": createdAt,
        "userInfo": userInfo?.toJson(),
    };
}

class UserInfo {
    UserInfo({
        this.userId,
        this.firstName,
        this.lastName,
        this.profilePic,
    });

    int? userId;
    String? firstName;
    String? lastName;
    String? profilePic;

    factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        userId: json["userId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        profilePic: json["profilePic"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "profilePic": profilePic,
    };
}

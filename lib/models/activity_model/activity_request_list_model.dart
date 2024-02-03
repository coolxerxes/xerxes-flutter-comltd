// To parse this JSON data, do
//
//     final activityRequestListResponse = activityRequestListResponseFromJson(jsonString);

import 'dart:convert';

ActivityRequestListResponse activityRequestListResponseFromJson(String str) => ActivityRequestListResponse.fromJson(json.decode(str));

String activityRequestListResponseToJson(ActivityRequestListResponse data) => json.encode(data.toJson());

class ActivityRequestListResponse {
    int? status;
    String? message;
    List<Datum>? data;

    ActivityRequestListResponse({
        this.status,
        this.message,
        this.data,
    });

    factory ActivityRequestListResponse.fromJson(Map<String, dynamic> json) => ActivityRequestListResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : json["data"] is List ?  List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))):[],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? id;
    int? userId;
    int? activityId;
    String? role;
    String? status;
    bool? isInvited;
    String? createdAt;
    int? groupId;
    User? user;

    Datum({
        this.id,
        this.userId,
        this.activityId,
        this.groupId,
        this.role,
        this.status,
        this.isInvited,
        this.createdAt,
        this.user,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["userId"],
        activityId: json["activityId"],
        role: json["role"],
        status: json["status"],
        groupId: json["groupId"],
        isInvited: json["isInvited"],
        createdAt: json["createdAt"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "activityId": activityId,
        "groupId": groupId,
        "role": role,
        "status": status,
        "isInvited": isInvited,
        "createdAt": createdAt,
        "user": user?.toJson(),
    };
}

class User {
    int? id;
    UserInfo? userInfo;

    User({
        this.id,
        this.userInfo,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        userInfo: json["userInfo"] == null ? null : UserInfo.fromJson(json["userInfo"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userInfo": userInfo?.toJson(),
    };
}

class UserInfo {
    String? firstName;
    String? lastName;
    String? profilePic;
    dynamic biography;

    UserInfo({
        this.firstName,
        this.lastName,
        this.profilePic,
        this.biography,
    });

    factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        firstName: json["firstName"],
        lastName: json["lastName"],
        profilePic: json["profilePic"],
        biography: json["biography"],
    );

    Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "profilePic": profilePic,
        "biography": biography,
    };
}

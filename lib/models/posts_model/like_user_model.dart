// To parse this JSON data, do
//
//     final likeUserResponse = likeUserResponseFromJson(jsonString);

import 'dart:convert';

LikeUserResponse likeUserResponseFromJson(String str) => LikeUserResponse.fromJson(json.decode(str));

String likeUserResponseToJson(LikeUserResponse data) => json.encode(data.toJson());

class LikeUserResponse {
    LikeUserResponse({
        this.status,
        this.message,
        this.data,
    });

    int? status;
    String? message;
    List<Datum>? data;

    factory LikeUserResponse.fromJson(Map<String, dynamic> json) => LikeUserResponse(
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
        this.postId,
        this.likeDate,
        this.userInfo,
    });

    int? id;
    int? userId;
    int? postId;
    String? likeDate;
    UserInfo? userInfo;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["userId"],
        postId: json["postId"],
        likeDate: json["likeDate"],
        userInfo: json["userInfo"] == null ? null : UserInfo.fromJson(json["userInfo"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "postId": postId,
        "likeDate": likeDate,
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

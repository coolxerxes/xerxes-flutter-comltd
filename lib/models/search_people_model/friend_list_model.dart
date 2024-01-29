// To parse this JSON data, do
//
//     final friendListResponseModel = friendListResponseModelFromJson(jsonString);

import 'dart:convert';

FriendListResponseModel friendListResponseModelFromJson(String str) =>
    FriendListResponseModel.fromJson(json.decode(str));

String friendListResponseModelToJson(FriendListResponseModel data) =>
    json.encode(data.toJson());

class FriendListResponseModel {
  FriendListResponseModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  List<Datum>? data;

  factory FriendListResponseModel.fromJson(Map<String, dynamic> json) =>
      FriendListResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) { return Datum.fromJson(x??{});})),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.id,
    this.userId,
    this.friendId,
    this.status,
    this.createdAt,
    this.user,
    this.isHidden,
  });

  int? id;
  int? userId;
  int? friendId;
  String? status;
  String? createdAt;
  UserInfo? user;

  bool? isHidden;

  bool? get getIsHidden => isHidden;
  set setIsHidden(bool? isHidden) => this.isHidden = isHidden;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["userId"],
        friendId: json["friendId"],
        status: json["status"],
        createdAt: json["createdAt"],
        user: json["friendInfo"] == null
            ? null
            : UserInfo.fromJson(json["friendInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "friendId": friendId,
        "status": status,
        "createdAt": createdAt,
        "user": user?.toJson(),
      };
}

class User {
  User({
    this.id,
    this.userInfo,
  });

  int? id;
  UserInfo? userInfo;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        userInfo: json["userInfo"] == null
            ? null
            : UserInfo.fromJson(json["userInfo"]??{}),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userInfo": userInfo?.toJson(),
      };
}

class UserInfo {
  UserInfo(
      {this.firstName,
      this.lastName,
      this.biography,
      this.profilePic,
      this.username,
      this.userId});

  String? firstName;
  String? lastName;
  String? biography;
  String? profilePic;
  String? username;
  dynamic userId;

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
      firstName: json["firstName"],
      lastName: json["lastName"],
      biography: json["biography"],
      username: json["username"],
      profilePic: json["profilePic"] ?? "",
      userId: json["userId"] ?? "");

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "biography": biography,
      };
}

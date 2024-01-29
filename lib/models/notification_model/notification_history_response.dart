// To parse this JSON data, do
//
//     final notificationHistoryResponseModel = notificationHistoryResponseModelFromJson(jsonString);

import 'dart:convert';

NotificationHistoryResponseModel notificationHistoryResponseModelFromJson(
        String str) =>
    NotificationHistoryResponseModel.fromJson(json.decode(str));

String notificationHistoryResponseModelToJson(
        NotificationHistoryResponseModel data) =>
    json.encode(data.toJson());

class NotificationHistoryResponseModel {
  NotificationHistoryResponseModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  List<Datum>? data;

  factory NotificationHistoryResponseModel.fromJson(
          Map<String, dynamic> json) =>
      NotificationHistoryResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
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
    this.notificationType,
    this.createdDate,
    this.user,
  });

  int? id;
  int? userId;
  int? friendId;
  String? notificationType;
  String? createdDate;
  User? user;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["userId"],
        friendId: json["friendId"],
        notificationType: json["notificationType"],
        createdDate: json["createdDate"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "friendId": friendId,
        "notificationType": notificationType,
        "createdDate": createdDate,
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
            : UserInfo.fromJson(json["userInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
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
        firstName: json["firstName"]??"",
        lastName: json["lastName"]??"",
        profilePic : json["profilePic"]??""
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
      };
}

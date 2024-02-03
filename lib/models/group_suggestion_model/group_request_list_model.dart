// To parse this JSON data, do
//
//     final groupRequestListModel = groupRequestListModelFromJson(jsonString);

import 'dart:convert';

GroupRequestListModel groupRequestListModelFromJson(String str) =>
    GroupRequestListModel.fromJson(json.decode(str));

String groupRequestListModelToJson(GroupRequestListModel data) =>
    json.encode(data.toJson());

class GroupRequestListModel {
  int? status;
  String? message;
  List<Datum>? data;

  GroupRequestListModel({
    this.status,
    this.message,
    this.data,
  });

  factory GroupRequestListModel.fromJson(Map<String, dynamic> json) =>
      GroupRequestListModel(
          status: json["status"],
          message: json["message"],
          data: json["data"] == null
              ? []
              : json["data"] is List
                  ? List<Datum>.from(
                      json["data"]!.map((x) => Datum.fromJson(x)))
                  : []);

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? id;
  int? userId;
  int? groupId;
  String? role;
  String? status;
  bool? isInvited;
  String? createdAt;
  User? user;

  Datum({
    this.id,
    this.userId,
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
        groupId: json["groupId"],
        role: json["role"],
        status: json["status"],
        isInvited: json["isInvited"],
        createdAt: json["createdAt"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
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
  String? firstName;
  String? lastName;

  UserInfo({
    this.firstName,
    this.lastName,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        firstName: json["firstName"],
        lastName: json["lastName"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
      };
}

/**
 * REQ
 * {
    "groupId": 2,
    "isInvited": false
   }
 */

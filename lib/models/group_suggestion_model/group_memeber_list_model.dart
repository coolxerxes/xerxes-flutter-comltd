// To parse this JSON data, do
//
//     final groupMemeberListModel = groupMemeberListModelFromJson(jsonString);

import 'dart:convert';

import 'package:jyo_app/view_model/group_details_screen_vm.dart';

GroupMemeberListModel groupMemeberListModelFromJson(String str) =>
    GroupMemeberListModel.fromJson(json.decode(str));

String groupMemeberListModelToJson(GroupMemeberListModel data) =>
    json.encode(data.toJson());

class GroupMemeberListModel {
  int? status;
  String? message;
  List<Datum>? data;

  GroupMemeberListModel({
    this.status,
    this.message,
    this.data,
  });

  factory GroupMemeberListModel.fromJson(Map<String, dynamic> json) =>
      GroupMemeberListModel(
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
  int? id;
  String? status;
  String? role;
  User? user;

  Datum({
    this.id,
    this.status,
    this.user,
    this.role
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        status: json["status"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        role: json["role"]??GroupRoles.member
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
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
  String? profilePic;

  UserInfo({this.firstName, this.lastName, this.profilePic});

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        firstName: json["firstName"],
        lastName: json["lastName"],
        profilePic: json["profilePic"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
      };
}


/**
 * REQ
 *  {
    "groupId": 2,
    "isInvited": "true",
    "status": "Approved"
    }
 */
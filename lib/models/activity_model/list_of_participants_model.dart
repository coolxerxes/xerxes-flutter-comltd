// To parse this JSON data, do
//
//     final listOfParticipantsActivityResponse = listOfParticipantsActivityResponseFromJson(jsonString);

import 'dart:convert';

import '../../view_model/activity_details_screen_vm.dart';

ListOfParticipantsActivityResponse listOfParticipantsActivityResponseFromJson(
        String str) =>
    ListOfParticipantsActivityResponse.fromJson(json.decode(str));

String listOfParticipantsActivityResponseToJson(
        ListOfParticipantsActivityResponse data) =>
    json.encode(data.toJson());

class ListOfParticipantsActivityResponse {
  final int? status;
  final String? message;
  final List<Datum>? data;

  ListOfParticipantsActivityResponse({
    this.status,
    this.message,
    this.data,
  });

  factory ListOfParticipantsActivityResponse.fromJson(
          Map<String, dynamic> json) =>
      ListOfParticipantsActivityResponse(
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
  final int? activityId;
  final User? user;
  final String? role;

  Datum({
    this.activityId,
    this.role,
    this.user,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        activityId: json["activityId"],
        role: json["role"]??ActivityRoles.participant,
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "activityId": activityId,
        "user": user?.toJson(),
      };
}

class User {
  final int? id;
  final UserInfo? userInfo;

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
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? profilePic;

  UserInfo({
    this.id,
    this.firstName,
    this.lastName,
    this.profilePic,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        profilePic: json["profilePic"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "profilePic": profilePic,
      };
}

//Request
// {
//     "activityId": 12
// }
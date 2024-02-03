// To parse this JSON data, do
//
//     final activitySearchModel = activitySearchModelFromJson(jsonString);

import 'dart:convert';

import 'activity_request_list_model.dart';

ActivitySearchModel activitySearchModelFromJson(String str) =>
    ActivitySearchModel.fromJson(json.decode(str));

String activitySearchModelToJson(ActivitySearchModel data) =>
    json.encode(data.toJson());

class ActivitySearchModel {
  int? status;
  String? message;
  List<Datum>? data;

  ActivitySearchModel({
    this.status,
    this.message,
    this.data,
  });

  factory ActivitySearchModel.fromJson(Map<String, dynamic> json) =>
      ActivitySearchModel(
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
  String? activityName;
  String? coverImage;
  dynamic location;
  String? lat;
  String? long;
  String? createdAt;
  dynamic group;
  User? user;
  String? activityDate;

  Datum(
      {this.id,
      this.activityName,
      this.coverImage,
      this.location,
      this.lat,
      this.long,
      this.createdAt,
      this.group,
      this.user,
      this.activityDate});

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        activityName: json["activityName"],
        coverImage: json["coverImage"],
        location: json["location"],
        lat: json["lat"],
        long: json["long"],
        createdAt: json["createdAt"],
        activityDate: json["activityDate"],
        group: json["group"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "activityName": activityName,
        "coverImage": coverImage,
        "location": location,
        "lat": lat,
        "long": long,
        "createdAt": createdAt,
        "group": group,
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


/**
 * REQ
 * {
 *   /need to add userId as well.
    "activityName": "s"
  }
 */
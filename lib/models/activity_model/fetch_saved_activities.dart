// To parse this JSON data, do
//
//     final fetchSavedActivitiesModel = fetchSavedActivitiesModelFromJson(jsonString);

import 'dart:convert';

import 'package:jyo_app/models/activity_model/fetch_activities_model.dart';

FetchSavedActivitiesModel fetchSavedActivitiesModelFromJson(String str) =>
    FetchSavedActivitiesModel.fromJson(json.decode(str));

String fetchSavedActivitiesModelToJson(FetchSavedActivitiesModel data) =>
    json.encode(data.toJson());

class FetchSavedActivitiesModel {
  int? status;
  String? message;
  List<Datum>? data;

  FetchSavedActivitiesModel({
    this.status,
    this.message,
    this.data,
  });

  factory FetchSavedActivitiesModel.fromJson(Map<String, dynamic> json) =>
      FetchSavedActivitiesModel(
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
  int? userId;
  int? activityId;
  Activity? activity;
  List<ActivityParticipant>? userInfoData;

  Datum({
    this.id,
    this.userId,
    this.activityId,
    this.activity,
    this.userInfoData,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["userId"],
        activityId: json["activityId"],
        activity: json["activity"] == null
            ? null
            : Activity.fromJson(json["activity"]),
        userInfoData: json["userInfoData"] == null
            ? []
            : List<ActivityParticipant>.from(json["userInfoData"]!
                .map((x) => ActivityParticipant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "activityId": activityId,
        "activity": activity?.toJson(),
        "userInfoData": userInfoData == null
            ? []
            : List<dynamic>.from(userInfoData!.map((x) => x)),
      };
}

class Activity {
  int? id;
  dynamic groupId;
  String? activityName;
  String? activityDate;
  String? lat;
  String? long;
  dynamic group;
  bool? isMember;
  bool? isJoinedActivity;
  bool? isActivitySaved;
  bool? isInvited;

  Activity({
    this.id,
    this.groupId,
    this.activityName,
    this.activityDate,
    this.lat,
    this.long,
    this.group,
    this.isMember,
    this.isJoinedActivity,
    this.isActivitySaved,
    this.isInvited,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
      id: json["id"],
      groupId: json["groupId"],
      activityName: json["activityName"],
      activityDate: json["activityDate"],
      lat: json["lat"],
      long: json["long"],
      group: json["group"],
      isMember: json["isMember"] ?? false,
      isJoinedActivity: json["isJoinedActivity"] ?? false,
      isActivitySaved: json["isActivitySaved"] ?? false,
      isInvited: json["isInvited"] ?? false);

  Map<String, dynamic> toJson() => {
        "id": id,
        "groupId": groupId,
        "activityName": activityName,
        "activityDate": activityDate,
        //"location": location,
        "group": group,
      };
}

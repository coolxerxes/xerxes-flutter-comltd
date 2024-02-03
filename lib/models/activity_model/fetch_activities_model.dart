// To parse this JSON data, do
//
//     final fetchActivitiesModel = fetchActivitiesModelFromJson(jsonString);

import 'dart:convert';

FetchActivitiesModel fetchActivitiesModelFromJson(String str) =>
    FetchActivitiesModel.fromJson(json.decode(str));

String fetchActivitiesModelToJson(FetchActivitiesModel data) =>
    json.encode(data.toJson());

class FetchActivitiesModel {
  int? status;
  String? message;
  List<Datum>? data;

  FetchActivitiesModel({
    this.status,
    this.message,
    this.data,
  });

  factory FetchActivitiesModel.fromJson(Map<String, dynamic> json) =>
      FetchActivitiesModel(
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
  dynamic groupId;
  int? userId;
  String? activityName;
  String? activityAbout;
  List<int>? category;
  String? activityDate;
  String? lat;
  String? long;
  dynamic group;
  bool? isActivitySaved;
  bool? isMember;
  bool? isJoinedActivity;
  bool? isInvited;
  dynamic activityParticipantsCount;
  List<ActivityParticipant>? activityParticipants;

  Datum(
      {this.id,
      this.groupId,
      this.userId,
      this.activityName,
      this.activityAbout,
      this.category,
      this.activityDate,
      this.lat,
      this.long,
      this.group,
      this.activityParticipantsCount,
      this.activityParticipants,
      this.isActivitySaved,
      this.isMember,
      this.isInvited,
      this.isJoinedActivity,
      });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        groupId: json["groupId"],
        userId: json["userId"],
        activityName: json["activityName"],
        activityAbout: json["activityAbout"],
        category: json["category"] == null
            ? []
            : List<int>.from(json["category"]!.map((x) => x)),
        activityDate: json["activityDate"],
        lat: json["lat"],
        long: json["long"],
        group: json["group"],
        activityParticipantsCount: json["activityParticipantsCount"],
        activityParticipants: json["activityParticipants"] == null
            ? []
            : List<ActivityParticipant>.from(json["activityParticipants"]!
                .map((x) => ActivityParticipant.fromJson(x))),
        isMember: json["isMember"]??false,
        isJoinedActivity: json["isJoinedActivity"]??false,
        isActivitySaved: json["isActivitySaved"]??false,
        isInvited: json["isInvited"]??false
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "groupId": groupId,
        "userId": userId,
        "activityName": activityName,
        "activityAbout": activityAbout,
        "category":
            category == null ? [] : List<dynamic>.from(category!.map((x) => x)),
        "activityDate": activityDate,
        //"location": location,
        "group": group,
      };
}

class ActivityParticipant {
  int? userId;
  String? firstName;
  String? lastName;
  String? profilePic;

  ActivityParticipant({
    this.userId,
    this.firstName,
    this.lastName,
    this.profilePic,
  });

  factory ActivityParticipant.fromJson(Map<String, dynamic> json) =>
      ActivityParticipant(
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

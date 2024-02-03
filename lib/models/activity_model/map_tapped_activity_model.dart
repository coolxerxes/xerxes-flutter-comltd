// To parse this JSON data, do
//
//     final mapTappedActivityModel = mapTappedActivityModelFromJson(jsonString);

import 'dart:convert';

import 'fetch_activities_model.dart';

MapTappedActivityModel mapTappedActivityModelFromJson(String str) => MapTappedActivityModel.fromJson(json.decode(str));

String mapTappedActivityModelToJson(MapTappedActivityModel data) => json.encode(data.toJson());

class MapTappedActivityModel {
    int? status;
    String? message;
    List<Datum>? data;

    MapTappedActivityModel({
        this.status,
        this.message,
        this.data,
    });

    factory MapTappedActivityModel.fromJson(Map<String, dynamic> json) => MapTappedActivityModel(
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
    int? id;
    dynamic groupId;
    int? userId;
    String? activityName;
    String? activityAbout;
    String? coverImage;
    String? activityDate;
    String? lat;
    String? long;
    dynamic group;
    bool? isJoinedActivity;
    bool? isActivitySaved;
    bool? isMember;
    bool? isInvited;
    int? activityParticipantsCount;
    List<ActivityParticipant>? activityParticipants;

    Datum({
        this.id,
        this.groupId,
        this.userId,
        this.activityName,
        this.activityAbout,
        this.coverImage,
        this.activityDate,
        this.lat,
        this.long,
        this.group,
        this.isJoinedActivity,
        this.isActivitySaved,
        this.isMember,
        this.isInvited,
        this.activityParticipantsCount,
        this.activityParticipants,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        groupId: json["groupId"],
        userId: json["userId"],
        activityName: json["activityName"],
        activityAbout: json["activityAbout"],
        coverImage: json["coverImage"],
        activityDate: json["activityDate"],
        lat: json["lat"],
        long: json["long"],
        group: json["group"],
        isMember: json["isMember"] ?? false,
        isJoinedActivity: json["isJoinedActivity"] ?? false,
        isActivitySaved: json["isActivitySaved"] ?? false,
        isInvited: json["isInvited"] ?? false,
        activityParticipantsCount: json["activityParticipantsCount"],
        activityParticipants: json["activityParticipants"] == null ? [] : List<ActivityParticipant>.from(json["activityParticipants"]!.map((x) => ActivityParticipant.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "groupId": groupId,
        "userId": userId,
        "activityName": activityName,
        "activityAbout": activityAbout,
        "coverImage": coverImage,
        "activityDate": activityDate,
        "lat": lat,
        "long": long,
        "group": group,
        "isJoinedActivity": isJoinedActivity,
        "isActivitySaved": isActivitySaved,
        "activityParticipantsCount": activityParticipantsCount,
        "activityParticipants": activityParticipants == null ? [] : List<dynamic>.from(activityParticipants!.map((x) => x)),
    };
}

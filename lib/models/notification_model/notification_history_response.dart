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
  int? status;
  String? message;
  List<Datum>? data;

  NotificationHistoryResponseModel({
    this.status,
    this.message,
    this.data,
  });

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
  int? id;
  int? userId;
  int? friendId;
  String? friendName;
  String? notificationType;
  int? relatedId;
  String? relatedName;
  String? relatedImage;
  String? createdDate;

  Datum({
    this.id,
    this.userId,
    this.friendId,
    this.friendName,
    this.notificationType,
    this.relatedId,
    this.relatedName,
    this.relatedImage,
    this.createdDate,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["userId"],
        friendId: json["friendId"],
        friendName: json["friendName"] ?? "",
        notificationType: json["notificationType"],
        relatedId: json["relatedId"],
        relatedName: json["relatedName"] ?? "",
        relatedImage: json["relatedImage"],
        createdDate: json["createdDate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "friendId": friendId,
        "friendName": friendName,
        "notificationType": notificationType,
        "relatedId": relatedId,
        "relatedName": relatedName,
        "relatedImage": relatedImage,
        "createdDate": createdDate,
      };
}

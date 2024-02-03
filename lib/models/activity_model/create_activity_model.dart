// To parse this JSON data, do
//
//     final createActivityModel = createActivityModelFromJson(jsonString);

import 'dart:convert';

CreateActivityModel createActivityModelFromJson(String str) =>
    CreateActivityModel.fromJson(json.decode(str));

String createActivityModelToJson(CreateActivityModel data) =>
    json.encode(data.toJson());

class CreateActivityModel {
  int? status;
  String? message;
  Data? data;

  CreateActivityModel({
    this.status,
    this.message,
    this.data,
  });

  factory CreateActivityModel.fromJson(Map<String, dynamic> json) =>
      CreateActivityModel(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  dynamic id;
  dynamic userId;
  dynamic groupId;
  String? activityName;
  String? activityAbout;
  List<int>? category;
  String? activityDate;
  String? coverImage;
  bool? limitParticipants;
  String? location;
  bool? privateActivity;
  bool? byApproval;
  String? ageRequirement;
  dynamic maxParticipants;
  String? createdAt;
  dynamic postId;

  Data({
    this.id,
    this.userId,
    this.groupId,
    this.activityName,
    this.activityAbout,
    this.category,
    this.activityDate,
    this.coverImage,
    this.limitParticipants,
    this.location,
    this.privateActivity,
    this.byApproval,
    this.ageRequirement,
    this.maxParticipants,
    this.createdAt,
    this.postId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"] ?? "",
        userId: json["userId"] ?? "",
        groupId: json["groupId"] ?? "",
        activityName: json["activityName"] ?? "",
        activityAbout: json["activityAbout"] ?? "",
        category: json["category"] == null
            ? []
            : List<int>.from(json["category"]!.map((x) => x)),
        activityDate: json["activityDate"] ?? "",
        coverImage: json["coverImage"] ?? "",
        limitParticipants: json["limitParticipants"] ?? false,
        location: json["location"] ?? "",
        privateActivity: json["privateActivity"] ?? false,
        byApproval: json["byApproval"] ?? false,
        ageRequirement: json["ageRequirement"] ?? "",
        maxParticipants: json["maxParticipants"] ?? 10,
        createdAt: json["createdAt"] ?? "",
        postId: json["postId"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "groupId": groupId,
        "activityName": activityName,
        "activityAbout": activityAbout,
        "category":
            category == null ? [] : List<dynamic>.from(category!.map((x) => x)),
        "activityDate": activityDate,
        "coverImage": coverImage,
        "limitParticipants": limitParticipants,
        "location": location,
        "privateActivity": privateActivity,
        "byApproval": byApproval,
        "ageRequirement": ageRequirement,
        "maxParticipants": maxParticipants,
        "createdAt": createdAt,
        "postId": postId,
      };
}

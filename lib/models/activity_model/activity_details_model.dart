// To parse this JSON data, do
//
//     final activityDetailsModel = activityDetailsModelFromJson(jsonString);

import 'dart:convert';

ActivityDetailsModel activityDetailsModelFromJson(String str) =>
    ActivityDetailsModel.fromJson(json.decode(str));

String activityDetailsModelToJson(ActivityDetailsModel data) =>
    json.encode(data.toJson());

class ActivityDetailsModel {
  int? status;
  String? message;
  Data? data;

  ActivityDetailsModel({
    this.status,
    this.message,
    this.data,
  });

  factory ActivityDetailsModel.fromJson(Map<String, dynamic> json) =>
      ActivityDetailsModel(
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
  int? id;
  int? userId;
  dynamic groupId;
  String? activityName;
  String? activityAbout;
  List<Category>? category;
  String? activityDate;
  String? coverImage;
  bool? limitParticipants;
  String? lat;
  String? long;
  bool? privateActivity;
  bool? byApproval;
  String? ageRequirement;
  dynamic maxParticipants;
  String? createdAt;
  ActivityHost? activityHost;
  bool? isMember;
  bool? isJoinedActivity;
  bool? isActivitySaved;
  String? role;
  String? spotsLeft;
  bool? isInvited;
  int? activityParticipantsCount;

  Data(
      {this.id,
      this.userId,
      this.groupId,
      this.activityName,
      this.activityAbout,
      this.category,
      this.activityDate,
      this.coverImage,
      this.limitParticipants,
      this.lat,
      this.long,
      this.privateActivity,
      this.byApproval,
      this.ageRequirement,
      this.maxParticipants,
      this.createdAt,
      this.activityHost,
      this.isMember,
      this.isJoinedActivity,
      this.isActivitySaved,
      this.isInvited,
      this.activityParticipantsCount,
      this.spotsLeft,
      this.role});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["userId"],
        groupId: json["groupId"],
        activityName: json["activityName"],
        activityAbout: json["activityAbout"],
        category: json["category"] == null
            ? []
            : List<Category>.from(
                json["category"]!.map((x) => Category.fromJson(x))),
        activityDate: json["activityDate"],
        coverImage: json["coverImage"],
        limitParticipants: json["limitParticipants"],
        lat: json["lat"],
        long: json["long"],
        privateActivity: json["privateActivity"],
        byApproval: json["byApproval"],
        ageRequirement: json["ageRequirement"],
        maxParticipants: json["maxParticipants"],
        activityParticipantsCount: json["activityParticipantsCount"],
        createdAt: json["createdAt"],
        isMember: json["isMember"] ?? false,
        isJoinedActivity: json["isJoinedActivity"] ?? false,
        isActivitySaved: json["isActivitySaved"] ?? false,
        role: json["role"] ?? "Participant",
        isInvited: json["isInvited"] ?? false,
        spotsLeft: (json["spotsLeft"] ?? "").toString(),
        activityHost: json["activityHost"] == null
            ? null
            : ActivityHost.fromJson(json["activityHost"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "groupId": groupId,
        "activityName": activityName,
        "activityAbout": activityAbout,
        "category": category == null
            ? []
            : List<dynamic>.from(category!.map((x) => x.toJson())),
        "activityDate": activityDate,
        "coverImage": coverImage,
        "limitParticipants": limitParticipants,
        //"location": location,
        "privateActivity": privateActivity,
        "byApproval": byApproval,
        "ageRequirement": ageRequirement,
        "maxParticipants": maxParticipants,
        "createdAt": createdAt,
        "isJoinedActivity": isJoinedActivity,
        "activityHost": activityHost?.toJson(),
      };
}

class ActivityHost {
  int? userId;
  String? firstName;
  String? lastName;
  String? profilePic;

  ActivityHost({
    this.userId,
    this.firstName,
    this.lastName,
    this.profilePic,
  });

  factory ActivityHost.fromJson(Map<String, dynamic> json) => ActivityHost(
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

class Category {
  int? id;
  String? name;
  String? icon;

  Category({
    this.id,
    this.name,
    this.icon,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "icon": icon,
      };
}

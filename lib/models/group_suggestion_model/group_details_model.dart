// To parse this JSON data, do
//
//     final groupDetailsModel = groupDetailsModelFromJson(jsonString);

import 'dart:convert';

import '../activity_model/activity_details_model.dart';

GroupDetailsModel groupDetailsModelFromJson(String str) =>
    GroupDetailsModel.fromJson(json.decode(str));

String groupDetailsModelToJson(GroupDetailsModel data) =>
    json.encode(data.toJson());

class GroupDetailsModel {
  int? status;
  String? message;
  GroupDetail? data;

  GroupDetailsModel({
    this.status,
    this.message,
    this.data,
  });

  factory GroupDetailsModel.fromJson(Map<String, dynamic> json) =>
      GroupDetailsModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : GroupDetail.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class GroupDetail {
  int? id;
  int? userId;
  String? groupName;
  String? groupImage;
  String? about;
  List<Category>? category;
  bool? isPrivateGroup;
  bool? requireAcceptance;
  String? createdAt;
  bool? isMember;
  String? role;
  dynamic activityCount;
  dynamic memberCount;
  bool? isInvited;
  bool? isJoinedGroup;

  GroupDetail(
      {this.id,
      this.userId,
      this.groupName,
      this.groupImage,
      this.about,
      this.category,
      this.isPrivateGroup,
      this.requireAcceptance,
      this.createdAt,
      this.isMember,
      this.role,
      this.activityCount,
      this.memberCount,
      this.isJoinedGroup,
      this.isInvited});

  factory GroupDetail.fromJson(Map<String, dynamic> json) => GroupDetail(
      id: json["id"],
      userId: json["userId"],
      groupName: json["groupName"],
      groupImage: json["groupImage"],
      about: json["about"],
      category: json["category"] == null
          ? []
          : List<Category>.from(
              json["category"]!.map((x) => Category.fromJson(x))),
      isPrivateGroup: json["isPrivateGroup"],
      requireAcceptance: json["requireAcceptance"],
      createdAt: json["createdAt"],
      isMember: json["isMember"] ?? false,
      isInvited: json["isInvited"] ?? false,
      isJoinedGroup: json["isJoinedGroup"] ?? false,
      role: json["role"],
      memberCount: json["memberCount"] ?? 0,
      activityCount: json["activityCount"] ?? 0);

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "groupName": groupName,
        "groupImage": groupImage,
        "about": about,
        "category": category == null
            ? []
            : List<dynamic>.from(category!.map((x) => x.toJson())),
        "isPrivateGroup": isPrivateGroup,
        "requireAcceptance": requireAcceptance,
        "createdAt": createdAt,
        "isMember": isMember,
        "role": role,
      };
}

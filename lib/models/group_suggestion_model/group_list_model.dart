// To parse this JSON data, do
//
//     final groupListModel = groupListModelFromJson(jsonString);

import 'dart:convert';

GroupListModel groupListModelFromJson(String str) =>
    GroupListModel.fromJson(json.decode(str));

String groupListModelToJson(GroupListModel data) => json.encode(data.toJson());

class GroupListModel {
  int? status;
  String? message;
  List<GroupData>? data;

  GroupListModel({
    this.status,
    this.message,
    this.data,
  });

  factory GroupListModel.fromJson(Map<String, dynamic> json) => GroupListModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<GroupData>.from(
                json["data"]!.map((x) => GroupData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class GroupData {
  int? groupId;
  String? status;
  String? role;
  Group? group;
  int? memberCount;
  bool? isMember;
  bool? isJoinedGroup;
  bool? isInvited;

  GroupData(
      {this.groupId,
      this.status,
      this.role,
      this.group,
      this.memberCount,
      this.isMember,
      this.isJoinedGroup,
      this.isInvited});

  factory GroupData.fromJson(Map<String, dynamic> json) => GroupData(
        groupId: json["groupId"],
        status: json["status"],
        role: json["role"],
        group: json["group"] == null ? null : Group.fromJson(json["group"]),
        memberCount: json["memberCount"],
      );

  Map<String, dynamic> toJson() => {
        "groupId": groupId,
        "status": status,
        "role": role,
        "group": group?.toJson(),
        "memberCount": memberCount,
      };
}

class Group {
  int? id;
  String? groupName;
  String? groupImage;

  Group({
    this.id,
    this.groupName,
    this.groupImage,
  });

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        id: json["id"],
        groupName: json["groupName"],
        groupImage: json["groupImage"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "groupName": groupName,
        "groupImage": groupImage,
      };
}

// To parse this JSON data, do
//
//     final groupSearchModel = groupSearchModelFromJson(jsonString);

import 'dart:convert';

GroupSearchModel groupSearchModelFromJson(String str) =>
    GroupSearchModel.fromJson(json.decode(str));

String groupSearchModelToJson(GroupSearchModel data) =>
    json.encode(data.toJson());

class GroupSearchModel {
  int? status;
  String? message;
  List<Datum>? data;

  GroupSearchModel({
    this.status,
    this.message,
    this.data,
  });

  factory GroupSearchModel.fromJson(Map<String, dynamic> json) =>
      GroupSearchModel(
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
  String? groupName;
  String? groupImage;
  bool? isMember;
  int? memberCount;
  bool? isJoinedGroup;
  bool? isInvited;

  Datum(
      {this.id,
      this.groupName,
      this.groupImage,
      this.isMember,
      this.memberCount,
      this.isJoinedGroup,
      this.isInvited});

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        groupName: json["groupName"],
        groupImage: json["groupImage"],
        isMember: json["isMember"] ?? false,
        isInvited: json["isInvited"] ?? false,
        isJoinedGroup: json["isJoinedGroup"] ?? false,
        memberCount: json["memberCount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "groupName": groupName,
        "groupImage": groupImage,
        "isMember": isMember,
        "memberCount": memberCount,
      };
}

/**
 * REQ
 * {
    "groupName": "gri",
    "userId": 1
  }
 * 
 */
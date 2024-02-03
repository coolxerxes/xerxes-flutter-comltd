// To parse this JSON data, do
//
//     final groupCreateModel = groupCreateModelFromJson(jsonString);

import 'dart:convert';

GroupCreateModel groupCreateModelFromJson(String str) => GroupCreateModel.fromJson(json.decode(str));

String groupCreateModelToJson(GroupCreateModel data) => json.encode(data.toJson());

class GroupCreateModel {
    GroupCreateModel({
        this.status,
        this.message,
        this.data,
    });

    int? status;
    String? message;
    Data? data;

    factory GroupCreateModel.fromJson(Map<String, dynamic> json) => GroupCreateModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    Data({
        this.id,
        this.userId,
        this.groupName,
        this.about,
        this.groupImage,
        this.category,
        this.isPrivateGroup,
        this.requireAcceptance,
        this.createdAt,
    });

    int? id;
    int? userId;
    String? groupName;
    String? about;
    String? groupImage;
    List<int>? category;
    bool? isPrivateGroup;
    bool? requireAcceptance;
    String? createdAt;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["userId"],
        groupName: json["groupName"],
        about: json["about"],
        groupImage: json["groupImage"],
        category: json["category"] == null ? [] : List<int>.from(json["category"]!.map((x) => x)),
        isPrivateGroup: json["isPrivateGroup"],
        requireAcceptance: json["requireAcceptance"],
        createdAt: json["createdAt"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "groupName": groupName,
        "about": about,
        "groupImage": groupImage,
        "category": category == null ? [] : List<dynamic>.from(category!.map((x) => x)),
        "isPrivateGroup": isPrivateGroup,
        "requireAcceptance": requireAcceptance,
        "createdAt": createdAt,
    };
}

/**
 * REQ
 * {
    "userId": 2,
    "groupName": "Griffyndor",
    "about": "This the group of my friends in Griffyndor.",
    "groupImage": "image.jpg",
    "category": [1, 2, 4],
    "isPrivateGroup": true,
    "requireAcceptance": true
   }
 */

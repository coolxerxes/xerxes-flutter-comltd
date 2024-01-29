// To parse this JSON data, do
//
//     final getPostResponseModel = getPostResponseModelFromJson(jsonString);

import 'dart:convert';

GetPostResponseModel getPostResponseModelFromJson(String str) => GetPostResponseModel.fromJson(json.decode(str));

String getPostResponseModelToJson(GetPostResponseModel data) => json.encode(data.toJson());

class GetPostResponseModel {
    GetPostResponseModel({
        this.status,
        this.message,
        this.data,
    });

    int? status;
    String? message;
    Data? data;

    factory GetPostResponseModel.fromJson(Map<String, dynamic> json) => GetPostResponseModel(
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
        this.text,
        this.postDate,
        this.attachment,
        this.activityId,
        this.topicTags,
        this.userTags,
        this.groupId,
        this.visible,
        this.createdAt,
        this.updatedAt,
    });

    int? id;
    int? userId;
    String? text;
    String? postDate;
    List<String>? attachment;
    dynamic activityId;
    dynamic topicTags;
    List<int>? userTags;
    dynamic groupId;
    String? visible;
    String? createdAt;
    String? updatedAt;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["userId"],
        text: json["text"],
        postDate: json["postDate"],
        attachment: json["attachment"] == null ? [] : List<String>.from(json["attachment"]!.map((x) => x)),
        activityId: json["activityId"],
        topicTags: json["topicTags"],
        userTags: json["userTags"] == null ? [] : List<int>.from(json["userTags"]!.map((x) => x)),
        groupId: json["groupId"],
        visible: json["visible"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "text": text,
        "postDate": postDate,
        "attachment": attachment == null ? [] : List<dynamic>.from(attachment!.map((x) => x)),
        "activityId": activityId,
        "topicTags": topicTags,
        "userTags": userTags == null ? [] : List<dynamic>.from(userTags!.map((x) => x)),
        "groupId": groupId,
        "visible": visible,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
    };
}

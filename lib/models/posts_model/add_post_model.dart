// To parse this JSON data, do
//
//     final addPostResponseModel = addPostResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:jyo_app/models/posts_model/timeline_model.dart';

AddPostResponseModel addPostResponseModelFromJson(String str) => AddPostResponseModel.fromJson(json.decode(str));

String addPostResponseModelToJson(AddPostResponseModel data) => json.encode(data.toJson());

class AddPostResponseModel {
    AddPostResponseModel({
        this.status,
        this.message,
        this.data,
    });

    int? status;
    String? message;
    Data? data;

    factory AddPostResponseModel.fromJson(Map<String, dynamic> json) => AddPostResponseModel(
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
        this.attachment,
        this.userTags,
        this.visible,
        this.postDate,
        this.createdAt,
        this.activityId,
        this.topicTags,
        this.groupId,
        this.updatedAt,
    });

    int? id;
    int? userId;
    String? text;
    List<Attachment>? attachment;
    List<int>? userTags;
    String? visible;
    String? postDate;
    String? createdAt;
    dynamic activityId;
    dynamic topicTags;
    dynamic groupId;
    dynamic updatedAt;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["userId"],
        text: json["text"],
        attachment: (json["attachment"] == null || json["attachment"] == "null" )
            ? []
            : List<Attachment>.from(jsonDecode(json["attachment"])
                .map((x) => Attachment.fromJson(x))),
        userTags: json["userTags"] == null ? [] : List<int>.from(json["userTags"]!.map((x) => x)),
        visible: json["visible"],
        postDate: json["postDate"],
        createdAt: json["createdAt"],
        activityId: json["activityId"],
        topicTags: json["topicTags"],
        groupId: json["groupId"],
        updatedAt: json["updatedAt"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "text": text,
        "attachment": attachment == null ? [] : List<dynamic>.from(attachment!.map((x) => x)),
        "userTags": userTags == null ? [] : List<dynamic>.from(userTags!.map((x) => x)),
        "visible": visible,
        "postDate": postDate,
        "createdAt": createdAt,
        "activityId": activityId,
        "topicTags": topicTags,
        "groupId": groupId,
        "updatedAt": updatedAt,
    };
}

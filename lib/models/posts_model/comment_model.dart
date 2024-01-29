// To parse this JSON data, do
//
//     final commentResponseModel = commentResponseModelFromJson(jsonString);

import 'dart:convert';

CommentResponseModel commentResponseModelFromJson(String str) => CommentResponseModel.fromJson(json.decode(str));

String commentResponseModelToJson(CommentResponseModel data) => json.encode(data.toJson());

class CommentResponseModel {
    CommentResponseModel({
        this.status,
        this.message,
        this.data,
    });

    int? status;
    String? message;
    Data? data;

    factory CommentResponseModel.fromJson(Map<String, dynamic> json) => CommentResponseModel(
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
        this.postId,
        this.comment,
        this.attachment,
        this.repliedTo,
        this.createdAt,
        this.updatedAt,
    });

    int? id;
    int? userId;
    int? postId;
    String? comment;
    List<String>? attachment;
    int? repliedTo;
    String? createdAt;
    dynamic updatedAt;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["userId"],
        postId: json["postId"],
        comment: json["comment"],
        attachment: json["attachment"] == null ? [] : List<String>.from(json["attachment"]!.map((x) => x)),
        repliedTo: json["repliedTo"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "postId": postId,
        "comment": comment,
        "attachment": attachment == null ? [] : List<dynamic>.from(attachment!.map((x) => x)),
        "repliedTo": repliedTo,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
    };
}

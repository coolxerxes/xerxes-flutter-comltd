// To parse this JSON data, do
//
//     final likeCommentModel = likeCommentModelFromJson(jsonString);

import 'dart:convert';

LikeCommentModel likeCommentModelFromJson(String str) => LikeCommentModel.fromJson(json.decode(str));

String likeCommentModelToJson(LikeCommentModel data) => json.encode(data.toJson());

class LikeCommentModel {
    LikeCommentModel({
        this.status,
        this.message,
        this.data,
    });

    int? status;
    String? message;
    Data? data;

    factory LikeCommentModel.fromJson(Map<String, dynamic> json) => LikeCommentModel(
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
        this.commentId,
        this.userId,
        this.likeDate,
    });

    int? id;
    int? commentId;
    int? userId;
    String? likeDate;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        commentId: json["commentId"],
        userId: json["userId"],
        likeDate: json["likeDate"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "commentId": commentId,
        "userId": userId,
        "likeDate": likeDate,
    };
}

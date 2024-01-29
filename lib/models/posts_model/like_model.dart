// To parse this JSON data, do
//
//     final likeResponseModel = likeResponseModelFromJson(jsonString);

import 'dart:convert';

LikeResponseModel likeResponseModelFromJson(String str) => LikeResponseModel.fromJson(json.decode(str));

String likeResponseModelToJson(LikeResponseModel data) => json.encode(data.toJson());

class LikeResponseModel {
    LikeResponseModel({
        this.status,
        this.message,
        this.data,
    });

    int? status;
    String? message;
    Data? data;

    factory LikeResponseModel.fromJson(Map<String, dynamic> json) => LikeResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : json["data"] is Map ? Data.fromJson(json["data"]) : Data(),
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
        this.likeDate,
    });

    int? id;
    int? userId;
    int? postId;
    String? likeDate;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"]??0,
        userId: json["userId"]??0,
        postId: json["postId"]??0,
        likeDate: json["likeDate"]??"",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "postId": postId,
        "likeDate": likeDate,
    };
}

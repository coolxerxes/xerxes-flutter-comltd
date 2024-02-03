// To parse this JSON data, do
//
//     final activityCommentResponse = activityCommentResponseFromJson(jsonString);

import 'dart:convert';

ActivityCommentResponse activityCommentResponseFromJson(String str) => ActivityCommentResponse.fromJson(json.decode(str));

String activityCommentResponseToJson(ActivityCommentResponse data) => json.encode(data.toJson());

class ActivityCommentResponse {
    final int? status;
    final String? message;
    final Data? data;

    ActivityCommentResponse({
        this.status,
        this.message,
        this.data,
    });

    factory ActivityCommentResponse.fromJson(Map<String, dynamic> json) => ActivityCommentResponse(
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
    final int? id;
    final int? userId;
    final String? comment;
    final int? activityId;
    final dynamic createdAt;
    final dynamic updatedAt;

    Data({
        this.id,
        this.userId,
        this.comment,
        this.activityId,
        this.createdAt,
        this.updatedAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["userId"],
        comment: json["comment"],
        activityId: json["activityId"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "comment": comment,
        "activityId": activityId,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
    };
}


// Request
// {
//     "userId": 7,
//     "comment": "commentinggggg.",
//     "activityId": 12
// }
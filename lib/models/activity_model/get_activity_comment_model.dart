// To parse this JSON data, do
//
//     final getActivityCommentResponse = getActivityCommentResponseFromJson(jsonString);

import 'dart:convert';

GetActivityCommentResponse getActivityCommentResponseFromJson(String str) => GetActivityCommentResponse.fromJson(json.decode(str));

String getActivityCommentResponseToJson(GetActivityCommentResponse data) => json.encode(data.toJson());

class GetActivityCommentResponse {
    final int? status;
    final String? message;
    final List<Datum>? data;

    GetActivityCommentResponse({
        this.status,
        this.message,
        this.data,
    });

    factory GetActivityCommentResponse.fromJson(Map<String, dynamic> json) => GetActivityCommentResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    final int? id;
    final int? userId;
    final int? activityId;
    final String? comment;
    final dynamic createdAt;
    final dynamic updatedAt;

    Datum({
        this.id,
        this.userId,
        this.activityId,
        this.comment,
        this.createdAt,
        this.updatedAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["userId"],
        activityId: json["activityId"],
        comment: json["comment"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "activityId": activityId,
        "comment": comment,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
    };
}


// Request 
// {
//     "activityId": 12
// }
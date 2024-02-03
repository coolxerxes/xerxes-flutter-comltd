// To parse this JSON data, do
//
//     final joinActivityResponse = joinActivityResponseFromJson(jsonString);

import 'dart:convert';

JoinActivityResponse joinActivityResponseFromJson(String str) => JoinActivityResponse.fromJson(json.decode(str));

String joinActivityResponseToJson(JoinActivityResponse data) => json.encode(data.toJson());

class JoinActivityResponse {
    final int? status;
    final String? message;
    final Data? data;

    JoinActivityResponse({
        this.status,
        this.message,
        this.data,
    });

    factory JoinActivityResponse.fromJson(Map<String, dynamic> json) => JoinActivityResponse(
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
    final int? activityId;
    final String? status;
    final bool? isInvited;
    final String? createdAt;

    Data({
        this.id,
        this.userId,
        this.activityId,
        this.status,
        this.isInvited,
        this.createdAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["userId"],
        activityId: json["activityId"],
        status: json["status"],
        isInvited: json["isInvited"],
        createdAt: json["createdAt"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "activityId": activityId,
        "status": status,
        "isInvited": isInvited,
        "createdAt": createdAt,
    };
}


// Request
// {
//      "userId": 7,
//      "activityId": 12   
// }
// To parse this JSON data, do
//
//     final inviteToActivityResponse = inviteToActivityResponseFromJson(jsonString);

import 'dart:convert';

InviteToActivityResponse inviteToActivityResponseFromJson(String str) => InviteToActivityResponse.fromJson(json.decode(str));

String inviteToActivityResponseToJson(InviteToActivityResponse data) => json.encode(data.toJson());

class InviteToActivityResponse {
    final int? status;
    final String? message;
    final Data? data;

    InviteToActivityResponse({
        this.status,
        this.message,
        this.data,
    });

    factory InviteToActivityResponse.fromJson(Map<String, dynamic> json) => InviteToActivityResponse(
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
    Data();

    factory Data.fromJson(Map<String, dynamic> json) => Data(
    );

    Map<String, dynamic> toJson() => {
    };
}

/**
 * REQUEST.
 * {
  "activityId": 12,
  "userArray": [7],
  "hostId": 35
}
 */

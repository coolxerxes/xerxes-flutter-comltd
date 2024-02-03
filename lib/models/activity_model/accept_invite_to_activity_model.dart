// To parse this JSON data, do
//
//     final acceptInviteToActivityResponse = acceptInviteToActivityResponseFromJson(jsonString);

import 'dart:convert';

AcceptInviteToActivityResponse acceptInviteToActivityResponseFromJson(
        String str) =>
    AcceptInviteToActivityResponse.fromJson(json.decode(str));

String acceptInviteToActivityResponseToJson(
        AcceptInviteToActivityResponse data) =>
    json.encode(data.toJson());

class AcceptInviteToActivityResponse {
  final int? status;
  final String? message;
  final List<int>? data;

  AcceptInviteToActivityResponse({
    this.status,
    this.message,
    this.data,
  });

  factory AcceptInviteToActivityResponse.fromJson(Map<String, dynamic> json) =>
      AcceptInviteToActivityResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : json["data"] is List
                ? List<int>.from(json["data"]!.map((x) => x))
                : [],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
      };
}

//REQUEST
// {
//   "userId": 7,
//   "activityId": 12
// }
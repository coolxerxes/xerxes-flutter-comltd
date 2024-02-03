// To parse this JSON data, do
//
//     final leaveActivityResponse = leaveActivityResponseFromJson(jsonString);

import 'dart:convert';


LeaveActivityResponse leaveActivityResponseFromJson(String str) => LeaveActivityResponse.fromJson(json.decode(str));

String leaveActivityResponseToJson(LeaveActivityResponse data) => json.encode(data.toJson());

class LeaveActivityResponse {
    final int? status;
    final String? message;
    final Data? data;

    LeaveActivityResponse({
        this.status,
        this.message,
        this.data,
    });

    factory LeaveActivityResponse.fromJson(Map<String, dynamic> json) => LeaveActivityResponse(
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

// Request
// {
//   "userId": 7,
//   "activityId": 12
// }
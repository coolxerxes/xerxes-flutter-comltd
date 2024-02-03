// To parse this JSON data, do
//
//     final rejectInviteActivityResponse = rejectInviteActivityResponseFromJson(jsonString);

import 'dart:convert';


RejectInviteActivityResponse rejectInviteActivityResponseFromJson(String str) => RejectInviteActivityResponse.fromJson(json.decode(str));

String rejectInviteActivityResponseToJson(RejectInviteActivityResponse data) => json.encode(data.toJson());

class RejectInviteActivityResponse {
    final int? status;
    final String? message;
    final int? data;

    RejectInviteActivityResponse({
        this.status,
        this.message,
        this.data,
    });

    factory RejectInviteActivityResponse.fromJson(Map<String, dynamic> json) => RejectInviteActivityResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data,
    };
}

// Request{
//   "userId": 7,
//   "activityId": 12
// }
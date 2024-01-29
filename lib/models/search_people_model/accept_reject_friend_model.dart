// To parse this JSON data, do
//
//     final acceptOrRejectFriendRequest = acceptOrRejectFriendRequestFromJson(jsonString);

import 'dart:convert';

AcceptOrRejectFriendRequest acceptOrRejectFriendRequestFromJson(String str) => AcceptOrRejectFriendRequest.fromJson(json.decode(str));

String acceptOrRejectFriendRequestToJson(AcceptOrRejectFriendRequest data) => json.encode(data.toJson());

class AcceptOrRejectFriendRequest {
    AcceptOrRejectFriendRequest({
        this.status,
        this.message,
        this.data,
    });

    int? status;
    String? message;
    List<int>? data;

    factory AcceptOrRejectFriendRequest.fromJson(Map<String, dynamic> json) => AcceptOrRejectFriendRequest(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : json["data"] is List ? List<int>.from(json["data"]!.map((x) => x)):[],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
    };
}

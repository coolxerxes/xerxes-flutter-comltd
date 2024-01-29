// To parse this JSON data, do
//
//     final fetchFriendListResponse = fetchFriendListResponseFromJson(jsonString);

import 'dart:convert';

FetchFriendListResponse fetchFriendListResponseFromJson(String str) => FetchFriendListResponse.fromJson(json.decode(str));

String fetchFriendListResponseToJson(FetchFriendListResponse data) => json.encode(data.toJson());

class FetchFriendListResponse {
    FetchFriendListResponse({
        this.status,
        this.message,
        this.data,
    });

    dynamic status;
    String? message;
    Data? data;

    factory FetchFriendListResponse.fromJson(Map<String, dynamic> json) => FetchFriendListResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? null : data!.toJson(),
    };
}

class Data {
    Data();

    factory Data.fromJson(Map<String, dynamic> json) => Data(
    );

    Map<String, dynamic> toJson() => {
    };
}

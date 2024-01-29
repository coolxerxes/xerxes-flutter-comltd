// To parse this JSON data, do
//
//     final notificationApiResponse = notificationApiResponseFromJson(jsonString);

import 'dart:convert';

NotificationApiResponse notificationApiResponseFromJson(String str) => NotificationApiResponse.fromJson(json.decode(str));

String notificationApiResponseToJson(NotificationApiResponse data) => json.encode(data.toJson());

class NotificationApiResponse {
    NotificationApiResponse({
        this.status,
        this.message,
        this.data,
    });

    dynamic status;
    String? message;
    Data? data;

    factory NotificationApiResponse.fromJson(Map<String, dynamic> json) => NotificationApiResponse(
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

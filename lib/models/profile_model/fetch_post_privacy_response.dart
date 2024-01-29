// To parse this JSON data, do
//
//     final fetchPostPrivacyResponse = fetchPostPrivacyResponseFromJson(jsonString);

import 'dart:convert';

FetchPostPrivacyResponse fetchPostPrivacyResponseFromJson(String str) => FetchPostPrivacyResponse.fromJson(json.decode(str));

String fetchPostPrivacyResponseToJson(FetchPostPrivacyResponse data) => json.encode(data.toJson());

class FetchPostPrivacyResponse {
    FetchPostPrivacyResponse({
        this.status,
        this.message,
        this.data,
    });

    dynamic status;
    String? message;
    Data? data;

    factory FetchPostPrivacyResponse.fromJson(Map<String, dynamic> json) => FetchPostPrivacyResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]??{}),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? null : data!.toJson(),
    };
}

class Data {
    Data({
        this.id,
        this.userId,
        this.postPrivacy,
        this.hidePostFrom,
        this.hidePostFromCount,
    });

    dynamic id;
    dynamic userId;
    String? postPrivacy;
    List<dynamic>? hidePostFrom;
    dynamic hidePostFromCount;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["userId"],
        postPrivacy: json["postPrivacy"],
        hidePostFrom: json["hidePostFrom"]??[],
        hidePostFromCount: json["hidePostFromCount"] ?? [],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "postPrivacy": postPrivacy,
        "hidePostFrom": hidePostFrom,
        "hidePostFromCount": hidePostFromCount,
    };
}

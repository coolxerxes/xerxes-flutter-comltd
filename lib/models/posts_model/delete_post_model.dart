// To parse this JSON data, do
//
//     final deletePostResponse = deletePostResponseFromJson(jsonString);

import 'dart:convert';

DeletePostResponse deletePostResponseFromJson(String str) => DeletePostResponse.fromJson(json.decode(str));

String deletePostResponseToJson(DeletePostResponse data) => json.encode(data.toJson());

class DeletePostResponse {
    DeletePostResponse({
        this.status,
        this.message,
        this.data,
    });

    int? status;
    String? message;
    int? data;

    factory DeletePostResponse.fromJson(Map<String, dynamic> json) => DeletePostResponse(
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

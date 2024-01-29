// To parse this JSON data, do
//
//     final uploadProfileResponse = uploadProfileResponseFromJson(jsonString);

import 'dart:convert';

UploadProfileResponse uploadProfileResponseFromJson(String str) => UploadProfileResponse.fromJson(json.decode(str));

String uploadProfileResponseToJson(UploadProfileResponse data) => json.encode(data.toJson());

class UploadProfileResponse {
    UploadProfileResponse({
        this.status,
        this.message,
        this.data,
    });

    dynamic status;
    String? message;
    Data? data;

    factory UploadProfileResponse.fromJson(Map<String, dynamic> json) => UploadProfileResponse(
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
    Data({
        this.id,
        this.originalFileName,
        this.s3FileName,
    });

    String? id;
    String? originalFileName;
    String? s3FileName;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        originalFileName: json["originalFileName"],
        s3FileName: json["s3FileName"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "originalFileName": originalFileName,
        "s3FileName": s3FileName,
    };
}

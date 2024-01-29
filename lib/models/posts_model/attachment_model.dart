// To parse this JSON data, do
//
//     final attachmentResponseModel = attachmentResponseModelFromJson(jsonString);

import 'dart:convert';

AttachmentResponseModel attachmentResponseModelFromJson(String str) => AttachmentResponseModel.fromJson(json.decode(str));

String attachmentResponseModelToJson(AttachmentResponseModel data) => json.encode(data.toJson());

class AttachmentResponseModel {
    AttachmentResponseModel({
        this.status,
        this.message,
        this.data,
    });

    int? status;
    String? message;
    Data? data;

    factory AttachmentResponseModel.fromJson(Map<String, dynamic> json) => AttachmentResponseModel(
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
    Data({
        this.id,
        this.originalFileName,
        this.s3FileName,
    });

    int? id;
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

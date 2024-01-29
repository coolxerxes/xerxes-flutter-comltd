// To parse this JSON data, do
//
//     final deleteCommentModel = deleteCommentModelFromJson(jsonString);

import 'dart:convert';

DeleteCommentModel deleteCommentModelFromJson(String str) => DeleteCommentModel.fromJson(json.decode(str));

String deleteCommentModelToJson(DeleteCommentModel data) => json.encode(data.toJson());

class DeleteCommentModel {
    DeleteCommentModel({
        this.status,
        this.message,
        this.data,
    });

    int? status;
    String? message;
    Data? data;

    factory DeleteCommentModel.fromJson(Map<String, dynamic> json) => DeleteCommentModel(
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

// To parse this JSON data, do
//
//     final updateCommentModel = updateCommentModelFromJson(jsonString);

import 'dart:convert';

UpdateCommentModel updateCommentModelFromJson(String str) => UpdateCommentModel.fromJson(json.decode(str));

String updateCommentModelToJson(UpdateCommentModel data) => json.encode(data.toJson());

class UpdateCommentModel {
    UpdateCommentModel({
        this.status,
        this.message,
        this.data,
    });

    int? status;
    String? message;
    Data? data;

    factory UpdateCommentModel.fromJson(Map<String, dynamic> json) => UpdateCommentModel(
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

// To parse this JSON data, do
//
//     final deleteActivityModel = deleteActivityModelFromJson(jsonString);

import 'dart:convert';

DeleteActivityModel deleteActivityModelFromJson(String str) => DeleteActivityModel.fromJson(json.decode(str));

String deleteActivityModelToJson(DeleteActivityModel data) => json.encode(data.toJson());

class DeleteActivityModel {
    int? status;
    String? message;

    DeleteActivityModel({
        this.status,
        this.message,
    });

    factory DeleteActivityModel.fromJson(Map<String, dynamic> json) => DeleteActivityModel(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}

// To parse this JSON data, do
//
//     final updateGroupModel = updateGroupModelFromJson(jsonString);

import 'dart:convert';

UpdateGroupModel updateGroupModelFromJson(String str) => UpdateGroupModel.fromJson(json.decode(str));

String updateGroupModelToJson(UpdateGroupModel data) => json.encode(data.toJson());

class UpdateGroupModel {
    int? status;
    String? message;
    List<int>? data;

    UpdateGroupModel({
        this.status,
        this.message,
        this.data,
    });

    factory UpdateGroupModel.fromJson(Map<String, dynamic> json) => UpdateGroupModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<int>.from(json["data"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
    };
}

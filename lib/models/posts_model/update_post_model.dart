// To parse this JSON data, do
//
//     final updatePostResponseModel = updatePostResponseModelFromJson(jsonString);

import 'dart:convert';

UpdatePostResponseModel updatePostResponseModelFromJson(String str) => UpdatePostResponseModel.fromJson(json.decode(str));

String updatePostResponseModelToJson(UpdatePostResponseModel data) => json.encode(data.toJson());

class UpdatePostResponseModel {
    UpdatePostResponseModel({
        this.status,
        this.message,
        this.data,
    });

    int? status;
    String? message;
    List<int>? data;

    factory UpdatePostResponseModel.fromJson(Map<String, dynamic> json) => UpdatePostResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? []  : json["data"] is List ? List<int>.from(json["data"]!.map((x) => x)):[],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
    };
}

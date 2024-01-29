// To parse this JSON data, do
//
//     final dislikeCommentModel = dislikeCommentModelFromJson(jsonString);

import 'dart:convert';

DislikeCommentModel dislikeCommentModelFromJson(String str) => DislikeCommentModel.fromJson(json.decode(str));

String dislikeCommentModelToJson(DislikeCommentModel data) => json.encode(data.toJson());

class DislikeCommentModel {
    DislikeCommentModel({
        this.status,
        this.message,
        this.data,
    });

    int? status;
    String? message;
    int? data;

    factory DislikeCommentModel.fromJson(Map<String, dynamic> json) => DislikeCommentModel(
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

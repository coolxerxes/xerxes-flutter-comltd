// To parse this JSON data, do
//
//     final tourUpdateModel = tourUpdateModelFromJson(jsonString);

import 'dart:convert';

TourUpdateModel tourUpdateModelFromJson(String str) => TourUpdateModel.fromJson(json.decode(str));

String tourUpdateModelToJson(TourUpdateModel data) => json.encode(data.toJson());

class TourUpdateModel {
    int? status;
    String? message;
    Data? data;

    TourUpdateModel({
        this.status,
        this.message,
        this.data,
    });

    factory TourUpdateModel.fromJson(Map<String, dynamic> json) => TourUpdateModel(
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

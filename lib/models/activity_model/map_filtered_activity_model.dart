// To parse this JSON data, do
//
//     final mapFilteredActivityModel = mapFilteredActivityModelFromJson(jsonString);

import 'dart:convert';

MapFilteredActivityModel mapFilteredActivityModelFromJson(String str) => MapFilteredActivityModel.fromJson(json.decode(str));

String mapFilteredActivityModelToJson(MapFilteredActivityModel data) => json.encode(data.toJson());

class MapFilteredActivityModel {
    int? status;
    String? message;
    List<Datum>? data;

    MapFilteredActivityModel({
        this.status,
        this.message,
        this.data,
    });

    factory MapFilteredActivityModel.fromJson(Map<String, dynamic> json) => MapFilteredActivityModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? id;
    String? coverImage;
    List<int>? category;
    String? lat;
    String? long;
    double? distance;

    Datum({
        this.id,
        this.coverImage,
        this.category,
        this.lat,
        this.long,
        this.distance,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        coverImage: json["coverImage"],
        category: json["category"] == null ? [] : List<int>.from(json["category"]!.map((x) => x)),
        lat: json["lat"],
        long: json["long"],
        distance: json["distance"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "coverImage": coverImage,
        "category": category == null ? [] : List<dynamic>.from(category!.map((x) => x)),
        "lat": lat,
        "long": long,
        "distance": distance,
    };
}

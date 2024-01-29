// To parse this JSON data, do
//
//     final taggedUserResponseModel = taggedUserResponseModelFromJson(jsonString);

import 'dart:convert';

TaggedUserResponseModel taggedUserResponseModelFromJson(String str) => TaggedUserResponseModel.fromJson(json.decode(str));

String taggedUserResponseModelToJson(TaggedUserResponseModel data) => json.encode(data.toJson());

class TaggedUserResponseModel {
    TaggedUserResponseModel({
        this.status,
        this.message,
        this.data,
    });

    int? status;
    String? message;
    List<Datum>? data;

    factory TaggedUserResponseModel.fromJson(Map<String, dynamic> json) => TaggedUserResponseModel(
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
    Datum({
        this.userId,
        this.firstName,
        this.lastName,
        this.profilePic,
    });

    int? userId;
    String? firstName;
    String? lastName;
    String? profilePic;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        userId: json["userId"],
        firstName: json["firstName"]??"",
        lastName: json["lastName"]??"",
        profilePic: json["profilePic"]??"",
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "profilePic": profilePic,
    };
}

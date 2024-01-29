// To parse this JSON data, do
//
//     final searchPeopleResponseModel = searchPeopleResponseModelFromJson(jsonString);

import 'dart:convert';

SearchPeopleResponseModel searchPeopleResponseModelFromJson(String str) => SearchPeopleResponseModel.fromJson(json.decode(str));

String searchPeopleResponseModelToJson(SearchPeopleResponseModel data) => json.encode(data.toJson());

class SearchPeopleResponseModel {
    SearchPeopleResponseModel({
        this.status,
        this.message,
        this.data,
    });

    int? status;
    String? message;
    List<Datum>? data;

    factory SearchPeopleResponseModel.fromJson(Map<String, dynamic> json) => SearchPeopleResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : json["data"] is List ?  List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))):[],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        this.id,
        this.userId,
        this.firstName,
        this.lastName,
        this.username,
        this.biography,
        this.gender,
        this.qrcode,
        this.profilePic,
        this.birthday,
        this.privateAccount,
        this.privateActivity,
        this.appearanceSearch,
        this.lastUpdate,
    });

    int? id;
    int? userId;
    String? firstName;
    String? lastName;
    String? username;
    String? biography;
    String? gender;
    dynamic qrcode;
    String? profilePic;
    String? birthday;
    bool? privateAccount;
    bool? privateActivity;
    bool? appearanceSearch;
    String? lastUpdate;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["userId"],
        firstName: json["firstName"]??"",
        lastName: json["lastName"]??"",
        username: json["username"]??"",
        biography: json["biography"]??"",
        gender: json["gender"],
        qrcode: json["qrcode"],
        profilePic: json["profilePic"]??"",
        birthday: json["birthday"],
        privateAccount: json["privateAccount"],
        privateActivity: json["privateActivity"],
        appearanceSearch: json["appearanceSearch"],
        lastUpdate: json["lastUpdate"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "username": username,
        "biography": biography,
        "gender": gender,
        "qrcode": qrcode,
        "profilePic": profilePic,
        "birthday": birthday,
        "privateAccount": privateAccount,
        "privateActivity": privateActivity,
        "appearanceSearch": appearanceSearch,
        "lastUpdate": lastUpdate,
    };
}

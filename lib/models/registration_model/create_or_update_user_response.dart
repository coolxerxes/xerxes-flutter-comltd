// To parse this JSON data, do
//
//     final createOrUpdateUserResponse = createOrUpdateUserResponseFromJson(jsonString);

import 'dart:convert';

CreateOrUpdateUserResponse createOrUpdateUserResponseFromJson(String str) =>
    CreateOrUpdateUserResponse.fromJson(json.decode(str));

String createOrUpdateUserResponseToJson(CreateOrUpdateUserResponse data) =>
    json.encode(data.toJson());

class CreateOrUpdateUserResponse {
  CreateOrUpdateUserResponse({
    this.status,
    this.message,
    this.data,
  });

  dynamic status;
  String? message;
  dynamic data;

  factory CreateOrUpdateUserResponse.fromJson(Map<String, dynamic> json) =>
      CreateOrUpdateUserResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] is List ? [] : Data.fromJson(json["data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? null : data!.toJson(),
      };
}

class Data {
  Data({
    this.privateAccount,
    this.privateActivity,
    this.appearanceSearch,
    this.lastUpdate,
    this.id,
    this.firstName,
    this.lastName,
    this.userId,
    this.username,
    this.biography,
    this.qrcode,
    this.profilePic,
    this.birthDay,
  });

  bool? privateAccount;
  bool? privateActivity;
  bool? appearanceSearch;
  String? lastUpdate;
  dynamic id;
  String? firstName;
  String? lastName;
  dynamic userId;
  dynamic username;
  dynamic biography;
  dynamic qrcode;
  dynamic profilePic;
  dynamic birthDay;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        privateAccount: json["privateAccount"],
        privateActivity: json["privateActivity"],
        appearanceSearch: json["appearanceSearch"],
        lastUpdate: json["lastUpdate"],
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        userId: json["userId"],
        username: json["username"],
        biography: json["biography"],
        qrcode: json["qrcode"],
        profilePic: json["profilePic"],
        birthDay: json["birthDay"],
      );

  Map<String, dynamic> toJson() => {
        "privateAccount": privateAccount,
        "privateActivity": privateActivity,
        "appearanceSearch": appearanceSearch,
        "lastUpdate": lastUpdate,
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "userId": userId,
        "username": username,
        "biography": biography,
        "qrcode": qrcode,
        "profilePic": profilePic,
        "birthDay": birthDay,
      };
}

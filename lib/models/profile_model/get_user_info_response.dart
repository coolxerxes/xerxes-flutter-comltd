// To parse this JSON data, do
//
//     final getUserInfoResponse = getUserInfoResponseFromJson(jsonString);

import 'dart:convert';

GetUserInfoResponse getUserInfoResponseFromJson(String str) =>
    GetUserInfoResponse.fromJson(json.decode(str));

String getUserInfoResponseToJson(GetUserInfoResponse data) =>
    json.encode(data.toJson());

class GetUserInfoResponse {
  GetUserInfoResponse({
    this.status,
    this.message,
    this.data,
  });

  dynamic status;
  String? message;
  Data? data;

  factory GetUserInfoResponse.fromJson(Map<String, dynamic> json) =>
      GetUserInfoResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? null : data!.toJson(),
      };
}

class Data {
  Data({this.userInfoData, this.userIntrestData, this.friendCount, this.postCount});

  UserInfoData? userInfoData;
  List<UserIntrestDatum>? userIntrestData;
  dynamic friendCount;
  dynamic postCount;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      userInfoData: UserInfoData.fromJson(json["userInfoData"] ?? {}),
      userIntrestData: json["userIntrestData"] == null
          ? []
          : json["userIntrestData"] is Map
              ? []
              : List<UserIntrestDatum>.from(json["userIntrestData"]
                  .map((x) => UserIntrestDatum.fromJson(x))),
      friendCount: json["friendCount"] ?? "0",
      postCount : json["postCount"]??"0",
      );

  Map<String, dynamic> toJson() => {
        "userInfoData": userInfoData == null ? null : userInfoData!.toJson(),
        "userIntrestData": userIntrestData == null
            ? null
            : List<dynamic>.from(userIntrestData!.map((x) => x.toJson())),
      };
}

class UserInfoData {
  UserInfoData({
    this.id,
    this.userId,
    this.firstName,
    this.lastName,
    this.gender,
    this.username,
    this.biography,
    this.qrcode,
    this.profilePic,
    this.birthDay,
    this.privateAccount,
    this.privateActivity,
    this.appearanceSearch,
    this.lastUpdate,
  });

  dynamic id;
  dynamic userId;
  String? firstName;
  String? lastName;
  String? gender;
  dynamic username;
  dynamic biography;
  dynamic qrcode;
  dynamic profilePic;
  dynamic birthDay;
  bool? privateAccount;
  bool? privateActivity;
  bool? appearanceSearch;
  String? lastUpdate;

  factory UserInfoData.fromJson(Map<String, dynamic> json) => UserInfoData(
        id: json["id"],
        userId: json["userId"],
        firstName: json["firstName"] ?? "",
        lastName: json["lastName"] ?? "",
        gender: json["gender"] ?? "",
        username: json["username"] ?? "",
        biography: json["biography"] ?? "",
        qrcode: json["qrcode"] ?? "",
        profilePic: json["profilePic"] ?? "",
        birthDay: json["birthday"] ?? "",
        privateAccount: json["privateAccount"] ?? false,
        privateActivity: json["privateActivity"] ?? true,
        appearanceSearch: json["appearanceSearch"] ?? true,
        lastUpdate: json["lastUpdate"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "username": username,
        "biography": biography,
        "qrcode": qrcode,
        "profilePic": profilePic,
        "birthday": birthDay,
        "privateAccount": privateAccount,
        "privateActivity": privateActivity,
        "appearanceSearch": appearanceSearch,
        "lastUpdate": lastUpdate,
      };
}

class UserIntrestDatum {
  UserIntrestDatum({
    this.id,
    this.name,
    this.icon,
  });

  dynamic id;
  String? name;
  String? icon;

  factory UserIntrestDatum.fromJson(Map<String, dynamic> json) =>
      UserIntrestDatum(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "icon": icon,
      };
}

// To parse this JSON data, do
//
//     final userFreindProfileResponseModel = userFreindProfileResponseModelFromJson(jsonString);

import 'dart:convert';

UserFreindProfileResponseModel userFreindProfileResponseModelFromJson(
        String str) =>
    UserFreindProfileResponseModel.fromJson(json.decode(str));

String userFreindProfileResponseModelToJson(
        UserFreindProfileResponseModel data) =>
    json.encode(data.toJson());

class UserFreindProfileResponseModel {
  UserFreindProfileResponseModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  Data? data;

  factory UserFreindProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      UserFreindProfileResponseModel(
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
  Data({
    this.profileData,
    this.profileStatusData,
  });

  ProfileData? profileData;
  ProfileStatusData? profileStatusData;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        profileData: json["profileData"] == null
            ? null
            : ProfileData.fromJson(json["profileData"]),
        profileStatusData: json["profileStatusData"] == null
            ? null
            : ProfileStatusData.fromJson(json["profileStatusData"]),
      );

  Map<String, dynamic> toJson() => {
        "profileData": profileData?.toJson(),
        "profileStatusData": profileStatusData?.toJson(),
      };
}

class ProfileData {
  ProfileData({
    this.email,
    this.userInfo,
    this.userIntrest,
    this.activity,
    this.post,
    this.friendsCount,
    this.age,
  });

  dynamic email;
  UserInfo? userInfo;
  UserIntrest? userIntrest;
  int? activity;
  int? post;
  int? friendsCount;
  int? age;

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        email: json["email"],
        userInfo: json["userInfo"] == null
            ? null
            : UserInfo.fromJson(json["userInfo"]),
        userIntrest: json["userIntrest"] == null
            ? null
            : UserIntrest.fromJson(json["userIntrest"]),
        activity: json["activity"],
        post: json["post"],
        friendsCount: json["friendsCount"],
        age: json["age"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "userInfo": userInfo?.toJson(),
        "userIntrest": userIntrest?.toJson(),
        "activity": activity,
        "post": post,
        "friendsCount": friendsCount,
        "age": age,
      };
}

class UserInfo {
  UserInfo({
    this.firstName,
    this.lastName,
    this.username,
    this.biography,
    this.birthday,
    this.profilePic,
  });

  String? firstName;
  String? lastName;
  String? username;
  String? biography;
  String? birthday;
  String? profilePic;

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        firstName: json["firstName"] ?? "",
        lastName: json["lastName"] ?? "",
        username: json["username"] ?? "",
        biography: json["biography"] ?? "",
        birthday: json["birthday"],
        profilePic: json["profilePic"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "username": username,
        "biography": biography,
        "birthday": birthday,
        "profilePic": profilePic,
      };
}

class UserIntrest {
  UserIntrest({
    this.userId,
    this.intrestIds,
  });

  int? userId;
  List<IntrestId>? intrestIds;

  factory UserIntrest.fromJson(Map<String, dynamic> json) => UserIntrest(
        userId: json["userId"],
        intrestIds: json["intrestIds"] == null
            ? []
            : List<IntrestId>.from(
                json["intrestIds"]!.map((x) => IntrestId.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "intrestIds": intrestIds == null
            ? []
            : List<dynamic>.from(intrestIds!.map((x) => x.toJson())),
      };
}

class IntrestId {
  IntrestId({
    this.id,
    this.name,
    this.icon,
  });

  int? id;
  String? name;
  String? icon;

  factory IntrestId.fromJson(Map<String, dynamic> json) => IntrestId(
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

class ProfileStatusData {
  ProfileStatusData({
    this.isFriend,
    this.myProfile,
    this.isSentRequest,
    this.isApproved,
    this.isReceivedRequest,
    this.isBlocked,
    this.isYoublock,
    this.postPrivacy,
  });

  int? isFriend;
  int? myProfile;
  int? isSentRequest;
  int? isApproved;
  int? isReceivedRequest;
  int? isBlocked;
  int? isYoublock;
  PostPrivacy? postPrivacy;

  factory ProfileStatusData.fromJson(Map<String, dynamic> json) =>
      ProfileStatusData(
        isFriend: json["isFriend"],
        myProfile: json["myProfile"],
        isSentRequest: json["isSentRequest"],
        isApproved: json["isApproved"],
        isReceivedRequest: json["isReceivedRequest"],
        isBlocked: json["isBlocked"],
        isYoublock: json["isYoublock"],
        postPrivacy: PostPrivacy.fromJson(json["postPrivacy"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "isFriend": isFriend,
        "myProfile": myProfile,
        "isSentRequest": isSentRequest,
        "isApproved": isApproved,
        "isReceivedRequest": isReceivedRequest,
        "isBlocked": isBlocked,
        "isYoublock": isYoublock,
      };
}

class PostPrivacy {
    PostPrivacy({
        this.onlyMe,
        this.everyone,
        this.friendsOnly,
    });

    int? onlyMe;
    int? everyone;
    int? friendsOnly;

    factory PostPrivacy.fromJson(Map<String, dynamic> json) => PostPrivacy(
        onlyMe: json["onlyMe"]??0,
        everyone: json["everyone"]??0,
        friendsOnly: json["friendsOnly"]??0,
    );

    Map<String, dynamic> toJson() => {
        "onlyMe": onlyMe,
        "everyone": everyone,
        "friendsOnly": friendsOnly,
    };
}

// To parse this JSON data, do
//
//     final getPostByUserResponseModel = getPostByUserResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:jyo_app/models/posts_model/timeline_model.dart';

GetPostByUserResponseModel getPostByUserResponseModelFromJson(String str) =>
    GetPostByUserResponseModel.fromJson(json.decode(str));

String getPostByUserResponseModelToJson(GetPostByUserResponseModel data) =>
    json.encode(data.toJson());

class GetPostByUserResponseModel {
  GetPostByUserResponseModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  List<Datum>? data;

  factory GetPostByUserResponseModel.fromJson(Map<String, dynamic> json) =>
      GetPostByUserResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : json["data"] is List
                ? List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x)))
                : [],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.id,
    this.userId,
    this.text,
    this.postDate,
    this.attachment,
    this.document,
    this.activityId,
    this.topicTags,
    this.userTags,
    this.groupId,
    this.visible,
    this.createdAt,
    this.updatedAt,
    this.likeCount,
    this.commentCount,
    this.tagUserInfo,
    this.jioMeUserInfo,
    this.isLiked,
    this.isJioMe,
    this.activityData,
    this.mode

  });

  int? id;
  int? userId;
  String? text;
  String? mode;
  String? postDate;
  List<Attachment>? attachment;
  List<Document>? document;
  dynamic activityId;
  dynamic topicTags;
  List<int>? userTags;
  dynamic groupId;
  String? visible;
  String? createdAt;
  dynamic updatedAt;
  int? likeCount;
  int? commentCount;
  TagUserInfo? tagUserInfo;
  List<JioMeUserInfo>? jioMeUserInfo;
  int? isLiked;
  int? isJioMe;
  Map? activityData;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["userId"],
        text: json["text"],
        postDate: json["postDate"],
        attachment: (json["attachment"] == null || json["attachment"] == "null")
            ? []
            : List<Attachment>.from((jsonDecode(json["attachment"]) as List)
                .map((x) => Attachment.fromJson(x))),
        document: (json["documents"] == null || json["documents"] == "null")
            ? []
            : List<Document>.from(
                jsonDecode(json["documents"]).map((x) => Document.fromJson(x))),
        activityId: json["activityId"],
        topicTags: json["topicTags"],
        userTags: json["userTags"] == null
            ? []
            : List<int>.from(json["userTags"]!.map((x) => x)),
        groupId: json["groupId"],
        visible: json["visible"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        likeCount: json["likeCount"] ?? 0,
        mode: json["mode"],
        commentCount: json["commentCount"] ?? 0,
        tagUserInfo: json["tagUserInfo"] == null
            ? null
            : TagUserInfo.fromJson(json["tagUserInfo"]),
        jioMeUserInfo: json["jioMeUserInfo"] == null
            ? []
            : json["jioMeUserInfo"] is List
                ? List<JioMeUserInfo>.from(json["jioMeUserInfo"]!
                    .map((x) => JioMeUserInfo.fromJson(x)))
                : [],
        isLiked: json["isLiked"] ?? 0,
        isJioMe: json["isJioMe"] ?? 0,
        activityData: json["activityData"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "text": text,
        "postDate": postDate,
        "attachment": attachment == null
            ? []
            : List<dynamic>.from(attachment!.map((x) => x)),
        "activityId": activityId,
        "topicTags": topicTags,
        "userTags":
            userTags == null ? [] : List<dynamic>.from(userTags!.map((x) => x)),
        "groupId": groupId,
        "visible": visible,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "likeCount": likeCount,
        "commentCount": commentCount,
        "tagUserInfo": tagUserInfo?.toJson(),
        "jioMeUserInfo": jioMeUserInfo == null
            ? []
            : List<dynamic>.from(jioMeUserInfo!.map((x) => x.toJson())),
        "isLiked": isLiked,
        "isJioMe": isJioMe,
      };
}

class JioMeUserInfo {
  JioMeUserInfo({
    this.id,
    this.userId,
    this.postId,
    this.jioDate,
    this.jioMeUserList,
  });

  int? id;
  int? userId;
  int? postId;
  String? jioDate;
  UserData? jioMeUserList;

  factory JioMeUserInfo.fromJson(Map<String, dynamic> json) => JioMeUserInfo(
        id: json["id"],
        userId: json["userId"],
        postId: json["postId"],
        jioDate: json["jioDate"],
        jioMeUserList: UserData.fromJson(json["jioMeUserList"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "postId": postId,
        "jioDate": jioDate,
        "jioMeUserList": jioMeUserList?.toJson(),
      };
}

class UserData {
  UserData({
    this.userId,
    this.firstName,
    this.lastName,
    this.profilePic,
  });

  int? userId;
  String? firstName;
  String? lastName;
  String? profilePic;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        userId: json["userId"] ?? 0,
        firstName: json["firstName"] ?? "",
        lastName: json["lastName"] ?? "",
        profilePic: json["profilePic"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "profilePic": profilePic,
      };
}

class TagUserInfo {
  TagUserInfo({
    this.userData,
    this.countOfUserTags,
  });

  UserData? userData;
  int? countOfUserTags;

  factory TagUserInfo.fromJson(Map<String, dynamic> json) => TagUserInfo(
        userData: json["userData"] == null
            ? null
            : UserData.fromJson(json["userData"]),
        countOfUserTags: json["countOfUserTags"],
      );

  Map<String, dynamic> toJson() => {
        "userData": userData?.toJson(),
        "countOfUserTags": countOfUserTags,
      };
}

// To parse this JSON data, do
//
//     final timelineResponseModel = timelineResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:video_player/video_player.dart';

import 'get_post_by_user_model.dart';

TimelineResponseModel timelineResponseModelFromJson(String str) =>
    TimelineResponseModel.fromJson(json.decode(str));

String timelineResponseModelToJson(TimelineResponseModel data) =>
    json.encode(data.toJson());

class TimelineResponseModel {
  TimelineResponseModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  List<Datum>? data;

  factory TimelineResponseModel.fromJson(Map<String, dynamic> json) =>
      TimelineResponseModel(
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
    this.isLiked,
    this.isJioMe,
    this.likeCount,
    this.commentCount,
    this.userInfo,
    this.tagUserInfo,
  });

  int? id;
  int? userId;
  String? text;
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
  int? isLiked;
  int? likeCount;
  int? commentCount;
  int? isJioMe;
  UserInfo? userInfo;
  TagUserInfo? tagUserInfo;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["userId"],
        text: json["text"],
        postDate: json["postDate"],
        attachment: (json["attachment"] == null || json["attachment"] == "null")
            ? []
            : List<Attachment>.from(jsonDecode(json["attachment"])
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
        isLiked: json["isLiked"] ?? 0,
        isJioMe: json["isJioMe"] ?? 0,
        likeCount: json["likeCount"] ?? 0,
        commentCount: json["commentCount"] ?? 0,
        userInfo: json["userInfo"] == null
            ? null
            : UserInfo.fromJson(json["userInfo"]),
        tagUserInfo: json["tagUserInfo"] == null
            ? null
            : TagUserInfo.fromJson(json["tagUserInfo"]),
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
        "isLiked": isLiked,
        "likeCount": likeCount,
        "commentCount": commentCount,
        "userInfo": userInfo?.toJson(),
        "tagUserInfo": tagUserInfo?.toJson(),
      };
}

class Attachment {
  Attachment({this.type, this.name});

  int? type;
  String? name;
  VideoPlayerController? controller;
  late Future<void> initializeVideoPlayerFuture;

  VideoPlayerController? get getController => controller;
  set setController(VideoPlayerController? controller) =>
      this.controller = controller;

   Future<void> get getInitializeVideoPlayer => initializeVideoPlayerFuture;
  set setInitalizeVideoPlayer(initializeVidPlayer) =>
      initializeVideoPlayerFuture = initializeVidPlayer;

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        type: json["type"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "name": name,
      };
}

class Document {
  Document({
    this.s3Name,
    this.originalName,
  });

  String? s3Name;
  String? originalName;

  factory Document.fromJson(Map<String, dynamic> json) => Document(
        s3Name: json["s3Name"],
        originalName: json["originalName"],
      );

  Map<String, dynamic> toJson() => {
        "originalName": originalName,
        "s3Name": s3Name,
      };
}

// class TagUserInfo {
//   TagUserInfo({
//     this.userData,
//     this.countOfUserTags,
//   });

//   User? userData;
//   int? countOfUserTags;

//   factory TagUserInfo.fromJson(Map<String, dynamic> json) => TagUserInfo(
//         userData:
//             json["userData"] == null ? null : User.fromJson(json["userData"]),
//         countOfUserTags: json["countOfUserTags"],
//       );

//   Map<String, dynamic> toJson() => {
//         "userData": userData?.toJson(),
//         "countOfUserTags": countOfUserTags,
//       };
// }

class User {
  User({
    this.firstName,
    this.lastName,
    this.profilePic,
    this.userId,
  });

  String? firstName;
  String? lastName;
  String? profilePic;
  int? userId;

  factory User.fromJson(Map<String, dynamic> json) => User(
        firstName: json["firstName"] ?? "",
        lastName: json["lastName"] ?? "",
        profilePic: json["profilePic"] ?? "",
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "profilePic": profilePic,
        "userId": userId,
      };
}

class UserInfo {
  UserInfo({
    this.id,
    this.userInfo,
  });

  int? id;
  User? userInfo;

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        id: json["id"],
        userInfo:
            json["userInfo"] == null ? null : User.fromJson(json["userInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userInfo": userInfo?.toJson(),
      };
}

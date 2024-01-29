// To parse this JSON data, do
//
//     final getCommentResponseModel = getCommentResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

GetCommentResponseModel getCommentResponseModelFromJson(String str) =>
    GetCommentResponseModel.fromJson(json.decode(str));

String getCommentResponseModelToJson(GetCommentResponseModel data) =>
    json.encode(data.toJson());

class GetCommentResponseModel {
  GetCommentResponseModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  List<Datum>? data;

  factory GetCommentResponseModel.fromJson(Map<String, dynamic> json) =>
      GetCommentResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
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
  Datum(
      {this.id,
      this.userId,
      this.postId,
      this.comment,
      this.attachment,
      this.repliedTo,
      this.createdAt,
      this.updatedAt,
      this.userInfoData,
      this.repliedToCount,
      this.commentLikeCount,
      this.isCommentLikeByUser});

  int? id;
  int? userId;
  int? postId;
  String? comment;
  dynamic attachment;
  dynamic repliedTo;
  int? repliedToCount;
  String? createdAt;
  dynamic updatedAt;
  UserInfoData? userInfoData;
  RxBool? isReplying = false.obs;
  RxBool? hideViewReplyText = false.obs;
  TextEditingController replyCtrl = TextEditingController();
  RxList<Datum>? childComments = RxList();
  RxInt? commentLikeCount;
  RxInt? isCommentLikeByUser;
  RxBool? isUpating = false.obs;
  TextEditingController updateCtrl = TextEditingController();

  RxBool? get getIsUpating => isUpating;
  set setIsUpating(RxBool? isUpating) => this.isUpating = isUpating;

  TextEditingController get getUpdateCtrl => updateCtrl; 
  set setUpdateCtrl( updateCtrl) => this.updateCtrl = updateCtrl;


  RxList<Datum>? get getChildComments => childComments;
  set setChildComments(RxList<Datum>? childComments) =>
      this.childComments = childComments;

  TextEditingController get getReplyCtrl => replyCtrl;
  set setReplyCtrl(TextEditingController replyCtrl) =>
      this.replyCtrl = replyCtrl;

  bool? get getIsReplying => isReplying!.value;
  set setIsReplying(bool? isReplying) => this.isReplying!.value = isReplying!;

  bool? get getHideViewReplyText => hideViewReplyText!.value;
  set setHideViewReplyText(bool? hideViewReplyText) =>
      this.hideViewReplyText!.value = hideViewReplyText!;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
      id: json["id"],
      userId: json["userId"],
      postId: json["postId"],
      comment: json["comment"],
      attachment: json["attachment"],
      repliedTo: json["repliedTo"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      userInfoData: UserInfoData.fromJson(json["userInfoData"] ?? {}),
      repliedToCount: json["repliedToCount"] ?? 0,
      commentLikeCount: RxInt(json["commentLikeCount"] ?? 0),
      isCommentLikeByUser: RxInt(json["isCommentLikeByUser"] ?? 0));

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "postId": postId,
        "comment": comment,
        "attachment": attachment,
        "repliedTo": repliedTo,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "userInfoData": userInfoData?.toJson(),
      };
}

class UserInfoData {
  UserInfoData({
    this.userId,
    this.firstName,
    this.lastName,
    this.profilePic,
  });

  dynamic userId;
  String? firstName;
  String? lastName;
  String? profilePic;

  factory UserInfoData.fromJson(Map<String, dynamic> json) => UserInfoData(
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

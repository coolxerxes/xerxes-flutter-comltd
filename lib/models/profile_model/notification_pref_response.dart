// To parse this JSON data, do
//
//     final notificationPrefResponse = notificationPrefResponseFromJson(jsonString);

import 'dart:convert';

NotificationPrefResponse notificationPrefResponseFromJson(String str) => NotificationPrefResponse.fromJson(json.decode(str));

String notificationPrefResponseToJson(NotificationPrefResponse data) => json.encode(data.toJson());

class NotificationPrefResponse {
    NotificationPrefResponse({
        this.status,
        this.message,
        this.data,
    });

    dynamic status;
    String? message;
    Data? data;

    factory NotificationPrefResponse.fromJson(Map<String, dynamic> json) => NotificationPrefResponse(
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
    Data({
        this.id,
        this.userId,
        this.directChat,
        this.groupChat,
        this.postLikeComment,
        this.groupActvity,
        this.friendActivity,
        this.activityInvitation,
    });

    dynamic id;
    dynamic userId;
    bool? directChat;
    bool? groupChat;
    bool? postLikeComment;
    bool? groupActvity;
    bool? friendActivity;
    bool? activityInvitation;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["userId"],
        directChat: json["directChat"],
        groupChat: json["groupChat"],
        postLikeComment: json["postLikeComment"],
        groupActvity: json["groupActvity"],
        friendActivity: json["friendActivity"],
        activityInvitation: json["activityInvitation"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "directChat": directChat,
        "groupChat": groupChat,
        "postLikeComment": postLikeComment,
        "groupActvity": groupActvity,
        "friendActivity": friendActivity,
        "activityInvitation": activityInvitation,
    };
}

// To parse this JSON data, do
//
//     final blockProfileResponse = blockProfileResponseFromJson(jsonString);

import 'dart:convert';

BlockProfileResponse blockProfileResponseFromJson(String str) =>
    BlockProfileResponse.fromJson(json.decode(str));

String blockProfileResponseToJson(BlockProfileResponse data) =>
    json.encode(data.toJson());

class BlockProfileResponse {
  BlockProfileResponse({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  Data? data;

  factory BlockProfileResponse.fromJson(Map<String, dynamic> json) =>
      BlockProfileResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : json["data"] is Map
                ? Data.fromJson(json["data"])
                : Data.fromJson({}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  Data({
    this.id,
    this.userId,
    this.friendId,
    this.createdAt,
  });

  int? id;
  int? userId;
  int? friendId;
  String? createdAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["userId"],
        friendId: json["friendId"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "friendId": friendId,
        "createdAt": createdAt,
      };
}

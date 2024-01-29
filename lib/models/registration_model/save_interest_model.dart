// To parse this JSON data, do
//
//     final saveInterestResponse = saveInterestResponseFromJson(jsonString);

// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

SaveInterestResponse saveInterestResponseFromJson(String str) =>
    SaveInterestResponse.fromJson(json.decode(str));

String saveInterestResponseToJson(SaveInterestResponse data) =>
    json.encode(data.toJson());

class SaveInterestResponse {
  SaveInterestResponse({
    this.status,
    this.message,
    this.data,
  });

  dynamic status;
  String? message;
  Data? data;

  factory SaveInterestResponse.fromJson(Map<String, dynamic> json) =>
      SaveInterestResponse(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"] ?? {}),
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
    this.intrestIds,
  });

  dynamic id;
  dynamic userId;
  List<dynamic>? intrestIds;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["userId"],
        intrestIds: json["intrestIds"] == null
            ? []
            : List<int>.from(json["intrestIds"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "intrestIds": intrestIds == null
            ? null
            : List<dynamic>.from(intrestIds!.map((x) => x)),
      };
}

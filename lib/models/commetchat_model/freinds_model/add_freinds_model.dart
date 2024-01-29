// To parse this JSON data, do
//
//     final ccAddFreindResponse = ccAddFreindResponseFromJson(jsonString);

import 'dart:convert';

CcAddFreindResponse ccAddFreindResponseFromJson(String str) => CcAddFreindResponse.fromJson(json.decode(str));

String ccAddFreindResponseToJson(CcAddFreindResponse data) => json.encode(data.toJson());
//{"accepted":["8"]}
class CcAddFreindResponse {
    CcAddFreindResponse({
        this.data,
    });

    Data? data;

    factory CcAddFreindResponse.fromJson(Map<String, dynamic> json) => CcAddFreindResponse(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
    };
}

class Data {
    Data({
        this.accepted,
    });

    Accepted? accepted;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        accepted: json["accepted"] == null ? null : Accepted.fromJson(json["accepted"]),
    );

    Map<String, dynamic> toJson() => {
        "accepted": accepted?.toJson(),
    };
}

class Accepted {
    Accepted({
        this.the8,
    });

    The8? the8;

    factory Accepted.fromJson(Map<String, dynamic> json) => Accepted(
        the8: json["8"] == null ? null : The8.fromJson(json["8"]),
    );

    Map<String, dynamic> toJson() => {
        "8": the8?.toJson(),
    };
}

class The8 {
    The8({
        this.success,
        this.message,
    });

    bool? success;
    String? message;

    factory The8.fromJson(Map<String, dynamic> json) => The8(
        success: json["success"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
    };
}

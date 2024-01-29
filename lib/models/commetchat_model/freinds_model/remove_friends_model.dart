// To parse this JSON data, do
//
//     final ccRemoveFreindResponse = ccRemoveFreindResponseFromJson(jsonString);

import 'dart:convert';

CcRemoveFreindResponse ccRemoveFreindResponseFromJson(String str) => CcRemoveFreindResponse.fromJson(json.decode(str));

String ccRemoveFreindResponseToJson(CcRemoveFreindResponse data) => json.encode(data.toJson());
//{"friends":["8"]}
class CcRemoveFreindResponse {
    CcRemoveFreindResponse({
        this.data,
    });

    Data? data;

    factory CcRemoveFreindResponse.fromJson(Map<String, dynamic> json) => CcRemoveFreindResponse(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
    };
}

class Data {
    Data({
        this.success,
        this.message,
    });

    bool? success;
    String? message;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        success: json["success"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
    };
}

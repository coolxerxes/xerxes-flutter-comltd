// To parse this JSON data, do
//
//     final accountSettingResponse = accountSettingResponseFromJson(jsonString);

import 'dart:convert';

AccountSettingResponse accountSettingResponseFromJson(String str) => AccountSettingResponse.fromJson(json.decode(str));

String accountSettingResponseToJson(AccountSettingResponse data) => json.encode(data.toJson());

class AccountSettingResponse {
    AccountSettingResponse({
        this.status,
        this.message,
        this.data,
    });

    dynamic status;
    String? message;
    Data? data;

    factory AccountSettingResponse.fromJson(Map<String, dynamic> json) => AccountSettingResponse(
        status: json["status"],
        message: json["message"],
       // data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? null : data!.toJson(),
    };
}

class Data {
    Data();

    factory Data.fromJson(Map<String, dynamic> json) => Data(
    );

    Map<String, dynamic> toJson() => {
    };
}

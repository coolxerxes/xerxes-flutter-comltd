// To parse this JSON data, do
//
//     final changePhNoResponse = changePhNoResponseFromJson(jsonString);

import 'dart:convert';

ChangePhNoResponse changePhNoResponseFromJson(String str) => ChangePhNoResponse.fromJson(json.decode(str));

String changePhNoResponseToJson(ChangePhNoResponse data) => json.encode(data.toJson());

class ChangePhNoResponse {
    ChangePhNoResponse({
        this.status,
        this.message,
        this.data,
    });

    dynamic status;
    String? message;
    Data? data;

    factory ChangePhNoResponse.fromJson(Map<String, dynamic> json) => ChangePhNoResponse(
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
        this.hpNo,
        this.countryCode,
        this.email,
        this.providerKey,
        this.imNo,
        this.lastLogin,
        this.lastUpdate,
        this.isDelete,
        this.createdDate,
        this.userId,
    });

    dynamic id;
    String? hpNo;
    dynamic countryCode;
    dynamic email;
    dynamic providerKey;
    String? imNo;
    String? lastLogin;
    dynamic lastUpdate;
    bool? isDelete;
    String? createdDate;
    dynamic userId;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        hpNo: json["hpNo"],
        countryCode: json["countryCode"],
        email: json["email"],
        providerKey: json["providerKey"],
        imNo: json["imNo"],
        lastLogin: json["lastLogin"],
        lastUpdate: json["lastUpdate"],
        isDelete: json["isDelete"],
        createdDate: json["createdDate"],
        userId: json["userId"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "hpNo": hpNo,
        "countryCode": countryCode,
        "email": email,
        "providerKey": providerKey,
        "imNo": imNo,
        "lastLogin": lastLogin,
        "lastUpdate": lastUpdate,
        "isDelete": isDelete,
        "createdDate": createdDate,
        "userId": userId,
    };
}

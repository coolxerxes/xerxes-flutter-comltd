// To parse this JSON data, do
//
//     final voucherDataResponse = voucherDataResponseFromJson(jsonString);

import 'dart:convert';

VoucherDataResponse voucherDataResponseFromJson(String str) => VoucherDataResponse.fromJson(json.decode(str));

String voucherDataResponseToJson(VoucherDataResponse data) => json.encode(data.toJson());

class VoucherDataResponse {
    VoucherDataResponse({
        this.status,
        this.message,
        this.data,
    });

    dynamic status;
    String? message;
    Data? data;

    factory VoucherDataResponse.fromJson(Map<String, dynamic> json) => VoucherDataResponse(
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
        this.passVoucher,
        this.currentVoucher,
    });

    List<Voucher>? passVoucher;
    List<Voucher>? currentVoucher;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        passVoucher: json["pass_voucher"] == null ? [] : List<Voucher>.from(json["pass_voucher"].map((x) => Voucher.fromJson(x))),
        currentVoucher: json["current_voucher"] == null  ? [] : List<Voucher>.from(json["current_voucher"].map((x) => Voucher.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "pass_voucher": passVoucher == null ? null : List<dynamic>.from(passVoucher!.map((x) => x.toJson())),
        "current_voucher": currentVoucher == null ? null : List<dynamic>.from(currentVoucher!.map((x) => x.toJson())),
    };
}

class Voucher {
    Voucher({
        this.id,
        this.vendorId,
        this.title,
        this.banner,
        this.description,
        this.qrCode,
        this.redeemCode,
        this.vendorBranchId,
        this.termsCondition,
        this.redeemGuide,
        this.startDateTime,
        this.endDateTime,
        this.vendor,
    });

    dynamic id;
    dynamic vendorId;
    dynamic title;
    dynamic banner;
    dynamic description;
    dynamic qrCode;
    dynamic redeemCode;
    dynamic vendorBranchId;
    dynamic termsCondition;
    dynamic redeemGuide;
    dynamic startDateTime;
    String? endDateTime;
    Vendor? vendor;

    factory Voucher.fromJson(Map<String, dynamic> json) => Voucher(
        id: json["id"],
        vendorId: json["vendorId"],
        title: json["title"],
        banner: json["banner"],
        description: json["description"],
        qrCode: json["qrCode"],
        redeemCode: json["redeemCode"],
        vendorBranchId: json["vendorBranchId"],
        termsCondition: json["termsCondition"],
        redeemGuide: json["redeemGuide"],
        startDateTime: json["startDateTime"],
        endDateTime: json["endDateTime"],
        vendor: json["vendor"] == null ? null : Vendor.fromJson(json["vendor"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "vendorId": vendorId,
        "title": title,
        "banner": banner,
        "description": description,
        "qrCode": qrCode,
        "redeemCode": redeemCode,
        "vendorBranchId": vendorBranchId,
        "termsCondition": termsCondition,
        "redeemGuide": redeemGuide,
        "startDateTime": startDateTime,
        "endDateTime": endDateTime,
        "vendor": vendor == null ? null : vendor!.toJson(),
    };
}

class Vendor {
    Vendor({
        this.id,
        this.name,
        this.icon,
        this.termsCondition,
        this.redeemGuide,
    });

    dynamic id;
    dynamic name;
    dynamic icon;
    dynamic termsCondition;
    dynamic redeemGuide;

    factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
        termsCondition: json["termsCondition"]??"",
        redeemGuide: json["redeemGuide"]??"",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "icon": icon,
        "termsCondition": termsCondition,
        "redeemGuide": redeemGuide,
    };
}

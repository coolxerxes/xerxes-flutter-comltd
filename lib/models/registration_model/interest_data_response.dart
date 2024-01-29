// To parse this JSON data, do
//
//     final interestDataResponse = interestDataResponseFromJson(jsonString);

import 'dart:convert';

InterestDataResponse interestDataResponseFromJson(String str) =>
    InterestDataResponse.fromJson(json.decode(str));

String interestDataResponseToJson(InterestDataResponse data) =>
    json.encode(data.toJson());

class InterestDataResponse {
  InterestDataResponse({
    this.status,
    this.message,
    this.data,
  });

  dynamic status;
  String? message;
  List<Datum>? data;

  factory InterestDataResponse.fromJson(Map<String, dynamic> json) =>
      InterestDataResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.id,
    this.name,
    this.icon,
    this.isSelected
  });

  dynamic id;
  String? name;
  String? icon;
  bool? isSelected = false;

  bool? get getIsSelected => isSelected;
  set setIsSelected(bool? isSelected) => this.isSelected = isSelected;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "icon": icon,
      };
}

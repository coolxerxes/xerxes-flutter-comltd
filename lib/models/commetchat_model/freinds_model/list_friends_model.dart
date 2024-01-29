// To parse this JSON data, do
//
//     final ccListFriendsResponse = ccListFriendsResponseFromJson(jsonString);

import 'dart:convert';

CcListFriendsResponse ccListFriendsResponseFromJson(String str) => CcListFriendsResponse.fromJson(json.decode(str));

String ccListFriendsResponseToJson(CcListFriendsResponse data) => json.encode(data.toJson());

class CcListFriendsResponse {
    CcListFriendsResponse({
        this.data,
        this.meta,
    });

    List<Datum>? data;
    Meta? meta;

    factory CcListFriendsResponse.fromJson(Map<String, dynamic> json) => CcListFriendsResponse(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "meta": meta?.toJson(),
    };
}

class Datum {
    Datum({
        this.uid,
        this.name,
        this.avatar,
        this.status,
        this.role,
        this.lastActiveAt,
        this.createdAt,
        this.conversationId,
    });

    String? uid;
    String? name;
    String? avatar;
    String? status;
    String? role;
    int? lastActiveAt;
    int? createdAt;
    String? conversationId;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        uid: json["uid"],
        name: json["name"],
        avatar: json["avatar"],
        status: json["status"],
        role: json["role"],
        lastActiveAt: json["lastActiveAt"],
        createdAt: json["createdAt"],
        conversationId: json["conversationId"],
    );

    Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "avatar": avatar,
        "status": status,
        "role": role,
        "lastActiveAt": lastActiveAt,
        "createdAt": createdAt,
        "conversationId": conversationId,
    };
}

class Meta {
    Meta({
        this.pagination,
        this.cursor,
    });

    Pagination? pagination;
    Cursor? cursor;

    factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
        cursor: json["cursor"] == null ? null : Cursor.fromJson(json["cursor"]),
    );

    Map<String, dynamic> toJson() => {
        "pagination": pagination?.toJson(),
        "cursor": cursor?.toJson(),
    };
}

class Cursor {
    Cursor({
        this.updatedAt,
        this.affix,
    });

    int? updatedAt;
    String? affix;

    factory Cursor.fromJson(Map<String, dynamic> json) => Cursor(
        updatedAt: json["updatedAt"],
        affix: json["affix"],
    );

    Map<String, dynamic> toJson() => {
        "updatedAt": updatedAt,
        "affix": affix,
    };
}

class Pagination {
    Pagination({
        this.total,
        this.count,
        this.perPage,
        this.currentPage,
        this.totalPages,
    });

    int? total;
    int? count;
    int? perPage;
    int? currentPage;
    int? totalPages;

    factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        total: json["total"],
        count: json["count"],
        perPage: json["per_page"],
        currentPage: json["current_page"],
        totalPages: json["total_pages"],
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "count": count,
        "per_page": perPage,
        "current_page": currentPage,
        "total_pages": totalPages,
    };
}

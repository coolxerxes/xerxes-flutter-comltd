class GroupSuggestionItem {
  GroupSuggestionItem(
      {this.image, this.heading, this.member, this.id, this.isJoinedGroup});
  int? id;
  String? image;
  String? heading;
  String? member;
  bool? isJoinedGroup;
}

class TListGroupSuggestion {
  int? status;
  String? message;
  List<Data>? data;

  TListGroupSuggestion({this.status, this.message, this.data});

  TListGroupSuggestion.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? userId;
  String? groupName;
  String? groupImage;
  String? about;
  List<int>? category;
  bool? isPrivateGroup;
  bool? requireAcceptance;
  String? createdAt;
  bool? isMember;
  bool? isJoinedGroup;
  String? role;
  int? memberCount;

  Data(
      {this.id,
      this.userId,
      this.groupName,
      this.groupImage,
      this.about,
      this.category,
      this.isPrivateGroup,
      this.requireAcceptance,
      this.createdAt,
      this.isMember,
      this.role,
      this.memberCount});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    groupName = json['groupName'];
    groupImage = json['groupImage'];
    about = json['about'];
    category = json['category'].cast<int>();
    isPrivateGroup = json['isPrivateGroup'];
    requireAcceptance = json['requireAcceptance'];
    createdAt = json['createdAt'];
    isMember = json['isMember'] ?? false;
    isJoinedGroup = json['isJoinedGroup'] ?? false;
    role = json['role'];
    memberCount = json['memberCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['groupName'] = this.groupName;
    data['groupImage'] = this.groupImage;
    data['about'] = this.about;
    data['category'] = this.category;
    data['isPrivateGroup'] = this.isPrivateGroup;
    data['requireAcceptance'] = this.requireAcceptance;
    data['createdAt'] = this.createdAt;
    data['isMember'] = this.isMember;
    data['role'] = this.role;
    data['memberCount'] = this.memberCount;
    return data;
  }
}

class TSuggestedPeople {
  int? status;
  String? message;
  List<Data>? data;

  TSuggestedPeople({this.status, this.message, this.data});

  TSuggestedPeople.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? hpNo;
  int? countryCode;
  Null email;
  String? providerKey;
  String? imNo;
  String? lastLogin;
  Null lastUpdate;
  bool? isOverviewed;
  int? overviewStep;
  bool? isDelete;
  String? createdDate;
  UserInfo? userInfo;
  bool? isRequestSent;

  Data(
      {this.id,
      this.hpNo,
      this.countryCode,
      this.email,
      this.providerKey,
      this.imNo,
      this.lastLogin,
      this.lastUpdate,
      this.isOverviewed,
      this.overviewStep,
      this.isDelete,
      this.isRequestSent,
      this.createdDate,
      this.userInfo});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hpNo = json['hpNo'];
    countryCode = json['countryCode'];
    email = json['email'];
    providerKey = json['providerKey'];
    imNo = json['imNo'];
    lastLogin = json['lastLogin'];
    lastUpdate = json['lastUpdate'];
    isOverviewed = json['isOverviewed'];
    overviewStep = json['overviewStep'];
    isDelete = json['isDelete'];
    createdDate = json['createdDate'];
    isRequestSent = false;
    userInfo =
        json['userInfo'] != null ? UserInfo.fromJson(json['userInfo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['hpNo'] = hpNo;
    data['countryCode'] = countryCode;
    data['email'] = email;
    data['providerKey'] = providerKey;
    data['imNo'] = imNo;
    data['lastLogin'] = lastLogin;
    data['lastUpdate'] = lastUpdate;
    data['isOverviewed'] = isOverviewed;
    data['overviewStep'] = overviewStep;
    data['isDelete'] = isDelete;
    data['createdDate'] = createdDate;
    if (userInfo != null) {
      data['userInfo'] = userInfo!.toJson();
    }
    return data;
  }
}

class UserInfo {
  int? id;
  int? userId;
  String? firstName;
  String? lastName;
  String? fullName;
  String? username;
  String? biography;
  String? gender;
  String? qrcode;
  String? profilePic;
  String? birthday;
  bool? privateAccount;
  bool? privateActivity;
  bool? appearanceSearch;
  String? lastUpdate;

  UserInfo(
      {this.id,
      this.userId,
      this.firstName,
      this.lastName,
      this.fullName,
      this.username,
      this.biography,
      this.gender,
      this.qrcode,
      this.profilePic,
      this.birthday,
      this.privateAccount,
      this.privateActivity,
      this.appearanceSearch,
      this.lastUpdate});

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    fullName = json['fullName'];
    username = json['username'];
    biography = json['biography'];
    gender = json['gender'];
    qrcode = json['qrcode'];
    profilePic = json['profilePic'];
    birthday = json['birthday'];
    privateAccount = json['privateAccount'];
    privateActivity = json['privateActivity'];
    appearanceSearch = json['appearanceSearch'];
    lastUpdate = json['lastUpdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['fullName'] = fullName;
    data['username'] = username;
    data['biography'] = biography;
    data['gender'] = gender;
    data['qrcode'] = qrcode;
    data['profilePic'] = profilePic;
    data['birthday'] = birthday;
    data['privateAccount'] = privateAccount;
    data['privateActivity'] = privateActivity;
    data['appearanceSearch'] = appearanceSearch;
    data['lastUpdate'] = lastUpdate;
    return data;
  }
}

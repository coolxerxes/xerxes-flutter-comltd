// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jyo_app/models/search_people_model/friend_list_model.dart';
import 'package:jyo_app/repository/freinds_repo/freinds_repo_impl.dart';
import 'package:jyo_app/repository/profile_repo/profile_repo_impl.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/utils/secured_storage.dart';

class PostPrivacyScreenVM extends GetxController {
  ProfileRepoImpl profileRepoImpl = ProfileRepoImpl();
  final friendsRepoImpl = FriendsRepoImpl();
  int privacyStatus = Privacy.everyone;

  int hideFromCount = 0;
  List<Datum>? friends = List.empty(growable: true);
  List<Datum>? searchedFriends = List.empty(growable: true);
  List<String> hideFromListLocal = List.empty(growable: true);
  List<dynamic> hideFromListServer = List.empty(growable: true);

  TextEditingController searchCtrl = TextEditingController();

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() async {
    SecuredStorage.initiateSecureStorage();
    await fetchPostPrivacy();
    await fetchFreindList();
    update();
  }

  Future<void> fetchPostPrivacy() async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    await profileRepoImpl.fetchPostPrivacy(userId).then((res) async {
      if (res.status == 200) {
        hideFromCount = res.data!.hidePostFromCount ?? 0;
        hideFromListServer = res.data!.hidePostFrom!;
        if (hideFromListServer != null && hideFromListServer.isNotEmpty) {
          hideFromListLocal.clear();
          for (var i = 0; i < hideFromListServer.length; i++) {
            hideFromListLocal.add(hideFromListServer[i].toString());
          }
        }

        (res.data!.hidePostFrom);
        switch (res.data!.postPrivacy!.trim().toLowerCase()) {
          case "everyone":
            privacyStatus = Privacy.everyone;
            await SecuredStorage.writeStringValue(Keys.postPrivacy, "everyone");
            break;
          case "friends only":
            privacyStatus = Privacy.friendOnly;
            await SecuredStorage.writeStringValue(
                Keys.postPrivacy, "friends only");
            break;
          case "only me":
            privacyStatus = Privacy.onlyMe;
            await SecuredStorage.writeStringValue(Keys.postPrivacy, "only me");
            break;
        }
        //update();
      } else {
        showAppDialog(msg: res.message.toString());
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }

  Future<void> updatePostPrivacy(privacy) async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    var data = {"userId": userId, "postPrivacy": privacy};
    debugPrint("data $data");
    await profileRepoImpl.updatePostPrivacy(data).then((res) async {
      if (res.status == 200) {
        //await SecuredStorage.writeStringValue(Keys.postPrivacy, privacy.toString().toLowerCase());
        switch (privacy!.toString().trim().toLowerCase()) {
          case "everyone":
            privacyStatus = Privacy.everyone;
            await SecuredStorage.writeStringValue(Keys.postPrivacy, "everyone");
            break;
          case "friends only":
            privacyStatus = Privacy.friendOnly;
            await SecuredStorage.writeStringValue(
                Keys.postPrivacy, "friends only");
            break;
          case "only me":
            privacyStatus = Privacy.onlyMe;
            await SecuredStorage.writeStringValue(Keys.postPrivacy, "only me");
            break;
        }
        update();
      } else {
        showAppDialog(msg: res.message.toString());
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }

  Future<void> fetchFreindList() async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    Map data = {"userId": userId};
    // await profileRepoImpl.fetchFrientList(userId).then((res) async {
    //   if (res.status == 200) {
    //     // update();
    //   } else {
    //     showAppDialog(msg: res.message.toString());
    //   }
    // }).onError((error, stackTrace) {
    //   showAppDialog(msg: error.toString());
    // });
    await friendsRepoImpl.getFriendList(data)!.then((res) async {
      if (res.status == 200) {
        friends!.clear();
        searchedFriends!.clear();
        friends!.addAll(res.data!);
        searchedFriends!.addAll(res.data!);
        if (hideFromListLocal.isEmpty) {
          for (var i = 0; i < friends!.length; i++) {
            friends![i].setIsHidden = false;
            searchedFriends![i].setIsHidden = false;
          }
        } else {
          for (var i = 0; i < friends!.length; i++) {
            String fId = friends![i].user!.userId.toString();
            int idx = hideFromListLocal.indexWhere((String element) {
              return element == fId;
            });

            if (idx != -1) {
              friends![i].setIsHidden = true;
              searchedFriends![i].setIsHidden = true;
            } else {
              friends![i].setIsHidden = false;
              searchedFriends![i].setIsHidden = false;
            }
          }
        }
        update();
      } else {
        showAppDialog(msg: res.message.toString());
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }

  Future<void> updatePostHideFrom() async {
    debugPrint("Hide From List local $hideFromListLocal");
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    var data = {"userId": userId, "hideFrom": hideFromListLocal};
    debugPrint("updatePostHideFrom $data");
    await profileRepoImpl.updatePostHideFrom(data).then((res) async {
      if (res.status == 200) {
        Get.back();
        await fetchPostPrivacy();
        await fetchFreindList();

        update();
      } else {
        showAppDialog(msg: res.message.toString());
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }

  void togglePrivacy(int privacy) async {
    privacyStatus = privacy;
    update();
    switch (privacy) {
      case Privacy.everyone:
        updatePostPrivacy("Everyone");
        break;
      case Privacy.friendOnly:
        updatePostPrivacy("Friends only");
        break;
      case Privacy.onlyMe:
        updatePostPrivacy("Only me");
        break;
    }
  }

  void search(String t) {
    friends!.assignAll(searchedFriends!.where((Datum p0) =>
        (t.toString().isEmpty
            ? true
            : (p0.user!.firstName.toString().toLowerCase() +
                    " " + //.contains(t.toString().toLowerCase()) ||
                    p0.user!.lastName.toString().toLowerCase())
            // (p0.user!.firstName
            //         .toString()
            //         .toLowerCase()
            //         .contains(t.toString().toLowerCase()) ||
            //     p0.user!.lastName
            //         .toString()
            //         .toLowerCase()
                    .contains(t.toString().toLowerCase()))));
  }
}

class Privacy {
  static const everyone = 0;
  static const friendOnly = 1;
  static const onlyMe = 2;
}

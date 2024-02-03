import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jyo_app/data/local/user_search_model.dart';
import 'package:jyo_app/repository/freinds_repo/freinds_repo_impl.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/utils/secured_storage.dart';
import 'package:jyo_app/view_model/base_screen_vm.dart';

import '../models/search_people_model/friend_list_model.dart';

class FriendlistScreenVM extends GetxController {
  final baseScreenVM = Get.find<BaseScreenVM>();
  final friendsRepoImpl = FriendsRepoImpl();
  String? userId = "";
  List<Datum>? friends = List.empty(growable: true);
  List<Datum>? searchedFriends = List.empty(growable: true);
  String? imageFileName = "";
  TextEditingController? searchCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    SecuredStorage.initiateSecureStorage();
    if (SearchUser.getId != null) {
      userId = SearchUser.getId.toString();
    } else {
      userId = await SecuredStorage.readStringValue(Keys.userId);
    }
    await getFriends();
  }

  Future<void> getFriends() async {
    Map data = {"userId": userId};
    await friendsRepoImpl.getFriendList(data)!.then((res) {
      if (res.status == 200) {
        friends!.clear();
        searchedFriends!.clear();
        searchedFriends!.addAll(res.data!);
        friends!.addAll(res.data!);
      } else {
        showAppDialog(msg: res.message);
      }
      update();
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }

  void search(String t) {
    searchedFriends!.assignAll(friends!.where((Datum p0) =>
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

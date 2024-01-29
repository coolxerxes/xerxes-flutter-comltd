import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jyo_app/repository/freinds_repo/freinds_repo_impl.dart';
import 'package:jyo_app/repository/profile_repo/profile_repo_impl.dart';
import 'package:jyo_app/utils/secured_storage.dart';
import 'package:jyo_app/models/profile_model/blocked_user_response.dart' as bu;
import 'package:jyo_app/view_model/notification_screen_vm.dart';

import '../models/search_people_model/friend_list_model.dart';
import '../utils/common.dart';

class BlockedUserScreenVM extends GetxController {
  ProfileRepoImpl profileRepoImpl = ProfileRepoImpl();
  FriendsRepoImpl friendsRepoImpl = FriendsRepoImpl();
  List<bu.Datum>? blockListServer = List.empty(growable: true);
  List<bu.Datum>? searchedblockListServer = List.empty(growable: true);
  List<String> blockListLocal = List.empty(growable: true);
  TextEditingController? searchCtrl = TextEditingController();
  List<Datum>? friends = List.empty(growable: true);

  @override
  void onInit() {
    init();
    super.onInit();
  }

  Future<void> init() async {
    SecuredStorage.initiateSecureStorage();
    await fetchBLockedList();
    // await getFriends();
  }

  // Future<void> getFriends() async {
  //   String? userId = await SecuredStorage.readStringValue(Keys.userId);
  //   Map data = {"userId": userId};
  //   await friendsRepoImpl.getFriendList(data)!.then((res) {
  //     if (res.status == 200) {
  //       friends!.clear();
  //       friends!.addAll(res.data!);
  //       if (blockListLocal.isEmpty) {
  //         for (var i = 0; i < friends!.length; i++) {
  //           friends![i].setIsHidden = false;
  //         }
  //       } else {
  //         for (var i = 0; i < friends!.length; i++) {
  //           String fId = friends![i].friendId.toString();
  //           int idx = blockListLocal.indexWhere((String element) {
  //             return element == fId;
  //           });

  //           if (idx != -1) {
  //             friends![i].setIsHidden = true;
  //           } else {
  //             friends![i].setIsHidden = false;
  //           }
  //         }
  //       }
  //       update();
  //     } else {
  //       showAppDialog(msg: res.message);
  //     }
  //     update();
  //   }).onError((error, stackTrace) {
  //     showAppDialog(msg: error.toString());
  //   });
  // }

  Future<void> fetchBLockedList() async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    await profileRepoImpl.fetchBlockedUserList(userId).then((res) async {
      if (res.status == 200) {
        blockListServer!.clear();
        searchedblockListServer!.clear();
        blockListServer!.addAll(res.data!);
        searchedblockListServer!.addAll(res.data!);
        for (var i = 0; i < blockListServer!.length; i++) {
          blockListServer![i].setIsHidden = true;
          searchedblockListServer![i].setIsHidden = true;
        }
        // blockListServer = res.data!;
        // if (blockListServer != null && blockListServer!.isNotEmpty) {
        //   blockListLocal.clear();
        //   for (var i = 0; i < blockListServer!.length; i++) {
        //     blockListLocal.add(blockListServer![i].friendId.toString());
        //   }
        // }
        // debugPrint("blockList Local $blockListLocal, blockList Server $blockListServer");
        update();
      } else {
        showAppDialog(msg: res.message.toString());
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }

  Future<void> blockUser() async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);

    List<String> block = List.empty(growable: true);
    List<String> unblock = List.empty(growable: true);

    for (var i = 0; i < blockListServer!.length; i++) {
      if (blockListServer![i].getIsHidden!) {
        block.add(blockListServer![i].userInfo!.userId.toString());
      } else {
        unblock.add(blockListServer![i].userInfo!.userId.toString());
      }
    }
    //var data = {"userId": userId, "blockUsers": blockListLocal};
    var data = {"userId": userId, "blockUsers": block, "unblockUser": unblock};
    debugPrint("blocking data $data");
    await profileRepoImpl.blockUsers(data).then((res) async {
      if (res.status == 200) {
        //Get.back();
        await NotificationScreenVM.removeFriendInCommetChat(
            uid: userId.toString(), fuid: block);
        await fetchBLockedList();
      } else {
        showAppDialog(msg: res.message.toString());
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }

  void search(String t) {
    blockListServer!.assignAll(searchedblockListServer!.where((bu.Datum p0) =>
        (t.toString().isEmpty
            ? true
            : (p0.userInfo!.firstName
                    .toString()
                    .toLowerCase()
                    .contains(t.toString().toLowerCase()) ||
                p0.userInfo!.lastName
                    .toString()
                    .toLowerCase()
                    .contains(t.toString().toLowerCase())))));
  }
}

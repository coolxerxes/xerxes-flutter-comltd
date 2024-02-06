import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart' as c;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jyo_app/models/group_suggestion_model/group_list_model.dart';
import 'package:jyo_app/repository/freinds_repo/freinds_repo_impl.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/utils/secured_storage.dart';
import 'package:jyo_app/view_model/base_screen_vm.dart';
import 'package:jyo_app/view_model/posts_and_activities_vm.dart';

import '../models/posts_model/post_and_activity_model.dart';
import '../models/search_people_model/search_people_model.dart';

import '../repository/group_repo/group_repo_impl.dart';

class SearchScreenVM extends GetxController {
  final baseSreenVM = Get.find<BaseScreenVM>();
  final friendsRepoImpl = FriendsRepoImpl();
  final postVM = PostsAndActivitiesVM();
  final groupRepoImpl = GroupRepoImpl();
  String? userId = "";
  bool? isSearchEmpty = true;

  int selectedSearchType = SearchType.people;
  TextEditingController searchCtrl = TextEditingController();

  List<Datum?>? searchResults = List.empty(growable: true);
  List<PostOrActivity> activityResults = List.empty(growable: true);
  List<GroupData> groupResults = List.empty(growable: true);

  @override
  void onInit() {
    super.onInit();
    init();
  }

  void init() async {
    userId = await SecuredStorage.readStringValue(Keys.userId);
    postVM.afterInit(this);
  }

  void onTabChanged() {
    searchResults!.clear();
    activityResults.clear();
    searchCtrl.clear();
    groupResults.clear();
    update();
  }

  Future<void> searchPeople(String? name) async {
    await friendsRepoImpl.searchPeople(name, userId)!.then((res) {
      searchResults!.clear();
      if (res.status == 200) {
        if (isSearchEmpty!) {
          searchResults!.clear();
        } else {
          searchResults!.addAll(res.data!);
        }
      } else {
        showAppDialog(msg: res.message);
        searchResults!.clear();
      }
      //searchResults!.add(null);
      update();
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
      searchResults!.clear();
      update();
    });
  }

  Future<void> searchActivity(String? name) async {
    await postVM.searchActivities({"activityName": name}, this).then((res) {
      activityResults.clear();
      if (res.isNotEmpty) {
        if (isSearchEmpty!) {
          activityResults.clear();
        } else {
          activityResults.addAll(res);
        }
      } else {
        debugPrint("activityResults $res  Not found");
        // showAppDialog(msg: "Not found");
        activityResults.clear();
      }
      //searchResults!.add(null);
      update();
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
      activityResults.clear();
      update();
    });
  }

  Future<void> searchGroup(String? name) async {
    String userId = (await SecuredStorage.readStringValue(Keys.userId))!;
    await groupRepoImpl
        .seachGroup({"groupName": name, "userId": userId})!.then((res) {
      groupResults.clear();
      if (res.status == 200) {
        if (isSearchEmpty!) {
          groupResults.clear();
        } else {
          for (int i = 0; i < res.data!.length; i++) {
            groupResults.add(GroupData(
                memberCount: res.data![i].memberCount,
                groupId: res.data![i].id,
                isMember: res.data![i].isMember,
                isInvited: res.data![i].isInvited,
                isJoinedGroup: res.data![i].isJoinedGroup,
                group: Group(
                    groupImage: res.data![i].groupImage,
                    groupName: res.data![i].groupName)));
          }
          //groupResults.addAll(res.data!);
        }
      } else {
        debugPrint("groupResults $res  Not found");
        // showAppDialog(msg: "Not found");
        groupResults.clear();
      }
      //searchResults!.add(null);
      update();
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
      groupResults.clear();
      update();
    });
  }

  Future<void> joinGroup(index) async {
    String userId = (await SecuredStorage.readStringValue(Keys.userId))!;
    String firstName = (await SecuredStorage.readStringValue(Keys.firstName))!;
    String lastName = (await SecuredStorage.readStringValue(Keys.lastName))!;
    await groupRepoImpl.requestToJoin({
      "userId": userId.toString(),
      "groupId": groupResults[index].groupId.toString()
    }).then((res) {
      if (res.status == 200) {
        groupResults[index].isMember = !groupResults[index].isMember!;
        if (res.data!.status.toString().trim() == "Approved") {
          //join group.
          addMemberToGroupCometChat(
              groupId: groupResults[index].groupId.toString(),
              userId: userId.toString(),
              userName: "$firstName $lastName");
        }
      } else {
        showAppDialog(msg: res.message);
      }
      searchGroup(searchCtrl.text.trim());
      update();
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
      update();
    });
  }

  Future<void> addMemberToGroupCometChat({userId, userName, groupId}) async {
    c.CometChat.joinGroup(groupId, c.CometChatGroupType.public,
        onSuccess: (c.Group group) {
      debugPrint("chat Group Joined Successfully : $group ");
    }, onError: (c.CometChatException e) {
      debugPrint("chat Group Joining failed with exception: ${e.message}");
    });
    // c.CometChat.addMembersToGroup(
    //     guid: groupId.toString(),
    //     groupMembers: [
    //       c.GroupMember.fromUid(
    //         scope: c.CometChatMemberScope.participant,
    //         uid: userId.toString(),
    //         name: userName,
    //       )
    //     ],
    //     onSuccess: (Map<String?, String?> result) {
    //       debugPrint("chat Group Member added Successfully : $result");
    //     },
    //     onError: (c.CometChatException e) {
    //       debugPrint(
    //           "chat Group Member addition failed with exception: ${e.message}");
    //     });
  }
}

class SearchType {
  static const activities = 0;
  static const people = 1;
  static const group = 2;
}

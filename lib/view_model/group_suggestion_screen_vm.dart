import 'dart:developer';
import 'package:cometchat/cometchat_sdk.dart' as c;

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jyo_app/repository/group_repo/group_repo.dart';
import 'package:jyo_app/repository/group_repo/group_repo_impl.dart';
import 'package:jyo_app/resources/app_image.dart';
import 'package:jyo_app/view_model/most_liked_screen_vm.dart';
import 'package:jyo_app/view_model/posts_and_activities_vm.dart';

import '../models/group_suggestion_model/group_list_model.dart';
import '../models/group_suggestion_model/group_suggestion_model.dart';
import '../repository/freinds_repo/freinds_repo_impl.dart';
import '../utils/common.dart';
import '../utils/secured_storage.dart';
import 'base_screen_vm.dart';

class GroupSuggestionScreenVM extends GetxController {
  List<GroupSuggestionItem> list = List.empty(growable: true);
  bool isLoading = false;
  List selectedInterestIds = [];

  @override
  void onInit() {
    // init();
    super.onInit();
  }

  void init() {
    getGroupSuggestionItemsAPI();
  }

  TListGroupSuggestion? tListGroupSuggestion;
  getGroupSuggestionItemsAPI() async {
    isLoading = true;
    update();
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    tListGroupSuggestion = await GroupRepoImpl().getGroupSuggestion(userId);

    if (tListGroupSuggestion!.status == 200) {
      list.clear();
      tListGroupSuggestion!.data!.forEach((element) {
        list.add(GroupSuggestionItem(
            id: element.id,
            heading: "${element.groupName}",
            member: "${element.memberCount}",
            image: '${element.groupImage}',
            isJoinedGroup: element.isJoinedGroup));
      });
    } else {
      showAppDialog(msg: tListGroupSuggestion!.message.toString());
    }

    isLoading = false;
    update();
  }

  // final baseSreenVM = Get.find<BaseScreenVM>();
  // final friendsRepoImpl = FriendsRepoImpl();
  // final postVM = PostsAndActivitiesVM();
  final groupRepoImpl = GroupRepoImpl();
  Future<void> joinGroup(index) async {
    // List<GroupData> groupResults = List.empty(growable: true);

    String userId = (await SecuredStorage.readStringValue(Keys.userId))!;
    String firstName = (await SecuredStorage.readStringValue(Keys.firstName))!;
    String lastName = (await SecuredStorage.readStringValue(Keys.lastName))!;
    await groupRepoImpl.requestToJoin({
      "userId": userId.toString(),
      "groupId": list![index].id.toString()
    }).then((res) {
      if (res.status == 200) {
        list![index].isJoinedGroup = !list![index].isJoinedGroup!;
        if (res.data!.status.toString().trim() == "Approved") {
          //join group.
          addMemberToGroupCometChat(
              groupId: list![index].id.toString(),
              userId: userId.toString(),
              userName: firstName + " " + lastName);
        }
      } else {
        showAppDialog(msg: res.message);
      }
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

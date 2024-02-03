// ignore_for_file: unnecessary_null_comparison

import 'package:cometchat/cometchat_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as mt;
import 'package:get/get.dart';
import 'package:jyo_app/repository/group_repo/group_repo_impl.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/utils/secured_storage.dart';
import 'package:jyo_app/view_model/group_list_screen_vm.dart';
import 'package:jyo_app/view_model/posts_and_activities_vm.dart';

import '../data/local/tab_data.dart';
import '../data/remote/endpoints.dart';
import '../models/group_suggestion_model/group_details_model.dart';
import 'package:jyo_app/models/search_people_model/friend_list_model.dart' as f;

import '../repository/freinds_repo/freinds_repo_impl.dart';
import 'package:jyo_app/models/group_suggestion_model/group_memeber_list_model.dart'
    as m;
import 'package:jyo_app/models/activity_model/activity_request_list_model.dart'
    as r;

class GroupDetailsScreenVM extends GetxController {
//  Admin
//  Supper admin
//  Member
  final postsVM = PostsAndActivitiesVM();
  GroupRepoImpl groupRepoImpl = GroupRepoImpl();
  bool isLoadingGrp = false;
  bool? isAppStartingFromNotification = false;
  //For super admin

  List<Tab> tabs = List.empty(growable: true);
  Tab? selectedTab;
  String userId = "";
  String userName = "";
  String groupId = "";
  List<f.Datum>? friends = List.empty(growable: true);
  List<f.Datum>? searchedFriends = List.empty(growable: true);
  List<m.Datum> membersList = List.empty(growable: true);
  List<m.Datum>? searchedMembers = List.empty(growable: true);
  List<r.Datum> requestList = List.empty(growable: true);

  mt.TextEditingController? searchCtrl = mt.TextEditingController();
  mt.TextEditingController? fsearchCtrl = mt.TextEditingController();

  GroupDetail? group;
  Group? cometGroup;
  bool isLoading = true;

  String role = "Member";

  bool isReadingMore = false;

  bool isInvited = false;
  bool isSupAd = false;
  bool isAdmin = false;

  int toSAIndex = -1;

  int toSAId = -1;

  void createTabs() {
    tabs.clear();
    tabs.add(
        Tab(index: GroupTabs.activities, text: "Activities", showBadge: false));
    tabs.add(Tab(index: GroupTabs.members, text: "Members", showBadge: false));
    // tabs.add(
    //     Tab(index: GroupTabs.requests, text: "Request", showBadge: false));
    selectedTab = tabs[0];
    update();
  }

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init({withoutArg = false}) async {
    CometChat.getLoggedInUser(
      onSuccess: (p0) {
        debugPrint("chat Logged in user ${p0.name}, ${p0.uid}");
      },
    );
    userId = (await SecuredStorage.readStringValue(Keys.userId))!;
    userName = (await SecuredStorage.readStringValue(Keys.firstName))! +
        " " +
        (await SecuredStorage.readStringValue(Keys.lastName))!;
    postsVM.afterInit(this, endpoint: Endpoints.activity);
    if (!withoutArg) {
      groupId = Get.arguments["groupId"].toString();
      isAppStartingFromNotification = Get.arguments["isAppStartingFromNotification"]??false;
    }
    createTabs();
    //if (Get.arguments != null) {
    // groupId = Get.arguments["groupId"];
    getCometChatDetailOfThisGroup();
    await fetchGroupDetails();
    role = group!.role.toString();
    isInvited = group!.isInvited!;
    isSupAd = group!.role.toString() == GroupRoles.superAdmin;
    isAdmin = group!.role.toString() == GroupRoles.admin;
    if (isAdmin || isSupAd) {
      fetchFreindList();
      tabs.add(
          Tab(index: GroupTabs.requests, text: "Requests", showBadge: false));
      await getRequestList({
        'groupId': groupId.toString(),
        'adminId': userId.toString(),
        "role": role.toString()
      });
    }

    getActivities();
    getParticipants({'groupId': groupId.toString()});
    // }
    isLoading = false;
    update();
  }

  Future<void> memberToAdmin(Map<String, String> data) async {
    debugPrint("memberToAdmin req $data");
    await groupRepoImpl.memberToAdmin(data).then((res) async {
      if (res["status"] == 200) {
        await changeScopeTo(
            userId: data["toBeAdmin"], scope: CometChatMemberScope.admin);
      }
      getParticipants({'groupId': groupId.toString()});
      update();
    }).onError((error, stackTrace) {
      debugPrint("ARQL Error ${error.toString()}");
      update();
    });
  }

  Future<void> demoteAdminToMember(Map<String, String> data) async {
    debugPrint("demoteAdminToMember req $data");
    await groupRepoImpl.demoteAdminToMember(data).then((res) async {
      if (res["status"] == 200) {
        await changeScopeTo(
            userId: data["toBeMember"],
            scope: CometChatMemberScope.participant);
      }
      getParticipants({'groupId': groupId.toString()});
      update();
    }).onError((error, stackTrace) {
      debugPrint("ARQL Error ${error.toString()}");
      update();
    });
  }

  Future<void> removeMember(Map<String, String> data) async {
    debugPrint("removeMember req $data");
    await groupRepoImpl.removeMember(data).then((res) async {
      if (res["status"] == 200) {
        await removeMemberCometChat(uid: data["memberId"]);
      }
      getParticipants({'groupId': groupId.toString()});
      update();
    }).onError((error, stackTrace) {
      debugPrint("ARQL Error ${error.toString()}");
      update();
    });
  }

  Future<void> setSuperAdminDemoteToAdmin(Map<String, String> data) async {
    debugPrint("setSuperAdminDemoteToAdmin req $data");
    await groupRepoImpl.setSuperAdminDemoteToAdmin(data).then((res) async {
      if (res["status"] == 200) {
        await changeScopeTo(
            userId: data["toBeSuperAdmin"], scope: CometChatMemberScope.admin);
      }
      getParticipants({'groupId': groupId.toString()});
      init(withoutArg: true);
      update();
    }).onError((error, stackTrace) {
      debugPrint("ARQL Error ${error.toString()}");
      update();
    });
  }

  Future<void> leaveGroup(Map<String, String> data) async {
    debugPrint("leaveGroup req $data");
    await groupRepoImpl.leaveGroup(data).then((res) async {
      if (res["status"] == 200) {
        await leaveGroupCometChat();
        final g = Get.put(GroupListScreenVM());
        g.init();
        getParticipants({'groupId': groupId.toString()});
        init(withoutArg: true);
      } else {}
      update();
    }).onError((error, stackTrace) {
      debugPrint("ARQL Error ${error.toString()}");
      update();
    });
  }

  Future<void> fetchGroupDetails() async {
    isLoading = true;
    update();
    await groupRepoImpl
        .getGroupDetails({"groupId": groupId, "userId": userId}).then((res) {
      if (res.status == 200) {
        group = res.data!;
      } else {
        showAppDialog(msg: res.message);
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }

  Future<void> inviteFriends() async {
    var userArray = [];
    for (int i = 0; i < friends!.length; i++) {
      if (friends![i].getIsHidden!) {
        userArray.add(friends![i].user!.userId.toString());
      }
    }
    var data = {
      "groupId": groupId.toString(),
      "userArray": userArray,
      "adminId": userId.toString()
    };
    debugPrint("Invite Data $data");
    await groupRepoImpl.inviteFriend(data).then((res) {
      if (res.status == 200) {
        Get.back();
        snackbar(title: res.message);
      } else {
        showAppDialog(msg: res.message);
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }

  Future<void> fetchFreindList() async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    Map data = {"userId": userId};

    await FriendsRepoImpl().getFriendList(data)!.then((res) async {
      if (res.status == 200) {
        friends!.clear();
        searchedFriends!.clear();
        friends!.addAll(res.data!);
        searchedFriends!.addAll(res.data!);

        for (var i = 0; i < friends!.length; i++) {
          friends![i].setIsHidden = false;
          searchedFriends![i].setIsHidden = false;
        }
      } else {
        showAppDialog(msg: res.message.toString());
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }

  void searchInvities(String t) {
    friends!
        .assignAll(searchedFriends!.where((f.Datum p0) => (t.toString().isEmpty
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

  Future<void> getActivities() async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    var data = {"userId": userId.toString(), "groupId": groupId.toString()};
    debugPrint("data grp list $data");
    await postsVM.getActivitiesByUser(data, this).then((res) async {
      postsVM.activitiesList.clear();
      if (res != null) {
        postsVM.activitiesList.addAll(res);
      }
      //isLoadingActs = false;
      update();
    }).onError((error, stackTrace) {
      showAppDialog(msg: "Error ${error.toString()}");
      //isLoadingActs = false;
      update();
    });
  }

  void search(String t) {
    searchedMembers!
        .assignAll(membersList.where((m.Datum p0) => (t.toString().isEmpty
            ? true
            : (p0.user!.userInfo!.firstName.toString().toLowerCase() +
                    " " + //.contains(t.toString().toLowerCase()) ||
                    p0.user!.userInfo!.lastName.toString().toLowerCase())
                .contains(t.toString().toLowerCase()))));
  }

  Future<void> getParticipants(Map data) async {
    await groupRepoImpl.memberList(data).then((res) {
      if (res.status == 200) {
        membersList.clear();
        searchedMembers!.clear();
        searchedMembers!.addAll(res.data!);
        membersList.addAll(res.data!);
      } else {
        debugPrint("PL RES MSG ${res.message}");
      }
      update();
    }).onError((error, stackTrace) {
      debugPrint("PL Error ${error.toString()}");
      update();
    });
  }

  Future<void> getRequestList(Map data) async {
    debugPrint("REQ LIST DA $data");
    await groupRepoImpl.requestList(data).then((res) {
      if (res.status == 200) {
        requestList.clear();
        requestList.addAll(res.data!);
      } else {
        debugPrint("RQL RES MSG ${res.message}");
      }
      if (requestList.isNotEmpty) {
        tabs[2].showBadge = true;
      }
      update();
    }).onError((error, stackTrace) {
      debugPrint("RQL Error ${error.toString()}");
      update();
    });
  }

  Future<void> acceptRequestToJoin(Map<String, String> data,
      {r.User? user}) async {
    // {
    //   "groupId": 1,
    //   "adminId": 1,
    //   "role": "ADMIN",
    //   "userId": 46,
    //   "isAccept": 0
    // }
    debugPrint("acceptRequestToJoin req $data");
    await groupRepoImpl.acceptOrRejectRequestGroup(data).then((res) async {
      // if (res.status == 200) {
      if (data["isAccept"] == "1") {
        await addMemberToGroupCometChat(user: user);
      }
      if ((isSupAd || isAdmin)) {
        getRequestList({
          'groupId': groupId.toString(),
          'adminId': userId.toString(),
          "role": role.toString()
        });
      }
      getParticipants({'groupId': groupId.toString()});
      //} else {
      debugPrint("ARQL RES MSG ${res.message}");
      //}
      update();
    }).onError((error, stackTrace) {
      debugPrint("ARQL Error ${error.toString()}");
      update();
    });
  }

  Future<void> acceptOrRejetInvite(Map<String, String> data) async {
    // {
    //   "groupId": 1,
    //   "userId": 46,
    //   "isAccept": 0
    // }
    debugPrint("acceptRejInvite req $data");
    await groupRepoImpl.acceptOrRejectInvitation(data).then((res) async {
      // if (res.status == 200) {
      if (data["isAccept"] == "1") {
        await joinToGroupCometChat(
            groupId: groupId.toString(),
            userId: userId.toString(),
            userName: userName.toString());
      }
      showAppDialog(msg: res["message"]);
      //} else {
      // debugPrint("ARQL RES MSG ${res.message}");
      //}
      update();
    }).onError((error, stackTrace) {
      debugPrint("ARQL Error ${error.toString()}");
      update();
    });
  }

  Future<void> addMemberToGroupCometChat({r.User? user}) async {
    CometChat.addMembersToGroup(
        guid: groupId.toString(),
        groupMembers: [
          GroupMember.fromUid(
            scope: CometChatMemberScope.participant,
            uid: user!.id.toString(),
            name: user.userInfo!.firstName.toString() +
                " " +
                user.userInfo!.lastName.toString(),
          )
        ],
        onSuccess: (Map<String?, String?> result) {
          debugPrint("chat Group Member added Successfully : $result");
        },
        onError: (CometChatException e) {
          debugPrint(
              "chat Group Member addition failed with exception: ${e.message}");
        });
  }

  Future<void> joinToGroupCometChat({userId, userName, groupId}) async {
    CometChat.joinGroup(groupId, CometChatGroupType.public,
        onSuccess: (Group group) {
      debugPrint("chat Group Joined Successfully : $group ");
    }, onError: (CometChatException e) {
      debugPrint("chat Group Joining failed with exception: ${e.message}");
    });
  }

  Future<void> leaveGroupCometChat() async {
    CometChat.leaveGroup(groupId, onSuccess: (group) {
      debugPrint("chat Group left Successfully : $group ");
    }, onError: (CometChatException e) {
      debugPrint("chat Group left failed with exception: ${e.message}");
    });
  }

  Future<void> changeScopeTo({userId, scope}) async {
    CometChat.updateGroupMemberScope(
        guid: groupId,
        uid: userId,
        scope: scope,
        onSuccess: (group) {
          debugPrint("chat mem scope upd Successfully : $group ");
        },
        onError: (CometChatException e) {
          debugPrint("chat mem scope upd failed with exception: ${e.message}");
        });
  }

  Future<void> getCometChatDetailOfThisGroup() async {
    CometChat.getGroup(groupId.toString(), onSuccess: (Group group) {
      cometGroup = group;
      debugPrint("Fetched Group Successfully : $group ");
    }, onError: (CometChatException e) {
      debugPrint("Group Request failed with exception: ${e.message}");
    });
  }

  Future<void> removeMemberCometChat({uid}) async {
    CometChat.kickGroupMember(
        guid: groupId,
        uid: uid,
        onSuccess: (String message) {
          debugPrint("chat Group Member Kicked  Successfully : $message");
        },
        onError: (CometChatException e) {
          debugPrint("chat Group Member Kicked failed  : ${e.message}");
        });
  }

  Future<void> leaveAndSetAsHost(Map<String, String> data) async {
    debugPrint("leaveAndSetSomeOneAsSuperAdmin req $data");

    await groupRepoImpl.leaveAndSetSomeOneAsSuperAdmin(data).then((res) async {
      if (res["status"] == 200) {
        await changeScopeTo(
            userId: data["toBeSuperAdmin"].toString(),
            scope: CometChatMemberScope.admin);
        await leaveGroupCometChat();
        final g = Get.put(GroupListScreenVM());
        g.init();
      }
      Get.back();
      getParticipants({"groupId": groupId.toString()});
      init(withoutArg: true);
      update();
    }).onError((error, stackTrace) {
      debugPrint("leaveAndSetSomeOneAsSuperAdmin Error ${error.toString()}");
      update();
    });
  }
}

class GroupTabs {
  static const activities = 0;
  static const members = 1;
  static const requests = 2;
}

class GroupRoles {
  static const superAdmin = "Supper admin";
  static const admin = "Admin";
  static const member = "Member";
}

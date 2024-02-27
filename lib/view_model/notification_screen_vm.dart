import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:jyo_app/data/local/notification_type.dart';
import 'package:jyo_app/repository/commetchat_repo/friends_repo/friends_repo_impl.dart';
import 'package:jyo_app/repository/freinds_repo/freinds_repo_impl.dart';
import 'package:jyo_app/repository/group_repo/group_repo_impl.dart';
import 'package:jyo_app/repository/notification_repo/notification_repo_impl.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/utils/secured_storage.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/notification_model/pending_friend_req_response_model.dart';
import '../models/notification_model/notification_history_response.dart' as n;
import '../repository/activities_repo/activities_repo_impl.dart';
import 'package:jyo_app/models/activity_model/activity_request_list_model.dart'
    as r;

class NotificationScreenVM extends GetxController {
  final notificationRepoImpl = NotificationRepoImpl();
  final friendsRepoImpl = FriendsRepoImpl();
  int currentTab = NotificationType.allActivities;
  String? userId = "";
  String? userName = "";
  List<Datum>? pendingRequests = List.empty(growable: true);
  List<n.Datum>? notifications = List.empty(growable: true);
  List<n.Datum>? notificationsEarlier = List.empty(growable: true);

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    userId = await SecuredStorage.readStringValue(Keys.userId);
    userName = (await SecuredStorage.readStringValue(Keys.firstName))! +
        " " +
        (await SecuredStorage.readStringValue(Keys.lastName))!;
    await getPendingFriendList();
    await getNotifications();
  }

  Future<void> getPendingFriendList() async {
    await notificationRepoImpl
        .getPendingFriendRequests(userId.toString())
        .then((res) {
      if (res.status == 200) {
        pendingRequests!.clear();
        pendingRequests!.addAll(res.data!);
      } else {
        showAppDialog(msg: res.message);
      }
      update();
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }

  Future<void> acceptRequestToJoin(Map<String, String> data) async {
    debugPrint("acceptRequestToJoin req $data");
    await ActivitiesRepoImpl().acceptRequestToJoin(data).then((res) {
      // if (res.status == 200) {

      //} else {
      //debugPrint("ARQL RES MSG ${res.message}");
      showAppDialog(msg: res["message"]);
      init();
      //}
      update();
    }).onError((error, stackTrace) {
      debugPrint("ARQL Error ${error.toString()}");
      update();
    });
  }

  Future<void> acceptRequestToJoinGroup(Map<String, String> data,
      {groupId, uid, name}) async {
    // {
    //   "groupId": 1,
    //   "adminId": 1,
    //   "role": "ADMIN",
    //   "userId": 46,
    //   "isAccept": 0
    // }
    debugPrint("acceptRequestToJoin req $data");
    await GroupRepoImpl()
        .acceptOrRejectRequestGroup(
      data,
    )
        .then((res) async {
      // if (res.status == 200) {
      if (data["isAccept"] == "1") {
        await addMemberToGroupCometChat(
            groupId: groupId.toString(),
            uid: uid.toString(),
            name: name.toString());
      }
      showAppDialog(msg: res.message);

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
    await GroupRepoImpl().acceptOrRejectInvitation(data).then((res) async {
      // if (res.status == 200) {
      if (data["isAccept"] == "1") {
        await joinToGroupCometChat(
            groupId: data["groupId"].toString(),
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

  Future<void> addMemberToGroupCometChat({groupId, uid, name}) async {
    CometChat.addMembersToGroup(
        guid: groupId.toString(),
        groupMembers: [
          GroupMember.fromUid(
            scope: CometChatMemberScope.participant,
            uid: uid.toString(),
            name: name.toString(),
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

  Future<void> getNotifications() async {
    await notificationRepoImpl
        .getNotifications({"userId": userId.toString()}).then((res) {
      if (res.status == 200) {
        notifications!.clear();
        notificationsEarlier!.clear();

        DateTime now = DateTime.now();
        for (var i = 0; i < res.data!.length; i++) {
          DateTime notifDate =
              DateTime.parse(res.data![i].createdDate.toString());
          if (notifDate.difference(now).inHours >= 6) {
            notificationsEarlier!.add(res.data![i]);
          } else {
            notifications!.add(res.data![i]);
          }
        }
        //notifications!.addAll(res.data!);
      } else {
        showAppDialog(msg: res.message);
      }
      update();
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }

  Future<void> acceptOrIgnoreRequest(index,
      {required String? friendId,
      required String? isAccept,
      String? type}) async {
    Map data = {"userId": userId, "friendId": friendId, "isAccept": isAccept};
    debugPrint("DAT $data");
    await friendsRepoImpl.acceptOrRejectRequest(data)!.then((res) async {
      if (res.status == 200) {
        if (res.message == "Friend request accepted") {
          //1 - pending, 2 - notifi, 3 - notifiEarl
          if (type! == "1") {
            pendingRequests!.removeAt(index);
          } else if (type == "2") {
            notifications!.removeAt(index);
          } else if (type == "3") {
            notificationsEarlier!.removeAt(index);
          }
          await addFriendInCommetChat(
              uid: userId.toString(), fuid: friendId.toString());
          showAppDialog(msg: "Friend request accepted");
        } else if (res.message == "Friend request rejected/unfriend") {
          if (type! == "1") {
            pendingRequests!.removeAt(index);
          } else if (type == "2") {
            notifications!.removeAt(index);
          } else if (type == "3") {
            notificationsEarlier!.removeAt(index);
          }
          showAppDialog(msg: "Friend request rejected");
        } else {
          showAppDialog(msg: res.message);
        }
      } else {
        showAppDialog(msg: "Status : ${res.status}\n${res.message}");
      }
      init();
      update();
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
      update();
    });
  }

  String getTime(String? createdDate) {
    String? timeStamp = createdDate.toString();
    DateTime dateTime = DateTime.parse(timeStamp);
    return timeago.format(dateTime, allowFromNow: false);
  }

  String getLine(String? notificationType) {
    switch (notificationType) {
      //Group Related
      case NotificationTypes.createdActivityInsideGroup:
        return "created an activity:";
      case NotificationTypes.sentJoinGroupRequest:
        return "has requested for approval to join";
      case NotificationTypes.acceptGroupJoinRequest:
        return "has approved your application to join";
      case NotificationTypes.sentJoinGroupInvitaion:
        return "invite you to";
      case NotificationTypes.joinGroup:
      case NotificationTypes.acceptJoinGroupInvitation:
        return "has just joined the";
      case NotificationTypes.pramotedToAdmin:
        return "You have been promoted to admin in";
      case NotificationTypes.pramotedToSupAdmin:
        return "You have been promoted to super admin in";

      //Activity Related
      case NotificationTypes.pramottedToSubHost:
        return "You have been promoted to sub-host in";
      case NotificationTypes.promottedToHost:
        return "You have been promoted to host in";
      case NotificationTypes.sentRequestToJoinActivity:
        return "has requested for approval to join";
      case NotificationTypes.acceptActivityJoinRequest:
        return "has approved your application to join";
      case NotificationTypes.joinActivity:
      case NotificationTypes.acceptJoinActivityInvitation:
        return "has just joined the";
      case NotificationTypes.sentJoinActivityInvitation:
        return "invite you to";
      case NotificationTypes.commentActivity:
        return "commented on your activity";

      //Friends Related
      case NotificationTypes.accetpFriendReq:
        return "accepted your friend request";
      case NotificationTypes.friendReqSent:
        return "send you a friend request";

      //Post Related
      case NotificationTypes.commentPost:
        return "commented on your post";
      case NotificationTypes.jioMePost:
        return '"jio me" in your post';
      case NotificationTypes.likePost:
        return "liked your post";
      default:
        return "";
    }
  }

  static Future<void> addFriendInCommetChat(
      {String? uid,
      String? fuid,
      Function(dynamic)? onSuccess,
      Function(Object)? onError}) async {
    CCFriendsRepoImpl ccFriendsRepoImpl = CCFriendsRepoImpl();
    List<String> accepted = List.empty(growable: true);
    accepted.add(fuid!);
    var data = {
      'uid': uid.toString(),
      'data': {'accepted': accepted}
    };
    debugPrint("commetchat add Json $data");
    ccFriendsRepoImpl.addCCFriend(data).then((res) {
      //onSuccess!(res);
      debugPrint("commetchat Add CC Friend RES $res");
      debugPrint("commetchat res ${res['data']['accepted'][fuid]['message']}");
    }).onError((error, stackTrace) {
      //onError!(error!);
      debugPrint("commetchat error add cc friend ${error.toString()}");
    });
  }

  static Future<void> removeFriendInCommetChat(
      {String? uid,
      dynamic fuid,
      Function(dynamic)? onSuccess,
      Function(Object)? onError}) async {
    CCFriendsRepoImpl ccFriendsRepoImpl = CCFriendsRepoImpl();

    List<String> friends = List.empty(growable: true);
    if (fuid is String) {
      friends.add(fuid);
    } else {
      friends = fuid;
    }

    var data = {
      'uid': uid.toString(),
      'data': {'friends': friends}
    };
    debugPrint("commetchat remove Json $data");
    ccFriendsRepoImpl.removeCCFriend(data).then((res) {
      //onSuccess!(res);
      if (res.data!.success!) {
        debugPrint("commetchat Rem CC Friend RES $res");
        debugPrint("commetchat res ${res.data!.message}");
      } else {
        debugPrint("commetchat Rem CC Friend RES $res");
        debugPrint("commetchat res ${res.data!.message}");
      }
    }).onError((error, stackTrace) {
      //onError!(error!);
      debugPrint("commetchat error rem cc friend ${error.toString()}");
    });
  }

  Future<void> acceptActivityInvite({index, activityId, type, data}) async {
    // var data = {
    //   "userId": userId.toString(),
    //   "activityId": activityId.toString()
    // };
    debugPrint("acceptActivityInvite data $data");
    await ActivitiesRepoImpl().acceptInvite(data)!.then((res) {
      if (res.status == 200) {
        showAppDialog(msg: res.message);

        // if (type! == "1") {
        //   pendingRequests!.removeAt(index);
        // } else if (type == "2") {
        //   notifications!.removeAt(index);
        // } else if (type == "3") {
        //   notificationsEarlier!.removeAt(index);
        // }
      } else {
        showAppDialog(msg: res.message);
      }
      getNotifications();
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }

  // Future<void> makeFriend(Map data,
  //     {required Function(CcAddFreindResponse)? onSuccess,
  //     required Function(Object)? onError}) async {}
  Future<void> rejectActivityInvite({index, activityId, type, data}) async {
    // var data = {
    //   "userId": userId.toString(),
    //   "activityId": activityId.toString()
    // };
    debugPrint("acceptActivityInvite data $data");
    await ActivitiesRepoImpl().rejectInvite(data)!.then((res) {
      if (res.status == 200) {
        showAppDialog(msg: res.message);
        // if (type! == "1") {
        //   pendingRequests!.removeAt(index);
        // } else if (type == "2") {
        //   notifications!.removeAt(index);
        // } else if (type == "3") {
        //   notificationsEarlier!.removeAt(index);
        // }
      } else {
        showAppDialog(msg: res.message);
      }
      getNotifications();
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }
}

class NotificationType {
  static const allActivities = 0;
  static const friendRequest = 1;
}

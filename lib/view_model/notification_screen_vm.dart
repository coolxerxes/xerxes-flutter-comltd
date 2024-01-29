import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:jyo_app/data/local/notification_type.dart';
import 'package:jyo_app/repository/commetchat_repo/friends_repo/friends_repo_impl.dart';
import 'package:jyo_app/repository/freinds_repo/freinds_repo_impl.dart';
import 'package:jyo_app/repository/notification_repo/notification_repo_impl.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/utils/secured_storage.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/notification_model/pending_friend_req_response_model.dart';
import '../models/notification_model/notification_history_response.dart' as n;

class NotificationScreenVM extends GetxController {
  final notificationRepoImpl = NotificationRepoImpl();
  final friendsRepoImpl = FriendsRepoImpl();
  int currentTab = NotificationType.allActivities;
  String? userId = "";
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
      case NotificationTypes.accetpFriendReq:
        return "accepted your friend request";
      case NotificationTypes.friendReqSent:
        return "send you a friend request";
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

  // Future<void> makeFriend(Map data,
  //     {required Function(CcAddFreindResponse)? onSuccess,
  //     required Function(Object)? onError}) async {}
}

class NotificationType {
  static const allActivities = 0;
  static const friendRequest = 1;
}

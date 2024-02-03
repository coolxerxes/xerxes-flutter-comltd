import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jyo_app/data/local/user_search_model.dart';
import 'package:jyo_app/data/remote/endpoints.dart';
import 'package:jyo_app/repository/freinds_repo/freinds_repo_impl.dart';
import 'package:jyo_app/repository/profile_repo/profile_repo_impl.dart';
import 'package:jyo_app/resources/app_strings.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/view_model/base_screen_vm.dart';
import 'package:jyo_app/view_model/notification_screen_vm.dart';
import 'package:jyo_app/view_model/posts_and_activities_vm.dart';
import 'package:jyo_app/view_model/timeline_screen_vm.dart';

import '../models/search_people_model/user_friend_profile_model.dart';
import '../utils/secured_storage.dart';

class FriendUserProfileScreenVM extends GetxController {
  final friendsRepoImpl = FriendsRepoImpl();
  final profileRepoImpl = ProfileRepoImpl();
  final tsv = Get.put(TimelineScreenVM());
  final baseVM = Get.find<BaseScreenVM>();
  final postsVM = PostsAndActivitiesVM(); //Get.find<PostsAndActivitiesVM>();
  final notificationScreenV = Get.put(NotificationScreenVM());
  String? myUserId = "", userId = "";
  String? firstName = "", lastName = "", age = "", userName = "", bio = "";
  String? freinds = "0", posts = "0", activities = "0";

  bool? isThisUserMyFriend = false;
  bool? isPrivateAccount = false;
  bool? isRequestSent = false;
  bool? isRequestRecieved = false;
  //bool? isThisUserPrivate = false;
  bool? isThisUserBlocked = false;
  bool? amIBlockedByThisUser = false;
  bool? isLoadingPost = true;
  bool? isThisMyProfile = false;
  bool? isAppStartingFromNotification = false;

  List<IntrestId> userIntrests = List.empty(growable: true);
  String? imageFileName = "";

  int profileSection = 0;
  bool? isEnabled = true;
  bool? isOnlyMePrivacy = false;
  bool? isFriendsPrivacy = false;
  bool? isEveryonePrivacy = false;

  bool isLoadingActs = true;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    Map? args = Get.arguments;
    if (args != null) {
      isAppStartingFromNotification = args["isAppStartingFromNotification"];
    }
    myUserId = "";
    firstName = "";
    lastName = "";
    age = "";
    userName = "";
    bio = "";
    freinds = "0";
    posts = "0";
    activities = "0";
    isThisUserMyFriend = false;
    isRequestSent = false;
    isRequestRecieved = false;
    //isThisUserPrivate = false;
    isThisUserBlocked = false;
    amIBlockedByThisUser = false;
    isThisMyProfile = false;
    isOnlyMePrivacy = false;
    isFriendsPrivacy = false;
    isEveryonePrivacy = false;

    userIntrests = List.empty(growable: true);
    postsVM.postsList = List.empty(growable: true);
    postsVM.taggedUsersList = List.empty(growable: true);
    postsVM.cvm.commentList = List.empty(growable: true);
    postsVM.likeUsers = List.empty(growable: true);
    imageFileName = "";

    profileSection = 0;
    isEnabled = true;
    SecuredStorage.initiateSecureStorage();
    myUserId = await SecuredStorage.readStringValue(Keys.userId);

    if (SearchUser.getId != null) {
      userId = SearchUser.getId;
    } else {
      userId = Get.arguments!['id'];
    }
    postsVM.afterInit(this, endpoint: Endpoints.post);
    await getProfileData();
    if (!(amIBlockedByThisUser! ||
        (isPrivateAccount! && !isThisUserMyFriend!))) {
      await getPosts();
      await getActivities();
    }
    isLoadingPost = false;
    update();
  }

  Future<void> getProfileData() async {
    Map data = {"myUserId": myUserId, "userId": userId};
    debugPrint("profile data $data");
    await friendsRepoImpl.userFriendProfile(data)!.then((res) {
      if (res.status == 200) {
        userIntrests.clear();
        firstName = res.data!.profileData!.userInfo!.firstName.toString();
        lastName = res.data!.profileData!.userInfo!.lastName.toString();
        if (res.data!.profileStatusData!.isYoublock != 1) {
          age = res.data!.profileData!.age.toString();
          userName = res.data!.profileData!.userInfo!.username.toString();
          bio = res.data!.profileData!.userInfo!.biography.toString();
          userIntrests.addAll(res.data!.profileData!.userIntrest!.intrestIds!);
          freinds = res.data!.profileData!.friendsCount.toString();
          activities = res.data!.profileData!.activity.toString();
          posts = res.data!.profileData!.post.toString();
          imageFileName =
              res.data!.profileData!.userInfo!.profilePic.toString();
        }
        if (res.data!.profileStatusData!.isFriend == 1) {
          isThisUserMyFriend = true;
        }
        if (res.data!.profileStatusData!.isSentRequest == 1) {
          isRequestSent = true;
        }
        if (res.data!.profileStatusData!.isReceivedRequest == 1) {
          isRequestRecieved = true;
        }
        if (res.data!.profileStatusData!.isBlocked == 1) {
          isThisUserBlocked = true;
        }
        if (res.data!.profileStatusData!.isYoublock == 1) {
          amIBlockedByThisUser = true;
          showAppDialog(msg: "User blocked you for some reason.");
        }
        if (res.data!.profileStatusData!.myProfile == 1) {
          isThisMyProfile = true;
        }
        if (res.data!.profileStatusData!.isPrivateAccount == 1) {
          isPrivateAccount = true;
        }
        if (res.data!.profileStatusData!.postPrivacy!.onlyMe == 1) {
          isOnlyMePrivacy = true;
        }
        if (res.data!.profileStatusData!.postPrivacy!.friendsOnly == 1) {
          isFriendsPrivacy = true;
        }
        if (res.data!.profileStatusData!.postPrivacy!.everyone == 1) {
          isEveryonePrivacy = true;
        }
        SearchUser.setId = null;
      } else {
        showAppDialog(msg: res.message);
      }
      update();
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }

  Future<void> addFriend() async {
    isEnabled = false;
    update();
    Map data = {"userId": myUserId, "friendId": userId};
    debugPrint("addFriend Req $data");
    await friendsRepoImpl.sendFriendRequest(data)!.then((res) {
      if (res.status == 200) {
        if (res.data!.status == "Pending") {
          isRequestSent = true;
        }
      } else {
        showAppDialog(msg: res.message);
      }
      isEnabled = true;
      update();
    }).onError((error, stackTrace) {
      isEnabled = true;
      update();
      showAppDialog(msg: error.toString());
    });
  }

  Future<void> acceptOrRejectRequest({required String? isAccept}) async {
    // isEnabled = false;
    // update();
    Map data = {"userId": myUserId, "friendId": userId, "isAccept": isAccept};
    debugPrint("acceptOrRej req $data");
    await friendsRepoImpl.acceptOrRejectRequest(data)!.then((res) async {
      if (res.status == 200) {
        if (res.message == "Friend request accepted") {
          isThisUserMyFriend = true;
          isRequestSent = false;
          isRequestRecieved = false;
          await NotificationScreenVM.addFriendInCommetChat(
            uid: myUserId.toString(), fuid: userId.toString(),
            // onSuccess: (res){
            //   debugPrint("onSuccess: Add CC Friend RES $res");
            //   debugPrint("onSuccess: res ${res['data']['accepted'][userId]['message']}");
            // }, onError: (error){
            //   debugPrint("onError: error add cc friend ${error.toString()}");
            // }
          );
          await init();
        } else if (res.message == "Friend request rejected/unfriend") {
          isThisUserMyFriend = false;
          isRequestSent = false;
          isRequestRecieved = false;
          await NotificationScreenVM.removeFriendInCommetChat(
              uid: myUserId.toString(), fuid: userId.toString());
          await init();
        }
        notificationScreenV.init();
      } else {
        showAppDialog(msg: res.message, btnText: AppStrings.okay);
      }
      // isEnabled = true;
      update();
    }).onError((error, stackTrace) {
      // isEnabled = true;
      // update();
      showAppDialog(msg: error.toString());
    });
  }

  Future<void> blockUserProfile() async {
    Map data = {"userId": myUserId, "friendId": userId};
    debugPrint("block user prof req $data");
    await friendsRepoImpl.blockUserProfile(data)!.then((res) async {
      if (res.status == 200) {
        if (res.message == "User blocked") {
          await NotificationScreenVM.removeFriendInCommetChat(
              uid: myUserId.toString(), fuid: userId.toString());
          showAppDialog(msg: res.message);
          await init();
        }
      } else {
        showAppDialog(msg: res.message);
      }
      update();
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }

  Future<void> unblockUser() async {
    List<String> block = List.empty(growable: true);
    List<String> unblock = List.empty(growable: true);

    unblock.add(userId.toString());
    //var data = {"userId": userId, "blockUsers": blockListLocal};
    var data = {
      "userId": myUserId,
      "blockUsers": block,
      "unblockUser": unblock
    };
    debugPrint("blocking data $data");
    await profileRepoImpl.blockUsers(data).then((res) async {
      if (res.status == 200) {
        //Get.back();
        init();
      } else {
        showAppDialog(msg: res.message.toString());
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }

  Future<void> cancelFriendRequest() async {
    isEnabled = false;
    update();
    Map data = {"myUserId": myUserId, "friendId": userId};
    debugPrint("cancel Req $data");
    await friendsRepoImpl.cancelFriendRequest(data)!.then((res) async {
      if (res.status == 200) {
        await init();
      } else {
        showAppDialog(msg: res.message);
      }
      isEnabled = true;
      update();
    }).onError((error, stackTrace) {
      isEnabled = true;
      update();
      showAppDialog(msg: error.toString());
    });
  }

  Future<void> getPosts() async {
    var data = {"userId": myUserId.toString(), "friendId": userId.toString()};
    debugPrint("getPostsData friend $data");
    await postsVM.getPostByUser(data, this).then((res) async {
      postsVM.postsList.clear();
      postsVM.postsList.addAll(res);
      update();
    }).onError((error, stackTrace) {
      showAppDialog(msg: "Error ${error.toString()}");
      isLoadingPost = false;
      update();
    });
  }

  Future<void> getActivities() async {
    var data = {"userId": userId.toString()};
    debugPrint("data acts fup $data");
    await postsVM.getActivitiesByUser(data, this).then((res) async {
      postsVM.activitiesList.clear();
      postsVM.activitiesList.addAll(res);
      isLoadingActs = false;
      update();
    }).onError((error, stackTrace) {
      showAppDialog(msg: "Error ${error.toString()}");
      isLoadingActs = false;
      update();
    });
  }
}

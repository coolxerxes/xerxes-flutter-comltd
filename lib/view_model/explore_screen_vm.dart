import 'package:flutter/material.dart';
import 'package:flutter_chat_ui_kit/flutter_chat_ui_kit.dart';
import 'package:get/get.dart';
import 'package:jyo_app/repository/notification_repo/notification_repo_impl.dart';
import 'package:jyo_app/utils/secured_storage.dart';

import '../data/remote/api_interface.dart';
import '../data/remote/endpoints.dart';
import '../repository/profile_repo/profile_repo_impl.dart';
import '../utils/commet_chat_constants.dart';

class ExploreScreenVM extends GetxController {
  NotificationRepoImpl notificationRepoImpl = NotificationRepoImpl();
  ProfileRepoImpl profileRepoImpl = ProfileRepoImpl();

  String? userId, dob, gender, profile, faceUrl, firstName, lastName;

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
        // Use `MapController` as needed
    });
    init();
    super.onInit();
  }

  Future<void> init() async {
    SecuredStorage.initiateSecureStorage();
    await getStorageData();
    notificationApi();
    loginIntoCommetChat();
  }

  Future<void> notificationApi() async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    String? deviceToken =
        await SecuredStorage.readStringValue(Keys.deviceToken);
    var data = {"userId": userId, "deviceId": deviceToken};
    debugPrint("NOTI data $data");
    await notificationRepoImpl.sendSignInNotification(data).then((res) {
      debugPrint("NOTI MSG ${res.message}");
    }).onError((error, stackTrace) {
      debugPrint("NOTI ERROR ${error.toString()}");
    });
  }

  Future<void> createCommetChatUser() async {
    String authKey =
        CometChatConstants.authKey; //Replace with the auth key of app
    User user = User(
        uid: userId.toString(),
        name: firstName! + " " + lastName!,
        avatar: faceUrl); //Replace with name and uid of user

    CometChat.createUser(user, authKey, onSuccess: (User user) {
      debugPrint("commetchat Create User succesful $user");
      loginIntoCommetChat();
    }, onError: (CometChatException e) {
      debugPrint(
          "commetchat Create User Failed with exception ${e.message}, ${e.code}");
    });
  }

  Future<void> loginIntoCommetChat() async {
    final user = await CometChat.getLoggedInUser();
    if (user == null) {
      await CometChatUIKit.login(userId.toString(), onSuccess: (user) {
        debugPrint("commetchat Login Successful : $user");
      }, onError: (CometChatException e) {
        debugPrint(
            "commetchat Login failed with exception:  ${e.message}, ${e.code}");
        if (e.code.toString() == "ERR_UID_NOT_FOUND") {
          createCommetChatUser();
        } else {
          debugPrint("else commetchat Login failed with exception:  ${e.message}, ${e.code}");
        }
      });
    } else {
      //User is already logged in.
      debugPrint("commetchat User is already logged in");
    }
  }

  Future<void> getStorageData() async {
    userId = await SecuredStorage.readStringValue(Keys.userId);
    firstName = await SecuredStorage.readStringValue(Keys.firstName);
    lastName = await SecuredStorage.readStringValue(Keys.lastName);
    gender = await SecuredStorage.readStringValue(Keys.gender);
    dob = await SecuredStorage.readStringValue(Keys.birthday);
    profile = await SecuredStorage.readStringValue(Keys.profile);
    faceUrl = ApiInterface.baseUrl +
        Endpoints.user +
        Endpoints.profileImage +
        profile.toString();
  }
}

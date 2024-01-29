// ignore_for_file: empty_catches

import 'dart:convert';

import 'package:device_information/device_information.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jyo_app/repository/profile_repo/profile_repo_impl.dart';
import 'package:jyo_app/repository/registration_repo/registration_repo_impl.dart';
import 'package:jyo_app/utils/secured_storage.dart';
import 'package:permission_handler/permission_handler.dart';

import '../resources/app_routes.dart';
import '../utils/common.dart';

class LoginVM extends GetxController {
  RegistrationRepoImpl registrationRepoImpl = RegistrationRepoImpl();
  ProfileRepoImpl profileRepoImpl = ProfileRepoImpl();
  Map? fbUserData;
  GoogleSignInAccount? googleUserData;
  String? imeiNo = "";

  void fbLogin() async {
    showAppDialog(msg: "Facebook login is comming soon.");
    //Will Uncomment it later, NOT TO BE DELETED!
    // final result =
    //     await FacebookAuth.i.login(permissions: ["public_profile", "email"]);
    // if (result.status == LoginStatus.success) {
    //   final requestData = await FacebookAuth.i.getUserData(
    //     fields: "email,name",
    //   );

    //   fbUserData = requestData;
    //   debugPrint("FB_USER_DATA $fbUserData");
    //   update();
    // }
  }

  void googleLogin() async {
    try {
      final googleSignIn = GoogleSignIn();
      googleUserData = await googleSignIn.signIn();

      if (googleUserData != null) {
        debugPrint(
            "DISPLAY NAME ${googleUserData!.displayName},\nIMG URL ${googleUserData!.photoUrl},\nEmail ${googleUserData!.email}. providerKey ${googleUserData!.id} ");
        var providerKey = googleUserData!.id.toString();
        var email = googleUserData!.email.toString();
        await signIn(providerKey, email);
      } else {
        showAppDialog(
          msg: "Unable to login via Google",
        );
      }
    } catch (e) {
      showAppDialog(msg: "Unable to login via Google");
    }
  }

  void appleLogin() async {}

  void googleLogOut() async {
    final googleSignIn = GoogleSignIn();
    try {
      await googleSignIn.disconnect();
    } catch (e) {}
    googleUserData = null;
  }

  void fbLogOut() async {
    await FacebookAuth.i.logOut();
    fbUserData = null;
  }

  void appleLogOut() {}

  void logOutAll() {
    googleLogOut();
    fbLogOut();
    appleLogOut();
  }

  Future<void> signIn(providerKey, email) async {
    if (imeiNo.toString().trim().isEmpty) {
      showAppDialog(
          msg: "Need required permissions to continue",
          onPressed: () {
            Get.back();
            getRequiredPermission();
          });
      return;
    }
    var data = {
      //"email":email,
      "providerKey": providerKey.toString(),
      "imNo": imeiNo.toString()
    };
    debugPrint("DATA A $data");
    await registrationRepoImpl.signIn(data).then((response) async {
      if (response.status == 200) {
        await SecuredStorage.writeStringValue(
            Keys.userId, response.data!.userId.toString());
        await getProfileData();
        switch (response.message.toString().trim()) {
          case RedirectionMessages.displayPage:
          case RedirectionMessages.displayPage2:
            getOffNamed(displayNameRoute);
            break;
          case RedirectionMessages.interestsPage:
            getOffNamed(mostLikedScreenRoute);
            break;
          case RedirectionMessages.profilePage:
            getOffNamed(setProfilePicScreenRoute);
            break;
          default:
            navigate();
            break;
        }
      } else {
        showAppDialog(msg: response.message.toString());
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }

  Future<void> getDeviceInformation() async {
    try {
      //platformVersion = await DeviceInformation.platformVersion;
      imeiNo = await DeviceInformation.deviceIMEINumber;
      debugPrint("IMEI NO ${imeiNo.toString()}");
      //modelName = await DeviceInformation.deviceModel;
      //manufacturer = await DeviceInformation.deviceManufacturer;
      //apiLevel =  await DeviceInformation.apiLevel;
      //deviceName = await DeviceInformation.deviceName;
      //productName = await DeviceInformation.productName;
      //cpuType = await DeviceInformation.cpuName;
      //hardware = await DeviceInformation.hardware;
    } on PlatformException catch (e) {
      // platformVersion = 'Failed to get platform version.';
      debugPrint("HERE IN PFE ${e.toString()}");
    }
  }

  void getRequiredPermission() async {
    // prints PermissionStatus.granted
    var status = await Permission.phone.status;
    if (!status.isGranted) {
      final result = await Permission.phone.request();
      if (result.isGranted) {
        getDeviceInformation();
      }
      if (result.isPermanentlyDenied) {
        await Permission.phone.request();
      } else {}
    } else {
      getDeviceInformation();
    }
    //debugPrint("PERM ${await Permission.phone.status}");
  }

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() async {
    try {
      SecuredStorage.initiateSecureStorage();
      getRequiredPermission();
      logOutAll();
    } catch (e) {}
  }

  Future<void> getProfileData() async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    await profileRepoImpl.getUserInfo(userId).then((res) async {
      if (res.status == 200) {
        // userIntrests.clear();

        var firstName = res.data!.userInfoData!.firstName.toString().trim();
        var lastName = res.data!.userInfoData!.lastName.toString().trim();
        String? age = res.data!.userInfoData!.birthDay.toString().trim();
        if (age.isNotEmpty) {
          await SecuredStorage.writeStringValue(Keys.birthday, "DONE For Now");
        }
        await SecuredStorage.writeStringValue(Keys.firstName, firstName);
        await SecuredStorage.writeStringValue(Keys.lastName, lastName);
        await SecuredStorage.writeStringValue(Keys.birthday, "DONE For Now");

        var selectedIntrestIds = [];
        for (var i = 0; i < res.data!.userIntrestData!.length; i++) {
          selectedIntrestIds.add(res.data!.userIntrestData![i].id);
        }
        var data = {"userId": userId, "intrestIds": selectedIntrestIds};
        await SecuredStorage.writeStringValue(Keys.interests, jsonEncode(data));
        await SecuredStorage.writeStringValue(Keys.groups, "DONE");
        await SecuredStorage.writeStringValue(
            Keys.profile, res.data!.userInfoData!.profilePic);
        //userIntrests.addAll(res.data!.userIntrestData!);
        update();
      } else {
        showAppDialog(msg: "Error ${res.message.toString()}");
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: "Error ${error.toString()}");
    });
  }

  void navigate() async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    String? birthday = await SecuredStorage.readStringValue(Keys.birthday);
    String? firstName = await SecuredStorage.readStringValue(Keys.firstName);
    String? lastName = await SecuredStorage.readStringValue(Keys.lastName);
    String? intrests = await SecuredStorage.readStringValue(Keys.interests);
    String? groups = await SecuredStorage.readStringValue(Keys.groups);
    String? profile = await SecuredStorage.readStringValue(Keys.profile);

    if (userId != null &&
        userId.toString().trim().isNotEmpty &&
        userId != "null") {
      if (firstName == null || firstName.toString().trim().isEmpty) {
        getOffNamed(displayNameRoute);
      } else if (lastName == null || lastName.toString().trim().isEmpty) {
        getOffNamed(displayNameRoute);
      } else if (birthday == null || birthday.toString().trim().isEmpty) {
        getOffNamed(displayNameRoute);
      } else if (intrests == null || intrests.toString().trim().isEmpty) {
        getOffNamed(mostLikedScreenRoute);
      } else if (intrests.toString().trim().isNotEmpty) {
        var data = jsonDecode(intrests.toString().trim()) as Map;
        var list = data["intrestIds"] as List;
        if (list.isEmpty) {
          getOffNamed(mostLikedScreenRoute);
        } else {
          if (groups == null || groups.toString().trim().isEmpty) {
            getOffNamed(groupSuggestionScreenRoute);
          } else if (profile == null || profile.toString().trim().isEmpty) {
            getOffNamed(setProfilePicScreenRoute);
          } else {
            getOffNamed(baseScreenRoute);
          }
        }
      } else if (groups == null || groups.toString().trim().isEmpty) {
        getOffNamed(groupSuggestionScreenRoute);
      } else if (profile == null || profile.toString().trim().isEmpty) {
        getOffNamed(setProfilePicScreenRoute);
      } else {
        getOffNamed(baseScreenRoute);
      }
    } else {
      getOffNamed(loginScreenRoute);
    }
  }
}

class RedirectionMessages {
  static const displayPage =
      "user exist - last login updated - first and last name require";
  static const displayPage2 =
      "new user created - last login updated - first and last name require";
  static const interestsPage =
      "user exist - last login updated - user interest require";
  static const profilePage =
      "user exist - last login updated - user profile picture require";
  static const userCreated = "user exist - last login updated";
}

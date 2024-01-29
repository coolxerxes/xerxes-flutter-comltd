// ignore_for_file: prefer_const_declarations

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jyo_app/repository/profile_repo/profile_repo_impl.dart';
import 'package:jyo_app/repository/registration_repo/registration_repo_impl.dart';
import 'package:jyo_app/utils/secured_storage.dart';
import 'package:jyo_app/view_model/phone_number_vm.dart';
import 'package:otp_text_field/otp_text_field.dart';

import '../resources/app_routes.dart';
import '../utils/common.dart';

class OtpScreenVM extends GetxController {
  RegistrationRepoImpl registrationRepoImpl = RegistrationRepoImpl();
  ProfileRepoImpl profileRepoImpl = ProfileRepoImpl();
  PhoneNumberVM phoneNumberVM = Get.find<PhoneNumberVM>();

  String? timerTextMin = "0";
  String? timerTextSec = "00";

  Timer? countdownTimer;
  Duration myDuration = const Duration(minutes: 4);
  OtpFieldController otpCrl = OtpFieldController();
  String? otp = "";

  void setCountDown() {
    final reduceSecondsBy = 1;
    final seconds = myDuration.inSeconds - reduceSecondsBy;
    if (seconds < 0) {
      countdownTimer!.cancel();
    } else {
      myDuration = Duration(seconds: seconds);
    }
    timerTextMin = strDigits(myDuration.inMinutes.remainder(60));
    timerTextSec = strDigits(myDuration.inSeconds.remainder(60));
    update();
  }

  String strDigits(int n) => n.toString().padLeft(2, '0');

  @override
  void onInit() {
    SecuredStorage.initiateSecureStorage();
    startTimer();
    super.onInit();
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  Future<void> checkOtp() async {
    dynamic data = {};
    data["hpNo"] = phoneNumberVM.phoneNoCtr.text.trim();
    data["countryCode"] = phoneNumberVM.cCode.toString();
    data["imNo"] = phoneNumberVM.imeiNo.toString().trim();
    data["currentCode"] = otp.toString().trim();

    debugPrint("DATA ${jsonEncode(data)}");

    //Temporary
    // if (countdownTimer != null) {
    //   countdownTimer!.cancel();
    // }

    // getOffNamed(displayNameRoute);

    await registrationRepoImpl.checkOtp(data).then((response) async {
      debugPrint("RESPONSE ${response.status}");
      if (response.status == 200) {
        if (countdownTimer != null) {
          countdownTimer!.cancel();
        }

        await SecuredStorage.writeStringValue(
            Keys.userId, response.data!.userId.toString());
        await getProfileData();
        switch (response.data!.message.toString().trim()) {
          case RedirectionMessages.displayPage:
          case RedirectionMessages.displayPage2:
            debugPrint("displayPage");
            getOffNamed(displayNameRoute);
            break;
          case RedirectionMessages.genderPage:
            debugPrint("genderPage");
            getOffNamed(genderRoute);
            break;
          case RedirectionMessages.interestsPage:
            debugPrint("interestsPage");
            getOffNamed(mostLikedScreenRoute);
            break;
          case RedirectionMessages.profilePage:
            debugPrint("profilePage");
            getOffNamed(setProfilePicScreenRoute);
            break;
          default:
            debugPrint("def");
            navigate();
            break;
        }
      } else {
        // //TEMP
        // await SecuredStorage.writeStringValue(
        //     Keys.userId, "4");
        //getOffNamed(displayNameRoute);
        showAppDialog(msg: response.data!.message.toString());
      }
    }).onError((error, stackTrace) {
      debugPrint("RESPONSE otp error ${error.toString()}");
    });
  }

  void navigate() async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    String? birthday = await SecuredStorage.readStringValue(Keys.birthday);
    String? firstName = await SecuredStorage.readStringValue(Keys.firstName);
    String? lastName = await SecuredStorage.readStringValue(Keys.lastName);
    String? gender = await SecuredStorage.readStringValue(Keys.gender);
    String? intrests = await SecuredStorage.readStringValue(Keys.interests);
    String? groups = await SecuredStorage.readStringValue(Keys.groups);
    String? profile = await SecuredStorage.readStringValue(Keys.profile);
    debugPrint(
        "userId $userId, birthday $birthday, firstName $firstName, lastName $lastName, gender $gender interest $intrests, groups $groups, propic $profile");
    if (userId != null &&
        userId.toString().trim().isNotEmpty &&
        userId != "null") {
      if (firstName == null || firstName.toString().trim().isEmpty) {
        getOffNamed(displayNameRoute);
      } else if (lastName == null || lastName.toString().trim().isEmpty) {
        getOffNamed(displayNameRoute);
      }else if (gender == null || gender.toString().trim().isEmpty) {
        getOffNamed(genderRoute);
      }
      // else if (birthday == null || birthday.toString().trim().isEmpty) {
      //   getOffNamed(displayNameRoute);
      // }
      else if (intrests == null || intrests.toString().trim().isEmpty) {
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

  Future<void> checkOtpForChange() async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    dynamic data = {};
    data["hpNo"] = phoneNumberVM.phoneNoCtr.text.trim();
    data["countryCode"] = phoneNumberVM.cCode.toString();
    data["imNo"] = phoneNumberVM.imeiNo.toString().trim();
    data["currentCode"] = otp.toString().trim();
    data["userId"] = userId;

    debugPrint("DATA ${jsonEncode(data)}");

    //Temporary
    // if (countdownTimer != null) {
    //   countdownTimer!.cancel();
    // }

    // getOffNamed(displayNameRoute);

    await profileRepoImpl.checkChangePhoneNoOTP(data).then((response) async {
      debugPrint("RESPONSE ${response.status}");
      if (response.status == 200) {
        if (countdownTimer != null) {
          countdownTimer!.cancel();
        }

        Get.back();
        //Get.back();
        showAppDialog(msg: response.message.toString());
      } else {
        // //TEMP
        // await SecuredStorage.writeStringValue(
        //     Keys.userId, "4");
        //getOffNamed(displayNameRoute);
        Get.back();
        showAppDialog(msg: response.message.toString());
      }
    }).onError((error, stackTrace) {
      Get.back();
      debugPrint("RESPONSE otp error ${error.toString()}");
    });
  }

  Future<void> getProfileData() async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    await profileRepoImpl.getUserInfo(userId).then((res) async {
      if (res.status == 200) {
        // userIntrests.clear();

        var firstName = res.data!.userInfoData!.firstName.toString().trim();
        var lastName = res.data!.userInfoData!.lastName.toString().trim();
        var gender = res.data!.userInfoData!.gender.toString().trim();
        debugPrint("FName $firstName, Lname $lastName");
        String? age = res.data!.userInfoData!.birthDay.toString().trim();
        if (age.isNotEmpty) {
          await SecuredStorage.writeStringValue(Keys.birthday, "DONE For Now");
        }
        await SecuredStorage.writeStringValue(Keys.firstName, firstName);
        await SecuredStorage.writeStringValue(Keys.lastName, lastName);
        await SecuredStorage.writeStringValue(Keys.gender, gender);
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
}

class RedirectionMessages {
  static const displayPage =
      "OTP match - last login updated - first and last name require";
  static const displayPage2 =
      "OTP matched user created - last login updated - first and last name require";
  static const genderPage = "OTP match - last login updated - gender require";
  static const interestsPage =
      "OTP match - last login updated - user interest require";
  static const profilePage =
      "OTP match - last login updated - user profile picture require";
  static const userCreated = "OTP match - last login updated";
}

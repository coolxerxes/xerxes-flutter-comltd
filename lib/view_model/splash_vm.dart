// ignore_for_file: unused_catch_clause

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_ui_kit/flutter_chat_ui_kit.dart';
import 'package:get/get.dart';
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/utils/app_widgets/app_gradient_btn.dart';
import 'package:jyo_app/utils/common.dart';

import 'package:flutter/services.dart';
import 'package:jyo_app/utils/secured_storage.dart';
import 'package:jyo_app/view_model/base_screen_vm.dart';
import 'package:pushy_flutter/pushy_flutter.dart';

import '../data/local/user_search_model.dart';
import '../main.dart';
import '../utils/commet_chat_constants.dart';

class SplashVM extends GetxController {
  Timer? t;
  bool? isDialogOpen = false;
  bool isAppStartingFromNotification = false;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> initCommetChat() async {
    makeUISettings();
  }

  dynamic makeUISettings() {
    UIKitSettings authSettings = (UIKitSettingsBuilder()
          ..subscriptionType = CometChatSubscriptionType.allUsers
          ..region = CometChatConstants.region
          ..autoEstablishSocketConnection = true
          ..appId = CometChatConstants.appId
          ..apiKey = CometChatConstants.authKey)
        .build();

    CometChatUIKit.init(
        authSettings: authSettings,
        onSuccess: (String msg) {
          debugPrint("commetchat init success : $msg");
        },
        onError: (e) {
          debugPrint("commetchat init error : ${e.toString()}");
        });
  }

  init() async {
    //CommetChat initialisation
    initCommetChat();

    // Start the Pushy service
    Pushy.listen();

    // Enable in-app notification banners (iOS 10+)
    Pushy.toggleInAppBanner(true);

    // Listen for push notifications received
    Pushy.setNotificationListener(backgroundNotificationListener);

    // Listen for notification click
    Pushy.setNotificationClickListener((Map<String, dynamic> data) async {
      // Print notification payload data
      debugPrint('Notification click: $data');

      // Extract notification messsage

      if (data["payload"] != null) {
        // debugPrint("pl ${data["payload"]}");
        //debugPrint("pl ${jsonDecode(data["payload"])}");
        //isDialogOpen = true;

        if (!Get.isRegistered<BaseScreenVM>()) {
          Get.put(BaseScreenVM());
          isAppStartingFromNotification = true;
        }
        // Get.snackbar(
        //     "isAppStartingFromNotification", "$isAppStartingFromNotification");
        try {
          var payload = jsonDecode(data["payload"]);
          if (payload["notificationType"] == "friend_req_sent") {
            SearchUser.setId = payload["userId"].toString();
            await getToNamed(friendUserProfileScreeRoute,
                argument: isAppStartingFromNotification
                    ? {"isAppStartingFromNotification": true}
                    : null);
          } else if (payload["notificationType"] == "accept_friend_req") {
            SearchUser.setId = payload["userId"].toString();
            await getToNamed(friendUserProfileScreeRoute,
                argument: isAppStartingFromNotification
                    ? {"isAppStartingFromNotification": true}
                    : null);
          } else if (payload["notificationType"] == "like_post") {
            NotiPost.setId = payload["postId"].toString();
            await getToNamed(singlePostScreenRoute,
                argument: isAppStartingFromNotification
                    ? {"isAppStartingFromNotification": true}
                    : null);
          } else if (payload["notificationType"] == "comment_post") {
            NotiPost.setId = payload["postId"].toString();
            await getToNamed(singlePostScreenRoute,
                argument: isAppStartingFromNotification
                    ? {"isAppStartingFromNotification": true}
                    : null);
          } else if (payload["notificationType"] == "jio_me_post") {
            NotiPost.setId = payload["postId"].toString();
            await getToNamed(singlePostScreenRoute,
                argument: isAppStartingFromNotification
                    ? {"isAppStartingFromNotification": true}
                    : null);
          }
          // if (!isAppStartingFromNotification) {
          //   SecuredStorage.initiateSecureStorage();
          //   //if (!isDialogOpen!) {
          //   t = Timer.periodic(const Duration(seconds: 2), (t) {
          //     navigate();
          //     t.cancel();
          //   });
          //   //}
          // }
        } catch (e) {
          debugPrint("err $e");
        }
      } else {
        String message = data['message'] ?? 'Hello World!';

        // Display an alert with the "message" payload value
        isDialogOpen = true;
        showDialog(
            barrierDismissible: false,
            context: getContext(),
            builder: (BuildContext context) {
              return WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: AlertDialog(
                    title: const Text('Notification click'),
                    content: message.toString() == "Logout"
                        ? const Text(
                            "Multiple login of same user in not allowed, Logout?")
                        : Text(message),
                    actions: [
                      AppGradientButton(
                          btnText: "OKay",
                          onPressed: () async {
                            isDialogOpen = false;
                            Navigator.of(context, rootNavigator: true)
                                .pop('dialog');
                            logoutTo(loginScreenRoute);
                          })
                    ]),
              );
            }).whenComplete(() {
          isDialogOpen = false;
        });
      }
      // Clear iOS app badge number
      Pushy.clearBadge();
    });

    // Register the user for push notifications
    await pushyRegister();
    SecuredStorage.initiateSecureStorage();
    if (!isDialogOpen! && !isAppStartingFromNotification) {
      t = Timer.periodic(const Duration(seconds: 2), (t) {
        navigate();
        t.cancel();
      });
    }
  }

  Future pushyRegister() async {
    SecuredStorage.initiateSecureStorage();
    try {
      // Register the user for push notifications
      String deviceToken = await Pushy.register();

      // Print token to console/logcat
      debugPrint('Device token: $deviceToken');
      await SecuredStorage.writeStringValue(Keys.deviceToken, deviceToken);
      // Display an alert with the device token

      //Temp Comment SnackBar
      // Get.snackbar(
      //     "Pushy Token Success", 'Device token: $deviceToken',
      //     duration: const Duration(seconds: 3));

      // showDialog(
      //     context: getContext(),
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //           title: const Text('Pushy'),
      //           content: Text('Pushy device token: $deviceToken'),
      //           actions: [
      //             AppGradientButton(
      //                 btnText: "Okay",
      //                 onPressed: () {
      //                   Navigator.of(context, rootNavigator: true)
      //                       .pop('dialog');
      //                 })
      //           ]);
      //     });

      // Optionally send the token to your backend server via an HTTP GET request
      // ...
    } on PlatformException catch (error) {
      debugPrint("PUSHY ERROR ${error.code}, ${error.message}");
      //Temp Comment Snackbar
      // Get.snackbar(
      //     "Pushy Token Error", "PUSHY ERROR ${error.code}, ${error.message}",
      //     duration: const Duration(seconds: 3)) ;

      // Display an alert with the error message
      // showDialog(
      //     context: getContext(),
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //           title: const Text('Error'),
      //           content: Text(error.message!),
      //           actions: [
      //             AppGradientButton(
      //                 btnText: 'Okay',
      //                 onPressed: () {
      //                   Navigator.of(context, rootNavigator: true)
      //                       .pop('dialog');
      //                 })
      //           ]);
      //     });
    }
  }

  void navigate() async {
    if (isDialogOpen! || isAppStartingFromNotification) {
      return;
    }
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    String? birthday = await SecuredStorage.readStringValue(Keys.birthday);
    String? firstName = await SecuredStorage.readStringValue(Keys.firstName);
    String? lastName = await SecuredStorage.readStringValue(Keys.lastName);
    String? intrests = await SecuredStorage.readStringValue(Keys.interests);
    String? groups = await SecuredStorage.readStringValue(Keys.groups);
    String? profile = await SecuredStorage.readStringValue(Keys.profile);
    String? gender = await SecuredStorage.readStringValue(Keys.gender);

    if (userId != null &&
        userId.toString().trim().isNotEmpty &&
        userId != "null") {
      if (firstName == null || firstName.toString().trim().isEmpty) {
        getOffNamed(displayNameRoute);
      } else if (lastName == null || lastName.toString().trim().isEmpty) {
        getOffNamed(displayNameRoute);
      } else if (gender == null || gender.toString().trim().isEmpty) {
        getOffNamed(genderRoute);
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

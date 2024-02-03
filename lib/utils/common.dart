import 'package:cometchat/cometchat_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jyo_app/main.dart';
import 'package:jyo_app/utils/dialog_service/dialog_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jyo_app/utils/secured_storage.dart';

import '../resources/app_colors.dart';
import '../resources/app_strings.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../view_model/login_vm.dart';
import '../view_model/splash_vm.dart';

Future getToNamed(String? page, {Map? argument}) async {
  debugPrint("page $page");
  return await Get.toNamed(page!,
      preventDuplicates: false, arguments: argument);
}

void getOffAllNamed(String? page) {
  Get.offAllNamed(page!);
}

void getOffNamed(String? page) {
  Get.offNamed(page!);
}

BuildContext getContext() {
  return locator<NavigationService>().navigatoryKey.currentContext!;
}

void showAppDialog(
    {String? msg,
    String? btnText,
    String? btnText2,
    VoidCallback? onPressed,
    VoidCallback? onPressed2}) {
  showCupertinoDialog<void>(
    context: getContext(),
    builder: (BuildContext context) {
      List<CupertinoDialogAction> actions = List.empty(growable: true);
      actions.add(CupertinoDialogAction(
        child: Text(btnText ?? AppStrings.okay),
        onPressed: onPressed ??
            () {
              Navigator.pop(context);
            },
      ));
      if (btnText2 != null) {
        actions.add(CupertinoDialogAction(
          child: Text(btnText2),
          onPressed: onPressed2 ??
              () {
                Navigator.pop(context);
              },
        ));
      }
      return CupertinoAlertDialog(
        content: Text(msg ?? ""),
        actions: actions,
      );
    },
  );
}

void snackbar({title}) {
  showAppDialog(msg: title);
  // Get.snackbar("$title", "",
  //     backgroundColor: AppColors.orangePrimary,
  //     borderRadius: 8.r,
  //     colorText: Colors.white,
  //     duration: const Duration(seconds: 2),
  //     snackPosition: SnackPosition.BOTTOM,
  //     margin: const EdgeInsets.all(16));
}

Widget sizedBoxH({double height = 0.0}) {
  return SizedBox(
    height: height.h,
  );
}

Widget sizedBoxW({double width = 0.0}) {
  return SizedBox(
    width: width.w,
  );
}

String getTime(createdAt) {
  String? timeStamp = createdAt.toString();
  DateTime dateTime = DateTime.parse(timeStamp);
  return timeago.format(
    dateTime,
  );
}

Future<void> logoutTo(String? route) async {
  await SecuredStorage.clearSecureStorage();
  await CometChat.logout(onSuccess: (message) {
    debugPrint("commetchat logout success. $message");
  }, onError: (error) {
    debugPrint("commetchat logout error ${error.toString()}.");
  });
  await Get.delete<SplashVM>();
  await Get.delete<LoginVM>();
  Get.offAllNamed(route!);
}

String formatDateToEEEDDMMMFormat(DateTime? date) {
  try {
    return DateFormat("EEE, dd MMM").format(date!);
  } catch (e) {
    return date.toString();
  }
}

String formatDateToHMMAormat(DateTime? date) {
  try {
    return DateFormat("hh.mm a").format(date!);
  } catch (e) {
    return date.toString();
  }
}

DateTime? parseDateFromToEEEDDMMMFormat(String? date) {
  try {
    return DateFormat("EEE, dd MMM").parse(date!);
  } catch (e) {
    return null;
  }
}

bool isValidString(dynamic value) {
  return (value != null &&
      value.toString().trim().isNotEmpty &&
      value.toString().trim() != "null");
}

String twoDigits(int n) => n.toString().padLeft(2, "0");

String getTimeZone(Duration duration) {
  String hrs = twoDigits(duration.inHours);
  String mins = twoDigits(duration.inMinutes.remainder(60));
  if (duration.inMinutes > 0) {
    return "GMT+$hrs:$mins";
  }
  return "GMT-$hrs:$mins";
}

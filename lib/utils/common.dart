import 'package:cometchat/cometchat_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jyo_app/main.dart';
import 'package:jyo_app/utils/dialog_service/dialog_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jyo_app/utils/secured_storage.dart';

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

void showAppDialog({String? msg, String? btnText, VoidCallback? onPressed}) {
  showCupertinoDialog<void>(
    context: getContext(),
    builder: (BuildContext context) => CupertinoAlertDialog(
      content: Text(msg ?? ""),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          child: Text(btnText ?? AppStrings.okay),
          onPressed: onPressed ??
              () {
                Navigator.pop(context);
              },
        ),
      ],
    ),
  );
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

// ignore_for_file: avoid_init_to_null

import 'dart:convert';

import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:device_information/device_information.dart';
import 'package:jyo_app/data/local/condition_model.dart' as cd;
import 'package:jyo_app/repository/profile_repo/profile_repo_impl.dart';
import 'package:jyo_app/repository/registration_repo/registration_repo_impl.dart';
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/utils/secured_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class PhoneNumberVM extends GetxController {
  RegistrationRepoImpl registrationRepoImpl = RegistrationRepoImpl();
  ProfileRepoImpl profileRepoImpl = ProfileRepoImpl();

  final countryPicker = const FlCountryCodePicker();
  CountryCode? code;

  String? cCode = "+65";
  Widget? flage = null;
  String? imeiNo = "";
  bool? isEnabled = false;
  bool? isChangingPhoneNo = false;
  String? existingPhNo = "";
  String? existingCCode = "";

  TextEditingController phoneNoCtr = TextEditingController();

  getShader() {
    final Shader linearGradient = const LinearGradient(
      colors: <Color>[Color(0xffFFD036), Color(0xffFFA43C)],
    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
    return linearGradient;
  }

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() async {
    existingCCode = "";
    existingPhNo = "";
    SecuredStorage.initiateSecureStorage();
    if (cd.Condition.getIsChangingPhoneNo != null &&
        cd.Condition.getIsChangingPhoneNo) {
      isChangingPhoneNo = cd.Condition.getIsChangingPhoneNo;
      cd.Condition.setIsChangingPhoneNo = false;

      //Call Api to get the Existing user hp no and country code;
      await getHpNo();
    }
    getRequiredPermission();
    //getDeviceInformation();
  }

  void getRequiredPermission() async {
    // prints PermissionStatus.granted
    if (Platform.isIOS) {
      getDeviceInformation();
    } else {
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
    }
    //debugPrint("PERM ${await Permission.phone.status}");
  }

  void showCountryCodePicker(context) async {
    code = await countryPicker.showPicker(context: context);
    if (code != null) {
      cCode = code!.dialCode;
      flage = code!.flagImage();
      if (phoneNoCtr.text.trim().length == 8 &&
          isChangingPhoneNo! &&
          ((cCode.toString().trim() + phoneNoCtr.text.trim()) !=
              (existingCCode.toString().trim() +
                  existingPhNo.toString().trim()))) {
        isEnabled = true;
        update();
      } else {
        if (isChangingPhoneNo!) {
          isEnabled = false;
          update();
        }
      }
      update();
    }
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

  Future<void> getHpNo() async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    await profileRepoImpl.getHpNoByUserId(userId).then((response) {
//      debugPrint("RESPONSE ${response?.status}");
      if (response.status == 200) {
        existingPhNo = response.data!.hpNo.toString().trim();
        existingCCode = "+${response.data!.countryCode.toString().trim()}";
      } else {
        showAppDialog(msg: response.message.toString());
      }
    }).onError((error, stackTrace) {
      debugPrint("RESPONSE Get HP no. ${error.toString()}");
    });
  }

  Future<void> sendOtp() async {
    dynamic data = {};
    data["hpNo"] = phoneNoCtr.text.trim();
    data["countryCode"] = cCode.toString();
    data["imNo"] = imeiNo.toString().trim();
    debugPrint("DATA ${jsonEncode(data)}");
    await registrationRepoImpl.sendOtp(data).then((response) {
//      debugPrint("RESPONSE ${response?.status}");
      if (response?.status == 200) {
        getOffNamed(otpScreenRoute);
      } else {
        showAppDialog(msg: response!.message.toString());
      }
    }).onError((error, stackTrace) {
      debugPrint("RESPONSE PNO. ${error.toString()}");
    });
  }

  Future<void> sendOtpForChange() async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    dynamic data = {};
    data["hpNo"] = phoneNoCtr.text.trim();
    data["countryCode"] = cCode.toString();
    data["imNo"] = imeiNo.toString().trim();
    data["userId"] = userId;
    debugPrint("DATA ${jsonEncode(data)}");
    await profileRepoImpl.changePhoneNumber(data).then((response) {
//      debugPrint("RESPONSE ${response?.status}");
      if (response.status == 200) {
        getOffNamed(otpScreenRoute);
      } else {
        showAppDialog(msg: response.message.toString());
      }
    }).onError((error, stackTrace) {
      debugPrint("RESPONSE PNO CHNG. ${error.toString()}");
    });
  }

  void onNextPressed() async {
    if (phoneNoCtr.text.isEmpty) {
      return;
    }
    if (imeiNo.toString().trim().isEmpty) {
      showAppDialog(
          msg: "Need required permissions to continue",
          onPressed: () {
            Get.back();
            getRequiredPermission();
          });
      return;
    }
    // getOffNamed(otpScreenRoute);
    if (isChangingPhoneNo!) {
      await sendOtpForChange();
    } else {
      await sendOtp();
    }
  }

  void onBackPressed() {
    if (isChangingPhoneNo!) {
      Get.back();
    } else {
      getToNamed(loginScreenRoute);
    }
  }
}

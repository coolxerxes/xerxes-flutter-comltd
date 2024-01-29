import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:jyo_app/repository/profile_repo/profile_repo_impl.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/utils/secured_storage.dart';

class AccountSettingScreenVM extends GetxController {
  ProfileRepoImpl profileRepoImpl = ProfileRepoImpl();

  bool? isPrivateAcc = false;
  bool? isPrivateActivity = false;
  bool? isAppearanceSearch = false;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() async {
    SecuredStorage.initiateSecureStorage();
    isPrivateAcc = await SecuredStorage.readBoolValue(Keys.privateAcc);
    isPrivateActivity = await SecuredStorage.readBoolValue(Keys.showActToFrnz);
    isAppearanceSearch =
        await SecuredStorage.readBoolValue(Keys.appearanceSearch);
    update();
  }

  void toggleAccountPrivacy() {
    isPrivateAcc = !isPrivateAcc!;
    accountSetting();
    update();
  }

  void toggleActivityPrivacy() {
    isPrivateActivity = !isPrivateActivity!;
    accountSetting();
    update();
  }

  void toggleAppearanceSearch() {
    isAppearanceSearch = !isAppearanceSearch!;
    accountSetting();
    update();
  }

  Future<void> accountSetting() async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    var data = {
      "userId": userId,
      "AccountSetting": {
        "privateAccount": isPrivateAcc,
        "privateActivity": isPrivateActivity,
        "appearanceSearch": isAppearanceSearch
      }
    };
    await profileRepoImpl.accountSetting(data).then((res) async {
      debugPrint("res $res");
      if (res.status == 200) {
        await SecuredStorage.writeBoolValue(Keys.privateAcc, isPrivateAcc!);
        await SecuredStorage.writeBoolValue(
            Keys.showActToFrnz, isPrivateActivity!);
        await SecuredStorage.writeBoolValue(
            Keys.appearanceSearch, isAppearanceSearch!);
      } else {
        showAppDialog(msg: res.message.toString());
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }

  
}

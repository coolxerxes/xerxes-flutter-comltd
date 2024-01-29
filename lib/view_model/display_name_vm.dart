import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jyo_app/repository/registration_repo/registration_repo_impl.dart';
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/utils/secured_storage.dart';

import '../utils/common.dart';

class DisplayNameVM extends GetxController {
  RegistrationRepoImpl registrationRepoImpl = RegistrationRepoImpl();
  TextEditingController firstNameCtrl = TextEditingController();
  TextEditingController lastNameCtrl = TextEditingController();
  bool? isEnabled = false;

  @override
  void onInit() {
    SecuredStorage.initiateSecureStorage();
    init();
    super.onInit();
  }

  init() async {
    String? firstName = await SecuredStorage.readStringValue(Keys.firstName);
    String? lastName = await SecuredStorage.readStringValue(Keys.lastName);
    if (firstName != null && firstName.toString().trim().isNotEmpty) {
      firstNameCtrl.text = firstName.toString();
    }
    if (lastName != null && lastName.toString().trim().isNotEmpty) {
      lastNameCtrl.text = lastName.toString();
    }
    if (lastNameCtrl.text.trim().isNotEmpty &&
        firstNameCtrl.text.trim().isNotEmpty) {
      isEnabled = true;
    }
    update();
  }

  void onNextPressed() {
    if (firstNameCtrl.text.trim().isEmpty) {
      return;
    } else if (lastNameCtrl.text.trim().isEmpty) {
      return;
    } else {
      createOrUpdateUserInfo();
    }
  }

  Future<void> createOrUpdateUserInfo() async {
    var userId = await SecuredStorage.readStringValue(Keys.userId);
    var data = {
      "userId": userId,
      "info": {
        "firstName": firstNameCtrl.text.toString().trim(),
        "lastName": lastNameCtrl.text.toString().trim(),
        //"birthday" : "22-09-2022"
      }
    };
    debugPrint("DATAA $data");
    await registrationRepoImpl
        .createOrUpdateUserInfo(data)
        .then((response) async {
      debugPrint("RESPONSE ${response.status}");
      if (response.status == 200) {
        await SecuredStorage.writeStringValue(
            Keys.firstName, firstNameCtrl.text.toString().trim());
        await SecuredStorage.writeStringValue(
            Keys.lastName, lastNameCtrl.text.toString().trim());
        getOffNamed(genderRoute);
      } else {
        showAppDialog(msg: response.message.toString());
      }
    }).onError((error, stackTrace) {
      debugPrint("RESPONSE ${error.toString()}");
    });
  }
}

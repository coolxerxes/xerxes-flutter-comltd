import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/utils/common.dart';

import '../repository/registration_repo/registration_repo_impl.dart';
import '../utils/secured_storage.dart';

class GenderVM extends GetxController {
  RegistrationRepoImpl registrationRepoImpl = RegistrationRepoImpl();
  String? firstName, lastName;
  bool male = false, female = false, others = false;
  bool? isEnabled = false;
  TextEditingController genCtrl = TextEditingController();

  @override
  void onInit() {
    SecuredStorage.initiateSecureStorage();
    init();
    super.onInit();
  }

  init() async {
    firstName = await SecuredStorage.readStringValue(Keys.firstName);
    lastName = await SecuredStorage.readStringValue(Keys.lastName);
    var gender = await SecuredStorage.readStringValue(Keys.gender);

    if (gender != null && gender.toString().trim().isNotEmpty) {
      if (gender == "male") {
        male = true;
        female = false;
        others = false;
        genCtrl.clear();
      } else if (gender == "female") {
        male = false;
        female = true;
        others = false;
        genCtrl.clear();
      } else if (gender == "others") {
        male = false;
        female = false;
        others = true;
        genCtrl.clear();
      } else {
        male = false;
        female = false;
        others = true;
        genCtrl.text = gender;
      }
      isEnabled = true;
    } 

    update();
  }

  void onNextPressed() {
    createOrUpdateUserInfo();
  }

  Future<void> createOrUpdateUserInfo() async {
    var userId = await SecuredStorage.readStringValue(Keys.userId);
    dynamic gender;
    if (male) {
      gender = "male";
    } else if (female) {
      gender = "female";
    } else if (others) {
      if (genCtrl.text.trim().isNotEmpty) {
        gender = genCtrl.text.trim();
      } else {
        gender = "others";
      }
    }
    var data = {
      "userId": userId,
      "info": {
        "firstName": firstName.toString(),
        "lastName": lastName.toString(),
        "gender": gender.toString()
      }
    };
    debugPrint("DATAA  G $data");
    await registrationRepoImpl
        .createOrUpdateUserInfo(data)
        .then((response) async {
      debugPrint("RESPONSE G  ${response.status}");
      if (response.status == 200) {
        //Save Gender
        SecuredStorage.writeStringValue(Keys.gender, gender);
        getOffNamed(birthdayScreenRoute);
      } else {
        showAppDialog(msg: response.message.toString());
      }
    }).onError((error, stackTrace) {
      debugPrint("RESPONSE ${error.toString()}");
    });
  }
}

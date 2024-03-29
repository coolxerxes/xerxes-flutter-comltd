import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jyo_app/repository/registration_repo/registration_repo_impl.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/utils/secured_storage.dart';
import 'package:jyo_app/view_model/group_suggestion_screen_vm.dart';

import '../models/registration_model/interest_data_response.dart';
import '../resources/app_routes.dart';

class MostLikedScreenVM extends GetxController {
  RegistrationRepoImpl registrationRepoImpl = RegistrationRepoImpl();
  List<Datum> list = List.empty(growable: true);
  var selectedIntrestIds = [];
  var isEnabled = false;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() {
    SecuredStorage.initiateSecureStorage();
    getIntrest(preSelectIfAvailable: true);
  }

  void onNextPressed() {
    if (isIntrestListEmpty()) {
      return;
    } else {
      saveIntrests();
    }
  }

  Future<void> saveIntrests({bool? goToNext = true}) async {
    var userId = await SecuredStorage.readStringValue(Keys.userId);
    var data = {"userId": userId, "intrestIds": selectedIntrestIds};
    await registrationRepoImpl.saveIntrest(data).then((response) async {
      if (response.status == 200) {
        if (goToNext!) {
          await SecuredStorage.writeStringValue(
              Keys.interests, jsonEncode(data));
          getToNamed(
            groupSuggestionScreenRoute,
          );
          Get.find<GroupSuggestionScreenVM>().init();
        }
      } else {
        showAppDialog(msg: response.message.toString());
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: "ERRORR" + error.toString());
    });
  }

  bool isIntrestListEmpty({bool reInitList = true}) {
    if (reInitList) {
      selectedIntrestIds = [];
    }
    for (var i = 0; i < list.length; i++) {
      if (list[i].getIsSelected!) {
        selectedIntrestIds.add(list[i].id);
      }
    }
    debugPrint(
        "selectedInterestIds $selectedIntrestIds and Len ${selectedIntrestIds.length}");
    if (selectedIntrestIds.isEmpty) {
      isEnabled = false;
    } else {
      isEnabled = true;
    }
    update();
    return selectedIntrestIds.isEmpty ? true : false;
  }

  Future<void> getIntrest({bool preSelectIfAvailable = false}) async {
    await registrationRepoImpl.getAllIntrest().then((res) async {
      if (res.status == 200) {
        list.clear();
        list.addAll(res.data!);
        for (var i = 0; i < list.length; i++) {
          list[i].setIsSelected = false;
        }

        if (preSelectIfAvailable) {
          dynamic intrest =
              await SecuredStorage.readStringValue(Keys.interests);
          if (intrest != null) {
            var intrData = jsonDecode(intrest) as Map;
            var intrIds = intrData["intrestIds"] as List;
            selectedIntrestIds.clear();
            selectedIntrestIds.addAll(intrIds);

            for (var i = 0; i < selectedIntrestIds.length; i++) {
              var idx = list.indexWhere((Datum element) {
                return element.id == selectedIntrestIds[i];
              });
              if (idx != -1) {
                list[idx].setIsSelected = true;
              }
            }
            if (selectedIntrestIds.isNotEmpty) {
              isEnabled = true;
            }
          }
        }

        update();
      } else {
        showAppDialog(msg: res.message!.toString());
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: "ERROR " + error.toString());
    });
  }
}

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:jyo_app/models/registration_model/interest_data_response.dart';
import 'package:jyo_app/repository/registration_repo/registration_repo_impl.dart';

import '../utils/common.dart';

class CreateActivityScreenVM extends GetxController {
  RegistrationRepoImpl registrationRepoImpl = RegistrationRepoImpl();
  List<Datum> list = List.empty(growable: true);
  var selectedIntrestIds = [];
  TextEditingController? activityNameCtrl = TextEditingController();
  TextEditingController? aboutCtrl = TextEditingController();
  String? selectedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  DateTime? selectedDateTime = DateTime.now();

  bool? isPrivateThisActivity = false;

  bool? isByApproval = false;

  String? coverImage = "";

  double start = 16;
  double end = 100;

  bool? isParticipantsLimited = false;

  int maxPartipants = 10;

  bool? showTime = false;
  bool? showCal = false;

  void togglePrivateThisActivity() {
    isPrivateThisActivity = !isPrivateThisActivity!;
    update();
  }

  void toggleByApproval() {
    isByApproval = !isByApproval!;
    update();
  }

  void toggleLimiyParticipants() {
    isParticipantsLimited = !isParticipantsLimited!;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    getIntrest();
  }

  Future<void> getIntrest({bool preSelectIfAvailable = false}) async {
    await registrationRepoImpl.getAllIntrest().then((res) async {
      if (res.status == 200) {
        list.clear();
        list.addAll(res.data!);
        for (var i = 0; i < list.length; i++) {
          list[i].setIsSelected = false;
        }

        // if (preSelectIfAvailable) {
        //  // dynamic intrest =
        //    //   await SecuredStorage.readStringValue(Keys.interests);
        //   if (intrest != null) {
        //     var intrData = jsonDecode(intrest) as Map;
        //     var intrIds = intrData["intrestIds"] as List;
        //     selectedIntrestIds.clear();
        //     selectedIntrestIds.addAll(intrIds);
        //     for (var i = 0; i < selectedIntrestIds.length; i++) {
        //       var idx = list.indexWhere((Datum element) {
        //         return element.id == selectedIntrestIds[i];
        //       });
        //       if (idx != -1) {
        //         list[idx].setIsSelected = true;
        //       }
        //     }
        //     if (selectedIntrestIds.isNotEmpty) {
        //       isEnabled = true;
        //     }
        //   }
        // }

        update();
      } else {
        showAppDialog(msg: res.message!.toString());
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: "ERROR " + error.toString());
    });
  }
}

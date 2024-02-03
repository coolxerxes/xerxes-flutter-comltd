import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jyo_app/view_model/posts_and_activities_vm.dart';

import '../utils/common.dart';
import '../utils/secured_storage.dart';
import 'base_screen_vm.dart';

class ListOfSaveActivitiesScreenVM extends GetxController {
  String? userId = "";
  PostsAndActivitiesVM postsVM = PostsAndActivitiesVM();
  bool isLoadingActs = true;
  final bsvm = Get.put(BaseScreenVM());

  @override
  void onInit() {
    init();
    super.onInit();
  }

  Future<void> init() async {
    SecuredStorage.initiateSecureStorage();
    userId = await SecuredStorage.readStringValue(Keys.userId);
    postsVM.afterInit(this);
    getActivities();
  }

  Future<void> getActivities() async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    var data = {"userId": userId.toString()};
    debugPrint("data acts $data");
    await postsVM.getSavedActivities(data, this).then((res) async {
      postsVM.activitiesList.clear();
      postsVM.activitiesList.addAll(res);
      isLoadingActs = false;
      update();
    }).onError((error, stackTrace) {
      showAppDialog(msg: "Error ${error.toString()}");
      isLoadingActs = false;
      update();
    });
  }
}

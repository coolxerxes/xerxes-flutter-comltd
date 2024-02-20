import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jyo_app/repository/profile_repo/profile_repo_impl.dart';
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/utils/secured_storage.dart';
import 'package:jyo_app/view_model/login_vm.dart';
import 'package:jyo_app/view_model/splash_vm.dart';

class DeleteAccScreenVM extends GetxController {
  ProfileRepoImpl profileRepoImpl = ProfileRepoImpl();
  final TextEditingController reasonController = TextEditingController();

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() {
    SecuredStorage.initiateSecureStorage();
  }

  Future<void> deleteAccount() async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    final data = {"userId": userId, "reason": reasonController.text};
    await profileRepoImpl.deleteAcc(data).then((res) async {
      if (res.status == 200) {
        await SecuredStorage.clearSecureStorage();
        final loginVM = Get.put(LoginVM());
        loginVM.logOutAll();
        await Get.delete<SplashVM>();
        Get.offAllNamed(splashScreenRoute);
      } else {
        showAppDialog(msg: res.message.toString());
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }
}

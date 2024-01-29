import 'package:get/get.dart';
import 'package:jyo_app/models/profile_model/my_voucher_model.dart';
import 'package:jyo_app/repository/profile_repo/profile_repo_impl.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/utils/secured_storage.dart';

class VoucherScreenVM extends GetxController {
  ProfileRepoImpl profileRepoImpl = ProfileRepoImpl();
  int voucherType = 0;

  List<Voucher> currVList = List.empty(growable: true);
  List<Voucher> passVList = List.empty(growable: true);

  Future<void> init() async {
    SecuredStorage.initiateSecureStorage();
    getVoucherList();
  }

  @override
  void onInit() {
    init();
    super.onInit();
  }

  Future<void> getVoucherList() async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    await profileRepoImpl.getMyVouchers(userId).then((res) {
      if (res.status == 200) {
        currVList.clear();
        passVList.clear();

        currVList.addAll(res.data!.currentVoucher ?? []);
        passVList.addAll(res.data!.passVoucher ?? []);
        update();
      } else {
        showAppDialog(msg: res.message.toString());
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }
}

class VoucherType {
  static const currentVoucher = 0;
  static const passVoucher = 1;
}

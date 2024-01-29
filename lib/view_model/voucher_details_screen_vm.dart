import 'package:get/get.dart';
import 'package:jyo_app/data/local/voucher_detail_model.dart';
import 'package:jyo_app/utils/secured_storage.dart';

import '../models/profile_model/my_voucher_model.dart';

class VoucherDetailScreenVM extends GetxController {
  Voucher? voucher;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  Future<void> init() async {
    SecuredStorage.initiateSecureStorage();
    getVoucherDetails();
  }

  void getVoucherDetails() {
    if (VoucherDetail.getVoucher != null) {
      voucher = VoucherDetail.getVoucher;
      VoucherDetail.setVoucher = null;
    }
    update();
  }
}

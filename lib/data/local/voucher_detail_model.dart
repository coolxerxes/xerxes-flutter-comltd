import 'package:jyo_app/models/profile_model/my_voucher_model.dart';

class VoucherDetail {
  static Voucher? voucher;

  static get getVoucher => VoucherDetail.voucher;
  static set setVoucher(voucher) => VoucherDetail.voucher = voucher;

}

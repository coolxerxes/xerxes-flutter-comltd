import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jyo_app/utils/app_widgets/app_divider.dart';
import 'package:jyo_app/utils/app_widgets/app_gradient_btn.dart';
import 'package:jyo_app/view_model/voucher_details_screen_vm.dart';

import '../resources/app_colors.dart';
import '../resources/app_image.dart';
import '../resources/app_strings.dart';
import '../resources/app_styles.dart';
import '../utils/app_widgets/app_bar.dart';
import '../utils/app_widgets/app_icon_button.dart';
import '../utils/common.dart';

class VoucherDetailScreenView extends StatelessWidget {
  const VoucherDetailScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VoucherDetailScreenVM>(builder: (c) {
      return SafeArea(
          child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: MyAppBar(
          leading: [
            MyIconButton(
              onTap: () {
                Get.back();
              },
              icon: AppBarIcons.arrowBack,
                isSvg: true,
                size: 24,
            )
          ],
          middle: [
            Text(AppStrings.vouchersDetails,
                style: AppStyles.interSemiBoldStyle(
                    fontSize: 16.0, color: AppColors.textColor))
          ],
        ),
        body: ListView(children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 22.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 216.h,
                  width: double.infinity,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(16.r)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: (c.voucher!.banner != null &&
                            c.voucher!.banner.toString().trim().isNotEmpty)
                        ? Image.network(
                            c.voucher!.banner.toString().trim(),
                            fit: BoxFit.fill,
                          )
                        : Image.asset(AppImage.banner, fit: BoxFit.fill),
                  ),
                ),
                sizedBoxH(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        c.voucher!.title.toString(),
                        style: AppStyles.interBoldStyle(fontSize: 22),
                      ),
                    )
                  ],
                ),
                sizedBoxH(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: [
                          Container(
                            decoration: DottedDecoration(
                                color: AppColors.orangePrimary,
                                linePosition: LinePosition.bottom),
                            child: Text(
                              'Starbucks Coffe - Pasar Lama Toa Payoh', // c.voucher!.vendor!.name.toString(),
                              style: AppStyles.interMediumStyle(
                                  fontSize: 17.2,
                                  color: AppColors.orangePrimary),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                sizedBoxH(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "3155 Commonwealth Avenue West 03-K1/K3, Clementi Mall, Singapore 129588", //c.voucher!.vendor!.name.toString(),
                        style: AppStyles.interRegularStyle(
                            fontSize: 15, color: AppColors.editBorderColor),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          MyDivider(height: 8),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 22.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        AppStrings.tnc.toString(),
                        style: AppStyles.interSemiBoldStyle(fontSize: 16),
                      ),
                    )
                  ],
                ),
                sizedBoxH(height: 8),
                Column(
                  children: List.generate(
                      c.voucher!.vendor!.termsCondition.toString().isEmpty
                          ? 0
                          : c.voucher!.vendor!.termsCondition
                              .toString()
                              .split(".")
                              .length, (index) {
                    return c.voucher!.vendor!.termsCondition.toString().split(".")[index].toString().trim().isEmpty ? Container() : Padding(
                      padding:  EdgeInsets.only(bottom: 8.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("•",style: AppStyles.interRegularStyle(
                                  fontSize: 17.2,
                                  color: AppColors.editBorderColor),),
                                  SizedBox(width: 8.w,)        ,
                          Expanded(
                            flex: 1,
                            child: Text(
                              c.voucher!.vendor!.termsCondition.toString().split(".")[index].toString().trim(),
                              //AppStrings.sampleTnc,
                              //c.voucher!.vendor!.termsCondition.toString(),
                              style: AppStyles.interRegularStyle(
                                  fontSize: 17.2,
                                  color: AppColors.editBorderColor),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
                )
              ],
            ),
          ),
          MyDivider(height: 8),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 22.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Expanded(
                    //flex: 1,
                    //child:
                    Text(
                      AppStrings.validTill.toString(),
                      style: AppStyles.interSemiBoldStyle(fontSize: 16),
                    ),
                    //)
                    Text(
                      "" +
                          DateFormat("dd MMM yyyy").format(DateTime.parse(
                              c.voucher!.endDateTime.toString())),
                      style: AppStyles.interRegularStyle(
                          fontSize: 17.2, color: AppColors.editBorderColor),
                    ),
                  ],
                ),
                // sizedBoxH(height: 8),
                // Row(
                //   mainAxisSize: MainAxisSize.max,
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     Expanded(
                //       flex: 1,
                //       child: Text(
                //         AppStrings.sampleTnc,
                //         //c.voucher!.vendor!.termsCondition.toString(),
                //          style: AppStyles.interRegularStyle(fontSize: 17.2, color: AppColors.editBorderColor),),
                //     )
                //   ],),
              ],
            ),
          ),
          MyDivider(
            height: 8,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 22.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        AppStrings.howToRedeem.toString(),
                        style: AppStyles.interSemiBoldStyle(fontSize: 16),
                      ),
                    )
                  ],
                ),
                sizedBoxH(height: 8),
                Column(
                  children: List.generate(
                      c.voucher!.vendor!.redeemGuide.toString().isEmpty
                          ? 0
                          : c.voucher!.vendor!.redeemGuide
                              .toString()
                              .split(".")
                              .length, (index) {
                    return c.voucher!.vendor!.redeemGuide.toString().split(".")[index].toString().trim().isEmpty ? Container() : Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("•",style: AppStyles.interRegularStyle(
                                  fontSize: 17.2,
                                  color: AppColors.editBorderColor),),
                          SizedBox(width: 8.w,)        ,
                          Expanded(
                            flex: 1,
                            child: Text(
                              c.voucher!.vendor!.redeemGuide.toString().split(".")[index].toString().trim(),
                              //AppStrings.sampleTnc,
                              //c.voucher!.vendor!.termsCondition.toString(),
                              style: AppStyles.interRegularStyle(
                                  fontSize: 17.2,
                                  color: AppColors.editBorderColor),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
                )
              
              ],
            ),
          ),
          sizedBoxH(height: 100)
        ]),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(left: 33.w),
          child: AppGradientButton(
            btnText: AppStrings.redeemNow,
            onPressed: () {},
            width: double.infinity,
            height: 47,
          ),
        ),
      ));
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jyo_app/data/local/voucher_detail_model.dart';
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/view_model/voucher_screen_vm.dart';

import '../models/profile_model/my_voucher_model.dart';
import '../resources/app_colors.dart';
import '../resources/app_image.dart';
import '../resources/app_strings.dart';
import '../resources/app_styles.dart';
import '../utils/app_widgets/app_bar.dart';
import '../utils/app_widgets/app_icon_button.dart';

class VoucherScreenView extends StatelessWidget {
  const VoucherScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VoucherScreenVM>(builder: (c) {
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
                  Text(AppStrings.myVouchers,
                      style: AppStyles.interSemiBoldStyle(
                          fontSize: 16.0, color: AppColors.textColor))
                ],
              ),
              body:  RefreshIndicator(
                  color: AppColors.orangePrimary,
                  onRefresh: () async {
                    c.init();
                    return;
                  },
                child: Container(
                    color: AppColors.texfieldColor,
                    child: ListView(children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Container(
                              height: 15,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                      Container(
                          color: AppColors.white,
                          child: Container(
                            height: 41.h,
                            margin: EdgeInsets.symmetric(horizontal: 22.w),
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 3.h),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14.r),
                                color: AppColors.tabBkgColor),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      height: 41.h,
                                      // padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14.r),
                                          boxShadow: c.voucherType ==
                                                  VoucherType.currentVoucher
                                              ? [
                                                  BoxShadow(
                                                      blurRadius: 4.r,
                                                      offset: const Offset(1, 1),
                                                      color: AppColors
                                                          .tabShadowColor)
                                                ]
                                              : null,
                                          color: c.voucherType ==
                                                  VoucherType.currentVoucher
                                              ? AppColors.white
                                              : AppColors.tabBkgColor),
                                      child: Material(
                                        borderRadius: BorderRadius.circular(14.r),
                                        type: MaterialType.transparency,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(14.r),
                                          onTap: () {
                                            c.voucherType =
                                                VoucherType.currentVoucher;
                                            c.update();
                                          },
                                          child: Center(
                                            child: Text(
                                              AppStrings.currentVouchers,
                                              style: AppStyles.interMediumStyle(
                                                  fontSize: 12.8,
                                                  color: c.voucherType ==
                                                          VoucherType
                                                              .currentVoucher
                                                      ? AppColors.textColor
                                                      : AppColors
                                                          .editBorderColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      height: 41.h,
                                      // padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14.r),
                                          boxShadow: c.voucherType ==
                                                  VoucherType.passVoucher
                                              ? [
                                                  BoxShadow(
                                                      blurRadius: 4.r,
                                                      offset: const Offset(1, 1),
                                                      color: AppColors
                                                          .tabShadowColor)
                                                ]
                                              : null,
                                          color: c.voucherType ==
                                                  VoucherType.passVoucher
                                              ? AppColors.white
                                              : AppColors.tabBkgColor),
                                      child: Material(
                                          borderRadius:
                                              BorderRadius.circular(14.r),
                                          type: MaterialType.transparency,
                                          child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(14.r),
                                              onTap: () {
                                                c.voucherType =
                                                    VoucherType.passVoucher;
                                                c.update();
                                              },
                                              child: Center(
                                                child: Text(
                                                  AppStrings.passVouchers,
                                                  style: AppStyles.interMediumStyle(
                                                      fontSize: 12.8,
                                                      color: c.voucherType ==
                                                              VoucherType
                                                                  .passVoucher
                                                          ? AppColors.textColor
                                                          : AppColors
                                                              .editBorderColor),
                                                ),
                                              ))),
                                    ))
                              ],
                            ),
                          )),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Container(
                              height: 15,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                      Container(
                          color: AppColors.texfieldColor,
                          //height: 200,
                          child: c.voucherType == VoucherType.currentVoucher
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: c.currVList.length,
                                  itemBuilder: (context, index) {
                                    return voucherCard(index, c.currVList);
                                  })
                              // Center(
                              //     child: Text(
                              //     AppStrings.currentVouchers,
                              //     style: AppStyles.interMediumStyle(
                              //         color: AppColors.editBorderColor),
                              //   ))
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: c.passVList.length,
                                  itemBuilder: (context, index) {
                                    return voucherCard(index, c.passVList);
                                  })
                          // Center(
                          //     child: Text(
                          //     AppStrings.passVouchers,
                          //     style: AppStyles.interMediumStyle(
                          //         color: AppColors.editBorderColor),
                          //   )),
                          )
                    ])),
              )));
    });
  }

  Widget voucherCard(int index, List<Voucher> list) {
    return GetBuilder<VoucherScreenVM>(
      builder: (c) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 8.h),
          child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                  onTap: () {
                    VoucherDetail.setVoucher = list[index];
                    getToNamed(voucherDetailScreenRoute);
                  },
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        //SvgPicture.asset(AppImage.clipperSvg),
                        // Expanded(
                        //   flex: 1,
                        //   child:  SvgPicture.asset(AppImage.clipperSvg),//Image.asset(AppImage.clipperPng,width: 2,),
                        // ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: const BoxDecoration(
                                color: AppColors.white,
                                border: Border(
                                  right: BorderSide(
                                      color: AppColors.texfieldColor),
                                )),
                            child: Center(
                                child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 56.h,
                                  width: 56.w,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(22.4.r)),
                                  child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(22.4.r),
                                      child:
                                          (list[index].vendor!.icon != null &&
                                                  list[index]
                                                      .vendor!
                                                      .icon
                                                      .toString()
                                                      .trim()
                                                      .isNotEmpty)
                                              ? Image.network(list[index]
                                                  .vendor!
                                                  .icon
                                                  .toString()
                                                  .trim())
                                              : Image.asset(AppImage.jioLogo)),
                                ),
                                sizedBoxH(height: 8),
                                Text(
                                  list[index].vendor!.name.toString(),
                                  style: AppStyles.interRegularStyle(
                                      fontSize: 10.0),
                                )
                              ],
                            )),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            color: AppColors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 22.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                          list[index].title.toString(),
                                          style: AppStyles.interSemiBoldStyle(
                                              fontSize: 14.0),
                                        ))
                                  ],
                                ),
                                sizedBoxH(height: 8),
                                Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.w, vertical: 6.h),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(16.r),
                                        border: Border.all(
                                            color: AppColors.orangePrimary)),
                                    child: Text(
                                      "Valid until: " +
                                          DateFormat("dd MMM yyyy").format(
                                              DateTime.parse(list[index]
                                                  .endDateTime
                                                  .toString())),
                                      style: AppStyles.interMediumStyle(
                                        fontSize: 10.0,
                                        color: AppColors.orangePrimary,
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ))),
        );
      },
    );
  }
}

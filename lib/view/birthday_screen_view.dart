// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jyo_app/resources/app_colors.dart';
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/resources/app_strings.dart';
import 'package:jyo_app/resources/app_styles.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import '../utils/app_widgets/custom_scroll_date_picker.dart';

import '../utils/app_widgets/registration_top_nav.dart';
import '../view_model/birthday_screen_vm.dart';

class BirthdayScreenView extends StatelessWidget {
  const BirthdayScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BirthdayScreenVM>(
      builder: (c) {
        return SafeArea(
          child: Scaffold(
              backgroundColor: AppColors.appBkgColor,
              appBar: PreferredSize(
                preferredSize: Size(
                  double.infinity,
                  65.w,
                ),
                child: RegistrationTopBar(
                  progress: 3,
                  text: AppStrings.next,
                  onBackPressed: () {
                    getToNamed(genderRoute);
                  },
                  onNextPressed: () {
                    c.onNextPressed();
                  },
                  enabled: c.selectedDate == null ? false : true,
                ),
              ),
              body: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  sizedBoxH(
                    height: 82,
                  ),
                  Center(
                    child: Text(
                      AppStrings.myBirthday,
                      style: AppStyles.interMediumStyle(
                        fontSize: 28,
                      ),
                    ),
                  ),
                  sizedBoxH(height: 12),
                  Center(
                    child: Text(
                      AppStrings.publicAgeInfo,
                      style: AppStyles.interRegularStyle(
                          fontSize: 15, color: AppColors.hintTextColor),
                    ),
                  ),
                  sizedBoxH(height: 32),
                  // GestureDetector(
                  //   onTap: () {
                  //     c.selectDate();
                  //   },
                  //   child: Row(
                  //     mainAxisSize: MainAxisSize.min,
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Container(
                  //           color: Colors.transparent,
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             mainAxisSize: MainAxisSize.min,
                  //             children: [
                  //               DOBFied(controller: c.d1Ctrl, hint: "D"),
                  //               DOBFied(controller: c.d2Ctrl, hint: "D"),
                  //               sizedBoxW(
                  //                 width: 6,
                  //               ),
                  //               Text(Hints.slash,
                  //                   style: AppStyles.interRegularStyle(
                  //                     fontSize: 22,
                  //                     color: AppColors.hintTextColor,
                  //                   )),
                  //               sizedBoxW(
                  //                 width: 10,
                  //               ),
                  //               DOBFied(controller: c.m1Ctrl, hint: "M"),
                  //               DOBFied(
                  //                 controller: c.m2Ctrl,
                  //                 hint: "M",
                  //                 spacing: 6.0,
                  //               ),
                  //               Text(Hints.slash,
                  //                   style: AppStyles.interRegularStyle(
                  //                     fontSize: 22,
                  //                     color: AppColors.hintTextColor,
                  //                   )),
                  //               sizedBoxW(
                  //                 width: 10,
                  //               ),
                  //               DOBFied(controller: c.y1Ctrl, hint: "Y"),
                  //               DOBFied(controller: c.y2Ctrl, hint: "Y"),
                  //               DOBFied(controller: c.y3Ctrl, hint: "Y"),
                  //               DOBFied(controller: c.y4Ctrl, hint: "Y"),
                  //             ],
                  //           )),
                  //     ],
                  //   ),
                  // ),

                  Container(
                    margin: const EdgeInsets.only(
                      right: 15,
                    ),
                    child: SizedBox(
                      height: 250,
                      child: CustomScrollDatePicker(
                        selectedDate: c.selectedDate ?? DateTime(1993, 1, 1),
                        indicator: Container(
                          margin: const EdgeInsets.only(left: 15),
                          height: 28.h,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.15),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4)),
                          ),
                        ),
                        locale: const Locale('en'),
                        options: const DatePickerOptions(),
                        scrollViewOptions: const DatePickerScrollViewOptions(
                            day: ScrollViewDetailOptions(
                              alignment: Alignment.centerLeft,
                            ),
                            month: ScrollViewDetailOptions(
                              alignment: Alignment.center,
                            ),
                            year: ScrollViewDetailOptions(
                              alignment: Alignment.centerRight,
                            )),
                        onDateTimeChanged: (DateTime value) {
                          c.selectedDate = value;

                          int days =
                              c.selectedDate!.difference(DateTime.now()).inDays;
                          var years = (days / 365);
                          if (years < 0) {
                            years = years * -1;
                          }
                          debugPrint("YEARS $years");
                          if (years < 13) {
                            c.selectedDate = DateTime(1993, 1, 1);
                            showAppDialog(
                                msg:
                                    "User should be atleast 13 years or older");
                          }
                          c.update();
                        },
                      ),
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }
}

class DOBFied extends StatelessWidget {
  DOBFied({
    required this.controller,
    this.hint,
    this.spacing,
    Key? key,
  }) : super(key: key);

  TextEditingController controller;
  String? hint;
  double? spacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
            width: 20.w,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  focusColor: AppColors.texfieldColor,
                  focusedBorder: InputBorder.none,
                  enabled: false,
                  hintText: hint!),
              style: AppStyles.interRegularStyle(fontSize: 22),
            )),
        SizedBox(
          width: spacing != null ? spacing!.w : 4.0.w,
        )
      ],
    );
  }
}

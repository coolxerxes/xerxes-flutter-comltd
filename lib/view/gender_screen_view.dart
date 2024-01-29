// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jyo_app/resources/app_colors.dart';
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/resources/app_strings.dart';
import 'package:jyo_app/resources/app_styles.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/view_model/gender_screen_vm.dart';

import '../utils/app_widgets/registration_top_nav.dart';

class GenderView extends StatelessWidget {
  const GenderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GenderVM>(
      builder: (c) {
        return SafeArea(
          child: Scaffold(
              backgroundColor: AppColors.appBkgColor,
              appBar: PreferredSize(preferredSize: Size(double.infinity,65.w,),
                child: RegistrationTopBar(
                    progress: 3,
                    text: AppStrings.next,
                    enabled: c.isEnabled,
                    onBackPressed: () {
                      getToNamed(displayNameRoute);
                    },
                    onNextPressed: () {
                      c.onNextPressed();
                    },
                  ),),
              body: ListView(
                children: [
                  
                  sizedBoxH(
                    height: 82,
                  ),
                  Center(
                    child: Text(
                      AppStrings.myGender,
                      style: AppStyles.interMediumStyle(
                        fontSize: 28,
                      ),
                    ),
                  ),
                  sizedBoxH(height: 41),
                  InkWell(
                      onTap: () {
                        c.female = false;
                        c.male = true;
                        c.others = false;
                        c.isEnabled = true; 
                        c.update();
                      },
                      child: Center(
                          child: Container(
                        height: 60.h,
                        width: 250.w,
                        decoration: BoxDecoration(
                          color: AppColors.texfieldColor,
                          border: Border.all(
                            color: c.male
                                ? Colors.transparent
                                : AppColors.disabledColor,
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                          gradient: c.male
                              ? const LinearGradient(
                                  transform: GradientRotation(94.37),
                                  colors: [Color(0xffFFD036), Color(0xffFFA43C)])
                              : null,
                        ),
                        child: Center(
                            child: Text("Male",
                                style: AppStyles.interMediumStyle(
                                    color: c.male
                                        ? AppColors.white
                                        : AppColors.editBorderColor,
                                    fontSize: 22))),
                      ))),
                  sizedBoxH(height: 30),
                  InkWell(
                      onTap: () {
                        c.female = true;
                        c.male = false;
                        c.others = false;
                        c.isEnabled = true; 
                        c.update();
                      },
                      child: Center(
                          child: Container(
                        height: 60.h,
                        width: 250.w,
                        decoration: BoxDecoration(
                          color: AppColors.texfieldColor,
                          border: Border.all(
                            color: c.female
                                ? Colors.transparent
                                : AppColors.disabledColor,
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                          gradient: c.female
                              ? const LinearGradient(
                                  transform: GradientRotation(94.37),
                                  colors: [Color(0xffFFD036), Color(0xffFFA43C)])
                              : null,
                        ),
                        child: Center(
                            child: Text("Female",
                                style: AppStyles.interMediumStyle(
                                    color: c.female
                                        ? AppColors.white
                                        : AppColors.editBorderColor,
                                    fontSize: 22))),
                      ))),
                  sizedBoxH(height: 30),
                  InkWell(
                      onTap: () {
                        c.female = false;
                        c.male = false;
                        c.others = true;
                        c.isEnabled = true; 
                        c.update();
                      },
                      child: Center(
                          child: Container(
                        height: 60.h,
                        width: 250.w,
                        decoration: BoxDecoration(
                          color: AppColors.texfieldColor,
                          border: Border.all(
                            color: c.others
                                ? Colors.transparent
                                : AppColors.disabledColor,
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                          gradient: c.others
                              ? const LinearGradient(
                                  transform: GradientRotation(94.37),
                                  colors: [Color(0xffFFD036), Color(0xffFFA43C)])
                              : null,
                        ),
                        child: Center(
                            child: Text("Others",
                                style: AppStyles.interMediumStyle(
                                    color: c.others
                                        ? AppColors.white
                                        : AppColors.editBorderColor,
                                    fontSize: 22))),
                      ))),
                      sizedBoxH(height: 30),
                      !c.others ? Container():  Center(
                          child: Container(
                        height: 50.h,
                        width: 197.w,
                        decoration: BoxDecoration(
                          color: AppColors.texfieldColor,
                          border: Border.all(
                            color:AppColors.disabledColor,
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Center(
                            child: TextField(
                              controller: c.genCtrl,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Gender(optional)",
                              ),                            
                              textAlign: TextAlign.center,
                            )),
                      ))
        
                ],
              )),
        );
      },
    );
  }
}

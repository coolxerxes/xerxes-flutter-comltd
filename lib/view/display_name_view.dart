// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jyo_app/resources/app_colors.dart';
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/resources/app_strings.dart';
import 'package:jyo_app/resources/app_styles.dart';
import 'package:jyo_app/utils/app_widgets/ios_app_textfiled.dart';
import 'package:jyo_app/utils/common.dart';

import '../utils/app_widgets/registration_top_nav.dart';
import '../view_model/display_name_vm.dart';

class DisplayNameView extends StatelessWidget {
  const DisplayNameView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DisplayNameVM>(
      builder: (c) {
        return SafeArea(
          child: Scaffold(
              backgroundColor: AppColors.appBkgColor,
              appBar: PreferredSize(preferredSize: Size(double.infinity,65.w,),
              child: RegistrationTopBar(
                    progress: 2,
                    text: AppStrings.next,
                    enabled: c.isEnabled,
                    onBackPressed: () {
                      getToNamed(phoneNumberRoute);
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
                      AppStrings.myName,
                      style: AppStyles.interMediumStyle(
                        fontSize: 28,
                      ),
                    ),
                  ),
                  sizedBoxH(height: 32),
                  IosTextField(
                    controller: c.firstNameCtrl,
                    hintText: Hints.firstName,
                    onChanged: (t) {
                      if (c.firstNameCtrl.text.trim().isNotEmpty &&
                          c.lastNameCtrl.text.trim().isNotEmpty) {
                        c.isEnabled = true;
                      } else {
                        c.isEnabled = false;
                      }
                      c.update();
                    },
                  ),
                  sizedBoxH(height: 32),
                  IosTextField(
                    controller: c.lastNameCtrl,
                    hintText: Hints.lastName,
                    onChanged: (t) {
                      if (c.firstNameCtrl.text.trim().isNotEmpty &&
                          c.lastNameCtrl.text.trim().isNotEmpty) {
                        c.isEnabled = true;
                      } else {
                        c.isEnabled = false;
                      }
                      c.update();
                    },
                  )
                ],
              )),
        );
      },
    );
  }
}

// ignore_for_file: must_be_immutable, unused_import

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jyo_app/resources/app_colors.dart';
import 'package:jyo_app/resources/app_image.dart';
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/resources/app_strings.dart';
import 'package:jyo_app/resources/app_styles.dart';
import 'package:jyo_app/utils/common.dart';

import '../utils/app_widgets/app_gradient_btn.dart';
import '../utils/app_widgets/registration_top_nav.dart';
import '../utils/secured_storage.dart';
import '../view_model/set_profile_pic_screen_vm.dart';

class SetProfilePicScreenView extends StatelessWidget {
  const SetProfilePicScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SetProfilePicScreenVM>(
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
                  progress: 6,
                  text: AppStrings.next,
                  enabled: c.isEnabled,
                  onBackPressed: () {
                    getToNamed(groupSuggestionScreenRoute);
                  },
                  onNextPressed: () async {
                    // await SecuredStorage.writeStringValue(
                    //     Keys.profile, "Completed");
                    Get.offAllNamed(baseScreenRoute);
                  },
                ),
              ),
              body: ListView(
                children: [
                  sizedBoxH(
                    height: 82,
                  ),
                  Center(
                    child: Text(
                      AppStrings.setNewPhoto,
                      style: AppStyles.interMediumStyle(
                        fontSize: 28,
                      ),
                    ),
                  ),
                  sizedBoxH(height: 48),
                  Center(
                    child: c.isUploading!
                        ? SizedBox(
                            width: 144.w,
                            height: 144.h,
                            child: const Center(
                                child: CircularProgressIndicator()),
                          )
                        : c.selectedAvatarC == null
                            ? SizedBox(
                                width: 144.w,
                                height: 144.h,
                                child: Image.asset(AppImage.sampleAvatar),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(57.6.r),
                                ),
                                width: 144.w,
                                height: 144.h,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(57.6.r),
                                    child: Image.file(
                                      File(c.selectedAvatarC!.path),
                                      fit: BoxFit.cover,
                                    ))),
                  ),
                  sizedBoxH(height: 48),
                  Center(
                      child: AppGradientButton(
                    btnText: AppStrings.selectPhoto,
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) => CupertinoActionSheet(
                            // title: const Text('Choose Options'),
                            // message: const Text('Your options are '),
                            actions: <Widget>[
                              CupertinoActionSheetAction(
                                child: Text(
                                  AppStrings.selectPhoto,
                                  style: AppStyles.interRegularStyle(
                                      color: AppColors.iosBlue),
                                ),
                                onPressed: () {
                                  Navigator.pop(
                                      context, AppStrings.selectPhoto);
                                  c.pickImage(ImageSource.gallery);
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: Text(
                                  AppStrings.takePhoto,
                                  style: AppStyles.interRegularStyle(
                                      color: AppColors.iosBlue),
                                ),
                                onPressed: () {
                                  Navigator.pop(context, AppStrings.takePhoto);
                                  c.pickImage(ImageSource.camera);
                                },
                              )
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              child: Text(
                                AppStrings.cancel,
                                style: AppStyles.interRegularStyle(
                                    color: AppColors.iosBlue),
                              ),
                              isDefaultAction: true,
                              onPressed: () {
                                Navigator.pop(context, AppStrings.cancel);
                              },
                            )),
                      );
                    },
                    height: 42,
                    width: 176,
                  ))
                ],
              )),
        );
      },
    );
  }
}

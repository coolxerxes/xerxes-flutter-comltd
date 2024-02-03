// ignore_for_file: must_be_immutable

import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jyo_app/resources/app_colors.dart';
import 'package:jyo_app/resources/app_strings.dart';
import 'package:jyo_app/utils/app_widgets/app_gradient_btn.dart';
import 'package:jyo_app/utils/app_widgets/app_textfield.dart';
import 'package:jyo_app/utils/common.dart';

import '../data/remote/api_interface.dart';
import '../data/remote/endpoints.dart';
import '../resources/app_image.dart';
import '../resources/app_styles.dart';
import '../utils/app_widgets/app_bar.dart';
import '../utils/app_widgets/app_icon_button.dart';
import '../utils/app_widgets/setting_list_tile.dart';
import '../view_model/edit_profile_screen_vm.dart';

class EditProfileScreenView extends StatelessWidget {
  const EditProfileScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileScreenVM>(
      builder: (c) {
        return SafeArea(
            child: Scaffold(
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
              Text(AppStrings.editProfile,
                  style: AppStyles.interSemiBoldStyle(
                      fontSize: 16.0, color: AppColors.textColor))
            ],
          ),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: ListView(
              children: [
                //Propic and edit
                Container(
                    margin: EdgeInsets.symmetric(vertical: 16.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        sizedBoxH(
                          height: 24,
                        ),
                        Container(
                          width: 88.w,
                          height: 88.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35.2.r),
                          ),
                          child: c.isUploading!
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(35.2.r),
                                  child: (c.profileScreenVM.imageFileName !=
                                              null &&
                                          c.profileScreenVM.imageFileName!
                                              .isEmpty)
                                      ? Image.asset(
                                          AppImage.groupImage,
                                          fit: BoxFit.fill,
                                        )
                                      : Image.network(
                                          ApiInterface.baseUrl +
                                              Endpoints.user +
                                              Endpoints.profileImage +
                                              c.profileScreenVM.imageFileName
                                                  .toString(),
                                          fit: BoxFit.fill,
                                        ),
                                ),
                        ),
                        sizedBoxH(
                          height: 12,
                        ),
                        InkWell(
                            onTap: () {
                              showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext context) =>
                                    CupertinoActionSheet(
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
                                          Navigator.pop(
                                              context, AppStrings.takePhoto);
                                          c.pickImage(ImageSource.camera);
                                        },
                                      )
                                    ],
                                        cancelButton:
                                            CupertinoActionSheetAction(
                                          child: Text(
                                            AppStrings.cancel,
                                            style: AppStyles.interRegularStyle(
                                                color: AppColors.iosBlue),
                                          ),
                                          isDefaultAction: true,
                                          onPressed: () {
                                            Navigator.pop(
                                                context, AppStrings.cancel);
                                          },
                                        )),
                              );
                            },
                            child: Text(
                              "Change Photo",
                              style: AppStyles.interMediumStyle(
                                  fontSize: 16.0,
                                  color: AppColors.orangePrimary),
                            )),
                        sizedBoxH(
                          height: 26,
                        ),
                      ],
                    ))

                //TextFields
                ,

                AppTextField(
                  controller: c.fullNameCtrl,
                  margin: const EdgeInsets.all(0),
                  style: AppStyles.interRegularStyle(),
                  hintText: "Full Name",
                ),
                sizedBoxH(
                  height: 24,
                ),
                Container(
                  height: 52.h,
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  //.symmetric(
                  //  horizontal: 22.w), //EdgeInsets.symmetric(horizontal: 22),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.r),
                        bottomRight: Radius.circular(10.r),
                        topLeft: Radius.circular(10.r),
                        topRight: Radius.circular(10.r),
                      ),
                      color: AppColors.texfieldColor),
                  child: Row(mainAxisSize: MainAxisSize.max, children: [
                    Text(
                      "@",
                      style: AppStyles.interRegularStyle(
                          fontSize: 15.6, color: AppColors.hintTextColor),
                    ),
                    Expanded(
                        child: TextField(
                      controller: c.userNameCtrl,
                      style: AppStyles.interRegularStyle(),
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                    ))
                  ]),
                ),

                // AppTextField(
                //   controller: c.userNameCtrl,
                //   margin: const EdgeInsets.all(0),
                //   style: AppStyles.interRegularStyle(),
                //   hintText: "Username",
                //   //prefixText: "@",

                //   icon: SizedBox(
                //       width: 10,
                //       child: Center(
                //           child: Text(
                //         "@",
                //         style: AppStyles.interRegularStyle(
                //             fontSize: 15.6, color: AppColors.hintTextColor),
                //       ))),
                // ),
                sizedBoxH(
                  height: 24,
                ),
                // AppTextField(
                //   controller: c.bioCtrl,
                //  // height: 144.h,
                //   margin: const EdgeInsets.all(0),
                //   style: AppStyles.interRegularStyle(),
                //   hintText: "Biography",
                //   maxLines: null,
                //   maxLength: null,
                //   // onSubmitted: (t) {
                //   //   c.bioCtrl.text =  c.bioCtrl.text+'\n';
                //   //   c.bioCtrl.selection = TextSelection.fromPosition(TextPosition(offset: c.bioCtrl.text.length));
                //   // },
                // ),
                Container(
                    height: 144.h, //52,
                    margin: const EdgeInsets.all(
                        0), //EdgeInsets.symmetric(horizontal: 22),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10.0.r),
                          bottomRight: Radius.circular(10.0.r),
                          topLeft: Radius.circular(10.0.r),
                          topRight: Radius.circular(10.0.r),
                        ),
                        color: AppColors.texfieldColor),
                    child: TextField(
                        controller: c.bioCtrl,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Biography",
                            hintStyle: AppStyles.interRegularStyle(
                                fontSize: 20, color: AppColors.hintTextColor),
                            contentPadding: EdgeInsets.only(
                                left: 14.w,
                                bottom: MediaQuery.of(context).size.width <= 400
                                    ? 8.h
                                    : 0.0)),
                        style: AppStyles.interRegularStyle())),

                sizedBoxH(
                  height: 24,
                ),
                SettingListTile(
                    text: AppStrings.manageInterest,
                    icon: const Icon(
                      Icons.keyboard_arrow_right,
                      color: AppColors.textColor,
                    ),
                    onTap: () async {
                      await c.init();
                      showFlexibleBottomSheet(
                        initHeight: 0.4,
                        //isExpand: true,
                        minHeight: 0,
                        maxHeight: 0.9,
                        //isCollapsible: true,
                        bottomSheetColor: Colors.transparent,
                        context: getContext(),
                        builder: (a, b, c) {
                          return showInterest(b);
                        },
                        anchors: [0, 0.5, 0.9],
                        isSafeArea: true,
                      );
                    }),
                sizedBoxH(
                  height: 100,
                )
              ],
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(left: 32),
            child: AppGradientButton(
              btnText: AppStrings.save,
              onPressed: () {
                c.createOrUpdateUserInfo();
              },
              height: 47,
              width: double.infinity,
            ),
          ),
        ));
      },
    );
  }

  Widget showInterest(ScrollController b) {
    return GetBuilder<EditProfileScreenVM>(
      builder: (c) {
        return Container(
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.r),
                    topRight: Radius.circular(32.r))),
            child: ListView(
              controller: b,
              children: [
                sizedBoxH(
                  height: 10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 54.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.r),
                          color: AppColors.disabledColor),
                    )
                  ],
                ),
                sizedBoxH(
                  height: 10,
                ),
                MyAppBar(
                  leading: [
                    MyIconButton(
                      onTap: () {
                        Get.back();
                      },
                      icon: AppBarIcons.closeIcon,
                      isSvg: true,
                    )
                  ],
                  middle: [
                    Text(AppStrings.manageInterest,
                        style: AppStyles.interSemiBoldStyle(
                            fontSize: 16.0, color: AppColors.textColor))
                  ],
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 22.w, vertical: 16.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.yourInterests,
                        style: AppStyles.interMediumStyle(),
                      ),
                      sizedBoxH(
                        height: 8,
                      ),
                      Center(
                          child: Wrap(
                              direction: Axis.horizontal,
                              runSpacing: 12.h,
                              spacing: 20.w,
                              children: List.generate(c.userInterestlist.length,
                                  (index) {
                                return MostLikedCard(
                                    index, FromList.editProfileVM);
                              })))
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 22.w, vertical: 16.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.addNewInterest,
                        style: AppStyles.interMediumStyle(),
                      ),
                      sizedBoxH(
                        height: 8,
                      ),
                      Center(
                          child: Wrap(
                              direction: Axis.horizontal,
                              runSpacing: 12.h,
                              spacing: 20.w,
                              children: List.generate(c.mostLikedVM.list.length,
                                  (index) {
                                return MostLikedCard(
                                  index,
                                  FromList.mostLikedVM,
                                  clickable: true,
                                );
                              })))
                    ],
                  ),
                ),
                sizedBoxH(
                  height: 54,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppGradientButton(
                      btnText: AppStrings.save,
                      onPressed: () async {
                        if (c.mostLikedVM
                            .isIntrestListEmpty(reInitList: false)) {
                          Get.back();
                        } else {
                          c.userName = c.userNameCtrl.text.trim();
                          c.bio = c.bioCtrl.text.trim();
                          await c.mostLikedVM.saveIntrests(goToNext: false);
                          await c.profileScreenVM.getProfileData();
                          await c.profileScreenVM.init();
                          await c.init();
                          c.userNameCtrl.text = c.userName!;
                          c.bioCtrl.text = c.bio!;
                          c.update();
                          Get.back();
                        }
                      },
                      width: 176,
                      height: 56,
                    )
                  ],
                )
              ],
            ));
      },
    );
  }
}

class MostLikedCard extends StatelessWidget {
  MostLikedCard(
    this.index,
    this.fromList, {
    this.clickable = false,
    Key? key,
  }) : super(key: key);

  int? index;
  int? fromList;
  bool? clickable;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileScreenVM>(
      builder: (c) {
        return Container(
          //height: 40.h,
          padding: EdgeInsets.symmetric(
            vertical: 8.5.h,
          ),
          width: MediaQuery.of(context).size.width / 2.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            gradient: fromList == FromList.mostLikedVM
                ? c.mostLikedVM.list[index!].getIsSelected!
                    ? const LinearGradient(
                        colors: [Color(0xffFFD036), Color(0xffFFA43C)],
                        transform: GradientRotation(240) //120
                        )
                    : null
                : c.userInterestlist[index!].getIsSelected!
                    ? const LinearGradient(
                        colors: [Color(0xffFFD036), Color(0xffFFA43C)],
                        transform: GradientRotation(240) //120
                        )
                    : null,
            color: AppColors.texfieldColor,
          ),
          child: Material(
              type: MaterialType.transparency,
              borderRadius: BorderRadius.circular(10.r),
              child: InkWell(
                  borderRadius: BorderRadius.circular(10.r),
                  onTap: clickable!
                      ? fromList == FromList.mostLikedVM
                          ? () {
                              c.mostLikedVM.list[index!].setIsSelected =
                                  !c.mostLikedVM.list[index!].getIsSelected!;
                              debugPrint(
                                  "IsSelected ${c.mostLikedVM.list[index!].getIsSelected!}");
                              c.mostLikedVM.update();
                              c.update();
                            }
                          : null
                      : null,
                  child: Center(
                      child: Wrap(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        sizedBoxW(
                          width: 0,
                        ),
                        Image.network(
                          fromList == FromList.mostLikedVM
                              ? c.mostLikedVM.list[index!].icon!.toString()
                              : c.userInterestlist[index!].icon!.toString(),
                          width: 18.w,
                          height: 18.h,
                        ),
                        sizedBoxW(
                          width: 8,
                        ),
                        // Expanded(
                        //   child: Row(
                        //     children: [
                        //       Expanded(
                        //         child:
                        SizedBox(
                            width: fromList == FromList.mostLikedVM
                                ? c.mostLikedVM.list[index!].name!.length >=
                                        14.0
                                    ? MediaQuery.of(context).size.width / 3.0
                                    : null
                                : c.userInterestlist[index!].name!.length >=
                                        14.0
                                    ? MediaQuery.of(context).size.width / 3.0
                                    : null,
                            child: Text(
                              fromList == FromList.mostLikedVM
                                  ? c.mostLikedVM.list[index!].name!
                                      .toString()
                                      .trim()
                                  : c.userInterestlist[index!].name!
                                      .toString()
                                      .trim(),
                              style: fromList == FromList.mostLikedVM
                                  ? c.mostLikedVM.list[index!].getIsSelected!
                                      ? AppStyles.interMediumStyle(
                                          fontSize: 16,
                                          color: AppColors.appBkgColor)
                                      : AppStyles.interMediumStyle(fontSize: 16)
                                  : c.userInterestlist[index!].getIsSelected!
                                      ? AppStyles.interMediumStyle(
                                          fontSize: 16,
                                          color: AppColors.appBkgColor)
                                      : AppStyles.interMediumStyle(
                                          fontSize: 16),
                              // overflow: TextOverflow.ellipsis,
                            ))
                        // )
                        //],
                        //)
                        // )
                      ])))),
        );
      },
    );
  }
}

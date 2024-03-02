import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jyo_app/data/remote/api_interface.dart';
import 'package:jyo_app/resources/app_colors.dart';
import 'package:jyo_app/resources/app_image.dart';
import 'package:jyo_app/resources/app_strings.dart';
import 'package:jyo_app/resources/app_styles.dart';
import 'package:jyo_app/utils/app_widgets/app_bar.dart';
import 'package:jyo_app/utils/app_widgets/app_divider.dart';
import 'package:jyo_app/utils/app_widgets/app_gradient_btn.dart';
import 'package:jyo_app/utils/app_widgets/app_icon_button.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/view/create_post_screen_view.dart';
import 'package:jyo_app/view/timeline_screen_view.dart';
import 'package:jyo_app/view_model/create_activity_screen_vm.dart';

import '../data/local/post_edit_model.dart';
import '../data/remote/endpoints.dart';
import '../utils/app_widgets/setting_list_tile.dart';

class CreateActivityScreen2View extends StatelessWidget {
  const CreateActivityScreen2View({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateActivityScreenVM>(builder: (c) {
      return SafeArea(
          child: Scaffold(
        appBar: MyAppBar(
          leading: [
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Text(
                AppStrings.back,
                style: AppStyles.interMediumStyle(
                    fontSize: 18, color: AppColors.hintTextColor),
              ),
            )
          ],
        ),
        body: ListView(
          children: [
            sizedBoxH(height: 16),
            InkWell(
              onTap: () {
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
                            Navigator.pop(context, AppStrings.selectPhoto);
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
                        ),
                      ],
                      cancelButton: CupertinoActionSheetAction(
                        isDefaultAction: true,
                        onPressed: () {
                          Navigator.pop(context, AppStrings.cancel);
                        },
                        child: Text(
                          AppStrings.cancel,
                          style: AppStyles.interRegularStyle(
                              color: AppColors.iosBlue),
                        ),
                      )),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 22.w),
                child: Stack(
                  children: [
                    SizedBox(
                      width: (double.infinity).w,
                      height: 240.h,
                    ),
                    Positioned(
                        child: c.coverImage!.isEmpty
                            ? MyAvatar(
                                width: (double.infinity).w,
                                height: 240.h,
                                url: AppImage.addCover,
                                isSVG: true,
                                radiusAll: 16,
                              )
                            : MyAvatar(
                                width: (double.infinity).w,
                                height: 240.h,
                                url: ApiInterface.postImgUrl + c.coverImage!,
                                isNetwork: true,
                                radiusAll: 16,
                              )),
                    Positioned(
                        child: c.coverImage!.trim().isEmpty
                            ? Container()
                            : Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  onTap: () {
                                    debugPrint("Close Clicked");
                                    c.xCoverImage = null;
                                    c.coverImage = "";
                                    c.update();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 9.w, vertical: 9.h),
                                    height: 32.h,
                                    width: 32.w,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(100.r),
                                      color: const Color(0x8F000000),
                                    ),
                                    child: Center(
                                        child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(100.r),
                                      child: SvgPicture.asset(
                                        AppIcons.closeSvg,
                                        width: 28.w,
                                        height: 28.h,
                                        color: AppColors.white,
                                      ),
                                    )),
                                  ),
                                ),
                              )),
                  ],
                ),
              ),
            ),
            sizedBoxH(height: 24),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 22.w),
              child: Column(
                children: [
                  SettingListTile(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    text: AppStrings.privateThisActivity,
                    icon: FlutterSwitch(
                      width: 52.0.w,
                      height: 32.0.h,
                      valueFontSize: 0.0.sp,
                      toggleSize: 27.0.w,
                      value: c.isPrivateThisActivity!,
                      borderRadius: 16.0.r,
                      // padding: 8.0,
                      showOnOff: false,
                      activeColor: AppColors.orangePrimary,

                      onToggle: (val) {
                        c.togglePrivateThisActivity();
                      },
                    ),
                  ),
                  sizedBoxH(height: 20),
                  SettingListTile(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    text: AppStrings.byApproval,
                    icon: FlutterSwitch(
                      width: 52.0.w,
                      height: 32.0.h,
                      valueFontSize: 0.0.sp,
                      toggleSize: 27.0.w,
                      value: c.isByApproval!,
                      borderRadius: 16.0.r,
                      // padding: 8.0,
                      showOnOff: false,
                      activeColor: AppColors.orangePrimary,

                      onToggle: (val) {
                        c.toggleByApproval();
                      },
                    ),
                  ),
                  sizedBoxH(height: 20),
                  SettingListTile(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    text: AppStrings.additionalSettings,
                    icon: const Icon(
                      Icons.keyboard_arrow_right,
                      color: AppColors.textColor,
                    ),
                    onTap: () {
                      showFlexibleBottomSheet(
                        initHeight: 0.75,
                        isExpand: true,
                        minHeight: 0,
                        maxHeight: 0.85,
                        //isCollapsible: true,
                        bottomSheetColor: Colors.transparent,
                        context: getContext(),
                        builder: (a, b, d) {
                          return additionalSettingSheet(b);
                        },
                        anchors: [0, 0.75, 0.85],
                        isSafeArea: true,
                      );
                    },
                  ),
                ],
              ),
            ),
            sizedBoxH(height: 67),
          ],
        ),
        floatingActionButton: AppGradientButton(
            margin: EdgeInsets.only(
              left: 30.w,
            ),
            width: double.infinity,
            height: 47,
            btnText: PostEdit.getPostOrActivity != null
                ? "Update activity"
                : "Create activity", //AppStrings.continuee,
            onPressed: () {
              c.validatePage2();
            }),
      ));
    });
  }

  Widget additionalSettingSheet(b) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r), topRight: Radius.circular(32.r)),
      child: GetBuilder<CreateActivityScreenVM>(builder: (c) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: MyAppBar(
            leading: [
              Padding(
                padding: EdgeInsets.only(top: 14.h),
                child: MyIconButton(
                    onTap: () {
                      Get.back();
                    },
                    isSvg: true,
                    icon: AppIcons.closeSvg),
              ),
            ],
            middle: [
              Column(
                children: [
                  Container(
                    height: 4.h,
                    width: 54.w,
                    decoration: BoxDecoration(
                        color: AppColors.disabledColor,
                        borderRadius: BorderRadius.circular(100.r)),
                  ),
                  sizedBoxH(height: 10),
                  Text(
                    AppStrings.additionalSettings,
                    style: AppStyles.interSemiBoldStyle(fontSize: 16),
                  )
                ],
              )
            ],
            actions: [
              Padding(
                padding: EdgeInsets.only(top: 14.h),
                child: MyIconButton(
                    onTap: () {
                      Get.back();
                    },
                    isSvg: true,
                    icon: AppIcons.reloadSvg),
              ),
            ],
          ),
          body: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32.r),
                  topRight: Radius.circular(32.r)),
              child: SingleChildScrollView(
                  controller: b,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 22.w),
                    child: Column(
                      children: [
                        sizedBoxH(height: 36),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 28.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: AppColors.texfieldColor,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppStrings.ageRequirement,
                                    style: AppStyles.interRegularStyle(
                                        fontSize: 15.6),
                                  ),
                                  Text(
                                    "${c.start.ceil()} - ${c.end.ceil()}",
                                    style: AppStyles.interRegularStyle(
                                        fontSize: 15.6),
                                  ),
                                ],
                              ),
                              sizedBoxH(height: 16),
                              SliderTheme(
                                data: const SliderThemeData(
                                    thumbColor: AppColors.white,
                                    rangeThumbShape: RoundRangeSliderThumbShape(
                                        enabledThumbRadius: 15,
                                        disabledThumbRadius: 15)),
                                child: RangeSlider(
                                    inactiveColor:
                                        AppColors.inactiveSliderColor,
                                    min: 16,
                                    max: 100,
                                    values: RangeValues(c.start, c.end),
                                    onChanged: (value) {
                                      c.start = value.start;
                                      c.end = value.end;
                                      c.update();
                                    }),
                              ),
                            ],
                          ),
                        ),
                        sizedBoxH(height: 20),
                        SettingListTile(
                          text: AppStrings.limitTheParticipants,
                          icon: FlutterSwitch(
                            width: 52.0.w,
                            height: 32.0.h,
                            valueFontSize: 0.0.sp,
                            toggleSize: 27.0.w,
                            value: c.isParticipantsLimited!,
                            borderRadius: 16.0.r,
                            // padding: 8.0,
                            showOnOff: false,
                            activeColor: AppColors.orangePrimary,

                            onToggle: (val) {
                              c.toggleLimiyParticipants();
                            },
                          ),
                          radiusBottomRight:
                              !c.isParticipantsLimited! ? 10 : 0.0,
                          radiusBottomLeft:
                              !c.isParticipantsLimited! ? 10 : 0.0,
                        ),
                        !c.isParticipantsLimited! ? Container() : MyDivider(),
                        !c.isParticipantsLimited!
                            ? Container()
                            : SettingListTile(
                                text: AppStrings.maxParticipants,
                                icon: Row(
                                  children: [
                                    CounterButton(
                                      icon: const Icon(Icons.remove),
                                      onTap: () {
                                        if (c.maxPartipants != 0) {
                                          c.maxPartipants--;
                                          c.update();
                                        }
                                      },
                                    ),
                                    sizedBoxW(width: 8.w),
                                    Text(
                                      "${c.maxPartipants}",
                                      style: AppStyles.interRegularStyle(
                                          fontSize: 15.6),
                                    ),
                                    sizedBoxW(width: 8.w),
                                    CounterButton(
                                      icon: const Icon(Icons.add),
                                      onTap: () {
                                        c.maxPartipants++;
                                        c.update();
                                      },
                                    )
                                  ],
                                ),
                                radiusTopRight: 0.0,
                                radiusTopLeft: 0.0,
                              ),
                      ],
                    ),
                  ))),
          bottomNavigationBar: SizedBox(
            height: 52.h,
            child: Center(
                child: AppGradientButton(
                    width: 152.w,
                    btnText: AppStrings.apply,
                    onPressed: () {
                      Get.back();
                    })),
          ),
        );
      }),
    );
  }

  static showInviteSheet({void Function()? onPressed, String? title}) {
    showFlexibleBottomSheet(
      initHeight: 0.84,
      //isExpand: true,
      minHeight: 0.83,
      maxHeight: 0.85,
      //isCollapsible: true,
      bottomSheetColor: Colors.transparent,
      context: getContext(),
      builder: (a, b, c) {
        return showUsers(b, onPressed: onPressed, title: title);
      },
      anchors: [0.83, 0.84, 0.85],
      isSafeArea: true,
    );
  }

  static Widget showUsers(ScrollController b,
      {void Function()? onPressed, String? title}) {
    return GetBuilder<CreateActivityScreenVM>(
      builder: (c) {
        return ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32.r), topRight: Radius.circular(32.r)),
          child: Scaffold(
            body: Container(
                // padding: EdgeInsets.only(
                // bottom: MediaQuery.of(getContext()).viewInsets.bottom,),
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
                        Text(title ?? AppStrings.inviteFriend,
                            style: AppStyles.interSemiBoldStyle(
                                fontSize: 16.0, color: AppColors.textColor))
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 22.w, vertical: 16.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SearchTextField(
                            controller: c.searchCtrl,
                            onChanged: (t) {
                              if (t.trim().isEmpty) {
                                c.friends!.clear();
                                c.friends!.addAll(c.searchedFriends!);
                              } else {
                                c.searchInvities(t);
                              }
                              c.update();
                            },
                            radius: 30,
                            hint: "Search",
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              height: 8.h,
                              decoration: const BoxDecoration(
                                  //borderRadius: BorderRadius.circular(100),
                                  color: AppColors.texfieldColor),
                            ))
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 22.w, vertical: 22.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          c.friends!.isEmpty
                              ? Center(
                                  child: Text(
                                  "No freinds available",
                                  style: AppStyles.interRegularStyle(),
                                ))
                              : GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 12.h,
                                    mainAxisSpacing: 16.w,
                                    mainAxisExtent: 105.h,
                                  ),
                                  itemCount:
                                      c.friends!.length, //25, //c.list.length,
                                  itemBuilder: (context, index) {
                                    return userCard(c, index);
                                  })
                        ],
                      ),
                    ),
                    sizedBoxH(
                      height: 10,
                    ),
                    c.friends!.isEmpty
                        ? Container()
                        : AppGradientButton(
                            btnText: AppStrings.done,
                            onPressed: onPressed ??
                                () {
                                  c.inviteFriends();
                                },
                            height: 56,
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                                horizontal: 22.w, vertical: 16.h),
                          )
                  ],
                )),
          ),
        );
      },
    );
  }

  static Widget userCard(CreateActivityScreenVM c, index) {
    return GetBuilder<CreateActivityScreenVM>(builder: (c) {
      return InkWell(
        onTap: () {
          debugPrint("Is Hidden ${c.friends![index].getIsHidden!}");
          if (!c.friends![index].getIsHidden!) {
            c.friends![index].setIsHidden = true;
          } else {
            c.friends![index].setIsHidden = false;
          }
          c.update();
        },
        child: Container(
          color: AppColors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                  child: Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    height: 76.h,
                    width: 72.w,
                  ),
                  Positioned(
                    child: c.friends![index].user!.profilePic!.trim().isNotEmpty
                        ? MyAvatar(
                            url: ApiInterface.baseUrl +
                                Endpoints.user +
                                Endpoints.profileImage +
                                c.friends![index].user!.profilePic!.toString(),
                            height: 72,
                            width: 72,
                            radiusAll: 28.8,
                            isNetwork: true,
                          )
                        : MyAvatar(
                            url: AppImage.sampleAvatar,
                            height: 72,
                            width: 72,
                            radiusAll: 28.8,
                          ),
                  ),
                  Positioned(
                    top: 58.h,
                    left: 27.w,
                    child: Container(
                      width: 22.w,
                      height: 22.h,
                      decoration: BoxDecoration(
                        color: c.friends![index].getIsHidden!
                            ? AppColors.orangePrimary
                            : AppColors.btnStrokeColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.asset(
                          c.friends![index].getIsHidden!
                              ? AppIcons.checkedIcon
                              : AppIcons.uncheckedIcon,
                          fit: BoxFit.fill,
                          width: 22.w,
                          height: 22.h,
                        ),
                      ),
                    ),
                  )
                ],
              )),
              sizedBoxH(
                height: 7,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "${c.friends![index].user!.firstName} ${c.friends![index].user!.lastName}",
                      style: AppStyles.interMediumStyle(fontSize: 15.4),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}

class CounterButton extends StatelessWidget {
  const CounterButton({
    required this.onTap,
    required this.icon,
    this.radius,
    this.width,
    this.height,
    Key? key,
  }) : super(key: key);

  final VoidCallback onTap;
  final Widget icon;
  final double? width;
  final double? height;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(radius?.r ?? 8.r),
      onTap: onTap,
      child: Container(
        width: width?.w ?? 32.w,
        height: height?.h ?? 32.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius?.r ?? 8.r),
            border: Border.all(color: AppColors.ageColor)),
        child: Center(child: icon),
      ),
    );
  }
}

import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jyo_app/resources/app_image.dart';
import 'package:jyo_app/utils/app_widgets/app_bar.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/view/create_post_screen_view.dart';
import 'package:jyo_app/view/timeline_screen_view.dart';
import 'package:jyo_app/view_model/create_group_screen_vm.dart';

import '../data/local/group_edit_model.dart';
import '../data/remote/api_interface.dart';
import '../data/remote/endpoints.dart';
import '../resources/app_colors.dart';
import '../resources/app_strings.dart';
import '../resources/app_styles.dart';
import '../utils/app_widgets/app_gradient_btn.dart';
import '../utils/app_widgets/app_icon_button.dart';
import '../utils/app_widgets/setting_list_tile.dart';

class CreateGroupScreenView extends StatelessWidget {
  const CreateGroupScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateGroupScreenVM>(builder: (c) {
      return SafeArea(
          child: Scaffold(
        appBar: MyAppBar(color: 0xffffffff, leading: [
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Text(
              AppStrings.cancel,
              style: AppStyles.interMediumStyle(
                  fontSize: 18, color: AppColors.hintTextColor),
            ),
          )
        ]),
        body: ListView(
          children: [
            GroupEdit.getGroup != null
                ? Container()
                : Container(
                    color: AppColors.white,
                    padding:
                        EdgeInsets.symmetric(horizontal: 22.w, vertical: 16.h),
                    child: Column(
                      children: [
                        MyAvatar(
                          url: AppIcons.groupIcon,
                          width: 72,
                          height: 72,
                          radiusAll: 26,
                        ),
                        sizedBoxH(height: 10),
                        Text(
                          AppStrings.createGroupInfoHeading,
                          style: AppStyles.interSemiBoldStyle(fontSize: 16),
                        ),
                        sizedBoxH(height: 5),
                        Text(
                          AppStrings.createGroupInfoSubHead,
                          style: AppStyles.interRegularStyle(),
                        )
                      ],
                    ),
                  ),
            sizedBoxH(height: 8),
            Container(
              color: AppColors.white,
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 24.h),
              child: Column(
                children: [
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
                              ),
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
                    child: SizedBox(
                      height: 80.h,
                      width: 80.w,
                      child: Stack(
                        children: [
                          SizedBox(
                            width: 80.w,
                            height: 80.h,
                          ),
                          Positioned(
                              child: c.coverImage!.isEmpty
                                  ? MyAvatar(
                                      url: AppIcons.groupPhIcon,
                                      width: 80,
                                      height: 80,
                                      radiusAll: 32,
                                    )
                                  : MyAvatar(
                                      width: 80,
                                      height: 80,
                                      url: ApiInterface.postImgUrl +
                                          c.coverImage!,
                                      isNetwork: true,
                                      radiusAll: 32,
                                    )),
                          // Positioned(
                          //     child: c.coverImage!.trim().isEmpty
                          //         ? Container()
                          //         : Align(
                          //             alignment: Alignment.topRight,
                          //             child: InkWell(
                          //               onTap: () {
                          //                 debugPrint("Close Clicked");
                          //                 c.xCoverImage = null;
                          //                 c.coverImage = "";
                          //                 c.update();
                          //               },
                          //               child: Container(
                          //                 margin: EdgeInsets.symmetric(
                          //                     horizontal: 9.w, vertical: 9.h),
                          //                 height: 32.h,
                          //                 width: 32.w,
                          //                 decoration: BoxDecoration(
                          //                   borderRadius:
                          //                       BorderRadius.circular(100.r),
                          //                   color: const Color(0x8F000000),
                          //                 ),
                          //                 child: Center(
                          //                     child: ClipRRect(
                          //                   borderRadius:
                          //                       BorderRadius.circular(100.r),
                          //                   child: SvgPicture.asset(
                          //                     AppIcons.closeSvg,
                          //                     width: 28.w,
                          //                     height: 28.h,
                          //                     color: AppColors.white,
                          //                   ),
                          //                 )),
                          //               ),
                          //             ),
                          //           )),
                        ],
                      ),
                    ),
                  ),
                  sizedBoxH(height: 10),
                  TextField(
                    controller: c.groupNameCtrl,
                    style: AppStyles.interRegularStyle(
                        fontSize: 20, color: AppColors.hintTextColor),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: Hints.groupName,
                      hintStyle: AppStyles.interRegularStyle(
                          fontSize: 20, color: AppColors.hintTextColor),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  sizedBoxH(height: 10),
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
                          controller: c.groupAboutCtrl,
                          maxLines: null,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: Hints.groupAbt,
                              hintStyle: AppStyles.interRegularStyle(
                                  fontSize: 20, color: AppColors.hintTextColor),
                              contentPadding: EdgeInsets.only(
                                  left: 14.w,
                                  bottom:
                                      MediaQuery.of(getContext()).size.width <=
                                              400
                                          ? 8.h
                                          : 0.0)),
                          style: AppStyles.interRegularStyle())),
                  sizedBoxH(height: 20),
                  SettingListTile(
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
                          return categorySheet(b);
                        },
                        anchors: [0, 0.75, 0.85],
                        isSafeArea: true,
                      );
                    },
                    text: AppStrings.category,
                    icon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 150.w,
                          child: Text(
                            c.selectedCategories,
                            style: AppStyles.interRegularStyle(
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                          ),
                        ),
                        sizedBoxW(width: 3),
                        const Icon(
                          Icons.keyboard_arrow_right,
                          color: AppColors.textColor,
                        )
                      ],
                    ),
                  ),
                  sizedBoxH(height: 20),
                  SettingListTile(
                    text: AppStrings.privateThisGroup,
                    icon: FlutterSwitch(
                      width: 52.0.w,
                      height: 32.0.h,
                      valueFontSize: 0.0.sp,
                      toggleSize: 27.0.w,
                      value: c.isPrivateGroup,
                      borderRadius: 16.0.r,
                      // padding: 8.0,
                      showOnOff: false,
                      activeColor: AppColors.orangePrimary,

                      onToggle: (val) {
                        c.togglePrivateGroup();
                      },
                    ),
                  ),
                  sizedBoxH(height: 20),
                  SettingListTile(
                    text: AppStrings.requireAcceptance,
                    icon: FlutterSwitch(
                      width: 52.0.w,
                      height: 32.0.h,
                      valueFontSize: 0.0.sp,
                      toggleSize: 27.0.w,
                      value: c.requireAccept,
                      borderRadius: 16.0.r,
                      // padding: 8.0,
                      showOnOff: false,
                      activeColor: AppColors.orangePrimary,

                      onToggle: (val) {
                        c.toggleRequireAccept();
                      },
                    ),
                  ),
                  sizedBoxH(height: 20),
                  AppGradientButton(
                    width: double.infinity,
                    btnText: AppStrings.continuee,
                    onPressed: () {
                      c.createGroup();
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ));
    });
  }

  static void showInviteFriendSheet() {
    showFlexibleBottomSheet(
      initHeight: 0.84,
      //isExpand: true,
      minHeight: 0,
      maxHeight: 0.85,
      //isCollapsible: true,
      bottomSheetColor: Colors.transparent,
      context: getContext(),
      builder: (a, b, c) {
        return showUsers(b);
      },
      anchors: [0, 0.84, 0.85],
      isSafeArea: true,
    );
  }

  static Widget showUsers(ScrollController b) {
    return GetBuilder<CreateGroupScreenVM>(
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
                    Text(AppStrings.inviteFriend,
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
                      Row(
                        children: [
                          Expanded(
                            child: SearchTextField(
                              controller: c.searchCtrl,
                              onChanged: (t) {
                                if (t.trim().isEmpty) {
                                  c.friends!.clear();
                                  c.friends!.addAll(c.searchedFriends!);
                                } else {
                                  c.searchFriends(t);
                                }
                                c.update();
                              },
                              radius: 30,
                            ),
                          ),
                        ],
                      ),

                      // AppTextField(
                      //   controller: c.searchCtrl,
                      //   onChanged: (t) {
                      //     if (t.trim().isEmpty) {
                      //       c.friends!.clear();
                      //       c.friends!.addAll(c.searchedFriends!);
                      //     } else {
                      //       c.search(t);
                      //     }
                      //     c.update();
                      //   },
                      //   radiusBottomLeft: 30,
                      //   radiusBottomRight: 30,
                      //   radiusTopLeft: 30,
                      //   radiusTopRight: 30,
                      //   height: 40,
                      //   margin: const EdgeInsets.all(0),
                      //   icon: const Icon(
                      //     Icons.search,
                      //     color: AppColors.hintTextColor,
                      //   ),
                      //   hintText: "Seach user",
                      //   contentPaddingTop: 6,
                      // )
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
                  height: (MediaQuery.of(getContext()).size.height -
                          (MediaQuery.of(getContext()).size.height * 0.48))
                      .h,
                  padding:
                      EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
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
                          : Expanded(
                              child: GridView.builder(
                                  shrinkWrap: true,
                                  //physics: const NeverScrollableScrollPhysics(),
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
                                  }),
                            )
                    ],
                  ),
                ),
                // sizedBoxH(
                //   height: 10,
                // ),
                c.friends!.isEmpty
                    ? Container()
                    : AppGradientButton(
                        btnText: AppStrings.done,
                        onPressed: () {
                          //c.updatePostHideFrom();
                          c.inviteFriends();
                        },
                        height: 56,
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(
                            horizontal: 22.w, vertical: 16.h),
                      )
              ],
            ));
      },
    );
  }

  static Widget userCard(CreateGroupScreenVM c, index) {
    return InkWell(
      onTap: () {
        if (!c.friends![index].getIsHidden!) {
          c.friends![index].setIsHidden = true;
          c.taggedFriends!.add(c.friends![index]);
        } else {
          c.friends![index].setIsHidden = false;
          int idx = c.taggedFriends!.indexWhere((element) {
            return c.friends![index].user!.userId.toString() ==
                element.user!.userId.toString();
          });
          if (idx != -1) {
            c.taggedFriends!.removeAt(idx);
          }
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
                  child: c.friends![index].user!.profilePic!.isNotEmpty
                      ? MyAvatar(
                          url: ApiInterface.baseUrl +
                              Endpoints.user +
                              Endpoints.profileImage +
                              c.friends![index].user!.profilePic!.toString(),
                          radiusAll: 28.8,
                          height: 72,
                          width: 72,
                          isNetwork: true,
                        )
                      : MyAvatar(
                          url: AppImage.sampleAvatar,
                          radiusAll: 28.8,
                          height: 72,
                          width: 72,
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
                    c.friends![index].user!.firstName.toString() +
                        " " +
                        c.friends![index].user!.lastName.toString(),
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
  }

  Widget categorySheet(b) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r), topRight: Radius.circular(32.r)),
      child: GetBuilder<CreateGroupScreenVM>(builder: (c) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32.r),
                  topRight: Radius.circular(32.r)),
              child: Column(
                children: [
                  sizedBoxH(height: 15),
                  Container(
                    height: 4.h,
                    width: 54.w,
                    decoration: BoxDecoration(
                        color: AppColors.disabledColor,
                        borderRadius: BorderRadius.circular(100.r)),
                  ),
                  //sizedBoxH(height: 15),
                  MyAppBar(
                    leading: [
                      MyIconButton(
                          onTap: () {
                            Get.back();
                          },
                          isSvg: true,
                          icon: AppIcons.closeSvg)
                    ],
                    middle: [
                      Text(
                        AppStrings.selectCategory,
                        style: AppStyles.interSemiBoldStyle(fontSize: 16),
                      ),
                    ],
                    actions: [
                      MyIconButton(
                          onTap: () {
                            //  Get.back();
                          },
                          isSvg: true,
                          icon: AppIcons.reloadSvg)
                    ],
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 16.h, horizontal: 22.w),
                    child: SearchTextField(
                        controller: c.searchCtrl,
                        onChanged: (t) {
                          if (t.trim().isEmpty) {
                            c.list.clear();
                            c.list.addAll(c.baseList);
                            c.update();
                          } else {
                            c.search(t.trim());
                          }
                        },
                        icon: true,
                        radius: 10),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                            height: 8.h,
                            color: AppColors.white //AppColors.texfieldColor,
                            ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                        controller: b,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 22.w),
                          child: Wrap(
                            direction: Axis.horizontal,
                            spacing: 10,
                            runSpacing: 10,
                            children: List.generate(c.list.length, (index) {
                              return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    gradient: c.list[index].getIsSelected!
                                        ? const LinearGradient(
                                            colors: [
                                                Color(0xffFFD036),
                                                Color(0xffFFA43C)
                                              ],
                                            transform:
                                                GradientRotation(240) //120
                                            )
                                        : null,
                                    color: AppColors.texfieldColor,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 10.h),
                                  child: Material(
                                    type: MaterialType.transparency,
                                    borderRadius: BorderRadius.circular(10.r),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(10.r),
                                      onTap: () {
                                        c.list[index].setIsSelected =
                                            !c.list[index].getIsSelected!;
                                        //c.isIntrestListEmpty();

                                        c.selectedCategories = "";
                                        int count = 0;
                                        for (int i = 0;
                                            i < c.list.length;
                                            i++) {
                                          if (c.list[i].getIsSelected!) {
                                            count++;
                                            if (count == 1) {
                                              c.selectedCategories =
                                                  c.selectedCategories +
                                                      "${c.list[i].name}";
                                            } else {
                                              c.selectedCategories =
                                                  c.selectedCategories +
                                                      ", ${c.list[i].name}";
                                            }
                                          }
                                        }
                                        c.update();
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.network(c.list[index].icon!),
                                          sizedBoxW(width: 8),
                                          Text(
                                            c.list[index].name!,
                                            style: AppStyles.interMediumStyle(
                                                fontSize: 14.6,
                                                color:
                                                    c.list[index].getIsSelected!
                                                        ? AppColors.white
                                                        : AppColors.textColor),
                                          )
                                        ],
                                      ),
                                    ),
                                  ));
                            }),
                          ),
                        )),
                  ),
                ],
              )),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
            child: AppGradientButton(
                btnText: AppStrings.save,
                onPressed: () {
                  Get.back();
                }),
          ),
        );
      }),
    );
  }
}

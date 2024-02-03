import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jyo_app/resources/app_image.dart';
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/resources/app_strings.dart';
import 'package:jyo_app/utils/app_widgets/app_bar.dart';
import 'package:jyo_app/utils/app_widgets/app_icon_button.dart';
import 'package:jyo_app/view/timeline_screen_view.dart';
import 'package:jyo_app/view_model/create_post_screen_vm.dart';
import 'package:video_player/video_player.dart';

import '../data/remote/api_interface.dart';
import '../data/remote/endpoints.dart';
import '../models/posts_model/post_and_activity_model.dart';
import '../resources/app_colors.dart';
import '../resources/app_fonts.dart';
import '../resources/app_styles.dart';
import '../utils/app_widgets/app_gradient_btn.dart';
import '../utils/common.dart';

class CreatePostScreenView extends StatelessWidget {
  const CreatePostScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreatePostScreenVM>(builder: (c) {
      return WillPopScope(
        onWillPop: (() async {
          c.back();
          return true;
        }),
        child: SafeArea(
            child: Scaffold(
                backgroundColor: AppColors.white,
                appBar: MyAppBar(
                  leading: [
                    MyIconButton(
                      onTap: () {
                        c.back();
                      },
                      icon: AppIcons.closeSvg,
                      isSvg: true,
                    )
                  ],
                  actions: [
                    InkWell(
                      onTap: () {
                        if (c.isEditing!) {
                          c.updatePost();
                        } else {
                          c.addPost();
                        }
                      },
                      child: Text(AppStrings.post,
                          style: TextStyle(
                              foreground: Paint()
                                ..shader = const LinearGradient(
                                  colors: <Color>[
                                    Color(0xffFFD036),
                                    Color(0xffFFA43C)
                                  ],
                                ).createShader(
                                    const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                              fontSize: 18.sp,
                              fontFamily: interMedium)),
                    )
                  ],
                ),
                body: ListView(
                  children: [
                    Container(
                      color: AppColors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 22.w, vertical: 24.h),
                      child: Row(children: [
                        c.tvm.imageFileName!.isNotEmpty
                            ? MyAvatar(
                                url: ApiInterface.baseUrl +
                                    Endpoints.user +
                                    Endpoints.profileImage +
                                    c.tvm.imageFileName.toString(),
                                height: 48,
                                width: 48,
                                radiusAll: 19.2,
                                isNetwork: true,
                              )
                            : MyAvatar(
                                url: AppImage.avatar3,
                                height: 48,
                                width: 48,
                                radiusAll: 19.2,
                              ),
                        sizedBoxW(width: 12.w),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.tvm.firstName.toString() +
                                  " " +
                                  c.tvm.lastName.toString(),
                              style: AppStyles.interSemiBoldStyle(
                                  fontSize: 16, color: AppColors.textColor),
                            ),
                            InkWell(
                              onTap: () async {
                                await getToNamed(postPrivacyRoute);
                                await c.fetchPostPrivacy();
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    AppIcons.globeSvg,
                                    color: AppColors.hintTextColor,
                                    height: 16.h,
                                    width: 16,
                                  ),
                                  sizedBoxW(width: 4.w),
                                  Text(
                                    c.privacyStatus!,
                                    style: AppStyles.interRegularStyle(
                                        fontSize: 13.2,
                                        color: AppColors.hintTextColor),
                                  ),
                                  const Icon(Icons.keyboard_arrow_down,
                                      size: 13.2,
                                      color: AppColors.hintTextColor)
                                ],
                              ),
                            )
                          ],
                        )
                      ]),
                    ),
                    Container(
                      // height: 40.h,
                      margin: EdgeInsets.symmetric(horizontal: 22.w),
                      child: TextField(
                        controller: c.userStatusCtrl,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: AppStrings.whatsNew,
                          hintStyle: AppStyles.interRegularStyle(
                              fontSize: 17.2, color: AppColors.hintTextColor),
                        ),
                        maxLines: null,
                      ),
                    ),
                    c.privacyStatus.toString() == "Only me"
                        ? Container()
                        : Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 22.w, vertical: 24.h),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      AppIcons.friendTagSvg,
                                      width: 24.h,
                                      height: 24.h,
                                    ),
                                    sizedBoxW(width: 2.w),
                                    InkWell(
                                        onTap: () {
                                          showFlexibleBottomSheet(
                                            initHeight: 0.84,
                                            //isExpand: true,
                                            minHeight: 0,
                                            maxHeight: 0.85,
                                            //isCollapsible: true,
                                            bottomSheetColor:
                                                Colors.transparent,
                                            context: getContext(),
                                            builder: (a, b, c) {
                                              return showUsers(b);
                                            },
                                            anchors: [0, 0.84, 0.85],
                                            isSafeArea: true,
                                          );
                                        },
                                        child: Text(
                                          AppStrings.tagFriend,
                                          style: AppStyles.interMediumStyle(
                                              fontSize: 14,
                                              color: AppColors.orangePrimary),
                                        ))
                                  ],
                                ),
                                sizedBoxH(
                                    height:
                                        c.taggedFriends!.isNotEmpty ? 12.h : 0),
                                SizedBox(
                                  height:
                                      c.taggedFriends!.isNotEmpty ? 40.h : 0,
                                  child: ListView.builder(
                                      itemCount: c.taggedFriends!.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: EdgeInsets.only(right: 8.w),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12.w),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              color: AppColors.texfieldColor),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                c.taggedFriends![index].user!
                                                        .firstName
                                                        .toString() +
                                                    " " +
                                                    c.taggedFriends![index]
                                                        .user!.lastName
                                                        .toString(),
                                                style:
                                                    AppStyles.interMediumStyle(
                                                        fontSize: 14),
                                              ),
                                              sizedBoxW(width: 7.4),
                                              InkWell(
                                                onTap: () {
                                                  int idx = c.friends!
                                                      .indexWhere((element) {
                                                    if (c.taggedFriends![index]
                                                            .user!.userId
                                                            .toString() ==
                                                        element.user!.userId
                                                            .toString()) {
                                                      element.setIsHidden =
                                                          false;
                                                      return true;
                                                    } else {
                                                      return false;
                                                    }
                                                  });
                                                  if (idx != -1) {
                                                    c.taggedFriends!
                                                        .removeAt(index);
                                                  }
                                                  //  c.taggedFriends!.removeAt(index);
                                                  c.update();
                                                },
                                                child: SvgPicture.asset(
                                                  AppIcons.closeSvg,
                                                  color: AppColors.ageColor,
                                                  width: 24.w,
                                                  height: 24.w,
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }),
                                )
                              ],
                            )),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 22.w,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                              onTap: () {
                                c.pickImage(ImageSource.gallery,
                                    type: CaptureType.doc);
                              },
                              child: Text(
                                AppStrings.addDoc,
                                style: AppStyles.interMediumStyle(
                                    fontSize: 14,
                                    color: AppColors.orangePrimary),
                              )),
                          SizedBox(
                            height: c.documents!.isNotEmpty ? 12.h : 0,
                          ),
                          SizedBox(
                            height: c.documents!.isNotEmpty ? 40.h : 0,
                            child: ListView.builder(
                                itemCount: c.documents!.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.only(right: 8.w),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12.w),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        color: AppColors.texfieldColor),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          c.documents![index].originalName
                                              .toString(),
                                          style: AppStyles.interMediumStyle(
                                              fontSize: 14),
                                        ),
                                        sizedBoxW(width: 7.4),
                                        InkWell(
                                          onTap: () {
                                            c.documents!.removeAt(index);

                                            //  c.taggedFriends!.removeAt(index);
                                            c.update();
                                          },
                                          child: SvgPicture.asset(
                                            AppIcons.closeSvg,
                                            color: AppColors.ageColor,
                                            width: 24.w,
                                            height: 24.w,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                          ),
                          SizedBox(
                            height: 15.h,
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 22.w),
                      height: 184.h,
                      child: Row(
                        children: [
                          Expanded(
                              child: ListView.builder(
                                  itemCount: c.attachments!.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Container(
                                        width: 144.w,
                                        decoration: BoxDecoration(
                                            color: c.isUploading!
                                                ? AppColors.btnStrokeColor
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(18.r)),
                                        margin: EdgeInsets.only(right: 12.w),
                                        child: c.isUploading!
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        backgroundColor:
                                                            AppColors
                                                                .orangePrimary),
                                              )
                                            : c.attachments![index] == null
                                                ? InkWell(
                                                    onTap: () {
                                                      debugPrint("Add images");
                                                      showCupertinoModalPopup(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            CupertinoActionSheet(
                                                                // title: const Text('Choose Options'),
                                                                // message: const Text('Your options are '),
                                                                actions: <
                                                                    Widget>[
                                                              CupertinoActionSheetAction(
                                                                child: Text(
                                                                  AppStrings
                                                                      .selectPhoto,
                                                                  style: AppStyles
                                                                      .interRegularStyle(
                                                                          color:
                                                                              AppColors.iosBlue),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context,
                                                                      AppStrings
                                                                          .selectPhoto);
                                                                  c.pickImage(
                                                                      ImageSource
                                                                          .gallery);
                                                                },
                                                              ),
                                                              CupertinoActionSheetAction(
                                                                child: Text(
                                                                  AppStrings
                                                                      .takePhoto,
                                                                  style: AppStyles
                                                                      .interRegularStyle(
                                                                          color:
                                                                              AppColors.iosBlue),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context,
                                                                      AppStrings
                                                                          .takePhoto);
                                                                  c.pickImage(
                                                                      ImageSource
                                                                          .camera);
                                                                },
                                                              ),
                                                              CupertinoActionSheetAction(
                                                                child: Text(
                                                                  AppStrings
                                                                      .selectVideo,
                                                                  style: AppStyles
                                                                      .interRegularStyle(
                                                                          color:
                                                                              AppColors.iosBlue),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context,
                                                                      AppStrings
                                                                          .selectVideo);
                                                                  c.pickImage(
                                                                      ImageSource
                                                                          .gallery,
                                                                      type: CaptureType
                                                                          .video);
                                                                },
                                                              ),
                                                            ],
                                                                cancelButton:
                                                                    CupertinoActionSheetAction(
                                                                  child: Text(
                                                                    AppStrings
                                                                        .cancel,
                                                                    style: AppStyles
                                                                        .interRegularStyle(
                                                                            color:
                                                                                AppColors.iosBlue),
                                                                  ),
                                                                  isDefaultAction:
                                                                      true,
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context,
                                                                        AppStrings
                                                                            .cancel);
                                                                  },
                                                                )),
                                                      );
                                                    },
                                                    child: MyAvatar(
                                                      url: AppImage.imgPh,
                                                      isSVG: true,
                                                      radiusAll: 18,
                                                      width: 144.w,
                                                      height: 184.h,
                                                    ))
                                                : Stack(
                                                    children: [
                                                      SizedBox(
                                                          height: 184.h,
                                                          width: 144.w,
                                                          child: c
                                                                      .attachments![
                                                                          index]!
                                                                      .type ==
                                                                  CaptureType
                                                                      .video
                                                              ? c
                                                                      .attachments![
                                                                          index]!
                                                                      .getController!
                                                                      .value
                                                                      .isInitialized
                                                                  ? ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              18.r),
                                                                      child:
                                                                          AspectRatio(
                                                                        aspectRatio: c
                                                                            .attachments![index]!
                                                                            .getController!
                                                                            .value
                                                                            .aspectRatio,
                                                                        child: VideoPlayer(c
                                                                            .attachments![index]!
                                                                            .getController!),
                                                                      ),
                                                                    )
                                                                  : Container()
                                                              : MyAvatar(
                                                                  url: ApiInterface
                                                                          .postImgUrl +
                                                                      c.attachments![index]!
                                                                          .name!,
                                                                  //  c
                                                                  //     .postsToUpload![
                                                                  //         index]!
                                                                  //     .path,
                                                                  width: 144.w,
                                                                  radiusAll: 18,
                                                                  isNetwork:
                                                                      true,
                                                                )),
                                                      Positioned(
                                                          child: Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: InkWell(
                                                          onTap: () {
                                                            debugPrint(
                                                                "Close Clicked");
                                                            // c.postsToUpload!
                                                            //     .removeAt(
                                                            //         index);
                                                            c.attachments!
                                                                .removeAt(
                                                                    index);
                                                            c.update();
                                                          },
                                                          child: Container(
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        9.w,
                                                                    vertical:
                                                                        9.h),
                                                            height: 32.h,
                                                            width: 32.w,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100.r),
                                                              color: const Color(
                                                                  0x8F000000),
                                                            ),
                                                            child: Center(
                                                                child:
                                                                    ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100.r),
                                                              child: SvgPicture
                                                                  .asset(
                                                                AppIcons
                                                                    .closeSvg,
                                                                width: 28.w,
                                                                height: 28.h,
                                                                color: AppColors
                                                                    .white,
                                                              ),
                                                            )),
                                                          ),
                                                        ),
                                                      )),
                                                      Positioned(
                                                          child: Align(
                                                              alignment: Alignment
                                                                  .bottomLeft,
                                                              child: c
                                                                          .attachments![
                                                                              index]!
                                                                          .type ==
                                                                      CaptureType
                                                                          .video
                                                                  ? InkWell(
                                                                      onTap: c
                                                                              .attachments![index]!
                                                                              .getController!
                                                                              .value
                                                                              .isPlaying
                                                                          ? () {
                                                                              c.attachments![index]!.getController!.pause();
                                                                              c.update();
                                                                            }
                                                                          : () {
                                                                              c.attachments![index]!.getController!.play();
                                                                              c.update();
                                                                            },
                                                                      child: Container(
                                                                          margin: EdgeInsets.symmetric(horizontal: 9.w, vertical: 9.h),
                                                                          height: 32.h,
                                                                          width: 32.w,
                                                                          decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(100.r),
                                                                            color:
                                                                                const Color(0x8F000000),
                                                                          ),
                                                                          child: Center(
                                                                              child: Icon(
                                                                            c.attachments![index]!.getController!.value.isPlaying
                                                                                ? Icons.pause_rounded
                                                                                : Icons.play_arrow_rounded,
                                                                            color:
                                                                                Colors.white,
                                                                          ))))
                                                                  : Container()))
                                                    ],
                                                  ));
                                  })),
                        ],
                      ),
                    ),
                    c.activityData.isNotEmpty
                        ? ActivitySearchedCard(
                            activity: PostOrActivity(
                                coverImage: c.activityData["coverImage"],
                                activityName: c.activityData["activityName"],
                                activityDate: DateFormat("dd MMM yyyy").format(
                                    DateTime.parse(c
                                        .activityData["activityDate"]
                                        .toString())),
                                group: c.activityData["group"],
                                activityId: c.activityData["activityId"]))
                        : Container()
                  ],
                ))),
      );
    });
  }

  Widget showUsers(ScrollController b) {
    return GetBuilder<CreatePostScreenVM>(
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
                    Text(AppStrings.tagFriend,
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
                                  c.search(t);
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
                          Get.back();
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

  Widget userCard(CreatePostScreenVM c, index) {
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
}

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    required this.controller,
    this.onChanged,
    this.radius = 10,
    this.hint,
    this.autoFocus = false,
    this.icon = true,
    Key? key,
  }) : super(key: key);

  final TextEditingController? controller;
  final Function(String)? onChanged;
  final double? radius;
  final String? hint;
  final bool? autoFocus;
  final bool? icon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged ?? (t) {},
      autofocus: autoFocus ?? false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: icon! ? 5.w : 15.w),
        //isCollapsed: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius!.r),
          borderSide: BorderSide(
              color: AppColors.texfieldColor,
              width: 1.0.w,
              style: BorderStyle.none),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius!.r),
          borderSide: BorderSide(
              color: AppColors.texfieldColor,
              width: 1.0.w,
              style: BorderStyle.none),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius!.r),
          borderSide: BorderSide(
              color: AppColors.texfieldColor,
              width: 1.0.w,
              style: BorderStyle.none),
        ),
        hintText: hint ?? "Search",
        filled: true,
        fillColor: AppColors.texfieldColor,
        hintStyle: AppStyles.interRegularStyle(
            fontSize: 18, color: AppColors.hintTextColor),
        prefixIcon: icon!
            ? const Icon(
                Icons.search,
                color: AppColors.hintTextColor,
              )
            : null,
      ),
      style: AppStyles.interRegularStyle(
          fontSize: 18, color: AppColors.hintTextColor),
    );
  }
}

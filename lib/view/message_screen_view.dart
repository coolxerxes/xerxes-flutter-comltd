import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jyo_app/resources/app_image.dart';
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/utils/app_widgets/app_bar.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/view/create_post_screen_view.dart';
import 'package:jyo_app/view/timeline_screen_view.dart';
import 'package:jyo_app/view_model/chat_screen_vm.dart';
import 'package:jyo_app/view_model/message_screen_vm.dart';

import '../resources/app_colors.dart';
import '../resources/app_strings.dart';
import '../resources/app_styles.dart';
import '../utils/app_widgets/app_icon_button.dart';

class MessageScreenView extends StatelessWidget {
  const MessageScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MessageScreenVM>(builder: (c) {
      return Scaffold(
          appBar: PreferredSize(
              preferredSize: Size(double.infinity, 56.h),
              child: Container(
                decoration: const BoxDecoration(
                    //color: Color(color ?? 0x00000000),
                    gradient: LinearGradient(
                        colors: [Color(0xffFFD036), Color(0xffFFA43C)],
                        transform: GradientRotation(240) //120
                        )),
                child: MyAppBar(
                  // isGradient: true,
                  leading: [
                    Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: Text(
                          "Message",
                          style: AppStyles.interMediumStyle(
                              fontSize: 24, color: AppColors.white),
                        )),
                  ],
                  actions: [
                    InkWell(
                        onTap: () {
                          showFlexibleBottomSheet(
                            initHeight: 0.4,
                            //isExpand: true,
                            minHeight: 0,
                            maxHeight: 0.85,
                            //isCollapsible: true,
                            bottomSheetColor: Colors.transparent,
                            context: getContext(),
                            builder: (a, b, c) {
                              return showUsers(b);
                            },
                            anchors: [0, 0.5, 0.85],
                            isSafeArea: true,
                          );
                        },
                        child: Padding(
                            padding: EdgeInsets.only(top: 20.h),
                            child: const Icon(Icons.add,
                                size: 24, color: AppColors.white)))
                  ],
                ),
              )),
          body: ListView(
            children: [
              Container(
                color: AppColors.white,
                padding: EdgeInsets.only(top: 24.h),
                child: Container(
                  color: AppColors.white,
                  padding:
                      EdgeInsets.only(right: 22.w, left: 22.w, bottom: 16.w),
                  child: Container(
                    height: 41.h,
                    // margin: EdgeInsets.symmetric(horizontal: 22.w),
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
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
                                  borderRadius: BorderRadius.circular(14.r),
                                  boxShadow: c.currentTab == MessageType.friend
                                      ? [
                                          BoxShadow(
                                              blurRadius: 4.r,
                                              offset: const Offset(1, 1),
                                              color: AppColors.tabShadowColor)
                                        ]
                                      : null,
                                  color: c.currentTab == MessageType.friend
                                      ? AppColors.white
                                      : AppColors.tabBkgColor),
                              child: Material(
                                borderRadius: BorderRadius.circular(14.r),
                                type: MaterialType.transparency,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(14.r),
                                  onTap: () {
                                    c.currentTab = MessageType.friend;
                                    c.update();
                                  },
                                  child: Center(
                                    child: Text(
                                      AppStrings.freinds,
                                      style: AppStyles.interMediumStyle(
                                          fontSize: 12.8,
                                          color:
                                              c.currentTab == MessageType.friend
                                                  ? AppColors.textColor
                                                  : AppColors.editBorderColor),
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
                                  borderRadius: BorderRadius.circular(14.r),
                                  boxShadow: c.currentTab == MessageType.group
                                      ? [
                                          BoxShadow(
                                              blurRadius: 4.r,
                                              offset: const Offset(1, 1),
                                              color: AppColors.tabShadowColor)
                                        ]
                                      : null,
                                  color: c.currentTab == MessageType.group
                                      ? AppColors.white
                                      : AppColors.tabBkgColor),
                              child: Material(
                                  borderRadius: BorderRadius.circular(14.r),
                                  type: MaterialType.transparency,
                                  child: InkWell(
                                      borderRadius: BorderRadius.circular(14.r),
                                      onTap: () {
                                        c.currentTab = MessageType.group;
                                        c.update();
                                      },
                                      child: Center(
                                        child: Text(
                                          AppStrings.groups,
                                          style: AppStyles.interMediumStyle(
                                              fontSize: 12.8,
                                              color: c.currentTab ==
                                                      MessageType.group
                                                  ? AppColors.textColor
                                                  : AppColors.editBorderColor),
                                        ),
                                      ))),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
              c.currentTab == MessageType.friend
                  ? RefreshIndicator(
                      onRefresh: () async {
                        await c.refreshLists();
                      },
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height - 190,
                        //color: Colors.black,
                        child: c.isLoading!
                            ? const Center(
                                child: CircularProgressIndicator(
                                    backgroundColor: AppColors.orangePrimary),
                              )
                            : c.conversationList.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.message,
                                          color: AppColors.hintTextColor,
                                          size: 50,
                                        ),
                                        sizedBoxH(height: 16),
                                        Text(
                                          "No conversations found.\nSend messages to friends to get conversations.",
                                          style: AppStyles.interMediumStyle(
                                              fontSize: 14,
                                              color: AppColors.hintTextColor),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: c.conversationList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return freindMessage(c, index);
                                    }),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        await c.refreshLists();
                      },
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height - 190,
                        //color: Colors.black,
                        child: c.isLoadingGroup!
                            ? const Center(
                                child: CircularProgressIndicator(
                                    backgroundColor: AppColors.orangePrimary),
                              )
                            : c.groupsList.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.message,
                                          color: AppColors.hintTextColor,
                                          size: 50,
                                        ),
                                        sizedBoxH(height: 16),
                                        Text(
                                          "No Groups found.\nCreate or join groups to get the list.",
                                          style: AppStyles.interMediumStyle(
                                              fontSize: 14,
                                              color: AppColors.hintTextColor),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: c.groupsList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return groupMessage(c, index);
                                    }),
                      ),
                    )

              // SizedBox(
              //     height: MediaQuery.of(context).size.height - 190,
              //     //color: Colors.black,
              //     child: RefreshIndicator(
              //       onRefresh: () async {
              //         //await c.refreshLists();
              //       },
              //       child: ListView.builder(
              //           itemCount: 25,
              //           shrinkWrap: true,
              //           itemBuilder: (context, index) {
              //             return groupMessage();
              //           }),
              //     ),
              //   )
            ],
          ));
    });
  }

  Widget freindMessage(MessageScreenVM c, index) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
            ),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () {
                  Get.delete<ChatScreenVM>(force: true);
                  final cvm = Get.put(ChatScreenVM());
                  cvm.conversation = c.conversationList[index];
                  getToNamed(chatScreenRoute);
                },
                child: Container(
                  // margin: EdgeInsets.only(left: 22.w, right: 22.w),
                  padding:
                      EdgeInsets.symmetric(vertical: 12.h, horizontal: 22.w),
                  child: Row(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SizedBox(
                            width: 71.w,
                            height: 64.h,
                          ),
                          (c.conversationList[index].conversationWith as User)
                                  .avatar!
                                  .trim()
                                  .isEmpty
                              ? MyAvatar(
                                  url: AppImage.sampleAvatar,
                                  width: 64,
                                  height: 64,
                                  radiusAll: 22,
                                )
                              : MyAvatar(
                                  url: (c.conversationList[index]
                                          .conversationWith as User)
                                      .avatar!
                                      .trim(),
                                  width: 64,
                                  height: 64,
                                  radiusAll: 22,
                                  isNetwork: true,
                                ),
                          Positioned(
                              left: 57.w,
                              top: 28.h,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100.r),
                                    color: AppColors.white),
                                child: Container(
                                    width: 14.w,
                                    height: 14.h,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100.r),
                                        color: AppColors.orangePrimary)),
                              ))
                        ],
                      ),
                      sizedBoxW(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    (c.conversationList[index].conversationWith
                                            as User)
                                        .name
                                        .trim(),
                                    style: AppStyles.interSemiBoldStyle(
                                        fontSize: 16),
                                  ),
                                ),
                                Text(
                                  DateFormat("HH:mm a").format(
                                      c.conversationList[index].updatedAt!),
                                  style: AppStyles.interRegularStyle(
                                      fontSize: 14, color: AppColors.ageColor),
                                ),
                              ],
                            ),
                            sizedBoxH(height: 4.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    getMessage(c, index),
                                    style: AppStyles.interRegularStyle(
                                        fontSize: 15,
                                        textOverflow: TextOverflow.ellipsis),
                                  ),
                                ),
                                const RotatedBox(
                                    quarterTurns: 4,
                                    child: Icon(
                                      Icons.push_pin_sharp,
                                      color: Colors
                                          .transparent, //AppColors.ageColor,
                                      size: 20,
                                    ))
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget groupMessage(MessageScreenVM c, index) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () {
            Get.delete<ChatScreenVM>(force: true);
            final cvm = Get.put(ChatScreenVM());
            cvm.group = c.groupsList[index];
            getToNamed(chatScreenRoute);
          },
          child: Row(
            children: [
              Expanded(
                child: Container(
                  //margin: EdgeInsets.only(left: 22.w, right: 22.w),
                  padding:
                      EdgeInsets.symmetric(horizontal: 22.w, vertical: 12.h),

                  child: Row(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SizedBox(
                            width: 71.w,
                            height: 64.h,
                          ),
                          isValidString(c.groupsList[index].icon)
                              ? MyAvatar(
                                  url: c.groupsList[index].icon.toString(),
                                  width: 64,
                                  height: 64,
                                  radiusAll: 22,
                                  isNetwork: true,
                                )
                              : MyAvatar(
                                  url: AppImage.sampleAvatar,
                                  width: 64,
                                  height: 64,
                                  radiusAll: 22,
                                ),
                          // Positioned(
                          //     left: 57.w,
                          //     top: 28.h,
                          //     child: Container(
                          //       padding: const EdgeInsets.all(2),
                          //       decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(100.r),
                          //           color: AppColors.white),
                          //       child: Container(
                          //           width: 14.w,
                          //           height: 14.h,
                          //           decoration: BoxDecoration(
                          //               borderRadius: BorderRadius.circular(100.r),
                          //               color: Colors
                          //                   .transparent //AppColors.orangePrimary
                          //               )),
                          //     ))
                        ],
                      ),
                      sizedBoxW(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    c.groupsList[index].name.toString(),
                                    style: AppStyles.interSemiBoldStyle(
                                        fontSize: 16),
                                  ),
                                ),
                                Text(
                                  c.groupsList[index].updatedAt != null
                                      ? DateFormat("HH:mm a").format(
                                          c.groupsList[index].updatedAt!)
                                      : "",
                                  style: AppStyles.interRegularStyle(
                                      fontSize: 14, color: AppColors.ageColor),
                                ),
                              ],
                            ),
                            sizedBoxH(height: 4.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "", //c.groupsList[index].
                                    style: AppStyles.interRegularStyle(
                                        fontSize: 15,
                                        textOverflow: TextOverflow.ellipsis),
                                  ),
                                ),
                                const RotatedBox(
                                    quarterTurns: 4,
                                    child: Icon(
                                      Icons.push_pin_sharp,
                                      color: Colors
                                          .transparent, //AppColors.ageColor,
                                      size: 20,
                                    ))
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showUsers(ScrollController b) {
    return GetBuilder<MessageScreenVM>(
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
                    Text(AppStrings.newChat,
                        style: AppStyles.interSemiBoldStyle(
                            fontSize: 16.0, color: AppColors.textColor))
                  ],
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 22.w, vertical: 16.h),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchTextField(
                        controller: null, //c.searchCtrl,
                        //     onChanged: (t) {
                        //       if (t.trim().isEmpty) {
                        //         c.friends!.clear();
                        //         c.friends!.addAll(c.searchedFriends!);
                        //       } else {
                        //         c.search(t);
                        //       }
                        //       c.update();
                        //     },
                        radius: 30,
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      c.friends.isEmpty
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
                                  c.friends.length, //25, //c.list.length,
                              itemBuilder: (context, index) {
                                return userCard(c, index);
                              })
                    ],
                  ),
                ),
                sizedBoxH(
                  height: 10,
                ),
              ],
            ));
      },
    );
  }

  Widget userCard(MessageScreenVM c, index) {
    return GetBuilder<MessageScreenVM>(builder: (c) {
      return InkWell(
        onTap: () async {
          Get.back();
          Get.delete<ChatScreenVM>(force: true);
          final cvm = Get.put(ChatScreenVM());

          cvm.conversation = Conversation(
            conversationType: 'user',
            conversationWith: User(
              name: c.friends[index].name.toString(),
              avatar: c.friends[index].avatar.toString(),
              uid: c.friends[index].uid.toString(),
            ),
          );
          await getToNamed(chatScreenRoute);
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
                    child: c.friends[index].avatar!.trim().isNotEmpty
                        ? MyAvatar(
                            url: c.friends[index].avatar!.trim(),
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
                ],
              )),
              sizedBoxH(
                height: 7,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      //c.friends![index].user!.firstName.toString() +
                      c.friends[index].name!.trim(), //+
                      //  c.friends![index].user!.lastName.toString(),
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

  String getMessage(MessageScreenVM c, index) {
    if (c.conversationList[index].lastMessage is TextMessage) {
      return (c.conversationList[index].lastMessage as TextMessage).text;
    } else if (c.conversationList[index].lastMessage is MediaMessage) {
      return (c.conversationList[index].lastMessage as MediaMessage)
          .attachment!
          .fileName;
    } else {
      return "Custom message";
    }
  }
}

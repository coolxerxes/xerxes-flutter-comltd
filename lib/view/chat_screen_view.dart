import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Typography;
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jyo_app/data/remote/api_interface.dart';
import 'package:jyo_app/models/group_suggestion_model/group_details_model.dart';
import 'package:jyo_app/resources/app_colors.dart';
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/resources/app_strings.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/view/timeline_screen_view.dart';
import 'package:jyo_app/view_model/chat_screen_vm.dart';

import '../resources/app_image.dart';
import '../resources/app_styles.dart';
import '../utils/app_widgets/app_bar.dart';
import '../utils/app_widgets/app_icon_button.dart';

class ChatScreenView extends StatelessWidget {
  const ChatScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Creating a custom message template
    CometChatMessageTemplate customMessageTemplate = CometChatMessageTemplate(
      type: CometChatMessageType.custom,
      category: CometChatMessageCategory.custom,
      bubbleView: (message, context, alignment) {
        final group = GroupDetail.fromSendMessage(
            (message as CustomMessage).customData ?? {});

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.btnStrokeColor),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              isValidString(group.groupImage)
                  ? MyAvatar(
                      url: ApiInterface.profileImgUrl +
                          group.groupImage.toString(),
                      height: 62,
                      width: 62,
                      isNetwork: true,
                      radiusAll: 8,
                    )
                  : MyAvatar(
                      url: AppImage.groupImage,
                      height: 62,
                      width: 62,
                      radiusAll: 8,
                    ),
              sizedBoxW(width: 14),
              Column(
                children: [
                  Text(
                    group.groupName ?? '',
                    style: AppStyles.interRegularStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    group.createdAt != null
                        ? parseDateFromToDDMMYYYY(group.createdAt) ?? ''
                        : '',
                    style: AppStyles.interRegularStyle(
                      fontSize: 13,
                      color: AppColors.hintTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );

    //custom list of templates
    List<CometChatMessageTemplate> messageTypes = [
      ...CometChatUIKit.getDataSource().getAllMessageTemplates(),
      customMessageTemplate
    ];

    return GetBuilder<ChatScreenVM>(builder: (c) {
      return WillPopScope(
        onWillPop: () async {
          c.messageVM.refreshLists();
          return true;
        },
        child: SafeArea(
            child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColors.white,
          appBar: MyAppBar(
            color: 0xffffffff,
            leading: [
              MyIconButton(
                icon: AppBarIcons.arrowBack,
                size: 24,
                isSvg: true,
                onTap: () async {
                  c.messageVM.refreshLists();
                  Get.back();
                },
              )
            ],
            middle: [
              c.conversation != null
                  ? (c.conversation!.conversationWith as User)
                          .avatar!
                          .trim()
                          .isEmpty
                      ? MyAvatar(
                          url: AppImage.sampleAvatar,
                          height: 40,
                          width: 40,
                          radiusAll: 16,
                        )
                      : MyAvatar(
                          url: (c.conversation!.conversationWith as User)
                              .avatar!,
                          height: 40,
                          width: 40,
                          radiusAll: 16,
                          isNetwork: true,
                        )
                  : c.group != null
                      ? c.group!.icon!.trim().isEmpty
                          ? MyAvatar(
                              url: AppImage.sampleAvatar,
                              height: 40,
                              width: 40,
                              radiusAll: 16,
                            )
                          : MyAvatar(
                              url: c.group!.icon!.trim(),
                              height: 40,
                              width: 40,
                              radiusAll: 16,
                              isNetwork: true,
                            )
                      : MyAvatar(
                          url: AppImage.sampleAvatar,
                          height: 40,
                          width: 40,
                          radiusAll: 16,
                        ),
              sizedBoxW(width: 8),
              Text(
                c.conversation != null
                    ? (c.conversation!.conversationWith as User).name
                    : c.group != null
                        ? ("${c.group!.name.toString()}\n${c.group!.membersCount.toString()} members")
                        : "",
                style: AppStyles.interSemiBoldStyle(fontSize: 16),
              )
            ],
            actions: c.group != null
                ? []
                : [
                    MyIconButton(
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
                                      AppStrings.pinChat,
                                      style: AppStyles.interRegularStyle(
                                        color: AppColors.iosBlue,
                                      ),
                                    ),
                                    onPressed: () {}),
                                CupertinoActionSheetAction(
                                  child: Text(
                                    "${AppStrings.blockUser} user",
                                    style: AppStyles.interRegularStyle(
                                        color: Colors.red),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(
                                        context, AppStrings.reportUser);
                                    c.blockUserProfile();
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  child: Text(
                                    AppStrings.clearMessages,
                                    style: AppStyles.interRegularStyle(
                                        color: Colors.red),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(
                                        context, AppStrings.blockUser);
                                    c.messageList.clear();
                                    c.update();
                                    c.deleteConvo(c.receiver!.uid,
                                        CometChatConversationType.user);
                                    c.init();
                                    Get.offNamed(chatScreenRoute,
                                        preventDuplicates: false);
                                    //c.blockUserProfile();
                                  },
                                )
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
                      icon: AppBarIcons.menuSvg,
                      isSvg: true,
                      size: 24,
                    )
                  ],
          ),

          body: c.group != null
              ? CometChatMessages(
                  group: c.group,
                  hideMessageHeader: true,
                  theme: CometChatTheme(
                      palette: const Palette(
                        backGroundColor: PaletteModel(
                            light: Colors.white, dark: Colors.white),
                        primary: PaletteModel(
                            light: AppColors.orangePrimary,
                            dark: AppColors.orangePrimary),
                      ),
                      typography: Typography.fromDefault()),
                )
              : CometChatMessageList(
                  group: c.group,
                  user: c.conversation?.conversationWith as User?,
                  messageListStyle: const MessageListStyle(),
                  messagesRequestBuilder: (MessagesRequestBuilder()
                    ..uid = c.receiver!.uid
                    ..messageId = -1
                    ..withTags = true
                    ..limit = 30),
                  templates: messageTypes,
                  theme: CometChatTheme(
                      palette: const Palette(
                        backGroundColor: PaletteModel(
                            light: Colors.white, dark: Colors.white),
                        primary: PaletteModel(
                            light: AppColors.orangePrimary,
                            dark: AppColors.orangePrimary),
                      ),
                      typography: Typography.fromDefault()),
                  //messagesRequestBuilder: MessagesRequestBuilder()..uid = c.receiver!.uid,
                ),
          //     ListView.builder(
          //   itemCount: c.messageList.length,
          //   itemBuilder: (context, index) {
          //     return Row(
          //       mainAxisSize: MainAxisSize.max,
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         getMessage(c, c.messageList[index])
          //         //     :
          //         //Expanded(flex: 1, child: Container()),
          //         // c.messageList[index].recvID.toString() == c.friendId.toString()
          //         //     ? Expanded(
          //         //         flex: 5,
          //         //         child: Row(
          //         //           mainAxisSize: MainAxisSize.min,
          //         //           mainAxisAlignment: MainAxisAlignment.end,
          //         //           children: [
          //         //             Expanded(
          //         //               child: Wrap(
          //         //                 direction: Axis.horizontal,
          //         //                 alignment: WrapAlignment.end,
          //         //                 children: [
          //         //                   Container(
          //         //                     padding: EdgeInsets.symmetric(
          //         //                         vertical: 8.h, horizontal: 12.w),
          //         //                     margin: EdgeInsets.only(
          //         //                         bottom: 14.h, left: 12.w, right: 12.h),
          //         //                     decoration: BoxDecoration(
          //         //                         borderRadius:
          //         //                             BorderRadius.circular(12.r),
          //         //                         color: AppColors.texfieldColor,
          //         //                         gradient: const LinearGradient(
          //         //                             colors: [
          //         //                               Color(0xffFFD036),
          //         //                               Color(0xffFFA43C)
          //         //                             ],
          //         //                             transform:
          //         //                                 GradientRotation(240) //120
          //         //                             )),
          //         //                     child: Text(
          //         //                       "I m fine!I m fine!I m fine!I m fine!I m fine!I m fine!I m fine!I m fine!I m fine!I m fine!I m fine!I m fine!I m fine!I m fine!I m fine!I m fine!",
          //         //                       style: AppStyles.interMediumStyle(
          //         //                           fontSize: 15, color: AppColors.white),
          //         //                     ),
          //         //                   ),
          //         //                 ],
          //         //               ),
          //         //             ),
          //         //           ],
          //         //         ),
          //         //       )
          //         //     : Expanded(flex: 1, child: Container()),
          //       ],
          //     );
          //   },
          // ),

          bottomNavigationBar: c.group != null
              ? null
              : Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: c.user != null
                      ?
                      // Container(
                      //     color: AppColors.white,
                      //     //margin: EdgeInsets.only(left: 30),
                      //     padding: EdgeInsets.only(
                      //         bottom: 15.h, right: 22.w, left: 22.w, top: 5.h),
                      //     child: Row(
                      //       children: [
                      //         InkWell(
                      //           onTap: () {},
                      //           child: SvgPicture.asset(
                      //             AppIcons.cameraSvg,
                      //           ),
                      //         ),
                      //         sizedBoxW(width: 12),
                      //         Expanded(
                      //           child: SearchTextField(
                      //             controller: c.textEditingController,
                      //             radius: 100,
                      //             hint: AppStrings.saySomething,
                      //             icon: false,
                      //           ),
                      //         ),
                      //         sizedBoxW(width: 12),
                      //         InkWell(
                      //           onTap: () {
                      //             c.onSendButtonClick();
                      //           },
                      //           child: Text(AppStrings.send,
                      //               style: TextStyle(
                      //                   foreground: Paint()
                      //                     ..shader = const LinearGradient(
                      //                       colors: <Color>[
                      //                         Color(0xffFFD036),
                      //                         Color(0xffFFA43C)
                      //                       ],
                      //                     ).createShader(const Rect.fromLTWH(
                      //                         0.0, 0.0, 200.0, 70.0)),
                      //                   fontSize: 16.sp,
                      //                   fontFamily: interMedium)),
                      //         )
                      //       ],
                      //     ),
                      //   )

                      c.isBlocked!
                          ? SizedBox(
                              height: 80.h,
                              width: double.infinity,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Center(
                                      child: Text(
                                        "You blocked this user.\nCannot send messages to this user now.",
                                        style: AppStyles.interMediumStyle(),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : SizedBox(
                              height: 115.h,
                              child: CometChatMessageComposer(
                                group: c.group,
                                user: c.conversation != null
                                    ? c.conversation!.conversationWith as User
                                    : null,
                                hideLiveReaction: true,
                                placeholderText: AppStrings.saySomething,
                              ),
                            )
                      : Container()),
        )),
      );
    });
  }

  // Expanded senderBubble(ChatScreenVM c, TextMessage msg) {
  //   return Expanded(
  //     flex: 5,
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       children: [
  //         Expanded(
  //           child: Wrap(
  //             direction: Axis.horizontal,
  //             alignment: WrapAlignment.end,
  //             children: [
  //               Container(
  //                   padding:
  //                       EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
  //                   margin:
  //                       EdgeInsets.only(bottom: 14.h, left: 12.w, right: 12.h),
  //                   decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(12.r),
  //                       color: AppColors.texfieldColor,
  //                       gradient: const LinearGradient(
  //                           colors: [Color(0xffFFD036), Color(0xffFFA43C)],
  //                           transform: GradientRotation(240) //120
  //                           )),
  //                   child: Text(
  //                     (msg).text.toString(),
  //                     style: AppStyles.interMediumStyle(
  //                         fontSize: 15,
  //                         color: msg.sender!.uid.toString() !=
  //                                 c.user!.uid.toString()
  //                             ? AppColors.black
  //                             : AppColors.white),
  //                   )),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Expanded receiverBubble(ChatScreenVM c, TextMessage msg) {
  //   return Expanded(
  //     flex: 5,
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Expanded(
  //           child: Wrap(
  //             direction: Axis.horizontal,
  //             alignment: WrapAlignment.start,
  //             children: [
  //               Container(
  //                   padding:
  //                       EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
  //                   margin:
  //                       EdgeInsets.only(bottom: 14.h, left: 12.w, right: 12.h),
  //                   decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(12.r),
  //                       color: AppColors.texfieldColor),
  //                   child: Text(
  //                     (msg).text.toString(),
  //                     style: AppStyles.interMediumStyle(
  //                         fontSize: 15,
  //                         color: msg.sender!.uid.toString() !=
  //                                 c.user!.uid.toString()
  //                             ? AppColors.black
  //                             : AppColors.white),
  //                   )),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // getMessage(ChatScreenVM c, BaseMessage message) {
  //   if (message is TextMessage) {
  //     return message.sender!.uid.toString() != c.user!.uid.toString()
  //         ? receiverBubble(c, message)
  //         : senderBubble(c, message);
  //   } else if (message is MediaMessage) {
  //     return Container(
  //       width: 100,
  //       height: 120,
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(8.r),
  //       ),
  //       child: ClipRRect(
  //           borderRadius: BorderRadius.circular(8.r),
  //           child: Image.network(message.attachment!.fileUrl)),
  //     );
  //   } else {
  //     return Container();
  //   }
  // }
}

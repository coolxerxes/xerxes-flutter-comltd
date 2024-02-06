import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jyo_app/resources/app_colors.dart';
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/resources/app_strings.dart';
import 'package:jyo_app/resources/app_styles.dart';
import 'package:jyo_app/utils/app_widgets/app_gradient_btn.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/utils/secured_storage.dart';
import 'package:jyo_app/view/timeline_screen_view.dart';

import '../data/remote/api_interface.dart';
import '../models/group_suggestion_model/group_list_model.dart';
import '../resources/app_image.dart';
import '../utils/app_widgets/registration_top_nav.dart';
import '../view_model/group_suggestion_screen_vm.dart';

class GroupSuggestionScreenView extends StatelessWidget {
  const GroupSuggestionScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupSuggestionScreenVM>(
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
                  progress: 5,
                  text: AppStrings.next,
                  onBackPressed: () {
                    getToNamed(mostLikedScreenRoute);
                  },
                  onNextPressed: () async {
                    await SecuredStorage.writeStringValue(
                        Keys.groups, "Completed");
                    getToNamed(setProfilePicScreenRoute);
                  },
                ),
              ),
              body: c.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                          backgroundColor: AppColors.orangePrimary),
                    )
                  : c.list.isEmpty
                      ? Center(
                          child: Text(AppStrings.noData,
                              style: AppStyles.interMediumStyle(
                                fontSize: 18,
                              )),
                        )
                      : ListView(
                          shrinkWrap: true,
                          children: [
                            sizedBoxH(
                              height: 82,
                            ),
                            Center(
                              child: Text(
                                AppStrings.forNewJourney,
                                style: AppStyles.interMediumStyle(
                                  fontSize: 28,
                                ),
                              ),
                            ),
                            sizedBoxH(height: 48),
                            c.list.isEmpty
                                ? Container()
                                : Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 22.w),
                                    child: GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 12.h,
                                          mainAxisSpacing: 16.w,
                                          mainAxisExtent: 228.h,
                                        ),
                                        itemCount: c.list.length,
                                        itemBuilder: (context, index) {
                                          return GroupCard(
                                            onJoin: () {
                                              c.joinGroup(index);
                                            },
                                            groupData: GroupData(
                                              group: Group(
                                                  groupImage:
                                                      "${c.list[index].image}",
                                                  groupName:
                                                      "${c.list[index].heading}"),
                                              groupId: 0,
                                              memberCount: int.tryParse(
                                                  c.list[index].member!),
                                              role: "member",
                                              status:
                                                  c.list[index].isJoinedGroup!
                                                      ? "Pending"
                                                      : "Join",
                                            ),
                                          );
                                        })),
                          ],
                        )),
        );
      },
    );
  }
}

class GroupCard extends StatelessWidget {
  GroupCard({
    required this.groupData,
    this.onTap,
    this.onJoin,
    Key? key,
  }) : super(key: key);

  GroupData? groupData;
  VoidCallback? onTap;
  VoidCallback? onJoin;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        color: AppColors.texfieldColor,
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(24.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(24.r),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(16.sm),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              // color: AppColors.texfieldColor,
            ),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isValidString(groupData!.group!.groupImage!)
                      ? MyAvatar(
                          url: ApiInterface.profileImgUrl +
                              groupData!.group!.groupImage.toString(),
                          width: 64,
                          height: 64,
                          radiusAll: 25.6,
                          isNetwork: true,
                        )
                      : MyAvatar(
                          url: AppImage.groupImage,
                          width: 64,
                          height: 64,
                          radiusAll: 25.6,
                        ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Text(
                        groupData!.group!.groupName.toString(),
                        style: AppStyles.interMediumStyle(),
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ))
                    ],
                  ),
                  sizedBoxH(
                    height: 6,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Text(
                        "${groupData!.memberCount} members",
                        style: AppStyles.interRegularStyle(
                            fontSize: 14.0, color: AppColors.hintTextColor),
                        textAlign: TextAlign.start,
                      ))
                    ],
                  ),
                  sizedBoxH(
                    height: 12,
                  ),
                  groupData!.status == "Approved"
                      ? Container()
                      : groupData!.status == "Pending"
                          ? AppGradientButton(
                              isDisabled: true,
                              height: 34,
                              width: 88,
                              btnText: "Pending",
                              onPressed: null)
                          : AppGradientButton(
                              isDisabled: groupData!.isJoinedGroup ?? false,
                              height: 34,
                              width: 88,
                              btnText: groupData!.isJoinedGroup ?? false
                                  ? "Pending"
                                  : "Join",
                              onPressed: groupData!.isJoinedGroup ?? false
                                  ? null
                                  : onJoin)
                ]),
          ),
        ),
      ),
    );
  }
}

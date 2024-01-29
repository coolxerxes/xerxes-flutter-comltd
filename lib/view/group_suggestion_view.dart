// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jyo_app/resources/app_colors.dart';
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/resources/app_strings.dart';
import 'package:jyo_app/resources/app_styles.dart';
import 'package:jyo_app/utils/app_widgets/app_gradient_btn.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/utils/secured_storage.dart';

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
              appBar: PreferredSize(preferredSize: Size(double.infinity,65.w,),
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
              body: ListView(
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
                          margin:  EdgeInsets.symmetric(horizontal: 22.w),
                          child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                   SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12.h,
                                mainAxisSpacing: 16.w,
                                mainAxisExtent: 228.h,
                              ),
                              itemCount: c.list.length,
                              itemBuilder: (context, index) {
                                return SuggestionCard(index);
                              })),
                ],
              )),
        );
      },
    );
  }
}

class SuggestionCard extends StatelessWidget {
  SuggestionCard(
    this.index, {
    Key? key,
  }) : super(key: key);

  int? index;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupSuggestionScreenVM>(builder: (c) {
      return Container(
        padding:  EdgeInsets.all(16.sm),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          color: AppColors.texfieldColor,
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 64.h,
                width: 64.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.6.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.6.r),
                  child: Image.asset(//AppImage.groupImage
                      c.list[index!].image.toString()),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text(
                    c.list[index!].heading!,
                    style: AppStyles.interMediumStyle(),
                    textAlign: TextAlign.start,
                    maxLines: 2,
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
                    c.list[index!].member! + " members",
                    style: AppStyles.interRegularStyle(
                        fontSize: 14.0, color: AppColors.hintTextColor),
                    textAlign: TextAlign.start,
                  ))
                ],
              ),
              sizedBoxH(
                height: 12,
              ),
              AppGradientButton(
                  height: 34, width: 88, btnText: "Join", onPressed: () {})
            ]),
      );
    });
  }
}

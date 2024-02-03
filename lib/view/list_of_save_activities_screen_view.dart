import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jyo_app/view/profile_screen_view.dart';
import 'package:jyo_app/view_model/list_of_save_activites_screen_vm.dart';

import '../resources/app_colors.dart';
import '../resources/app_image.dart';
import '../resources/app_strings.dart';
import '../resources/app_styles.dart';
import '../utils/app_widgets/app_bar.dart';
import '../utils/app_widgets/app_icon_button.dart';
import '../view_model/explore_screen_vm.dart';

class ListOfSaveActivitesScreenView extends StatelessWidget {
  const ListOfSaveActivitesScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ListOfSaveActivitiesScreenVM>(builder: (c) {
      return WillPopScope(
        onWillPop: () async {
          Get.delete<ExploreScreenVM>();
                  Get.back();
                  c.bsvm.changePage(0);
          return true;
        },
        child: SafeArea(
            child: Scaffold(
          appBar: MyAppBar(
            color: 0xffffffff,
            leading: [
              MyIconButton(
                onTap: () {
                  Get.delete<ExploreScreenVM>();
                  Get.back();
                  c.bsvm.changePage(0);
                },
                icon: AppBarIcons.arrowBack,
                isSvg: true,
                size: 24,
              )
            ],
            middle: [
              Text(
                AppStrings.savedActivities,
                style: AppStyles.interMediumStyle(
                    fontSize: 18, color: AppColors.textColor),
              )
            ],
            actions: [
              MyIconButton(
                onTap: () {
                  //getToNamed(createGroupScreenRoute);
                },
                icon: AppBarIcons.plusSvg,
                isSvg: true,
                size: 24,
              )
            ],
          ),
          body: c.isLoadingActs
              ? SizedBox(
                  height: 150.h,
                  child: const Center(
                      child: CircularProgressIndicator(
                    color: AppColors.orangePrimary,
                  )),
                )
              : c.postsVM.activitiesList.isEmpty
                  ? SizedBox(
                      height: 150.h,
                      child: Center(
                          child: Text(
                        "No activities available",
                        style: AppStyles.interRegularStyle(),
                      )),
                    )
                  : ListView.builder(
                      itemCount: c.postsVM.activitiesList.length,
                      itemBuilder: (context, index) {
                        return ActivityWidget.activity(
                            c.postsVM.activitiesList[index], c.postsVM, c);
                      },
                    ),
        )),
      );
    });
  }
}

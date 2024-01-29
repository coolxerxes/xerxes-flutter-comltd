import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jyo_app/resources/app_image.dart';
import 'package:jyo_app/resources/app_strings.dart';
import 'package:jyo_app/resources/app_styles.dart';
import 'package:jyo_app/utils/app_widgets/app_bar.dart';
import 'package:jyo_app/utils/app_widgets/app_icon_button.dart';
import 'package:jyo_app/view/timeline_screen_view.dart';

import '../resources/app_colors.dart';
import '../resources/app_routes.dart';
import '../utils/common.dart';
import '../view_model/single_post_screen_vm.dart';

class SinglePostScreenView extends StatelessWidget {
  const SinglePostScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SinglePostScreenVM>(builder: (c) {
      return WillPopScope(
        onWillPop: () async {
           if (c.isAppStartingFromNotification!) {
            getOffAllNamed(splashScreenRoute);
          } else {
            Get.back();
          }
          return true;
        },
        child: SafeArea(
            child: Scaffold(
                appBar: MyAppBar(
                  color: 0xffffffff,
                  leading: [
                    MyIconButton(
                      icon: AppBarIcons.arrowBack,
                      size: 24,
                      isSvg: true,
                      onTap: () {
                        Get.back();
                      },
                    )
                  ],
                  middle: [
                    Text(
                      AppStrings.post,
                      style: AppStyles.interSemiBoldStyle(fontSize: 16),
                    )
                  ],
                ),
                body: RefreshIndicator(
                    color: AppColors.orangePrimary,
                    onRefresh: () async {
                      c.init();
                      return;
                    },
                    child: c.isLoadingPost!
                        ? SizedBox(
                            height: 150.h,
                            child: const Center(
                                child: CircularProgressIndicator(
                              color: AppColors.orangePrimary,
                            )),
                          )
                        : c.postsVM.postsList.isEmpty
                            ? SizedBox(
                                height: 150.h,
                                child: Center(
                                    child: Text(
                                  "No posts available",
                                  style: AppStyles.interRegularStyle(),
                                )),
                              )
                            : Column(
                                children: List.generate(
                                    c.postsVM.postsList.length, (index) {
                                  return PostWidget.post(
                                    c.postsVM,
                                    c,
                                    index,
                                    isProfilePost: true,
                                  );
                                }),
                              )
                    //: Column()
                    ))),
      );
    });
  }
}

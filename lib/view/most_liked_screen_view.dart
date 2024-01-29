// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jyo_app/resources/app_colors.dart';
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/resources/app_strings.dart';
import 'package:jyo_app/resources/app_styles.dart';
import 'package:jyo_app/utils/common.dart';

import '../utils/app_widgets/registration_top_nav.dart';
import '../view_model/most_liked_screen_vm.dart';

class MostLikedScreenView extends StatelessWidget {
  const MostLikedScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MostLikedScreenVM>(
      builder: (c) {
        return SafeArea(
          
          child: Scaffold(
              backgroundColor: AppColors.appBkgColor,
              appBar: PreferredSize(preferredSize: Size(double.infinity,65.w),
              child: RegistrationTopBar(
                    progress: 4,
                    text: AppStrings.next,
                    enabled: c.isEnabled,
                    onBackPressed: () {
                      getToNamed(birthdayScreenRoute);
                    },
                    onNextPressed: () {
                      c.onNextPressed();
                    },
                  ),
                  ),
              body: ListView(
                children: [
                  sizedBoxH(
                    height: 82,
                  ),
                  Center(
                    child: Text(
                      AppStrings.mostLikedHeading,
                      style: AppStyles.interMediumStyle(
                        fontSize: 28,
                      ),
                    ),
                  ),
                  sizedBoxH(height: 48),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 22.w),
                      child: c.list.isEmpty
                          ? Container()
                          : Center(
                              child: Wrap(
                                  direction: Axis.horizontal,
                                  runSpacing: 12.h,
                                  spacing: 12.w,
                                  children: List.generate(c.list.length, (index) {
                                    return MostLikedCard(index);
                                  }))))
                ],
              )),
        );
      },
    );
  }
}

class MostLikedCard extends StatelessWidget {
  MostLikedCard(
    this.index, {
    Key? key,
  }) : super(key: key);

  int? index;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MostLikedScreenVM>(
      builder: (c) {
        return Container(
        //  height: 40.h,
        padding: EdgeInsets.symmetric(vertical: 8.5.h, ),
          width: MediaQuery.of(context).size.width / 2.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            gradient: c.list[index!].getIsSelected!
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
                  onTap: () {
                    c.list[index!].setIsSelected =
                        !c.list[index!].getIsSelected!;
                    c.isIntrestListEmpty();
                    c.update();
                  },
                  child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            c.list[index!].icon!.toString(),
                            // AppIcons
                            //     .burgerIcon,
                            width: 18.w,
                            height: 18.h,
                          ),
                          sizedBoxW(
                            width: 8,
                          ),
                          Flexible(
                            child: Text(
                              c.list[index!].name!,
                              style: c.list[index!].getIsSelected!
                                  ? AppStyles.interMediumStyle(
                                  fontSize: 15, color: AppColors.appBkgColor)
                                  : AppStyles.interMediumStyle(fontSize: 15),
                              // overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      )
                      // child: Wrap(
                      //   alignment: WrapAlignment.center,
                      //   crossAxisAlignment: WrapCrossAlignment.center,
                      //    // mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //   // SvgPicture.network(
                      //   //   c.list[index!].icon!.toString(),
                      //   //   width: 18,
                      //   //   height: 18,
                      //   // ),
                      //   Image.network(
                      //     c.list[index!].icon!.toString(),
                      //     // AppIcons
                      //     //     .burgerIcon,
                      //     width: 18.w,
                      //     height: 18.h,
                      //   ),
                      //   sizedBoxW(
                      //     width: 8,
                      //   ),
                      //   Text(
                      //     c.list[index!].name!,
                      //     style: c.list[index!].getIsSelected!
                      //         ? AppStyles.interMediumStyle(
                      //         fontSize: 16, color: AppColors.appBkgColor)
                      //         : AppStyles.interMediumStyle(fontSize: 16),
                      //     // overflow: TextOverflow.ellipsis,
                      //   )
                      //   // Expanded(
                      //   //   child: Row(
                      //   //     children: [
                      //   //       Expanded(
                      //   //         child:
                      //   // SizedBox(
                      //   //   width: c.list[index!].name!.length >= 14.0 ?  MediaQuery.of(context).size.width / 3.0 :null,
                      //   //   child: Text(
                      //   //     c.list[index!].name!,
                      //   //     style: c.list[index!].getIsSelected!
                      //   //         ? AppStyles.interMediumStyle(
                      //   //             fontSize: 16, color: AppColors.appBkgColor)
                      //   //         : AppStyles.interMediumStyle(fontSize: 16),
                      //   //    // overflow: TextOverflow.ellipsis,
                      //   //   )
                      //   // )
                      //   // )
                      //   //],
                      //   //)
                      //   // )
                      // ])
          ))),
        );
      },
    );
  }
}

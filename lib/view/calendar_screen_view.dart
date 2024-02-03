import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jyo_app/resources/app_colors.dart';
import 'package:jyo_app/resources/app_image.dart';
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/resources/app_strings.dart';
import 'package:jyo_app/resources/app_styles.dart';
import 'package:jyo_app/utils/app_widgets/app_bar.dart';
import 'package:jyo_app/utils/app_widgets/app_icon_button.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/view/timeline_screen_view.dart';

import '../view_model/calendar_srceen_vm.dart';
import '../view_model/create_activity_screen_vm.dart';

class CalendarScreenView extends StatelessWidget {
  const CalendarScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CalendarScreenVM>(
      builder: (c) {
        return Scaffold(
            backgroundColor: AppColors.texfieldColor,
            appBar: MyAppBar(
              color: 0xffffffff,
              padding: EdgeInsets.only(
                  left: 22.w, right: 22.w, top: 36.h, bottom: 16.h),
              leading: [
                Text(
                  AppStrings.myCalendar,
                  style: AppStyles.interMediumStyle(fontSize: 20),
                ),
              ],
              actions: [
                MyIconButton(
                  onTap: () {
                    Get.delete<CreateActivityScreenVM>();
                    getToNamed(createActivityScreenRoute);
                  },
                  icon: AppBarIcons.plusSvg,
                  isSvg: true,
                  size: 24,
                )
              ],
            ),
            body: Center(
              child: Text(
                "No data available",
                style: AppStyles.interRegularStyle(fontSize: 18),
              ),
            )
            // ListView.builder(
            //   itemCount: c.events.length,
            //   itemBuilder: (context, index) {
            //     if (index != 0) {
            //       c.selectedDate = c.events[index - 1].date.toString();
            //     }
            //     return CalendarEventCard(
            //         calendarData: c.events[index], index: index);
            //   },
            // )
            );
      },
    );
  }
}

class CalendarEventCard extends StatelessWidget {
  const CalendarEventCard({
    required this.calendarData,
    required this.index,
    Key? key,
  }) : super(key: key);

  final CalendarData? calendarData;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CalendarScreenVM>(
      builder: (c) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: c.selectedDate == calendarData!.date ? 4.h : 8.h,
                  horizontal: 22.w),
              color: AppColors.texfieldColor,
              child: c.selectedDate == calendarData!.date
                  ? Container()
                  : Text(
                      calendarData!.date!,
                      style: AppStyles.interMediumStyle(
                          color: AppColors.editBorderColor),
                    ),
            ),
            Container(
              color: AppColors.white,
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 14.h),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyAvatar(
                    url: calendarData!.image,
                    width: 64,
                    height: 64,
                    radiusAll: 25.5,
                  ),
                  sizedBoxW(width: 14),
                  Expanded(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        calendarData!.heading!,
                        style: AppStyles.interSemiBoldStyle(),
                      ),
                      sizedBoxH(height: 4),
                      Text(
                        calendarData!.activityOrGroupName!,
                        style: AppStyles.interMediumStyle(
                            fontSize: 14, color: AppColors.editBorderColor),
                      ),
                      sizedBoxH(height: 4),
                      Text(
                        "${calendarData!.time!} at ${calendarData!.location}",
                        style: AppStyles.interMediumStyle(
                            fontSize: 13.2, color: AppColors.hintTextColor),
                      ),
                    ],
                  ))
                ],
              ),
            )
          ],
        );
      },
    );
  }
}

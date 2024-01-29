import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jyo_app/resources/app_colors.dart';
import 'package:jyo_app/resources/app_image.dart';
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/resources/app_strings.dart';
import 'package:jyo_app/resources/app_styles.dart';
import 'package:jyo_app/utils/app_widgets/app_bar.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/view/create_post_screen_view.dart';
import 'package:jyo_app/view/timeline_screen_view.dart';
import 'package:jyo_app/view_model/create_activity_screen_vm.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:table_calendar/table_calendar.dart';

import '../utils/app_widgets/app_divider.dart';
import '../utils/app_widgets/app_gradient_btn.dart';
import '../utils/app_widgets/app_icon_button.dart';
import '../utils/app_widgets/app_textfield.dart';
import '../utils/app_widgets/setting_list_tile.dart';

class CreateActivityScreenView extends StatelessWidget {
  const CreateActivityScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateActivityScreenVM>(builder: (c) {
      return SafeArea(
        child: Scaffold(
          appBar: MyAppBar(
            leading: [
              Text(
                AppStrings.cancel,
                style: AppStyles.interMediumStyle(
                    fontSize: 18, color: AppColors.hintTextColor),
              )
            ],
          ),
          body: ListView(
            children: [
              sizedBoxH(height: 16),
              //Section1
              Container(
                margin: EdgeInsets.symmetric(horizontal: 22.w),
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        MyAvatar(
                          url: AppImage.avatar3,
                          height: 72,
                          width: 72,
                          radiusAll: 28.8,
                        ),
                        Positioned(
                            top: 60.h,
                            left: 28.h,
                            child: Container(
                              height: 20.h,
                              width: 20.h,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(100.r),
                              ),
                              child: Center(
                                child: Image.asset(AppIcons.crownPng),
                              ),
                            ))
                      ],
                    ),
                    sizedBoxH(height: 10),
                    Text(
                      "Banjamin Tan",
                      style: AppStyles.interSemiBoldStyle(fontSize: 16),
                    ),
                    sizedBoxH(height: 8),
                    Center(
                      child: Text(
                        AppStrings.createActivityHelperText,
                        style: AppStyles.interRegularStyle(
                            fontSize: 15, color: AppColors.editBorderColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              sizedBoxH(height: 34),

              //Section 2
              Container(
                margin: EdgeInsets.symmetric(horizontal: 22.w),
                child: Column(
                  children: [
                    AppTextField(
                      controller: c.activityNameCtrl,
                      margin: const EdgeInsets.all(0),
                      style: AppStyles.interRegularStyle(),
                      hintText: AppStrings.activityName,
                    ),
                    sizedBoxH(height: 20),
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
                            controller: c.aboutCtrl,
                            maxLines: null,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: AppStrings.aboutAct,
                                hintStyle: AppStyles.interRegularStyle(
                                    fontSize: 20,
                                    color: AppColors.hintTextColor),
                                contentPadding: EdgeInsets.only(
                                    left: 14.w,
                                    bottom:
                                        MediaQuery.of(context).size.width <= 400
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
                          Text(
                            "Non Profit, Sports, Pets",
                            style: AppStyles.interRegularStyle(
                              fontSize: 16,
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
                      onTap: () {
                        c.showCal = !c.showCal!;
                        c.update();
                      },
                      text: AppStrings.selectDate,
                      icon: Text(
                        "Fri, 24 May",
                        style: AppStyles.interRegularStyle(fontSize: 16),
                      ),
                      radiusBottomRight: 0.0,
                      radiusBottomLeft: 0.0,
                    ),
                    !c.showCal! ? Container(): Container(
                      color: AppColors.texfieldColor,
                      child: TableCalendar(
                        firstDay: DateTime.now(),
                        focusedDay: c.selectedDateTime!,
                        lastDay: DateTime(2100),
                        headerVisible: true,
                        calendarBuilders: const CalendarBuilders(),
                        calendarStyle: CalendarStyle(
                          outsideDaysVisible: false,
                          defaultTextStyle:
                              AppStyles.interMediumStyle(fontSize: 20)!,
                          weekendTextStyle:
                              AppStyles.interMediumStyle(fontSize: 20)!,
                          selectedTextStyle: AppStyles.interMediumStyle(
                              fontSize: 20, color: AppColors.iosBlue)!,
                          selectedDecoration: BoxDecoration(
                              color: AppColors.iosBlue.withOpacity(0.15),
                              shape: BoxShape.circle),
                          //isTodayHighlighted: false,
                          todayTextStyle: AppStyles.interMediumStyle(
                              fontSize: 20, color: AppColors.iosBlue)!,
                          todayDecoration: const BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle),
                          disabledTextStyle: AppStyles.interMediumStyle(
                              fontSize: 20, color: AppColors.calDisColor)!,
                        ),
                        headerStyle:
                            const HeaderStyle(formatButtonVisible: false),
                        daysOfWeekStyle: DaysOfWeekStyle(
                            weekdayStyle: AppStyles.interRegularStyle(
                                fontSize: 18, color: AppColors.calDisColor)!,
                            weekendStyle: AppStyles.interRegularStyle(
                                fontSize: 18, color: AppColors.calDisColor)!),
                        currentDay: DateTime.now(),
                        calendarFormat: CalendarFormat.month,
                        selectedDayPredicate: (day) {
                          return isSameDay(c.selectedDateTime, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) async {
                          debugPrint("selectedDay $selectedDay");
                          c.selectedDateTime = selectedDay;
                          c.selectedDate = DateFormat("yyyy-MM-dd")
                              .format(c.selectedDateTime!);
                          c.update();
                        },
                      ),
                    ),

                    MyDivider(),
                    SettingListTile(
                      onTap: (() {
                        c.showTime = !c.showTime!;
                        c.update();
                      }),
                      text: AppStrings.time,
                      icon: Text(
                        "6.00 PM",
                        style: AppStyles.interRegularStyle(fontSize: 16),
                      ),
                      radiusBottomLeft: c.showTime! ? 0.0 : 10,
                      radiusBottomRight: c.showTime! ? 0.0 : 10,
                      radiusTopLeft: 0.0,
                      radiusTopRight: 0.0,
                    ),
                    !c.showTime! ? Container():Container(
                      padding: EdgeInsets.only(bottom: 18.h),
                      color: AppColors.texfieldColor,
                      child: Column(
                        children: [
                          TimePickerSpinner(
                            is24HourMode: false,
                            normalTextStyle: AppStyles.interMediumStyle(
                                fontSize: 23, color: AppColors.hintTextColor),
                            highlightedTextStyle:
                                AppStyles.interSemiBoldStyle(fontSize: 24),
                            spacing: 20,
                            itemHeight: 60,
                            isForce2Digits: false,
                            onTimeChange: (time) {
                              c.update(); // setState(() {
                              //   _dateTime = time;
                              // });
                            },
                          ),
                          InkWell(
                              onTap: () {
                                c.showTime = false;
                                c.update();
                              },
                              borderRadius: BorderRadius.circular(10.r),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.h, horizontal: 15.w),
                                child: Text(
                                  AppStrings.done,
                                  style: AppStyles.interMediumStyle(),
                                ),
                              ))
                        ],
                      ),
                    ),
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
                            return locationSheet(b);
                          },
                          anchors: [0, 0.75, 0.85],
                          isSafeArea: true,
                        );
                      },
                      text: AppStrings.location,
                      icon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Starbuck Coffe Bishan",
                            style: AppStyles.interRegularStyle(
                              fontSize: 16,
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
                    sizedBoxH(height: 67),
                    // AppGradientButton(
                    //   btnText: AppStrings.continuee,
                    //   onPressed: () {
                    //     getToNamed(createActivityScreen2Route);
                    //   },
                    //   height: 47,
                    //   width: double.infinity,
                    // ),
                  ],
                ),
              )
            ],
          ),
          floatingActionButton: AppGradientButton(
              margin: EdgeInsets.only(
                left: 30.w,
              ),
              width: double.infinity,
              height: 47,
              btnText: AppStrings.continuee,
              onPressed: () {
                getToNamed(createActivityScreen2Route);
              }),
        ),
      );
    });
  }

  Widget locationSheet(b) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r), topRight: Radius.circular(32.r)),
      child: GetBuilder<CreateActivityScreenVM>(builder: (c) {
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
                      Text(
                        AppStrings.selectLocation,
                        style: AppStyles.interSemiBoldStyle(fontSize: 16),
                      ),
                    ],
                    actions: [
                      Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 15.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.r),
                              gradient: const LinearGradient(colors: [
                                Color(0xffFFD036),
                                Color(0xffFFA43C)
                              ], transform: GradientRotation(240) //120
                                  )),
                          child: Material(
                            type: MaterialType.transparency,
                            borderRadius: BorderRadius.circular(100.r),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(100.r),
                              onTap: () {
                                getToNamed(chooseLocationOnMapScreenRoute);
                              },
                              child: Center(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(AppIcons.mapSvg),
                                  sizedBoxW(
                                    width: 10,
                                  ),
                                  Text(
                                    AppStrings.selectByMap,
                                    style: AppStyles.interMediumStyle(
                                        fontSize: 14.4, color: Colors.white),
                                  ),
                                ],
                              )),
                            ),
                          ))
                      // AppGradientButton(
                      //   btnText: AppStrings.selectByMap,
                      //   onPressed: () {},
                      //   height: 36,
                      //   icon: SvgPicture.asset(AppIcons.mapSvg),
                      //   width: 200,
                      // ),
                    ],
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 16.h, horizontal: 22.w),
                    child: SearchTextField(
                        controller: TextEditingController(),
                        icon: true,
                        radius: 30),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 8.h,
                          color: AppColors.texfieldColor,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                        controller: b,
                        child: Column(
                          children: List.generate(15, (index) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 22.w, vertical: 16.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyAvatar(
                                    width: 40,
                                    height: 40,
                                    radiusAll: 80,
                                    url: AppImage.place,
                                    isSVG: true,
                                  ),
                                  sizedBoxW(width: 12),
                                  Expanded(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                        color: AppColors.btnStrokeColor,
                                      ))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                "Starbucks coffe Bishan",
                                                style: AppStyles
                                                    .interSemiBoldStyle(
                                                        fontSize: 16,
                                                        textOverflow:
                                                            TextOverflow
                                                                .ellipsis),
                                              )),
                                            ],
                                          ),
                                          sizedBoxW(width: 6),
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                "51 Bishan Street 13, #01-02 Bishan Community Club, Singapore 579799",
                                                style:
                                                    AppStyles.interRegularStyle(
                                                        fontSize: 14,
                                                        textOverflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                        color: AppColors
                                                            .editBorderColor),
                                              )),
                                            ],
                                          ),
                                          sizedBoxH(height: 20)
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                        )),
                  ),
                ],
              )),
        );
      }),
    );
  }

  Widget categorySheet(b) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r), topRight: Radius.circular(32.r)),
      child: GetBuilder<CreateActivityScreenVM>(builder: (c) {
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
                        controller: TextEditingController(),
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
            child:
                AppGradientButton(btnText: AppStrings.save, onPressed: () {}),
          ),
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jyo_app/resources/app_image.dart';
import 'package:jyo_app/view_model/splash_vm.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashVM>(
      builder: (c) {
        return Scaffold(
          body: Container(
            // ignore: prefer_const_constructors
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xffFFD036),Color(0xffFFA43C)],
                transform: GradientRotation(240)//120

              )
            ),
            alignment: const Alignment(0.0,0.0),
            child: Image.asset(AppImage.jioSplashLogo, width: 96.w, height: 211.h,)
          )
        );
      },
    );
  }
}

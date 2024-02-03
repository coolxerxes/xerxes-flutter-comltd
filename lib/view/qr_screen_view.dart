import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jyo_app/resources/app_colors.dart';
import 'package:jyo_app/resources/app_image.dart';
import 'package:jyo_app/utils/app_widgets/app_bar.dart';
import 'package:jyo_app/view_model/qr_screen_vm.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrScreenView extends StatelessWidget {
  const QrScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: SvgPicture.asset(
                  AppBarIcons.closeIcon,
                  color: Colors.white,
                ))),
        body: GetBuilder<QrScreenVM>(
          builder: (controller) => Stack(
            alignment: Alignment.center,
            children: [
              Container(
                // ignore: prefer_const_constructors
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xffFFD036), Color(0xffFFA43C)],
                        transform: GradientRotation(240) //120

                        )),
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32)),
                ),
                alignment: Alignment.center,
              ),
              controller.isGenerateQrCode
                  ? CircularProgressIndicator(
                      color: AppColors.orangePrimary,
                    )
                  : QrImageView(
                      data: controller.qrData,
                      size: 200,
                      embeddedImage: AssetImage(AppImage.jioLogoQr),
                      gapless: true,
                      embeddedImageStyle:
                          QrEmbeddedImageStyle(size: Size(20, 20)),
                    ),
            ],
          ),
        ));
  }
}

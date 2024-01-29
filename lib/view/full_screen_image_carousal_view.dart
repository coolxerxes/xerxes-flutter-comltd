import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jyo_app/data/remote/api_interface.dart';
import 'package:jyo_app/models/posts_model/timeline_model.dart';
import 'package:jyo_app/resources/app_colors.dart';
import 'package:jyo_app/view_model/create_post_screen_vm.dart';
import 'package:jyo_app/view_model/full_screen_image_carousal_vm.dart';
import 'package:video_player/video_player.dart';

class FullScreenImageCarousalView extends StatelessWidget {
  const FullScreenImageCarousalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FullScreenImageCarousalVM>(builder: (c) {
      return WillPopScope(
        onWillPop: () async {
          // ignore: avoid_function_literals_in_foreach_calls
          c.attachments!.forEach((element) async {
            await element.getController!.pause();
          });
          return true;
        },
        child: SafeArea(
            child: Scaffold(
                backgroundColor: AppColors.black,
                body: Carousel(
                  attachements: c.attachments,
                ))),
      );
    });
  }
}

class Carousel extends StatefulWidget {
  const Carousel({
    required this.attachements,
    Key? key,
  }) : super(key: key);

  final List<Attachment>? attachements;

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  late PageController _pageController;

  // List<String> images = [
  //   "https://images.wallpapersden.com/image/download/purple-sunrise-4k-vaporwave_bGplZmiUmZqaraWkpJRmbmdlrWZlbWU.jpg",
  //   "https://wallpaperaccess.com/full/2637581.jpg",
  //   "https://uhdwallpapers.org/uploads/converted/20/01/14/the-mandalorian-5k-1920x1080_477555-mm-90.jpg"
  // ];

  int activePage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.close,
                    color: AppColors.white,
                  ))
            ],
          ),
        ),
        SizedBox(
          height: 138.h,
        ),
        Expanded(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            //height: MediaQuery.of(context).size.height-100,
            child: PageView.builder(
                itemCount: widget.attachements!.length,
                pageSnapping: true,
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    activePage = page;
                  });
                },
                itemBuilder: (context, pagePosition) {
                  bool active = pagePosition == activePage;
                  return slider(widget.attachements, pagePosition, active);
                }),
          ),
        ),
        SizedBox(
          height: 138.h,
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: indicators(widget.attachements!.length, activePage)),
        SizedBox(
          height: 8.h,
        ),
      ],
    );
  }

  AnimatedContainer slider(images, pagePosition, active) {
    // double margin = active ? 10 : 20;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      // margin: EdgeInsets.all(margin),
      decoration: images[pagePosition].type == CaptureType.video
          ? null
          : BoxDecoration(
              image: DecorationImage(
              image: NetworkImage(
                  ApiInterface.postImgUrl + images[pagePosition].name),
              fit: BoxFit.cover,
            )),
      child: images[pagePosition].type == CaptureType.video
          ? Stack(
              children: [
                images[pagePosition].getController!.value.isInitialized
                    ? SizedBox(
                        //height: height == null ? 240.h : height?.h,
                        width: double.infinity,

                        child: AspectRatio(
                          aspectRatio: images[pagePosition]
                              .getController!
                              .value
                              .aspectRatio,
                          child:
                              VideoPlayer(images[pagePosition].getController!),
                        ),
                      )
                    : Container(),
                Positioned(
                    child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 12.h, horizontal: 12.w),
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100.r),
                                  color: const Color(0x8A000000)),
                              height: 35.h,
                              width: 35.h,
                              // padding:
                              //     EdgeInsets.symmetric(
                              //         horizontal: 8.w,
                              //         vertical: 8.h),
                              child: Center(
                                  child: InkWell(
                                onTap: images[pagePosition]
                                        .getController!
                                        .value
                                        .isPlaying
                                    ? () {
                                        images[pagePosition]
                                            .getController!
                                            .pause();
                                        setState(() {});
                                        //c.update();
                                      }
                                    : () {
                                        images[pagePosition]
                                            .getController!
                                            .play();
                                        setState(() {});
                                        //c.update();
                                      },
                                child: Icon(
                                  images[pagePosition]
                                          .getController!
                                          .value
                                          .isPlaying
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                ),
                              ))),
                        )))
              ],
            )
          : null,
    );
  }
}

imageAnimation(PageController animation, images, pagePosition) {
  return AnimatedBuilder(
    animation: animation,
    builder: (context, widget) {
      debugPrint(pagePosition);

      return SizedBox(
        width: 200,
        height: 200,
        child: widget,
      );
    },
    child: Container(
      margin: const EdgeInsets.all(10),
      child: Image.network(ApiInterface.postImgUrl + images[pagePosition]),
    ),
  );
}

List<Widget> indicators(imagesLength, currentIndex) {
  return List<Widget>.generate(imagesLength, (index) {
    return Container(
      margin: const EdgeInsets.all(3),
      width: 6.4.w,
      height: 6.4.h,
      decoration: BoxDecoration(
          color:
              currentIndex == index ? Colors.white : AppColors.editBorderColor,
          shape: BoxShape.circle),
    );
  });
}

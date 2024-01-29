import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jyo_app/view_model/posts_and_activities_vm.dart';

import '../repository/profile_repo/profile_repo_impl.dart';
import '../utils/common.dart';
import '../utils/secured_storage.dart';

class TimelineScreenVM extends GetxController {
  ProfileRepoImpl profileRepoImpl = ProfileRepoImpl();
  //BaseScreenVM bsv = Get.find<BaseScreenVM>();
  PostsAndActivitiesVM postsVM =
      PostsAndActivitiesVM();
       //Get.find<PostsAndActivitiesVM>();
  
  String? imageFileName = "";
  String? firstName = "";
  String? lastName = "";

  bool? isLoadingPost = true;
  String? userId;

  ScrollController scrollController = ScrollController();
  bool? fetchingMorePosts = false;
  bool? itIsTimeNow = false;
  int page = 1;
  int limit = 10;
  bool? dontReload = false;

  Timer? timer;

  bool? showCommentTextField = true;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  scrollListener() async {
    if (scrollController.offset >=
            scrollController.position.maxScrollExtent - 350
        //&& !scrollController.position.outOfRange
        ) {
      if (!fetchingMorePosts!) {
        fetchingMorePosts = true;
        page++;
        timer = Timer(const Duration(seconds: 5), () {
          if (fetchingMorePosts!) {
            itIsTimeNow = true;
          } else {
            itIsTimeNow = false;
          }
          if (timer != null) {
            timer!.cancel();
          }
          timer = null;
          update();
        });
        await getTimeline();
      }
    }
    if (scrollController.offset <= scrollController.position.minScrollExtent &&
        !scrollController.position.outOfRange) {
      fetchingMorePosts = false;
    }
    update();
  }

  Future<void> init() async {
    scrollController = ScrollController();
    scrollController.addListener(scrollListener);
    userId = await SecuredStorage.readStringValue(Keys.userId);
    postsVM.afterInit(this);
    await getProfileData();
    page = 1;
    await getTimeline();
    isLoadingPost = false;
    update();
  }

  Future<void> getProfileData() async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    await profileRepoImpl.getUserInfo(userId).then((res) async {
      if (res.status == 200) {
        imageFileName = res.data!.userInfoData!.profilePic.toString().trim();
        firstName = res.data!.userInfoData!.firstName.toString();
        lastName = res.data!.userInfoData!.lastName.toString();
        update();
      } else {
        showAppDialog(msg: "Error ${res.message.toString()}");
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: "Error ${error.toString()}");
    });
  }

  Future<void> getTimeline() async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    // taggedUsersList.clear();
    var data = {};
    data["userId"] = userId.toString();
    data["page"] = page.toString();
    data["limit"] = limit.toString();
    debugPrint("Timeline New data $data");
    await postsVM.getTimeline(data, this).then((res) async {
      if (page == 1) {
        postsVM.postsList.clear();
        postsVM.postsList.addAll(res);
      } else {
        postsVM.postsListPaged.clear();
        postsVM.postsListPaged.addAll(res);
        postsVM.postsList
            .insertAll(postsVM.postsList.length, postsVM.postsListPaged);
        fetchingMorePosts = false;
        itIsTimeNow = false;
      }
      update();
    }).onError((error, stackTrace) {
      fetchingMorePosts = false;
      update();
    });
  }
}

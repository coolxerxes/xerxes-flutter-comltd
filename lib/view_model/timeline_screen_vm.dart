import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jyo_app/models/posts_model/TSuggestedPeople.dart';
import 'package:jyo_app/repository/freinds_repo/freinds_repo.dart';
import 'package:jyo_app/repository/freinds_repo/freinds_repo_impl.dart';
import 'package:jyo_app/repository/post_repo/post_repo_impl.dart';
import 'package:jyo_app/view/timeline_screen_view.dart';
import 'package:jyo_app/view_model/posts_and_activities_vm.dart';

import '../data/remote/endpoints.dart';
import '../repository/profile_repo/profile_repo_impl.dart';
import '../utils/common.dart';
import '../utils/secured_storage.dart';
import 'base_screen_vm.dart';

class TimelineScreenVM extends GetxController {
  ProfileRepoImpl profileRepoImpl = ProfileRepoImpl();
  BaseScreenVM bsvm = Get.find<BaseScreenVM>();
  PostsAndActivitiesVM postsVM = PostsAndActivitiesVM();
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
  int pageSPeople = 1;
  int limit = 10;
  bool? dontReload = false;

  Timer? timer;

  bool? showCommentTextField = true;

  GlobalKey key1 = GlobalKey();
  GlobalKey key2 = GlobalKey();
  GlobalKey key3 = GlobalKey();
  GlobalKey key4 = GlobalKey();

  int step = 0;
  List<GlobalKey<State<StatefulWidget>>> keyList = List.empty(growable: true);

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Use `MapController` as needed
      TimelineScreenView.showcase(this);
    });
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
    spScrollController = ScrollController();

    addLoadMoreTrigger();
    scrollController.addListener(scrollListener);
    userId = await SecuredStorage.readStringValue(Keys.userId);
    postsVM.afterInit(this, endpoint: Endpoints.post);
    await getProfileData();
    page = 1;
    pageSPeople = 1;
    await getTimeline();
    await getSuggestedPeople();

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

  TSuggestedPeople? tSuggestedPeople;
  bool sgIsLoading = false;
  getSuggestedPeople() async {
    var data = {};

    data["userId"] = userId;
    data["page"] = pageSPeople;
    data["limit"] = limit;
    sgIsLoading = true;
    update();
    tSuggestedPeople = await PostRepoImpl().postSuggestedPeople(data);

    sgIsLoading = false;
    update();
  }

  late ScrollController spScrollController;
  addLoadMoreTrigger() {
    spScrollController.addListener(() {
      if (spScrollController.position.maxScrollExtent ==
          spScrollController.position.pixels) {
        loadMore();
      }
    });
  }

  bool stopLoad = false;
  bool tLoadMoreIsloading = false;

  void loadMore() async {
    var data = {};
    TSuggestedPeople? tLoadMore;
    pageSPeople += 1;
    tLoadMoreIsloading = true;

    data["userId"] = userId.toString();
    data["page"] = pageSPeople.toString();
    data["limit"] = limit.toString();
    if (stopLoad) return;

    update();
    tLoadMore = await PostRepoImpl().postSuggestedPeople(data);
    tSuggestedPeople!.data!.addAll(tLoadMore!.data!);

    if (tLoadMore.data!.isEmpty) stopLoad = true;

    tLoadMoreIsloading = false;

    update();
  }

  bool? isEnabled = true;
  bool isRequestSent = false;

  Future<void> addFriend(index) async {
    isEnabled = false;
    update();
    Map data = {
      "userId": userId,
      "friendId": tSuggestedPeople!.data![index].userInfo!.id
    };
    debugPrint("addFriend Req $data");
    await FriendsRepoImpl().sendFriendRequest(data)!.then((res) {
      if (res.status == 200) {
        if (res.data!.status == "Pending") {
          tSuggestedPeople!.data![index].isRequestSent = true;
          update();
        }
      } else {
        showAppDialog(msg: res.message);
      }
      isEnabled = true;
      update();
    }).onError((error, stackTrace) {
      isEnabled = true;
      update();
      showAppDialog(msg: error.toString());
    });
  }

  Future<void> cancelFriendRequest(index) async {
    isEnabled = false;
    update();
    Map data = {
      "myUserId": userId,
      "friendId": tSuggestedPeople!.data![index].userInfo!.id
    };
    debugPrint("cancel Req $data");
    await FriendsRepoImpl().cancelFriendRequest(data)!.then((res) async {
      if (res.status == 200) {
        tSuggestedPeople!.data![index].isRequestSent = false;
        update();
      } else {
        showAppDialog(msg: res.message);
      }
      isEnabled = true;
      update();
    }).onError((error, stackTrace) {
      isEnabled = true;
      update();
      showAppDialog(msg: error.toString());
    });
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as m;
import 'package:get/get.dart';
import 'package:jyo_app/data/remote/endpoints.dart';
import 'package:jyo_app/repository/activities_repo/activities_repo_impl.dart';
import 'package:jyo_app/view_model/posts_and_activities_vm.dart';
import 'package:jyo_app/models/search_people_model/friend_list_model.dart' as f;
import 'package:latlong2/latlong.dart';
import 'package:mapbox_search/mapbox_search.dart';

import '../data/local/tab_data.dart';
import '../models/activity_model/list_of_participants_model.dart';
import 'package:jyo_app/models/activity_model/activity_request_list_model.dart'
    as r;
import '../repository/freinds_repo/freinds_repo_impl.dart';
import '../utils/common.dart';
import '../utils/secured_storage.dart';
import '../view/explore_screen_view.dart';
import 'base_screen_vm.dart';
import 'notification_screen_vm.dart';

class ActivityDetailsScreenVM extends GetxController {
  final postsVM = PostsAndActivitiesVM();
  final notiVM = Get.put(NotificationScreenVM());
  final bsvm = Get.put(BaseScreenVM());
  bool? isAppStartingFromNotification = false;
  String? userId = "";
  bool isLoadingActs = true;
  String activityId = "";

  String? locationText = "";
  String? profile = "";

  List<Datum> members = List.empty(growable: true);
  List<Datum>? searchedMembers = List.empty(growable: true);
  List<r.Datum> requestList = List.empty(growable: true);
  List<f.Datum>? friends = List.empty(growable: true);
  List<f.Datum>? searchedFriends = List.empty(growable: true);

  m.TextEditingController? searchCtrl = m.TextEditingController();
  m.TextEditingController? fsearchCtrl = m.TextEditingController();
  List<Tab> tabs = List.empty(growable: true);

  Tab? selectedTab;
  bool? isHost = false;
  String? hostId = "";
  bool? isSubHost = false;
  bool? isInvited = false;
  int commentCount = 0;

  bool isReadingMore = false;
  bool isFromExplore = false;

  int toHostIndex = -1;
  int toHostId = -1;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  final reverseGeoCoding = ReverseGeoCoding(
    apiKey: MapConstants.accessToken,
    limit: 5,
  );

  Future<void> reverseGeocode(LatLng point, {bool goToSheet = true}) async {
    locationText = "Location loading...";
    update();
    getAddress(point).then((res) {
      debugPrint("rG len ${res!.length}");
      if (res.isNotEmpty) {
        locationText = res[0].placeName;
      } else {
        locationText = "${point.latitude - point.longitude}";
      }
      update();
    }).onError((error, stackTrace) {
      showAppDialog(msg: "unable to find location");
    });
  }

  Future<List<MapBoxPlace>?> getAddress(LatLng point) =>
      reverseGeoCoding.getAddress(
        Location(lat: point.latitude, lng: point.longitude),
      );

  Future<void> init({withoutArg = false}) async {
    SecuredStorage.initiateSecureStorage();
    userId = await SecuredStorage.readStringValue(Keys.userId);
    profile = await SecuredStorage.readStringValue(Keys.profile);
    postsVM.afterInit(this, endpoint: Endpoints.activity);

    if (!withoutArg) {
      activityId = Get.arguments["id"].toString();
      isFromExplore = Get.arguments["isFromExplore"] ?? false;
      isAppStartingFromNotification =
          Get.arguments["isAppStartingFromNotification"] ?? false;
    }
    createTabs();
    await getActivity();
    getRequestList({
      'activityId': activityId.toString(),
      'userId': hostId.toString() //userId.toString()
    });

    getParticipants({'activityId': activityId.toString()});

    fetchFreindList();
    getComments();
  }

  Future<void> inviteFriends() async {
    var userArray = [];
    for (int i = 0; i < friends!.length; i++) {
      if (friends![i].getIsHidden!) {
        userArray.add(friends![i].user!.userId.toString());
      }
    }
    var data = {
      "activityId": activityId.toString(),
      "userArray": userArray,
      "hostId": userId.toString()
    };
    debugPrint("Invite Data $data");
    await ActivitiesRepoImpl().invite(data)!.then((res) {
      if (res.status == 200) {
        Get.back();
        snackbar(title: res.message);
      } else {
        showAppDialog(msg: res.message);
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }

  Future<void> fetchFreindList() async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    Map data = {"userId": userId};

    await FriendsRepoImpl().getFriendList(data)!.then((res) async {
      if (res.status == 200) {
        friends!.clear();
        searchedFriends!.clear();
        friends!.addAll(res.data!);
        searchedFriends!.addAll(res.data!);

        for (var i = 0; i < friends!.length; i++) {
          friends![i].setIsHidden = false;
          searchedFriends![i].setIsHidden = false;
        }
      } else {
        showAppDialog(msg: res.message.toString());
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }

  void searchInvities(String t) {
    friends!
        .assignAll(searchedFriends!.where((f.Datum p0) => (t.toString().isEmpty
            ? true
            : (p0.user!.firstName.toString().toLowerCase() +
                    " " + //.contains(t.toString().toLowerCase()) ||
                    p0.user!.lastName.toString().toLowerCase())
                // (p0.user!.firstName
                //         .toString()
                //         .toLowerCase()
                //         .contains(t.toString().toLowerCase()) ||
                //     p0.user!.lastName
                //         .toString()
                //         .toLowerCase()
                .contains(t.toString().toLowerCase()))));
  }

  Future<void> getComments() async {
    await postsVM.cvm.afterInit(this, Endpoints.activity);
    await postsVM.cvm.getComments(activityId.toString(),
        cIndex: null, postIdIndex: -1, callback: () {
      commentCount = postsVM.cvm.commentList.length;
      //commentCount++;
      tabs[0].text = "Comments ($commentCount)";
      update();
    });
    if (postsVM.cvm.commentList.isNotEmpty) {
      commentCount = postsVM.cvm.commentList.length;
      tabs[0].text = "Comments ($commentCount)";
    }
    update();
    // postsVM.cvm.getComments(activityId.toString());
  }

  void createTabs() {
    tabs.clear();
    tabs.add(Tab(
        index: ActivityTabs.commentTab, text: "Comments", showBadge: false));
    tabs.add(
        Tab(index: ActivityTabs.requestTab, text: "Request", showBadge: false));

    selectedTab = tabs[0];
    update();
  }

  Future<void> getActivity() async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    var data = {
      "userId": userId.toString(),
      "activityId": activityId.toString()
    };
    debugPrint("data acts d $data");
    await postsVM.getActivitiyDetail(data, this).then((res) async {
      postsVM.activitiesList.clear();
      if (res != null) {
        postsVM.activitiesList.add(res);
        if (postsVM.activitiesList[0].location!.isNotEmpty) {
          await reverseGeocode(LatLng(postsVM.activitiesList[0].location![0],
              postsVM.activitiesList[0].location![1]));
          isInvited = postsVM.activitiesList[0].isInvited;
          debugPrint("isInvited $isInvited");
          isHost = postsVM.activitiesList[0].role == ActivityRoles.host;
          isSubHost = postsVM.activitiesList[0].role == ActivityRoles.subHost;
          hostId = postsVM.activitiesList[0].host!.userId.toString();
          //isParticipant = postsVM.activitiesList[0].role == ActivityRoles.participant;
          //postsVM.activitiesList[0].host!.userId.toString() ==
          //  userId.toString();
        } else {
          locationText = "No location available";
        }
      }
      isLoadingActs = false;
      update();
    }).onError((error, stackTrace) {
      showAppDialog(msg: "Error ${error.toString()}");
      isLoadingActs = false;
      update();
    });
  }

  Future<void> getParticipants(Map data) async {
    await ActivitiesRepoImpl().participantsList(data)!.then((res) {
      if (res.status == 200) {
        members.clear();
        searchedMembers!.clear();
        searchedMembers!.addAll(res.data!);
        members.addAll(res.data!);
      } else {
        debugPrint("PL RES MSG ${res.message}");
      }
      update();
    }).onError((error, stackTrace) {
      debugPrint("PL Error ${error.toString()}");
      update();
    });
  }

  Future<void> getRequestList(Map data) async {
    await ActivitiesRepoImpl().requestListToJoin(data)!.then((res) {
      if (res.status == 200) {
        requestList.clear();
        requestList.addAll(res.data!);
      } else {
        debugPrint("RQL RES MSG ${res.message}");
      }
      if (requestList.isNotEmpty) {
        tabs[1].showBadge = true;
      }
      update();
    }).onError((error, stackTrace) {
      debugPrint("RQL Error ${error.toString()}");
      update();
    });
  }

  Future<void> acceptRequestToJoin(Map<String, String> data) async {
    debugPrint("acceptRequestToJoin req $data");
    await ActivitiesRepoImpl().acceptRequestToJoin(data).then((res) {
      // if (res.status == 200) {
      getRequestList(
          {'activityId': activityId.toString(), 'userId': userId.toString()});
      getParticipants({'activityId': activityId.toString()});
      //} else {
      // debugPrint("ARQL RES MSG ${res.message}");
      //}
      update();
    }).onError((error, stackTrace) {
      debugPrint("ARQL Error ${error.toString()}");
      update();
    });
  }

  Future<void> shareActivityAsPost(Map<String, dynamic> data) async {
    await ActivitiesRepoImpl().shareAsPost(data)!.then((res) {
      // if (res.status == 200) {
      snackbar(title: res["message"].toString());
      //}
      update();
    }).onError((error, stackTrace) {
      debugPrint("Share As Post Error ${error.toString()}");
      update();
    });
  }

  void search(String t) {
    searchedMembers!.assignAll(members.where((Datum p0) => (t.toString().isEmpty
        ? true
        : (p0.user!.userInfo!.firstName.toString().toLowerCase() +
                " " + //.contains(t.toString().toLowerCase()) ||
                p0.user!.userInfo!.lastName.toString().toLowerCase())
            // (p0.user!.userInfo!.firstName
            //         .toString()
            //         .toLowerCase()
            //         .contains(t.toString().toLowerCase()) ||
            //     p0.user!.userInfo!.lastName
            //         .toString()
            //         .toLowerCase()
            .contains(t.toString().toLowerCase()))));
  }

  Future<void> setAsSubHost(Map<String, String> data) async {
    debugPrint("setAsSubHost req $data");
    await ActivitiesRepoImpl().setSubHost(data).then((res) {
      getParticipants({"activityId": activityId.toString()});
      update();
    }).onError((error, stackTrace) {
      debugPrint("ARQL Error ${error.toString()}");
      update();
    });
  }

  Future<void> demoteToNormalParticipant(Map<String, String> data) async {
    debugPrint("demoteToNormalParticipant req $data");
    await ActivitiesRepoImpl().demoteToNormalParticipants(data).then((res) {
      getParticipants({"activityId": activityId.toString()});
      update();
    }).onError((error, stackTrace) {
      debugPrint("ARQL Error ${error.toString()}");
      update();
    });
  }

  Future<void> removeParticipants(Map<String, String> data) async {
    debugPrint("removeParticipants req $data");
    await ActivitiesRepoImpl().removeParticipants(data).then((res) {
      getParticipants({"activityId": activityId.toString()});
      update();
    }).onError((error, stackTrace) {
      debugPrint("ARQL Error ${error.toString()}");
      update();
    });
  }

  Future<void> setAsHostAndDemoteYourSelfToSubHost(
      Map<String, String> data) async {
    debugPrint("setAsHostAndDemoteYourSelfToSubHost req $data");
    await ActivitiesRepoImpl().setHostAndSelfDemote(data).then((res) {
      getParticipants({"activityId": activityId.toString()});
      init(withoutArg: true);
      update();
    }).onError((error, stackTrace) {
      debugPrint("ARQL Error ${error.toString()}");
      update();
    });
  }

  Future<void> leaveAndSetAsHost(data) async {
    debugPrint("leaveAndSetAsHost req $data");
    await ActivitiesRepoImpl()
        .leaveActivityAppointSomeoneAsHost(data)
        .then((res) {
      Get.back();
      getParticipants({"activityId": activityId.toString()});
      init(withoutArg: true);
      update();
    }).onError((error, stackTrace) {
      debugPrint("leaveAndSetAsHost Error ${error.toString()}");
      update();
    });
  }
}

class ActivityRoles {
  static const host = "Host";
  static const subHost = "Sub host";
  static const participant = "Participant";
}

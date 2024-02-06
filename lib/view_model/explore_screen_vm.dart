import 'dart:convert';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jyo_app/models/posts_model/post_and_activity_model.dart';
import 'package:jyo_app/repository/activities_repo/activities_repo_impl.dart';
import 'package:jyo_app/repository/notification_repo/notification_repo_impl.dart';
import 'package:jyo_app/resources/app_image.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/utils/secured_storage.dart';
import 'package:jyo_app/view/explore_screen_view.dart';
import 'package:jyo_app/view/timeline_screen_view.dart';
import 'package:jyo_app/view_model/posts_and_activities_vm.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

import '../data/local/sort_card_data.dart';
import '../data/remote/api_interface.dart';
import '../data/remote/endpoints.dart';
import '../models/activity_model/map_filtered_activity_model.dart' as mf;
import '../models/registration_model/interest_data_response.dart';
import '../repository/profile_repo/profile_repo_impl.dart';
import '../repository/registration_repo/registration_repo_impl.dart';
import '../resources/app_colors.dart';
import '../utils/commet_chat_constants.dart';
import 'base_screen_vm.dart';

class ExploreScreenVM extends GetxController {
  final bsvm = Get.put(BaseScreenVM());
  NotificationRepoImpl notificationRepoImpl = NotificationRepoImpl();
  ProfileRepoImpl profileRepoImpl = ProfileRepoImpl();
  ActivitiesRepoImpl activitiesRepoImpl = ActivitiesRepoImpl();
  List<GlobalKey<State<StatefulWidget>>> list = List.empty(growable: true);
  List<EventsAroundMe> eventList = List.empty(growable: true);
  List<Marker> markers = List.empty(growable: true);
  List<Marker> myLocMarkers = List.empty(growable: true);
  List<Datum> catList = List.empty(growable: true);
  List<Datum> baseList = List.empty(growable: true);
  List<SortCardData> sortList = List.empty(growable: true);
  int selectedSort = 0;
  PopupController pc = PopupController();
  PostsAndActivitiesVM c = PostsAndActivitiesVM();
  bool? isLoading = true;
  LocationData? locationData;
  bool? isMapReady = false;
  List<PostOrActivity> clusteredActivities = List.empty(growable: true);

  String? userId, dob, gender, profile, faceUrl, firstName, lastName;

  MapController mapController = MapController();

  GlobalKey? key1;
  GlobalKey? key2;
  GlobalKey? key3;

  int step = 0;
  bool showMap = false;

  PostOrActivity activity = PostOrActivity(
    activityName: "Sunrise hike to Mount Faber - Only with complete equipment",
    activityAbout: "Singapore Outdoor Community",
    activityId: "0",
    activityDate: "2023-04-30T00:00:00.000Z",
    activityParticipants: [],
    activityParticipantsCount: 3,
    location: [],
    isSaved: false,
    isJoinedActivity: false,
    members: [],
    userId: 17,
  );

  double zoom = 16;

  double radius = 24.0;
  List selectedCatIds = List.empty(growable: true);

  void getSortList() {
    sortList.clear();
    sortList.add(SortCardData(
        index: 0,
        sortBy: "Nearest",
        onTap: () {
          selectedSort = 0;
          update();
        }));
    sortList.add(SortCardData(
        index: 1,
        sortBy: "Popular",
        onTap: () {
          selectedSort = 1;
          update();
        }));
    sortList.add(SortCardData(
        index: 2,
        sortBy: "Random",
        onTap: () {
          selectedSort = 2;
          update();
        }));
  }

  @override
  void onInit() {
    getSortList();
    getIntrest();
    c.afterInit(this);
    key1 = GlobalKey();
    key2 = GlobalKey();
    key3 = GlobalKey();
    SecuredStorage.initiateSecureStorage();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Use `MapController` as needed

      ExploreScreenView.showcase(this);
    });
    init();
    super.onInit();
  }

  Future<void> init({fromInit = false}) async {
    mapController = MapController();
    await getStorageData();
    notificationApi();
    loginIntoCommetChat();
    await getLocation(fromInit: fromInit);

    showMap = true;
    update();
  }

  Future<void> getIntrest({bool preSelectIfAvailable = false}) async {
    await RegistrationRepoImpl().getAllIntrest().then((res) async {
      if (res.status == 200) {
        catList.clear();
        baseList.addAll(res.data!);
        for (var i = 0; i < baseList.length; i++) {
          baseList[i].setIsSelected = false;
        }
        catList.addAll(baseList);

        // if (preSelectIfAvailable) {
        //  // dynamic intrest =
        //    //   await SecuredStorage.readStringValue(Keys.interests);
        //   if (intrest != null) {
        //     var intrData = jsonDecode(intrest) as Map;
        //     var intrIds = intrData["intrestIds"] as List;
        //     selectedIntrestIds.clear();
        //     selectedIntrestIds.addAll(intrIds);
        //     for (var i = 0; i < selectedIntrestIds.length; i++) {
        //       var idx = list.indexWhere((Datum element) {
        //         return element.id == selectedIntrestIds[i];
        //       });
        //       if (idx != -1) {
        //         list[idx].setIsSelected = true;
        //       }
        //     }
        //     if (selectedIntrestIds.isNotEmpty) {
        //       isEnabled = true;
        //     }
        //   }
        // }

        update();
      } else {
        //  showAppDialog(msg: res.message!.toString());
      }
    }).onError((error, stackTrace) {
      //showAppDialog(msg: "ERROR " + error.toString());
    });
  }

  Future<void> getLocation({fromInit = false}) async {
    Location location = Location();
    if (locationData != null &&
        (await location.hasPermission() == PermissionStatus.granted ||
            await location.hasPermission() ==
                PermissionStatus.grantedLimited) &&
        isMapReady!) {
      if (myLocMarkers.isNotEmpty) {
        mapController.move(myLocMarkers[0].point, zoom);
        c.update();
        // if (fromInit) {
        //    var data = {
        //   "lat": locationData!.latitude.toString(),
        //   "long": locationData!.longitude.toString(),
        //   "category": [],
        //   "radius": "150"
        // };
        //   await getEventsAroundMe(data);
        // }
        return;
      }
    } else {
      bool serviceEnabled;
      PermissionStatus permissionGranted;

      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      locationData = await location.getLocation();
      if (locationData != null) {
        debugPrint(
            "Lat ${locationData!.latitude!}, ${locationData!.longitude!}");
        myLocMarkers.clear();
        myLocMarkers.add(Marker(
          height: 40.h,
          width: 40.h,
          point: LatLng(locationData!.latitude!, locationData!.longitude!),
          builder: (context) {
            return Image.asset(AppIcons.marker);
          },
        ));

        var data = {
          "lat": locationData!.latitude.toString(),
          "long": locationData!.longitude.toString(),
          "category": [], //MapFilter.catLit,
          //"radius": MapFilter.radius.toString(),
          // "sortBy": MapFilter.sortBy.toString()
        };

        dynamic catgList = await SecuredStorage.readStringValue(Keys.catList);
        if (isValidString(catgList)) {
          data["category"] = jsonDecode(catgList) as List;
        } else {
          data["category"] = [];
        }

        dynamic radius = await SecuredStorage.readStringValue(Keys.radius);
        if (isValidString(radius)) {
          data["radius"] = radius;
        } else {
          data["radius"] = "24";
        }

        dynamic sortBy = await SecuredStorage.readStringValue(Keys.sortBy);
        if (isValidString(sortBy)) {
          //  data["sortBy"] = sortBy;
        } else {
          //  data["sortBy"] = "Nearest";
        }

        // var data = {
        //   "lat": locationData!.latitude.toString(),
        //   "long": locationData!.longitude.toString(),
        //   "category": [],
        //   "radius": "150"
        // };
        if (locationData != null && isMapReady!) {
          if (myLocMarkers.isNotEmpty) {
            // showMap = false;
            // update();
            // mapController.dispose();
            // init(fromInit: fromInit);
            // return;
            mapController.move(myLocMarkers[0].point, zoom);
            c.update();
          }
        }
        await getEventsAroundMe(data);
      }
    }
    update();
  }

  Future<void> notificationApi() async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    String? deviceToken =
        await SecuredStorage.readStringValue(Keys.deviceToken);
    var data = {"userId": userId, "deviceId": deviceToken};
    debugPrint("NOTI data $data");
    await notificationRepoImpl.sendSignInNotification(data).then((res) {
      debugPrint("NOTI MSG ${res.message}");
    }).onError((error, stackTrace) {
      debugPrint("NOTI ERROR ${error.toString()}");
    });
  }

  Future<void> createCommetChatUser() async {
    String authKey =
        CometChatConstants.authKey; //Replace with the auth key of app
    User user = User(
        uid: userId.toString(),
        name: "${firstName!} ${lastName!}",
        avatar: faceUrl); //Replace with name and uid of user

    CometChat.createUser(user, authKey, onSuccess: (User user) {
      debugPrint("commetchat Create User succesful $user");
      loginIntoCommetChat();
    }, onError: (CometChatException e) {
      debugPrint(
          "commetchat Create User Failed with exception ${e.message}, ${e.code}");
    });
  }

  Future<void> loginIntoCommetChat() async {
    final user = await CometChat.getLoggedInUser();
    if (user == null) {
      await CometChatUIKit.login(userId.toString(), onSuccess: (user) {
        debugPrint("commetchat Login Successful : $user");
      }, onError: (CometChatException e) {
        debugPrint(
            "commetchat Login failed with exception:  ${e.message}, ${e.code}");
        if (e.code.toString() == "ERR_UID_NOT_FOUND") {
          createCommetChatUser();
        } else {
          debugPrint(
              "else commetchat Login failed with exception:  ${e.message}, ${e.code}");
        }
      });
    } else {
      //User is already logged in.
      debugPrint("commetchat User is already logged in");
    }
  }

  Future<void> getStorageData() async {
    userId = await SecuredStorage.readStringValue(Keys.userId);
    firstName = await SecuredStorage.readStringValue(Keys.firstName);
    lastName = await SecuredStorage.readStringValue(Keys.lastName);
    gender = await SecuredStorage.readStringValue(Keys.gender);
    dob = await SecuredStorage.readStringValue(Keys.birthday);
    profile = await SecuredStorage.readStringValue(Keys.profile);
    faceUrl = ApiInterface.baseUrl +
        Endpoints.user +
        Endpoints.profileImage +
        profile.toString();
  }

  Future<void> getEventsAroundMe(data) async {
    debugPrint("getEventsAroundMe data $data");

    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://qa.jioyouout.com/api/v1/user/activity/getActivityByFilter'));
    request.body = json.encode({
      "lat": data["lat"].toString(), //"23.3207487",
      "long": data["long"].toString(), //"75.0320911",
      "category": data["category"],
      "radius": data["radius"].toString() //"24"
    });
    request.headers.addAll(headers);
    debugPrint("Filter act Json: ${request.body}");

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var st = await response.stream.bytesToString();
      debugPrint("RESPONSE OF MF : $st");

      final res = mf.mapFilteredActivityModelFromJson(st);

      //await activitiesRepoImpl.getMapFilteredActity(data)!.then((res) {
      if (res.status == 200) {
        eventList.clear();
        for (int i = 0; i < res.data!.length; i++) {
          eventList.add(EventsAroundMe(
              eventId: res.data![i].id.toString(),
              eventCoverImage:
                  ApiInterface.postImgUrl + res.data![i].coverImage.toString(),
              eventType: EventType.activity,
              point: LatLng(double.parse(res.data![i].lat.toString()),
                  double.parse(res.data![i].long.toString()))));
        }
        for (int i = 0; i < eventList.length; i++) {
          markers.add(Marker(
              height: 42.h,
              width: 42.w,
              point: eventList[i].point!,
              key: Key(eventList[i].eventId.toString()),
              builder: ((context) {
                return InkWell(
                  onTap: () async {
                    activity = (await getActivitys(
                        [eventList[i].eventId.toString()]))[0];
                    pc.showPopupsOnlyFor([eventList[i].marker!]);
                    update();
                    debugPrint("My internal tap ${eventList[i].eventId}");
                  },
                  child: Container(
                      width: 42.h,
                      height: 42.h,
                      padding: const EdgeInsets.all(1.5),
                      decoration: BoxDecoration(
                          color: AppColors.orangePrimary,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.dropShadowColor,
                              blurRadius: 4.2,
                              offset: Offset(0, 2),
                            )
                          ]),
                      child: MyAvatar(
                        url: eventList[i].eventCoverImage,
                        height: 40.h,
                        width: 40.h,
                        radiusAll: 16.r,
                        isNetwork: true,
                      )),
                );
              })));
          eventList[i].setMarker = markers[i];
        }
      }

      //   } else {
      //     debugPrint("MapFilteredAct ${res.message.toString()}");
      //   }
      // }).onError((error, stackTrace) {
      //   debugPrint("MapFilteredAct ${error.toString()}");
      // });
    } else {
      print(response.reasonPhrase);
    }
  }

  String getUrl(Key? key) {
    int idx = eventList.indexWhere((element) {
      return key == element.marker!.key;
    });
    if (idx != -1) {
      return eventList[idx].eventCoverImage.toString();
    }
    return AppImage.avatar0;
  }

  String getActivityId(Key? key) {
    int idx = eventList.indexWhere((element) {
      return key == element.marker!.key;
    });
    if (idx != -1) {
      return eventList[idx].eventId.toString();
    }
    return "";
  }

  Future<List<PostOrActivity>> getActivitys(
      List<String> postOrActivityIds) async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    var data = {"userId": userId, "activityIds": postOrActivityIds};
    List<PostOrActivity> list = List.empty(growable: true);
    await activitiesRepoImpl.mapTappedActivity(data).then((res) {
      if (res.status == 200) {
        for (int i = 0; i < res.postsOrActivities!.length; i++) {
          list.add(res.postsOrActivities![i]);
        }
      }
    }).onError((error, stackTrace) {});
    return list;
  }

  void showResult() {
    showMap = false;
    update();
    selectedCatIds.clear();
    for (int i = 0; i < catList.length; i++) {
      if (catList[i].getIsSelected!) {
        selectedCatIds.add(catList[i].id.toString());
      }
    }

    SecuredStorage.writeStringValue(Keys.catList, jsonEncode(selectedCatIds));
    SecuredStorage.writeStringValue(Keys.radius, radius.toStringAsFixed(0));
    SecuredStorage.writeStringValue(
        Keys.sortBy, sortList[selectedSort].sortBy.toString());

    // MapFilter.catLit = selectedCatIds;
    // MapFilter.radius = radius.toStringAsFixed(0);
    // MapFilter.sortBy = sortList[selectedSort].sortBy.toString();

    // var data = {
    //   "lat": locationData!.latitude.toString(),
    //   "long": locationData!.longitude.toString(),
    //   "category": selectedCatIds,
    //   "radius": radius.toStringAsFixed(0),
    //   "sortBy": sortList[selectedSort].sortBy.toString()
    // };
    mapController.dispose();
    Get.back();
    Get.delete<ExploreScreenVM>();
    bsvm.changePage(0);
  }
}

class EventsAroundMe {
  EventsAroundMe(
      {this.eventId, this.eventCoverImage, this.eventType, this.point});

  String? eventCoverImage;
  EventType? eventType;
  LatLng? point;
  String? eventId;
  Marker? marker;

  Marker? get getMarker => marker;
  set setMarker(Marker? marker) => this.marker = marker;
}

enum EventType { activity, group, none }

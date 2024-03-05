// ignore_for_file: avoid_init_to_null

import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jyo_app/data/local/post_edit_model.dart';
import 'package:jyo_app/models/group_suggestion_model/group_details_model.dart';
import 'package:jyo_app/models/registration_model/interest_data_response.dart';
import 'package:jyo_app/repository/activities_repo/activities_repo_impl.dart';
import 'package:jyo_app/repository/freinds_repo/freinds_repo_impl.dart';
import 'package:jyo_app/repository/post_repo/post_repo_impl.dart';
import 'package:jyo_app/repository/registration_repo/registration_repo_impl.dart';
import 'package:jyo_app/models/search_people_model/friend_list_model.dart' as f;
import 'package:jyo_app/utils/secured_storage.dart';
import 'package:jyo_app/view/choose_location_on_map_screen_view.dart';
import 'package:jyo_app/view/create_activity_screen2_view.dart';
import 'package:jyo_app/view/explore_screen_view.dart';
import 'package:jyo_app/view_model/activity_details_screen_vm.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as l;
import 'package:mapbox_search/mapbox_search.dart';

import '../resources/app_colors.dart';
import '../resources/app_image.dart';
import '../resources/app_routes.dart';
import '../utils/common.dart';
import 'base_screen_vm.dart';
import 'explore_screen_vm.dart';
import 'group_details_screen_vm.dart';

class CreateActivityScreenVM extends GetxController {
  final bsvm = Get.put(BaseScreenVM());
  RegistrationRepoImpl registrationRepoImpl = RegistrationRepoImpl();
  ActivitiesRepoImpl activitiesRepoImpl = ActivitiesRepoImpl();

  List<Datum> list = List.empty(growable: true);
  List<Datum> baseList = List.empty(growable: true);
  List<MapBoxPlace>? mapSearchResults = List.empty(growable: true);
  var selectedIntrestIds = [];
  List<f.Datum>? friends = List.empty(growable: true);
  List<f.Datum>? searchedFriends = List.empty(growable: true);

  TextEditingController? activityNameCtrl = TextEditingController();
  TextEditingController? aboutCtrl = TextEditingController();
  TextEditingController? searchCtrl = TextEditingController();
  TextEditingController? mapSearchCtrl = TextEditingController();

  String? selectedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());

  String selectedCategories = "";
  String userId = "", firstName = "", lastName = "";
  String profileImg = "";
  String? coverImage = "";
  String? createdActivityId = null;
  String? groupId;
  XFile? xCoverImage;

  double start = 16;
  double end = 100;

  int maxPartipants = 10;

  bool? showTime = false;
  bool? showCal = false;
  bool? isParticipantsLimited = false;
  bool? isPrivateThisActivity = false;
  bool? isByApproval = false;
  bool? isFetchingLocs = false;

  DateTime selectedTime = DateTime.now();
  DateTime? selectedDateTime = DateTime.now();

  MapBoxPlace? selectedLocation;

  final placesSearch = PlacesSearch(
    apiKey: MapConstants.accessToken,
    limit: 10,
  );

  final reverseGeoCoding = ReverseGeoCoding(
    apiKey: MapConstants.accessToken,
    limit: 5,
  );

  CroppedFile? xCoverImageC;

  Future<List<MapBoxPlace>?> getAddress(LatLng point) =>
      reverseGeoCoding.getAddress(
        Location(lat: point.latitude, lng: point.longitude),
      );

  Future<void> reverseGeocode(LatLng point, {bool goToSheet = true}) async {
    getAddress(point).then((res) {
      debugPrint("rG len ${res!.length}");
      if (res.isNotEmpty) {
        selectedLocation = res[0];
        if (goToSheet) {
          ChooseLocationOnMapScreenView.showLocSheet();
        }
      }
      update();
    }).onError((error, stackTrace) {
      showAppDialog(msg: "unable to find location");
    });
  }

  bool isUploading = false;

  LatLng? point;
  LatLng? myLocation;

  List<Marker> markers = List.empty(growable: true);

  void togglePrivateThisActivity() {
    isPrivateThisActivity = !isPrivateThisActivity!;
    update();
  }

  void toggleByApproval() {
    isByApproval = !isByApproval!;
    update();
  }

  void toggleLimiyParticipants() {
    isParticipantsLimited = !isParticipantsLimited!;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    init();
  }

  l.LocationData? locationData;
  bool? isMapReady = false;

  Future<void> getLocation({fromInit = false}) async {
    l.Location location = l.Location();
    if (locationData != null &&
        (await location.hasPermission() == l.PermissionStatus.granted ||
            await location.hasPermission() ==
                l.PermissionStatus.grantedLimited) &&
        isMapReady!) {
      myLocation = LatLng(locationData!.latitude!, locationData!.longitude!);
      // if (myLocMarkers.isNotEmpty) {
      //   mapController.move(myLocMarkers[0].point, zoom);
      //   c.update();
      //   // if (fromInit) {
      //   //    var data = {
      //   //   "lat": locationData!.latitude.toString(),
      //   //   "long": locationData!.longitude.toString(),
      //   //   "category": [],
      //   //   "radius": "150"
      //   // };
      //   //   await getEventsAroundMe(data);
      //   // }
      //   return;
      // }
    } else {
      bool serviceEnabled;
      l.PermissionStatus permissionGranted;

      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == l.PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != l.PermissionStatus.granted) {
          return;
        }
      }

      locationData = await location.getLocation();

      if (locationData != null) {
        myLocation = LatLng(locationData!.latitude!, locationData!.longitude!);
      }
      //   debugPrint(
      //       "Lat ${locationData!.latitude!}, ${locationData!.longitude!}");
      //   myLocMarkers.clear();
      //   myLocMarkers.add(Marker(
      //     height: 40.h,
      //     width: 40.h,
      //     point: LatLng(locationData!.latitude!, locationData!.longitude!),
      //     builder: (context) {
      //       return Image.asset(AppIcons.marker);
      //     },
      //   ));
      //   var data = {
      //     "lat": locationData!.latitude.toString(),
      //     "long": locationData!.longitude.toString(),
      //     "category": [],
      //     "radius": "150"
      //   };
      //   if (locationData != null && isMapReady!) {
      //     if (myLocMarkers.isNotEmpty) {
      //       // showMap = false;
      //       // update();
      //       // mapController.dispose();
      //       // init(fromInit: fromInit);
      //       // return;
      //       mapController.move(myLocMarkers[0].point, zoom);
      //       c.update();
      //     }
      //   }
      //   await getEventsAroundMe(data);
      // }
    }
    debugPrint("My Location $myLocation");
    update();
  }

  Future<void> cropImage() async {
    xCoverImageC = await ImageCropper().cropImage(
      sourcePath: xCoverImage!.path,
      aspectRatio: const CropAspectRatio(ratioX: 16.0, ratioY: 9.0),
      aspectRatioPresets: [
        CropAspectRatioPreset.ratio16x9,
        // CropAspectRatioPreset.ratio3x2,
        // CropAspectRatioPreset.original,
        // CropAspectRatioPreset.ratio4x3,
        // CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: AppColors.orangePrimary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioLockEnabled: true,
        ),
        // WebUiSettings(
        //   context: context,
        // ),
      ],
    );
  }

  Future<void> init() async {
    userId = (await SecuredStorage.readStringValue(Keys.userId))!;
    firstName = (await SecuredStorage.readStringValue(Keys.firstName))!;
    lastName = (await SecuredStorage.readStringValue(Keys.lastName))!;
    profileImg = (await SecuredStorage.readStringValue(Keys.profile))!;
    if (Get.arguments != null) {
      groupId = Get.arguments["groupId"].toString();
      if (isValidString(groupId)) {
        firstName = Get.arguments["groupName"].toString();
        lastName = "";
        profileImg = Get.arguments["groupImage"].toString();
      }
    }
    getLocation();
    await fetchFreindList();
    await getIntrest();

    if (PostEdit.postOrActivity != null) {
      groupId = PostEdit.getPostOrActivity!.groupId.toString();
      activityNameCtrl!.text = PostEdit.postOrActivity!.activityName.toString();
      aboutCtrl!.text = PostEdit.postOrActivity!.activityAbout.toString();
      for (int i = 0; i < PostEdit.postOrActivity!.category!.length; i++) {
        int idx = baseList.indexWhere((element) {
          return element.id.toString() ==
              PostEdit.postOrActivity!.category![i].id.toString();
        });
        if (idx != -1) {
          baseList[idx].setIsSelected = true;
        }
      }
      afterCategoriesSelected(this, baseList);

      try {
        selectedDateTime =
            DateTime.parse(PostEdit.postOrActivity!.activityDate!);
        formatDateToEEEDDMMMFormat(selectedDateTime);
        selectedTime = DateTime.parse(PostEdit.postOrActivity!.activityDate!);
        formatDateToHMMAormat(selectedTime);
      } catch (e) {
        debugPrint("date parse ex");
      }
      if (PostEdit.postOrActivity!.location!.isNotEmpty) {
        LatLng point = LatLng(PostEdit.postOrActivity!.location![0],
            PostEdit.postOrActivity!.location![1]);
        markers.clear();
        markers.add(Marker(
            height: 40.h,
            width: 40.w,
            point: point,
            builder: ((context) {
              return SvgPicture.asset(
                AppIcons.markerBig,
              );
            })));
        await reverseGeocode(point, goToSheet: false);
      } else {
        debugPrint("loc empty");
      }
      coverImage = PostEdit.postOrActivity!.coverImage!;
      isPrivateThisActivity = PostEdit.postOrActivity!.privateActivity ?? false;
      isByApproval = PostEdit.postOrActivity!.byApproval ?? false;
      isParticipantsLimited =
          PostEdit.postOrActivity!.limitParticipants ?? false;
      if (!isParticipantsLimited!) {
        maxPartipants = 10;
      } else {
        if (isValidString(PostEdit.postOrActivity!.ageRequirement)) {
          if (PostEdit.postOrActivity!.ageRequirement!.contains("-")) {
            if (PostEdit.postOrActivity!.ageRequirement!.split("-").length >
                1) {
              start = double.parse(
                  PostEdit.postOrActivity!.ageRequirement!.split("-")[0]);
              end = double.parse(
                  PostEdit.postOrActivity!.ageRequirement!.split("-")[1]);
            }
          } else {
            if (PostEdit.postOrActivity!.ageRequirement!.split(" ").length >
                1) {
              start = double.parse(
                  PostEdit.postOrActivity!.ageRequirement!.split(" ")[0]);
              end = double.parse(
                  PostEdit.postOrActivity!.ageRequirement!.split(" ")[1]);
            }
          }
        }
      }
    }
    //PostEdit.setPostOrActivity = null;
    update();
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
    friends!.assignAll(searchedFriends!.where((f.Datum p0) =>
        (t.toString().isEmpty
            ? true
            : (p0.user!.firstName
                    .toString()
                    .toLowerCase()
                    .contains(t.toString().toLowerCase()) ||
                p0.user!.lastName
                    .toString()
                    .toLowerCase()
                    .contains(t.toString().toLowerCase())))));
  }

  Future<void> getIntrest({bool preSelectIfAvailable = false}) async {
    await registrationRepoImpl.getAllIntrest().then((res) async {
      if (res.status == 200) {
        list.clear();
        baseList.addAll(res.data!);
        for (var i = 0; i < baseList.length; i++) {
          baseList[i].setIsSelected = false;
        }
        list.addAll(baseList);

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
        showAppDialog(msg: res.message!.toString());
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: "ERROR $error");
    });
  }

  void afterCategoriesSelected(CreateActivityScreenVM c, List<Datum> list) {
    c.selectedCategories = "";
    int count = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].getIsSelected!) {
        count++;
        if (count == 1) {
          c.selectedCategories = "${c.selectedCategories}${list[i].name}";
        } else {
          c.selectedCategories = "${c.selectedCategories}, ${list[i].name}";
        }
      }
    }
  }

  void search(String query) {
    list.clear();
    for (int i = 0; i < baseList.length; i++) {
      if (baseList[i]
          .name!
          .trim()
          .toLowerCase()
          .contains(query.toString().trim().toLowerCase())) {
        list.add(baseList[i]);
      }
    }
    update();
  }

  Future<void> searchPlaces(String place) async {
    isFetchingLocs = true;
    update();
    await getPlaces(place).then((res) {
      mapSearchResults!.clear();
      mapSearchResults!.addAll(res!);
      update();
    }).onError((error, stackTrace) {
      debugPrint("map search error $error");
    });
    isFetchingLocs = false;
    update();
  }

  void pickImage(ImageSource source) async {
    String? fileName;

    xCoverImage = await ImagePicker().pickImage(source: source);
    if (xCoverImage != null) {
      debugPrint("selected Avatar ext ${xCoverImage!.path}");
    }

    if (xCoverImage != null) {
      await cropImage();
      if (xCoverImageC != null) {
        isUploading = true;
        update();
        debugPrint("fileNme $fileName");
        await PostRepoImpl()
            .attachment(null, fileName: fileName, filePath: xCoverImageC!.path)!
            .then((res) async {
          if (res.status == 200) {
            // postsToUpload!.insert(postsToUpload!.length - 1, xCoverImage);
            coverImage = res.data!.s3FileName;
          } else {
            showAppDialog(msg: res.message.toString());
          }
          isUploading = false;
          update();
        }).onError((error, stackTrace) {
          showAppDialog(msg: error.toString());
          isUploading = false;
          update();
        });
      }
    }
    update();
  }

  Future<List<MapBoxPlace>?> getPlaces(String place) =>
      placesSearch.getPlaces(place);

  void validatePage1() {
    var category = [];
    for (int i = 0; i < baseList.length; i++) {
      if (baseList[i].isSelected!) {
        category.add(baseList[i].id.toString());
      }
    }
    if (activityNameCtrl!.text.trim().isEmpty) {
      showAppDialog(msg: "Enter activity name");
      return;
    }
    if (aboutCtrl!.text.trim().isEmpty) {
      showAppDialog(msg: "Enter activity about");
      return;
    }
    if (category.isEmpty) {
      showAppDialog(msg: "Please select categories");
      return;
    }
    if (selectedLocation == null) {
      showAppDialog(msg: "Please select location");
      return;
    }
    getToNamed(createActivityScreen2Route);
  }

  Future<void> validatePage2() async {
    if (coverImage!.isEmpty) {
      showAppDialog(msg: "Please upload cover image");
      return;
    }
    await addActivity();
  }

  Future<void> addActivity() async {
    var category = [];
    for (int i = 0; i < baseList.length; i++) {
      if (baseList[i].isSelected!) {
        category.add(baseList[i].id.toString());
      }
    }
    var data = {
      "userId": userId.toString(),
      "activityName": activityNameCtrl!.text.trim(),
      "activityAbout": aboutCtrl!.text.trim(),
      "category": category,
      "activityDate":
          "${DateFormat("yyyy-MM-dd").format(selectedDateTime!)} ${DateFormat("HH:mm:ss").format(selectedTime)}",
      "lat": "${selectedLocation!.center![1]}",
      "long": "${selectedLocation!.center![0]}",
      "privateActivity": isPrivateThisActivity,
      "byApproval": isByApproval,
      "ageRequirement": "${start.ceil()}-${end.ceil()}",
      "maxParticipants":
          isParticipantsLimited! ? maxPartipants.toString() : null,
      "coverImage": coverImage,
      "limitParticipants": isParticipantsLimited
    };

    if (isValidString(groupId)) {
      data["groupId"] = groupId.toString();
    }

    debugPrint("act data $data");
    if (PostEdit.getPostOrActivity != null) {
      if (isValidString(PostEdit.getPostOrActivity!.groupId)) {
        data["groupId"] = PostEdit.getPostOrActivity!.groupId.toString();
      }
      await activitiesRepoImpl
          .updateActivity(
              data, PostEdit.getPostOrActivity!.activityId.toString())
          .then((res) {
        if (res["status"] == 200) {
          PostEdit.setPostOrActivity = null;
          final advm = Get.put(ActivityDetailsScreenVM());
          advm.init(withoutArg: true);
          //For closing create_activity1_screen_view
          Get.back();
          //For closing create_activity2_screen_view
          Get.back();
          debugPrint("activity upd res $res");
          showAppDialog(msg: res["message"].toString());
        } else {
          showAppDialog(msg: res["message"].toString());
        }
      }).onError((error, stackTrace) {
        PostEdit.setPostOrActivity = null;
        showAppDialog(msg: error.toString());
      });
    } else {
      await activitiesRepoImpl.addActivity(data).then((res) {
        if (res.status == 200) {
          if (friends!.isNotEmpty) {
            createdActivityId = res.data!.id.toString();
            CreateActivityScreen2View.showInviteSheet();
          } else {
            if (isValidString(groupId)) {
              final grpVM = Get.put(GroupDetailsScreenVM());
              grpVM.init(withoutArg: true);
            }
            //For closing create_activity1_screen_view
            Get.back();
            //For closing create_activity2_screen_view
            Get.back();

            if (!isValidString(groupId)) {
              Get.delete<ExploreScreenVM>();
              bsvm.changePage(0);
            }
          }
          debugPrint("activity res $res");
        } else {
          showAppDialog(msg: res.message);
        }
        // showAppDialog(msg: res.message.toString());
      }).onError((error, stackTrace) {
        showAppDialog(msg: error.toString());
      });
    }
  }

  Future<void> inviteFriends() async {
    var userArray = [];
    for (int i = 0; i < friends!.length; i++) {
      if (friends![i].getIsHidden!) {
        userArray.add(friends![i].user!.userId.toString());
      }
    }
    var data = {
      "activityId": createdActivityId.toString(),
      "userArray": userArray,
      "hostId": userId.toString()
    };
    debugPrint("Invite Data $data");
    await ActivitiesRepoImpl().invite(data)!.then((res) {
      if (res.status == 200) {
        if (isValidString(groupId)) {
          final grpVM = Get.put(GroupDetailsScreenVM());
          grpVM.init(withoutArg: true);
        }
        Get.back();
        Get.back();
        Get.back();
        if (!isValidString(groupId)) {
          Get.delete<ExploreScreenVM>();
          bsvm.changePage(0);
        }
      } else {
        showAppDialog(msg: res.message);
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }

  Future<void> sendCustomMessage(String deeplink, GroupDetail? group) async {
    final userArray = [];
    for (int i = 0; i < friends!.length; i++) {
      if (friends![i].getIsHidden!) {
        userArray.add(friends![i].user!.userId.toString());
      }
    }
    for (var i in userArray) {
      final CustomMessage customMessage = CustomMessage(
        receiverUid: i.toString(),
        type: CometChatMessageType.custom,
        category: CometChatMessageCategory.custom,
        customData: group?.toSendMessage(deeplink),
        receiverType: CometChatConversationType.user,
        subType: 'Group',
        tags: ['pinned', 'Group Shared'],
      );

      CometChatMessageEvents.ccMessageSent(
          customMessage, MessageStatus.inProgress);

      await CometChat.sendCustomMessage(customMessage,
          onSuccess: (CustomMessage message) {
        debugPrint("Custom Message Sent Successfully : $message");
        CometChatMessageEvents.ccMessageSent(customMessage, MessageStatus.sent);
      }, onError: (CometChatException e) {
        debugPrint(
            "Custom message sending failed with exception: ${e.message}");
      });
    }
    Get.back();
    showAppDialog(msg: "Group shared successfully");
  }
}

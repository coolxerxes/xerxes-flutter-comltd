import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:jyo_app/models/activity_model/activity_details_model.dart';
import 'package:jyo_app/models/activity_model/activity_search_model.dart';
import 'package:jyo_app/models/activity_model/fetch_activities_model.dart';
import 'package:jyo_app/models/activity_model/fetch_saved_activities.dart';
import 'package:jyo_app/models/activity_model/map_tapped_activity_model.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:latlong2/latlong.dart';

import '../../resources/app_image.dart';
import 'get_post_by_user_model.dart';
import 'timeline_model.dart';

class PostOrActivityModel {
  PostOrActivityModel({this.status, this.message, this.postsOrActivities});

  int? status;
  String? message;
  List<PostOrActivity>? postsOrActivities;

  static PostOrActivityModel parse(dynamic res) {
    List<PostOrActivity> postsOrActivities = List.empty(growable: true);

    if (res is TimelineResponseModel) {
      for (var i = 0; i < res.data!.length; i++) {
        print('------' + res.data![i].activityParticipantsCount.toString());
        postsOrActivities.add(PostOrActivity(
          activityId: res.data![i].activityId,
          attachment: res.data![i].attachment,
          commentCount: res.data![i].commentCount,
          createdAt: res.data![i].createdAt,
          document: res.data![i].document,
          groupId: res.data![i].groupId,
          id: res.data![i].id,
          isJioMe: res.data![i].isJioMe,
          isLiked: res.data![i].isLiked,
          jioMeUserInfo: List.empty(growable: true),
          likeCount: res.data![i].likeCount,
          postDate: res.data![i].postDate,
          tagUserInfo: res.data![i].tagUserInfo,
          text: res.data![i].text,
          topicTags: res.data![i].topicTags,
          updatedAt: res.data![i].updatedAt,
          userId: res.data![i].userId,
          userInfo: res.data![i].userInfo,
          userTags: res.data![i].userTags,
          visible: res.data![i].visible,
          activityData: res.data![i].activityData,
          mode: res.data![i].mode,
          isActivitySaved: res.data![i].isActivitySaved ?? false,
          activityName: res.data![i].activityName,
          activityAbout: res.data![i].activityAbout,
          activityParticipantsCount: res.data![i].activityParticipantsCount,
          activityDate: getDate(res.data![i].activityDate),
          activityParticipants: res.data![i].activityParticipants,
          location: getLocation("${res.data![i].lat} ${res.data![i].long}"),
          members:
              res.data![i].activityParticipants as List<ActivityParticipant>,
          markers: getLocation("${res.data![i].lat} ${res.data![i].long}")
                  .isNotEmpty
              ? List.filled(
                  1,
                  Marker(
                      width: 40.w,
                      height: 40.h,
                      point: LatLng(
                          getLocation(
                              "${res.data![i].lat} ${res.data![i].long}")[0],
                          getLocation(
                              "${res.data![i].lat} ${res.data![i].long}")[1]),
                      builder: ((context) {
                        return Image.asset(
                          AppIcons.marker,
                        );
                      })))
              : List.empty(growable: true),
          isSaved: res.data![i].isActivitySaved ?? false,
          isMember: res.data![i].isMember,
          activityHost: res.data![i].activityHost,
        ));
      }
    } else if (res is GetPostByUserResponseModel) {
      for (var i = 0; i < res.data!.length; i++) {
        postsOrActivities.add(PostOrActivity(
            activityId: res.data![i].activityId,
            attachment: res.data![i].attachment,
            commentCount: res.data![i].commentCount,
            createdAt: res.data![i].createdAt,
            document: res.data![i].document,
            groupId: res.data![i].groupId,
            id: res.data![i].id,
            isJioMe: res.data![i].isJioMe,
            isLiked: res.data![i].isLiked,
            jioMeUserInfo: res.data![i].jioMeUserInfo,
            likeCount: res.data![i].likeCount,
            postDate: res.data![i].postDate,
            tagUserInfo: res.data![i].tagUserInfo,
            text: res.data![i].text,
            topicTags: res.data![i].topicTags,
            updatedAt: res.data![i].updatedAt,
            userId: res.data![i].userId,
            userInfo: null,
            userTags: res.data![i].userTags,
            visible: res.data![i].visible,
            activityData: res.data![i].activityData,
            mode: res.data![i].mode));
      }
    } else if (res is FetchActivitiesModel) {
      for (var i = 0; i < res.data!.length; i++) {
        postsOrActivities.add(
          PostOrActivity(
            activityId: res.data![i].id,
            groupId: res.data![i].groupId,
            id: res.data![i].id,
            userId: res.data![i].userId,
            activityName: res.data![i].activityName,
            activityAbout: res.data![i].activityAbout,
            activityDate: getDate(res.data![i].activityDate),
            location: getLocation("${res.data![i].lat} ${res.data![i].long}"),
            group: res.data![i].group,
            members: res.data![i].activityParticipants,
            markers: getLocation("${res.data![i].lat} ${res.data![i].long}")
                    .isNotEmpty
                ? List.filled(
                    1,
                    Marker(
                        width: 40.w,
                        height: 40.h,
                        point: LatLng(
                            getLocation(
                                "${res.data![i].lat} ${res.data![i].long}")[0],
                            getLocation(
                                "${res.data![i].lat} ${res.data![i].long}")[1]),
                        builder: ((context) {
                          return Image.asset(
                            AppIcons.marker,
                          );
                        })))
                : List.empty(growable: true),
            isSaved: res.data![i].isActivitySaved ?? false,
            isJoinedActivity: res.data![i].isJoinedActivity,
            isInvited: res.data![i].isInvited,
            isMember: res.data![i].isMember,
            activityParticipants: res.data![i].activityParticipants,
            activityParticipantsCount: res.data![i].activityParticipantsCount,
          ),
        );
      }
    } else if (res is FetchSavedActivitiesModel) {
      for (var i = 0; i < res.data!.length; i++) {
        postsOrActivities.add(
          PostOrActivity(
              activityId: res.data![i].activityId,
              groupId: res.data![i].activity!.groupId,
              id: res.data![i].id,
              userId: res.data![i].userId,
              activityName: res.data![i].activity!.activityName,
              activityAbout: "", //res.data![i].activity!.activityAbout,
              activityDate: getDate(res.data![i].activity!.activityDate),
              location: getLocation(
                  "${res.data![i].activity!.lat} ${res.data![i].activity!.long}"),
              group: res.data![i].activity!.group,
              members: res.data![i].userInfoData,
              markers: getLocation(
                          "${res.data![i].activity!.lat} ${res.data![i].activity!.long}")
                      .isNotEmpty
                  ? List.filled(
                      1,
                      Marker(
                          width: 40.w,
                          height: 40.h,
                          point: LatLng(
                              getLocation(
                                      "${res.data![i].activity!.lat} ${res.data![i].activity!.long}")[
                                  0],
                              getLocation(
                                  "${res.data![i].activity!.lat} ${res.data![i].activity!.long}")[1]),
                          builder: ((context) {
                            return Image.asset(
                              AppIcons.marker,
                            );
                          })))
                  : List.empty(growable: true),
              isSaved: res.data![i].activity!.isActivitySaved ?? false,
              isJoinedActivity: res.data![i].activity!.isJoinedActivity,
              isInvited: res.data![i].activity!.isInvited,
              isMember: res.data![i].activity!.isMember,
              activityParticipants: List.empty(growable: true),
              activityParticipantsCount: "0"),
        );
      }
    } else if (res is ActivityDetailsModel) {
      postsOrActivities.add(
        PostOrActivity(
            activityId: res.data!.id,
            groupId: res.data!.groupId,
            id: res.data!.id,
            userId: res.data!.userId,
            activityName: res.data!.activityName,
            activityAbout: res.data!.activityAbout,
            activityDate: (res.data!.activityDate),
            location: getLocation("${res.data!.lat} ${res.data!.long}"),
            members: [],
            spotsLeft: res.data!.spotsLeft,
            markers:
                getLocation("${res.data!.lat} ${res.data!.long}").isNotEmpty
                    ? List.filled(
                        1,
                        Marker(
                            width: 40.w,
                            height: 40.h,
                            point: LatLng(
                                getLocation(
                                    "${res.data!.lat} ${res.data!.long}")[0],
                                getLocation(
                                    "${res.data!.lat} ${res.data!.long}")[1]),
                            builder: ((context) {
                              return Image.asset(
                                AppIcons.marker,
                              );
                            })))
                    : List.empty(growable: true),
            isSaved: res.data!.isActivitySaved,
            isInvited: res.data!.isInvited,
            isMember: res.data!.isMember,
            isJoinedActivity: res.data!.isJoinedActivity,
            activityParticipants: List.empty(growable: true),
            activityParticipantsCount: res.data!.activityParticipantsCount,
            ageRequirement: res.data!.ageRequirement,
            byApproval: res.data!.byApproval,
            coverImage: res.data!.coverImage,
            category: res.data!.category,
            createdAt: res.data!.createdAt,
            limitParticipants: res.data!.limitParticipants,
            privateActivity: res.data!.privateActivity,
            host: res.data!.activityHost,
            role: res.data!.role),
      );
    } else if (res is MapTappedActivityModel) {
      for (var i = 0; i < res.data!.length; i++) {
        postsOrActivities.add(
          PostOrActivity(
              activityId: res.data![i].id.toString(),
              groupId: res.data![i].groupId.toString(),
              id: res.data![i].id,
              userId: res.data![i].userId,
              activityName: res.data![i].activityName,
              activityAbout: res.data![i].activityAbout,
              activityDate: getDate(res.data![i].activityDate),
              location: getLocation("${res.data![i].lat} ${res.data![i].long}"),
              group: res.data![i].group,
              members: res.data![i].activityParticipants,
              markers: getLocation("${res.data![i].lat} ${res.data![i].long}")
                      .isNotEmpty
                  ? List.filled(
                      1,
                      Marker(
                          width: 40.w,
                          height: 40.h,
                          point: LatLng(
                              getLocation(
                                      "${res.data![i].lat} ${res.data![i].long}")[
                                  0],
                              getLocation(
                                  "${res.data![i].lat} ${res.data![i].long}")[1]),
                          builder: ((context) {
                            return Image.asset(
                              AppIcons.marker,
                            );
                          })))
                  : List.empty(growable: true),
              isSaved: res.data![i].isActivitySaved,
              isJoinedActivity: res.data![i].isJoinedActivity,
              isInvited: res.data![i].isInvited,
              isMember: res.data![i].isMember,
              activityParticipants: res.data![i].activityParticipants,
              activityParticipantsCount: res.data![i].activityParticipantsCount,
              coverImage: res.data![i].coverImage.toString()),
        );
      }
    } else if (res is ActivitySearchModel) {
      for (int i = 0; i < res.data!.length; i++) {
        postsOrActivities.add(PostOrActivity(
            activityId: res.data![i].id.toString(),
            activityDate: DateFormat("dd, MMM, yyyy")
                .format(DateTime.parse(res.data![i].activityDate!)),
            activityName: res.data![i].activityName.toString(),
            group: res.data![i].group ?? "N/A",
            coverImage: res.data![i].coverImage.toString()));
      }
    }

    //isJoined missing in byUser
    //isSaved missing in details

    return PostOrActivityModel(
        message: res.message,
        status: res.status,
        postsOrActivities: postsOrActivities);
  }

  static List<double> getLocation(String? location) {
    if (isValidString(location)) {
      if (location!.split(" ").length > 1) {
        if (double.tryParse(location.split(" ")[0]) != null &&
            double.tryParse(location.split(" ")[1]) != null) {
          return [
            double.parse(location.split(" ")[0]),
            double.parse(location.split(" ")[1])
          ];
        } else {
          return [];
        }
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  static String getDate(String? activityDate) {
    try {
      if (isValidString(activityDate)) {
        return DateFormat("EEE, dd MMMM • hh.mm a")
            .format(DateTime.parse(activityDate!));
      } else {
        return activityDate.toString();
      }
    } catch (e) {
      return activityDate.toString();
    }
  }
}

class PostOrActivity {
  PostOrActivity(
      {
      //Common
      this.id,
      this.userId,
      this.activityId,
      this.groupId,

      //Posts
      this.text,
      this.postDate,
      this.attachment,
      this.document,
      this.topicTags,
      this.userTags,
      this.visible,
      this.createdAt,
      this.updatedAt,
      this.isLiked,
      this.isJioMe,
      this.likeCount,
      this.commentCount,
      this.userInfo,
      this.tagUserInfo,
      this.jioMeUserInfo,
      this.activityData,

      //Activities
      this.activityName,
      this.activityAbout,
      this.activityDate,
      this.location,
      this.group,
      this.members,
      this.markers,
      this.activityParticipantsCount,
      this.activityParticipants,
      this.ageRequirement,
      this.byApproval,
      this.coverImage,
      this.category,
      this.isSaved,
      this.isJoinedActivity,
      this.isInvited,
      this.isMember,
      this.limitParticipants,
      this.privateActivity,
      this.isActivitySaved,
      this.mode,
      this.host,
      this.spotsLeft,
      this.activityHost,
      this.role});

  //Common
  int? id;
  int? userId;
  dynamic activityId;
  dynamic groupId;
  bool? isActivitySaved;
  UserData? activityHost;
  //Posts
  String? text;
  String? postDate;
  List<Attachment>? attachment;
  List<Document>? document;
  dynamic topicTags;
  List<int>? userTags;
  String? visible;
  String? createdAt;
  dynamic updatedAt;
  int? isLiked;
  int? likeCount;
  int? commentCount;
  int? isJioMe;
  UserInfo? userInfo;
  TagUserInfo? tagUserInfo;
  List<JioMeUserInfo>? jioMeUserInfo;
  Map? activityData;

  //Activities
  String? activityName;
  String? activityAbout;
  String? mode;
  String? activityDate;
  List<double>? location = List.empty(growable: true);
  dynamic group;
  List<ActivityParticipant>? members = List.empty(growable: true);
  List<Marker>? markers = List.empty(growable: true);
  bool? isSaved;
  dynamic activityParticipantsCount;
  List<ActivityParticipant>? activityParticipants = List.empty(growable: true);
  String? ageRequirement;
  bool? byApproval;
  String? coverImage;
  List<Category>? category;
  bool? isJoinedActivity;
  bool? isInvited;
  bool? isMember;
  bool? limitParticipants;
  bool? privateActivity;
  String? spotsLeft;
  ActivityHost? host;
  String? role;
}

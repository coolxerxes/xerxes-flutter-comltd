import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/view/account_setting_screen_view.dart';
import 'package:jyo_app/view/activity_details_screen_view.dart';
import 'package:jyo_app/view/activity_participants_screen_view.dart';
import 'package:jyo_app/view/base_screen_view.dart';
import 'package:jyo_app/view/birthday_screen_view.dart';
import 'package:jyo_app/view/blocked_user_screen_view.dart';
import 'package:jyo_app/view/chat_screen_view.dart';
import 'package:jyo_app/view/choose_location_on_map_screen_view.dart';
import 'package:jyo_app/view/create_activity_screen2_view.dart';
import 'package:jyo_app/view/create_group_screen_view.dart';
import 'package:jyo_app/view/create_post_screen_view.dart';
import 'package:jyo_app/view/delete_acc_screen_view.dart';
import 'package:jyo_app/view/display_name_view.dart';
import 'package:jyo_app/view/edit_profile_screen_view.dart';
import 'package:jyo_app/view/freindlist_screen_view.dart';
import 'package:jyo_app/view/friend_user_profile_screen_view.dart';
import 'package:jyo_app/view/full_screen_image_carousal_view.dart';
import 'package:jyo_app/view/gender_screen_view.dart';
import 'package:jyo_app/view/group_details_screen_view.dart';
import 'package:jyo_app/view/group_list_screen_view.dart';
import 'package:jyo_app/view/group_suggestion_view.dart';
import 'package:jyo_app/view/list_of_save_activities_screen_view.dart';
import 'package:jyo_app/view/login_view.dart';
import 'package:jyo_app/view/message_screen_view.dart';
import 'package:jyo_app/view/most_liked_screen_view.dart';
import 'package:jyo_app/view/notification_screen_view.dart';
import 'package:jyo_app/view/otp_screen_view.dart';
import 'package:jyo_app/view/phone_number_screen.dart';
import 'package:jyo_app/view/post_privacy_screen_view.dart';
import 'package:jyo_app/view/push_notification_screen_view.dart';
import 'package:jyo_app/view/qr_screen_view.dart';
import 'package:jyo_app/view/search_screen_view.dart';
import 'package:jyo_app/view/set_profile_pic_screen_view.dart';
import 'package:jyo_app/view/single_post_screen_view.dart';
import 'package:jyo_app/view/splash_screen_view.dart';
import 'package:jyo_app/view/voucher_details_screen_view.dart';
import 'package:jyo_app/view/voucher_screen_view.dart';
import 'package:pushy_flutter/pushy_flutter.dart';
import '../utils/bindings/user_binding.dart';
import '../utils/dialog_service/dialog_service.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import 'firebase_options.dart';
import 'view/create_activity_screen_view.dart';

// Please place this code in main.dart,
// After the import statements, and outside any Widget class (top-level)

@pragma('vm:entry-point')
void backgroundNotificationListener(Map<String, dynamic> data) async {
  // Print notification payload data
  debugPrint('Received notification: $data');

  //{__json: {"message":"Logout"}, message: Logout}
  debugPrint("Noti message -> ${data["message"]}");
  try {
    if (data["message"].toString() == "Logout") {
      logoutTo(loginScreenRoute);
    }
  } catch (e) {
    debugPrint("Noti exp ${e.toString()}");
  } finally {}

  // Notification title
  String notificationTitle = 'MyApp';

  // Attempt to extract the "message" property from the payload: {"message":"Hello World!"}
  String notificationText = data['message'] ?? 'Hello World!';

  // Android: Displays a system notification
  // iOS: Displays an alert dialog
  Pushy.notify(notificationTitle, notificationText, data);

  // Clear iOS app badge number
  Pushy.clearBadge();
}

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
}

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context1, child) {
        return GetMaterialApp(
          title: 'Jio You Out',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.amber,
          ),
          getPages: [
            GetPage(
                name: splashScreenRoute,
                page: () => const SplashView(),
                binding: SplashBinding()),
            GetPage(
                name: loginScreenRoute,
                page: () => const LoginView(),
                binding: LoginBinding()),
            GetPage(
                name: phoneNumberRoute,
                page: () => const PhoneNumberView(),
                binding: PhoneNumberBinding()),
            GetPage(
                name: genderRoute,
                page: () => const GenderView(),
                binding: GenderBinding()),
            GetPage(
                name: displayNameRoute,
                page: () => const DisplayNameView(),
                binding: DisplayNameBinding()),
            GetPage(
                name: birthdayScreenRoute,
                page: () => const BirthdayScreenView(),
                binding: BirthdayScreenBinding()),
            GetPage(
                name: setProfilePicScreenRoute,
                page: () => const SetProfilePicScreenView(),
                binding: SetProfilePicScreenBinding()),
            GetPage(
                name: mostLikedScreenRoute,
                page: () => const MostLikedScreenView(),
                binding: MostLikedScreenBinding()),
            GetPage(
                name: groupSuggestionScreenRoute,
                page: () => const GroupSuggestionScreenView(),
                binding: GroupSuggestionScreenBinding()),
            GetPage(
                name: otpScreenRoute,
                page: () => const OtpScreenView(),
                binding: OtpScreenBinding()),
            GetPage(
                name: baseScreenRoute,
                page: () => const BaseScreenView(),
                binding: BaseScreenBinding()),
            GetPage(
                name: editProfileScreenRoute,
                page: () => const EditProfileScreenView(),
                binding: EditProfileScreenBinding()),
            GetPage(
                name: accountSettingScreenRoute,
                page: () => const AccountSettingScreenView(),
                binding: AccountSettingScreenBinding()),
            GetPage(
                name: postPrivacyRoute,
                page: () => const PostPrivacyScreenView(),
                binding: PostPrivacyScreenBinding()),
            GetPage(
                name: pushNotificationRoute,
                page: () => const PushNotificaitonScreenView(),
                binding: PushNotificationScreenBinding()),
            GetPage(
                name: blockedUserRoute,
                page: () => const BlockedUserScreenView(),
                binding: BlockedUserScreenBinding()),
            GetPage(
                name: deleteAccRoute,
                page: () => const DeleteAccScreenView(),
                binding: DeleteAccScreenBinding()),
            GetPage(
                name: voucherScreenRoute,
                page: () => const VoucherScreenView(),
                binding: VoucherScreenBinding()),
            GetPage(
                name: voucherDetailScreenRoute,
                page: () => const VoucherDetailScreenView(),
                binding: VoucherDetailScreenBinding()),
            GetPage(
                name: friendlistScreenRoute,
                page: () => const FreindlistScreenView(),
                binding: FreindlistScreenBinding()),
            GetPage(
                name: createPostScreenRoute,
                page: () => const CreatePostScreenView(),
                binding: CreatePostBinding()),
            GetPage(
                name: fullScreenImageViewRoute,
                page: () => const FullScreenImageCarousalView(),
                binding: FullScreenImageCarousalBinding()),
            GetPage(
                name: searchScreenRoute,
                page: () => const SearchScreenView(),
                binding: SearchScreenBinding()),
            GetPage(
                name: notificationScreenRoute,
                page: () => const NotificationScreenView(),
                binding: NotificationScreenBinding()),
            GetPage(
                name: friendUserProfileScreeRoute,
                page: () => const FriendUserProfileScreenView(),
                binding: FriendUserProfileScreenBinding()),
            GetPage(
                name: singlePostScreenRoute,
                page: () => const SinglePostScreenView(),
                binding: SinglePostScreenBinding()),
            GetPage(
                name: chatScreenRoute,
                page: () => const ChatScreenView(),
                binding: ChatScreenBinding()),
            GetPage(
                name: createActivityScreenRoute,
                page: () => const CreateActivityScreenView(),
                binding: CreateActivityBinding()),
            GetPage(
                name: createActivityScreen2Route,
                page: () => const CreateActivityScreen2View(),
                binding: CreateActivityBinding()),
            GetPage(
                name: chooseLocationOnMapScreenRoute,
                page: () => const ChooseLocationOnMapScreenView(),
                binding: CreateActivityBinding()),
            GetPage(
                name: createGroupScreenRoute,
                page: () => const CreateGroupScreenView(),
                binding: CreateGroupBinding()),
            GetPage(
                name: groupListScreenRoute,
                page: () => const GroupListScreenView(),
                binding: GroupListBinding()),
            GetPage(
                name: groupDetailsScreenRoute,
                page: () => const GroupDetailsScreenView(),
                binding: GroupDetailsBinding()),
            GetPage(
                name: listOfSavedActivitiesScreenRoute,
                page: () => const ListOfSaveActivitesScreenView(),
                binding: ListOfSaveActivitiesBinding()),
            GetPage(
                name: activityDetailsScreenRoute,
                page: () => const ActivityDetailsScreeView(),
                binding: ActivityDetailsBinding()),
            GetPage(
                name: activityParticipantsScreenRoute,
                page: () => const ActivityParticipantsScreenView()),
            GetPage(
                name: qrScreenRoute,
                page: () => const QrScreenView(),
                binding: QRScreenBinding()),
            GetPage(
              name: messageScreenRoute,
              page: () => const MessageScreenView(),
              binding: MessageScreenBinding(),
            )
          ],
          initialRoute: splashScreenRoute,
          navigatorKey: locator<NavigationService>().navigatoryKey,
        );
      },
      designSize: const Size(414, 896),
    );
  }
}

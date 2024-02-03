import 'package:get/get.dart';
import 'package:jyo_app/view_model/activity_details_screen_vm.dart';
import 'package:jyo_app/view_model/birthday_screen_vm.dart';
import 'package:jyo_app/view_model/calendar_srceen_vm.dart';
import 'package:jyo_app/view_model/create_activity_screen_vm.dart';
import 'package:jyo_app/view_model/freindlist_screen_vm.dart';
import 'package:jyo_app/view_model/most_liked_screen_vm.dart';
import 'package:jyo_app/view_model/otp_screen_vm.dart';
import 'package:jyo_app/view_model/phone_number_vm.dart';
import 'package:jyo_app/view_model/qr_screen_vm.dart';
import 'package:jyo_app/view_model/splash_vm.dart';
import '../../view_model/account_setting_screen_vm.dart';
import '../../view_model/base_screen_vm.dart';
import '../../view_model/blocked_user_screen_vm.dart';
import '../../view_model/chat_screen_vm.dart';
import '../../view_model/create_group_screen_vm.dart';
import '../../view_model/create_post_screen_vm.dart';
import '../../view_model/delete_acc_screen_vm.dart';
import '../../view_model/display_name_vm.dart';
import '../../view_model/edit_profile_screen_vm.dart';
import '../../view_model/explore_screen_vm.dart';
import '../../view_model/freind_user_profile_screen_vm.dart';
import '../../view_model/full_screen_image_carousal_vm.dart';
import '../../view_model/gender_screen_vm.dart';
import '../../view_model/group_details_screen_vm.dart';
import '../../view_model/group_list_screen_vm.dart';
import '../../view_model/group_suggestion_screen_vm.dart';
import '../../view_model/list_of_save_activites_screen_vm.dart';
import '../../view_model/login_vm.dart';
import '../../view_model/message_screen_vm.dart';
import '../../view_model/notification_screen_vm.dart';
import '../../view_model/post_privacy_screen_vm.dart';
import '../../view_model/profile_screen_vm.dart';
import '../../view_model/push_notification_screen_vm.dart';
import '../../view_model/search_screen_vm.dart';
import '../../view_model/set_profile_pic_screen_vm.dart';
import '../../view_model/single_post_screen_vm.dart';
import '../../view_model/timeline_screen_vm.dart';
import '../../view_model/voucher_details_screen_vm.dart';
import '../../view_model/voucher_screen_vm.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashVM());
  }
}

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginVM());
  }
}

class PhoneNumberBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PhoneNumberVM());
  }
}

class DisplayNameBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DisplayNameVM());
  }
}

class GenderBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GenderVM());
  }
}

class BirthdayScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BirthdayScreenVM());
  }
}

class SetProfilePicScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SetProfilePicScreenVM());
  }
}

class MostLikedScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MostLikedScreenVM());
    Get.put(GroupSuggestionScreenVM());
  }
}

class GroupSuggestionScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GroupSuggestionScreenVM());
  }
}

class OtpScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OtpScreenVM());
  }
}

class BaseScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BaseScreenVM());
  }
}

class ProfileScreenBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put(PostsAndActivitiesVM());
    Get.put(ProfileScreenVM());
  }
}

class EditProfileScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(EditProfileScreenVM());
  }
}

class AccountSettingScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AccountSettingScreenVM());
  }
}

class PostPrivacyScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PostPrivacyScreenVM());
  }
}

class PushNotificationScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PushNotificationScreenVM());
  }
}

class BlockedUserScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BlockedUserScreenVM());
  }
}

class DeleteAccScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DeleteAccScreenVM());
  }
}

class ExploreScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ExploreScreenVM());
  }
}

class VoucherScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(VoucherScreenVM());
  }
}

class VoucherDetailScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(VoucherDetailScreenVM());
  }
}

class FreindlistScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FriendlistScreenVM());
  }
}

class TimelineScreenBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put(PostsAndActivitiesVM());
    Get.put(TimelineScreenVM());
  }
}

class CreatePostBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CreatePostScreenVM());
  }
}

class FullScreenImageCarousalBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FullScreenImageCarousalVM());
  }
}

class SearchScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SearchScreenVM());
  }
}

class FriendUserProfileScreenBinding extends Bindings {
  @override
  void dependencies() {
    //Get.put(PostsAndActivitiesVM());
    Get.put(FriendUserProfileScreenVM());
  }
}

class NotificationScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NotificationScreenVM());
  }
}

class MessageScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MessageScreenVM());
  }
}

class SinglePostScreenBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put(PostsAndActivitiesVM());
    Get.put(SinglePostScreenVM());
  }
}

class ChatScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ChatScreenVM());
  }
}

class CalendarBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CalendarScreenVM());
  }
}

class CreateActivityBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CreateActivityScreenVM());
  }
}

class CreateGroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CreateGroupScreenVM());
  }
}

class GroupListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GroupListScreenVM());
  }
}

class GroupDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GroupDetailsScreenVM());
  }
}

class ListOfSaveActivitiesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ListOfSaveActivitiesScreenVM());
  }
}

class ActivityDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ActivityDetailsScreenVM());
  }
}

class QRScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(QrScreenVM());
  }
}

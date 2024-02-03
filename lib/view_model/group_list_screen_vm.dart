import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jyo_app/repository/group_repo/group_repo_impl.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/utils/secured_storage.dart';
import 'package:jyo_app/view/group_list_screen_view.dart';

import '../models/group_suggestion_model/group_list_model.dart';

class GroupListScreenVM extends GetxController {
  GroupRepoImpl groupRepoImpl = GroupRepoImpl();
  int groupSelection = GroupSelection.myGroup;

  String userId = "";
  List<GroupData> groups = List.empty(growable: true);
  List<GroupData> pendingGroups = List.empty(growable: true);

  Future<void> init() async {
    userId = (await SecuredStorage.readStringValue(Keys.userId))!;
    await getMyGroups(status: GroupStatus.approved);
    await getMyGroups(status: GroupStatus.pending);
  }

  Future<void> getMyGroups({String? status = GroupStatus.approved}) async {
    await groupRepoImpl
        .getGroupList({"userId": userId, "groupStatus": status}).then((res) {
      if (res.status == 200) {
        if (status == GroupStatus.approved) {
          groups.clear();
          groups.addAll(res.data!);
        } else {
          pendingGroups.clear();
          pendingGroups.addAll(res.data!);
        }
        update();
      } else {
        showAppDialog(msg: res.message);
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }

  @override
  void onInit() {
    super.onInit();
    init();
  }
}

class GroupStatus {
  static const approved = "Approved";
  static const pending = "Pending";
}

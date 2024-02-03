import '../../models/group_suggestion_model/group_details_model.dart';

class GroupEdit {
  static GroupDetail? group;

  static GroupDetail? get getGroup => GroupEdit.group;
  static set setGroup(GroupDetail? group) => GroupEdit.group = group;
}

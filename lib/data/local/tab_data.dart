class Tab {
  Tab({this.index, this.text, this.showBadge = false});

  int? index;
  String? text;
  bool? showBadge;
}

class ActivityTabs {
  static const commentTab = 0;
  static const requestTab = 1;
}

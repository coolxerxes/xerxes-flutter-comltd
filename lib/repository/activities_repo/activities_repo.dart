import 'package:jyo_app/view_model/calendar_srceen_vm.dart';

abstract class ActivitiesRepo {
  Future<List<CalendarData>> getCalendarEvents(Map data);
}

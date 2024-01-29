import '../../models/posts_model/timeline_model.dart';

class Attachements {
  static List<Attachment>? attachements = List.empty(growable: true);
 
 static List<Attachment>? get getAttachements => Attachements.attachements;
 static set setAttachements(attachements) => Attachements.attachements = attachements;

}

import 'package:cloud_firestore/cloud_firestore.dart';

class LessonNotes {
  late String id;
  late String lessonID;
  late String note;

  LessonNotes({required this.note});

  LessonNotes.fromSnapshot(Map<String, dynamic> map) {
    id = map['id'];
    lessonID = map['lessonID'];
    note = map['notes'];
  }

  Map<String, dynamic> toJson() {
    return {
      'lessonID': lessonID,
      'note': note,
      'timestamp': FieldValue.serverTimestamp()
    };
  }
}

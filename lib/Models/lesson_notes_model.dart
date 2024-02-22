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
      'id': id,
      'lessonID': lessonID,
      'note': note,
    };
  }
}

class LessonModel {
  late String id;
  late String subjectID;
  late int weekNum;
  late String title;
  //late List<String> notes;
  bool isDone = false;

  LessonModel({required this.title, required this.weekNum});

  LessonModel.fromSnapshot(Map lessons) {
    subjectID = lessons['subjectID'];
    weekNum = lessons['weekNum'];
    title = lessons['title'];
    isDone = lessons['isDone'];
    //notes = lessons['notes'];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'subjectID': subjectID,
      'weekNum': weekNum,
      'title': title,
      'isDone': isDone,
      //'notes': notes,
    };
  }
}

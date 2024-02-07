import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectModel {
  late String id;
  late String name;
  int completedLessonsNum = 0;
  int allLessonNum = 0;
  int progress = 0;

  SubjectModel({required this.name});

  SubjectModel.fromSnapshot(Map subjectMap) {
    name = subjectMap['name'];
    completedLessonsNum = subjectMap['completedLessonsNum'];
    allLessonNum = subjectMap['allLessonNum'];
    progress = subjectMap['progress'];
  }

  Map<String,dynamic> toJson() {
    return <String,dynamic>{
      "name" : name ,
      "progress" : progress,
      "completedLessonsNum" : completedLessonsNum,
      "allLessonNum" : allLessonNum,
      'timestamp': FieldValue.serverTimestamp()
    };
  }
}
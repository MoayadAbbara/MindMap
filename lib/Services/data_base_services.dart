import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mind_map/Models/lesson_model.dart';
import 'package:mind_map/Models/subject_model.dart';

class DatabaseService {
  final _db = FirebaseFirestore.instance;

  void addSubject(String name) async {
    SubjectModel sub = SubjectModel(name: name);
    await _db.collection("Subject").add(sub.toJson());
  }

  Stream<List<SubjectModel>> getSubjectStream() {
    return _db
        .collection("Subject")
        .orderBy("timestamp", descending: false)
        .snapshots()
        .map((snapshot) {
      List<SubjectModel> subjectList = [];
      for (DocumentSnapshot doc in snapshot.docs) {
        SubjectModel subject = SubjectModel(name: doc['name']);
        subject.allLessonNum = doc['allLessonNum'];
        subject.completedLessonsNum = doc['completedLessonsNum'];
        subject.progress = doc['progress'];
        subject.id = doc.id;
        subjectList.add(subject);
      }
      return subjectList;
    });
  }

  Stream<SubjectModel> getSubjectWithID(String id) {
    return _db.collection("Subject").doc(id).snapshots().map((snapshot) {
      Map<String, dynamic> data = snapshot.data()!;
      SubjectModel subject = SubjectModel(name: data['name']);
      subject.allLessonNum = data['allLessonNum'];
      subject.id = id;
      subject.completedLessonsNum = data['completedLessonsNum'];
      subject.allLessonNum = data['allLessonNum'];
      subject.progress = data['progress'];
      return subject;
    });
  }

  Future<void> changeProgress(
      SubjectModel subject, bool isNew, bool increment) async {
    if (increment & isNew) {
      _db.collection('Subject').doc(subject.id).update({
        'allLessonNum': ++subject.allLessonNum,
        'progress':
            (subject.completedLessonsNum / subject.allLessonNum * 100).toInt()
      });
    } else if (!increment & isNew) {
      _db.collection('Subject').doc(subject.id).update({
        'allLessonNum': --subject.allLessonNum,
        'progress':
            (subject.completedLessonsNum / subject.allLessonNum * 100).toInt()
      });
    } else if (increment & !isNew) {
      _db.collection('Subject').doc(subject.id).update({
        'completedLessonsNum': ++subject.completedLessonsNum,
        'progress':
            (subject.completedLessonsNum / subject.allLessonNum * 100).toInt()
      });
    } else if (!increment & !isNew) {
      _db.collection('Subject').doc(subject.id).update({
        'completedLessonsNum': --subject.completedLessonsNum,
        'progress':
            (subject.completedLessonsNum / subject.allLessonNum * 100).toInt()
      });
    }
  }

  Future<void> addLesson(int weekNum, String title, String subjectID) async {
    LessonModel lesson = LessonModel(title: title, weekNum: weekNum);
    lesson.subjectID = subjectID;
    await _db.collection('Lesson').add(lesson.toJson());
  }

  Stream<List<LessonModel>> getLessonStream(String subjectID) {
    return _db
        .collection("Lesson")
        .orderBy('weekNum')
        .where('subjectID', isEqualTo: subjectID)
        .snapshots()
        .map((snapshot) {
      List<LessonModel> lessonList = [];
      for (DocumentSnapshot doc in snapshot.docs) {
        LessonModel lesson =
            LessonModel(title: doc['title'], weekNum: doc['weekNum']);
        lesson.isDone = doc['isDone'];
        lesson.subjectID = doc['subjectID'];
        lesson.id = doc.id;
        lessonList.add(lesson);
      }
      return lessonList;
    });
  }

  Future<void> checkLesson(String lessonID, bool isChecked) async {
    _db.collection('Lesson').doc(lessonID).update({'isDone': isChecked});
  }

/*
Future<SubjectModel> getSubjectWithID(String id) async{
  final snapshot = await _db.collection("Subject").doc(id).get();
  Map<String,dynamic> data= snapshot.data()!;
  SubjectModel subject = SubjectModel(name: data['name']);
  subject.allLessonNum = data['allLessonNum'];
  subject.id = id;
  subject.completedLessonsNum = data['completedLessonsNum'];
  subject.allLessonNum = data['allLessonNum'];
  subject.allLessonNum = data['allLessonNum'];
  return subject;
}
 */
}

import 'package:flutter/material.dart';
import 'package:mind_map/Views/subject_details.dart';

class SubjectCard extends StatelessWidget {
  final String id;
  final String name;
  final int completedLessonsNum;
  final int allLessonNum;
  const SubjectCard({super.key, required this.name, required this.completedLessonsNum, required this.allLessonNum, required this.id});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        tileColor: const Color.fromARGB(230, 115, 179, 220),
        title: Padding(
          padding: const EdgeInsets.fromLTRB(8.0,0,0,0),
          child: Text(name),
        ),
        trailing: Text('${completedLessonsNum.toString()}/${allLessonNum.toString()}'),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SubjectDetails(id : id)));
        },
      ),
    );
  }
}
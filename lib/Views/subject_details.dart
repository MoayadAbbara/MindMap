import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mind_map/Models/lesson_model.dart';
import 'package:mind_map/Models/subject_model.dart';
import 'package:mind_map/Services/database_services.dart';
import 'package:mind_map/utils/lesson_card.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class SubjectDetails extends StatefulWidget {
  final String id;

  const SubjectDetails({Key? key, required this.id}) : super(key: key);

  @override
  State<SubjectDetails> createState() => _SubjectDetailsState();
}

class _SubjectDetailsState extends State<SubjectDetails> {
  late TextEditingController _weekNumController;
  late TextEditingController _titleController;
  late Stream<SubjectModel> subjectStream;
  late String id;
  late Stream<List<LessonModel>> lessonsStream;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    subjectStream = DatabaseService().getSubjectWithID(id);
    _weekNumController = TextEditingController();
    _titleController = TextEditingController();
    lessonsStream = DatabaseService().getLessonStream(widget.id);
  }

  @override
  void dispose() {
    super.dispose();
    _weekNumController.dispose();
    _titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: subjectStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(snapshot.data!.name),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (_) => CupertinoAlertDialog(
                        title: const Text('Test'),
                        content: Card(
                          color: Colors.transparent,
                          elevation: 0.0,
                          child: Column(
                            children: <Widget>[
                              TextField(
                                decoration: const InputDecoration(
                                  labelText: "Week No",
                                ),
                                controller: _weekNumController,
                              ),
                              TextField(
                                decoration: const InputDecoration(
                                  labelText: "Title",
                                ),
                                controller: _titleController,
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          CupertinoDialogAction(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                          CupertinoDialogAction(
                            onPressed: () {
                              if (_weekNumController.text.isNotEmpty &&
                                  _titleController.text.isNotEmpty) {
                                DatabaseService().addLesson(
                                    int.parse(_weekNumController.text),
                                    _titleController.text,
                                    id);
                                _weekNumController.clear();
                                _titleController.clear();
                                DatabaseService()
                                    .changeProgress(snapshot.data!, true, true);
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Add'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Add Week'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text('You Have Finished : '),
                      Text(snapshot.data!.completedLessonsNum.toString()),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text('Total Number of Lessons is : '),
                      Text(snapshot.data!.allLessonNum.toString()),
                    ],
                  ),
                ),
                CircularPercentIndicator(
                  radius: 45.0,
                  lineWidth: 8.0,
                  percent: snapshot.data!.progress / 100,
                  animation: true,
                  animationDuration: 1500,
                  center: Text(snapshot.data!.progress.toString()),
                  progressColor: Colors.green,
                  backgroundColor: Colors.red,
                ),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder(
                  stream: lessonsStream,
                  builder: (context, lessonSnapshot) {
                    if (lessonSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: lessonSnapshot.data!.length,
                          itemBuilder: (context, index) {
                            return LessonCard(
                              id: lessonSnapshot.data![index].id,
                              title: lessonSnapshot.data![index].title,
                              isDone: lessonSnapshot.data![index].isDone,
                              subject: snapshot.data!,
                              weeknum: lessonSnapshot.data![index].weekNum,
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

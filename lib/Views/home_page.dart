import 'package:flutter/material.dart';
import 'package:mind_map/Models/subject_model.dart';
import 'package:mind_map/Services/database_services.dart';
import 'package:mind_map/utils/subject_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  late TextEditingController _name;
  late Stream<List<SubjectModel>> subjectList;

  @override
  void initState() {
    super.initState();
    subjectList = DatabaseService().getSubjectStream();
    _name = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(252, 255, 255, 255),
      appBar: AppBar(
        title: const Text('MindMap'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(230, 115, 179, 220),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Subject Name',
              ),
              controller: _name,
            ),
            TextButton(
              onPressed: () {
                if (_name.text.isNotEmpty) {
                  DatabaseService().addSubject(_name.text);
                  _name.clear();
                }
              },
              child: const Text('Add'),
            ),
            StreamBuilder(
              stream: subjectList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return SubjectCard(
                          name: snapshot.data![index].name,
                          completedLessonsNum:
                              snapshot.data![index].completedLessonsNum,
                          allLessonNum: snapshot.data![index].allLessonNum,
                          id: snapshot.data![index].id,
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

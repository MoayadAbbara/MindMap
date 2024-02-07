import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mind_map/Models/lesson_model.dart';
import 'package:mind_map/Models/subject_model.dart';
import 'package:mind_map/Services/data_base_services.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class SubjectDetails extends StatefulWidget {
  final String id;
  const SubjectDetails({super.key , required this.id});

  @override
  State<SubjectDetails> createState() => _SubjectDetailsState();
}

class _SubjectDetailsState extends State<SubjectDetails> {
  late TextEditingController _weekNumController;
  late TextEditingController _titleController;
  late Stream<SubjectModel>  subjectStrem;
  late String id;
  late Stream<List<LessonModel>> lessonsStream;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    subjectStrem = DatabaseService().getSubjectWithID(id);
    _weekNumController = TextEditingController();
    _titleController  = TextEditingController();
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
    return StreamBuilder(stream: subjectStrem, 
    builder: (context,snapshot){
      if(snapshot.connectionState == ConnectionState.waiting)
      {
        return const CircularProgressIndicator();
      }
      else
      {
        return Scaffold(
          appBar: AppBar(
            title: Text(snapshot.data!.name),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton(
                onPressed: (){
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
                          onPressed: (){Navigator.pop(context);},
                          child: const Text('Canel'),
                          ),
                        CupertinoDialogAction(
                          onPressed: (){
                            if(_weekNumController.text.isNotEmpty && _titleController.text.isNotEmpty)
                            {
                              DatabaseService().addLesson(int.parse(_weekNumController.text), _titleController.text, id);
                              _weekNumController.clear();
                              _titleController.clear();
                              DatabaseService().changeProgress(snapshot.data!,true,true);
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Add'),
                          ),
                      ],
                    ),
                  );
                },
                child: const Text('Add Week')
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
                  percent: snapshot.data!.progress /100,
                  animation: true,
                  animationDuration: 1500,
                  center: Text(snapshot.data!.progress.toString()),
                  progressColor: Colors.green,
                  backgroundColor: Colors.red,
              ),
              const SizedBox(height: 20,),
                StreamBuilder(
            stream: lessonsStream, 
            builder: (context , snapshott){
              if(snapshott.connectionState == ConnectionState.waiting)
              {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              else
              {
                return Expanded(
                  child: ListView.builder(
                  itemCount: snapshott.data!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        tileColor: const Color.fromARGB(230, 115, 179, 220),
                        title: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0,0,0,0),
                          child: Row(
                            children: [
                              Checkbox(
                                value: snapshott.data![index].isDone,
                                activeColor: Colors.green,
                                checkColor: Colors.black, 
                                onChanged: (bool? value){
                                  setState(() {
                                    DatabaseService().checkLesson(snapshott.data![index].id, value!);
                                    if(value)
                                    {
                                      DatabaseService().changeProgress(snapshot.data! ,false ,true);
                                    }
                                    else
                                    {
                                      DatabaseService().changeProgress(snapshot.data! ,false ,false);
                                    }
                                  });
                                }
                              ),
                              Text(
                                snapshott.data![index].title,
                                style: TextStyle(
                                  decoration: snapshott.data![index].isDone ? TextDecoration.lineThrough : TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                        },
                      ),
                    );
                  },
                ),
              );
            }
            }
            )
            ],
          ),
        );
      }
    }
    
    );
  }
}

/**
 * Scaffold(
      appBar: AppBar(
        title:const  Text('Subject Name'),
      ),
      body: Text(data),
    );
 */

import 'package:flutter/material.dart';
import 'package:mind_map/Models/subject_model.dart';
import '../Services/database_services.dart';

class LessonCard extends StatefulWidget {
  final String id;
  final String title;
  final bool isDone;
  final SubjectModel subject;
  final int weeknum;

  const LessonCard({
    Key? key,
    required this.id,
    required this.title,
    required this.isDone,
    required this.subject,
    required this.weeknum,
  }) : super(key: key);

  @override
  State<LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard> {
  late TextEditingController _note;

  @override
  void initState() {
    super.initState();
    _note = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _note.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        backgroundColor: const Color.fromARGB(230, 115, 179, 220),
        collapsedBackgroundColor: const Color.fromARGB(230, 115, 179, 220),
        subtitle: Text(
          widget.title,
          style: TextStyle(
            fontSize: 18,
            decoration: widget.isDone
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        title: Text(
          'Week: ${widget.weeknum}',
          style: const TextStyle(
            fontSize: 13,
            color: Color.fromARGB(204, 81, 81, 81),
          ),
        ),
        leading: Checkbox(
          value: widget.isDone,
          activeColor: Colors.green,
          checkColor: Colors.black,
          onChanged: (bool? value) {
            setState(() {
              DatabaseService().checkLesson(widget.id, value!);
              if (value) {
                DatabaseService().changeProgress(widget.subject, false, true);
              } else {
                DatabaseService().changeProgress(widget.subject, false, false);
              }
            });
          },
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: TextField(
              controller: _note,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    await DatabaseService().addNote(_note.text, widget.id);
                    _note.clear();
                  },
                  color: Colors.black,
                ),
                filled: true,
                fillColor: const Color.fromRGBO(190, 190, 190, 0.492),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.black)),
                hintText: 'Add a Note',
              ),
            ),
          ),
          SizedBox(
            height: 100,
            child: StreamBuilder(
              stream: DatabaseService().getNotesStream(widget.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(93, 0, 13, 255),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        margin: const EdgeInsets.fromLTRB(15, 8, 15, 0),
                        width: double.infinity,
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 8, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                snapshot.data![index].note,
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  size: 30,
                                ),
                                color: const Color.fromARGB(255, 216, 32, 18),
                                onPressed: () async {
                                  await DatabaseService()
                                      .deleteNote(snapshot.data![index].id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return (Container());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

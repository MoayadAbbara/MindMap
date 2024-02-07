import 'package:flutter/material.dart';
import 'package:mind_map/Models/subject_model.dart';
import '../Services/data_base_services.dart';

class LessonCard extends StatefulWidget {
  final String id;
  final String title;
  final bool isDone;
  final SubjectModel subject;

  const LessonCard({
    Key? key,
    required this.id,
    required this.title,
    required this.isDone,
    required this.subject,
  }) : super(key: key);

  @override
  State<LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        tileColor: const Color.fromARGB(230, 115, 179, 220),
        title: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
          child: Row(
            children: [
              Checkbox(
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
              Text(
                widget.title,
                style: TextStyle(
                  decoration: widget.isDone ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
        onTap: () {},
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mind_map/Models/subject_model.dart';
import '../Services/data_base_services.dart';

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
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        backgroundColor: const Color.fromARGB(255, 227, 73, 73),
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
      ),
    );
  }
}

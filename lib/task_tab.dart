import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TaskTab extends StatefulWidget {
  const TaskTab({Key? key, required this.taskList}) : super(key: key);

  final List<TaskInfo> taskList;

  @override
  State<TaskTab> createState() => _TaskTabState();
}

class TaskInfo {
  int id;
  bool completed;
  String title;
  String description;

  TaskInfo({
    required this.id,
    required this.completed,
    required this.title,
    required this.description,
  });
}

class _TaskTabState extends State<TaskTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Column(
          children: [
            ListTile(
              leading: Icon(Icons.face),
              title: Text('title'),
              subtitle: Text('sub title'),
            ),
          ],
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  if (kDebugMode) {
                    print('object');
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('Add'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

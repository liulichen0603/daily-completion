import 'package:daily_completion/data/task_storage.dart';
import 'package:flutter/material.dart';

import '../data/task_info.dart';

class TaskTab extends StatefulWidget {
  const TaskTab({Key? key, required this.taskModelStorage}) : super(key: key);

  final TaskModelStorage taskModelStorage;

  @override
  State<TaskTab> createState() => _TaskTabState();
}

class _TaskTabState extends State<TaskTab> {
  static int _taskId = 0;
  late List<TaskInfo> _taskList;

  @override
  void initState() {
    super.initState();
    _initializeTaskList();
  }

  // Helper function to initialize the task list asynchronously
  Future<void> _initializeTaskList() async {
    _taskList = await widget.taskModelStorage.readTaskList();
    setState(() {
      // Trigger a rebuild after setting the state
    });
  }

  void _addNewTask(TaskInfo newTaskInfo) {
    setState(() {
      newTaskInfo.id = ++_taskId;
      _taskList.add(newTaskInfo);
      _taskList.sort((a, b) {
        if (a.completed == b.completed) {
          return a.id.compareTo(b.id);
        } else {
          return a.completed ? 1 : -1;
        }
      });
      widget.taskModelStorage.writeTaskList(_taskList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: TaskList(taskList: _taskList),
        ),
        const SizedBox(height: 8.0),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: NewTaskButton(
              addNewTaskCallback: _addNewTask,
            ),
          ),
        ),
      ],
    );
  }
}

class TaskList extends StatefulWidget {
  const TaskList({super.key, required this.taskList});

  final List<TaskInfo> taskList;

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  Widget _buildTaskItem(TaskInfo task) {
    return ListTile(
      leading: task.completed
          ? const Icon(Icons.task_alt)
          : const Icon(Icons.circle_outlined),
      title: Text(
        task.title,
        style: task.completed
            ? const TextStyle(
                decoration: TextDecoration.lineThrough,
                decorationThickness: 2.0)
            : const TextStyle(),
      ),
      subtitle: Text(
        task.description,
        style: task.completed
            ? const TextStyle(
                decoration: TextDecoration.lineThrough,
                decorationThickness: 2.0)
            : const TextStyle(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.taskList.length,
        itemBuilder: (context, index) {
          return _buildTaskItem(widget.taskList[index]);
        });
  }
}

class NewTaskButton extends StatefulWidget {
  const NewTaskButton({super.key, required this.addNewTaskCallback});

  final AddNewTaskCallback addNewTaskCallback;

  @override
  State<NewTaskButton> createState() => _NewTaskButtonState();
}

class _NewTaskButtonState extends State<NewTaskButton> {
  Future<void> _showNewTaskPage(BuildContext context) async {
    final TaskInfo? newTaskInfo = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const NewTaskPage()));

    if (!mounted || newTaskInfo == null) return;

    widget.addNewTaskCallback(newTaskInfo);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        _showNewTaskPage(context);
      },
      icon: const Icon(Icons.add),
      label: const Text('Add'),
    );
  }
}

class NewTaskPage extends StatefulWidget {
  const NewTaskPage({super.key});

  @override
  State<NewTaskPage> createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  bool _isCompleted = false;

  void _onClickAdd() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Title cannot be null!'),
          ),
        );
      return;
    }

    TaskInfo newTaskInfo = TaskInfo(
        id: -1,
        completed: _isCompleted,
        title: _titleController.text,
        description: _descController.text);
    Navigator.pop(context, newTaskInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextInputContainer(
              textController: _titleController,
              maxLines: 1,
              labelText: 'Title',
            ),
            TextInputContainer(
                textController: _descController,
                maxLines: 15,
                labelText: 'Description'),
            const SizedBox(height: 6.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  checkColor: Colors.white,
                  value: _isCompleted,
                  onChanged: (bool? value) {
                    setState(() {
                      _isCompleted = value!;
                    });
                  },
                ),
                const Text('Completed'),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _onClickAdd,
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

class TextInputContainer extends StatelessWidget {
  const TextInputContainer(
      {super.key,
      required this.textController,
      required this.maxLines,
      required this.labelText});

  final TextEditingController textController;
  final int maxLines;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[200],
        ),
        child: TextField(
          controller: textController,
          maxLines: maxLines,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(16.0),
            labelText: labelText,
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue, width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            // prefixIcon: const Icon(Icons.message),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                textController.clear();
              },
            ),
          ),
        ),
      ),
    );
  }
}

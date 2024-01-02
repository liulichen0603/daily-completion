import 'package:daily_completion/data/local_storage.dart';
import 'package:daily_completion/data/task_info.dart';
import 'package:flutter/material.dart';

class TaskTab extends StatefulWidget {
  const TaskTab({super.key});

  @override
  State<TaskTab> createState() => _TaskTabState();
}

class _TaskTabState extends State<TaskTab> {
  List<TaskInfo> _taskList = [];
  List<TaskCatagory> _catagoryList = [];

  @override
  void initState() {
    super.initState();
    _initializeTaskList();
  }

  // Helper function to initialize the task list asynchronously
  Future<void> _initializeTaskList() async {
    _taskList = await TaskInfoStorage.getInstance().readTaskList();
    _catagoryList = await TaskCatagoryStorage.getInstance().readCatagoryList();
    setState(() {
      // Trigger a rebuild after setting the state
    });
  }

  void _addNewTask(TaskInfo newTaskInfo) {
    setState(() {
      _taskList.add(newTaskInfo);
      _taskList.sort((a, b) {
        if (a.completed == b.completed) {
          return a.id.compareTo(b.id);
        } else {
          return a.completed ? 1 : -1;
        }
      });
      TaskInfoStorage.getInstance().writeTaskList(_taskList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: TaskList(
            taskList: _taskList,
            catagoryList: _catagoryList,
          ),
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
  const TaskList({
    super.key,
    required this.taskList,
    required this.catagoryList,
  });

  final List<TaskInfo> taskList;
  final List<TaskCatagory> catagoryList;

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  Widget _buildTaskItem(TaskInfo task) {
    String getTaskTitleInfo() {
      TaskCatagory? catagory;
      for (TaskCatagory cata in widget.catagoryList) {
        if (task.catagoryId == cata.id) {
          catagory = cata;
          break;
        }
      }
      return '${catagory?.description} -- ${task.title}';
    }

    return ListTile(
      leading: task.completed
          ? const Icon(Icons.task_alt)
          : const Icon(Icons.circle_outlined),
      title: Text(
        getTaskTitleInfo(),
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
  const NewTaskButton({
    super.key,
    required this.addNewTaskCallback,
  });

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
  final TextEditingController _durController = TextEditingController();
  bool _isCompleted = false;
  int _selectedCatagoryId = 0;
  List<TaskCatagory> _catagoryList = [];
  late VoidTaskCatagoryCallback _onCatagorySelectedCallback;
  late VoidTaskCatagoryCallback _onCatagoryAddedCallback;

  _NewTaskPageState() {
    initializeCatagoryList();
    _onCatagorySelectedCallback = (TaskCatagory? catagory) {
      setState(() {
        if (catagory != null) {
          _selectedCatagoryId = catagory.id;
        }
      });
    };
    _onCatagoryAddedCallback = (TaskCatagory? catagory) {
      setState(() {
        if (catagory != null) {
          _catagoryList.add(catagory);
          _catagoryList.sort((a, b) {
            return a.id.compareTo(b.id);
          });
          TaskCatagoryStorage.getInstance().writeCatagoryList(_catagoryList);
        }
      });
    };
  }

  Future<void> initializeCatagoryList() async {
    _catagoryList = await TaskCatagoryStorage.getInstance().readCatagoryList();
    setState(() {
      // Trigger a rebuild after setting the state
    });
  }

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
    if (_durController.text.isEmpty) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Duration cannot be null!'),
          ),
        );
      return;
    }
    if (double.tryParse(_durController.text) == null) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Invalid duration!'),
          ),
        );
      return;
    }

    TaskInfo newTaskInfo = TaskInfo(
      completed: _isCompleted,
      title: _titleController.text,
      description: _descController.text,
      createdTime: DateTime.now(),
      duration: double.parse(_durController.text),
      catagoryId: _selectedCatagoryId,
    );
    Navigator.pop(context, newTaskInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Task'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CatagoryMenuContainer(
                catagoryList: _catagoryList,
                onCatagoryAddedCallback: _onCatagoryAddedCallback,
                onCatagorySelectedCallback: _onCatagorySelectedCallback,
              ),
              TextInputContainer(
                textController: _titleController,
                maxLines: 1,
                labelText: 'Title',
              ),
              TextInputContainer(
                textController: _durController,
                maxLines: 1,
                labelText: 'Duration',
              ),
              TextInputContainer(
                textController: _descController,
                maxLines: 10,
                labelText: 'Description',
              ),
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

class CatagoryMenuContainer extends StatefulWidget {
  final List<TaskCatagory>? catagoryList;
  final VoidTaskCatagoryCallback onCatagorySelectedCallback;
  final VoidTaskCatagoryCallback onCatagoryAddedCallback;

  const CatagoryMenuContainer({
    Key? key,
    required this.catagoryList,
    required this.onCatagorySelectedCallback,
    required this.onCatagoryAddedCallback,
  }) : super(key: key);

  @override
  State<CatagoryMenuContainer> createState() => _CatagoryMenuContainerState();
}

class _CatagoryMenuContainerState extends State<CatagoryMenuContainer> {
  final TextEditingController newCatagoryTextController =
      TextEditingController();
  TaskCatagory? selectedCatagory;

  @override
  void initState() {
    super.initState();
    selectedCatagory = widget.catagoryList?.elementAtOrNull(0);
  }

  void addNewTaskCatagory(String newCatagoryDesc) {
    if (newCatagoryDesc.isEmpty) {
      return;
    }

    TaskCatagory newCatagory = TaskCatagory(description: newCatagoryDesc);
    widget.onCatagoryAddedCallback(newCatagory);
    widget.onCatagorySelectedCallback(newCatagory);
  }

  @override
  Widget build(BuildContext context) {
    List<TaskCatagory> existingCataList = widget.catagoryList ?? [];
    return Row(
      children: [
        DropdownMenu<TaskCatagory>(
          initialSelection: selectedCatagory,
          requestFocusOnTap: false,
          label: const Text('Task Catagory'),
          onSelected: widget.onCatagorySelectedCallback,
          dropdownMenuEntries: existingCataList
              .map<DropdownMenuEntry<TaskCatagory>>((TaskCatagory catagory) {
            return DropdownMenuEntry<TaskCatagory>(
              value: catagory,
              label: catagory.description,
              enabled: true,
            );
          }).toList(),
          width: 250,
          menuHeight: 300,
        ),
        const SizedBox(
          width: 10,
        ),
        ElevatedButton.icon(
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => Dialog(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Add new task catagory'),
                    const SizedBox(height: 15),
                    TextInputContainer(
                      textController: newCatagoryTextController,
                      maxLines: 1,
                      labelText: 'New task catagory',
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 15),
                        TextButton(
                          onPressed: () {
                            addNewTaskCatagory(newCatagoryTextController.text);
                            Navigator.pop(context);
                          },
                          child: const Text('Add'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          icon: const Icon(Icons.add),
          label: const Text('Add'),
        ),
      ],
    );
  }
}
